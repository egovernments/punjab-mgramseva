import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mgramseva/model/localization/language.dart';
import 'package:mgramseva/model/mdms/tenants.dart';
import 'package:mgramseva/providers/common_provider.dart';
import 'package:mgramseva/providers/language.dart';
import 'package:mgramseva/providers/tenants_provider.dart';
import 'package:mgramseva/services/LocalStorage.dart';
import 'package:mgramseva/utils/Constants/I18KeyConstants.dart';
import 'package:mgramseva/utils/Locilization/application_localizations.dart';
import 'package:mgramseva/utils/constants.dart';
import 'package:mgramseva/utils/global_variables.dart';
import 'package:mgramseva/utils/loaders.dart';
import 'package:mgramseva/utils/notifyers.dart';
import 'package:provider/provider.dart';
import 'package:universal_html/html.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  CustomAppBar()
      : preferredSize = Size.fromHeight(kToolbarHeight),
        super();

  @override
  final Size preferredSize; // default is 56.0

  @override
  _CustomAppBarState createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  Tenants? tenants;
  @override
  void initState() {
    WidgetsBinding.instance?.addPostFrameCallback((_) => afterViewBuild());
    super.initState();
  }

  afterViewBuild() {
    var tenantProvider = Provider.of<TenantsProvider>(context, listen: false);
    print(tenantProvider.tenants);
    if (tenantProvider.tenants == null) {
      tenantProvider.getTenants();
    }
  }

  void setSelectedState(StateInfo stateInfo) {
    if (kIsWeb) {
      window.localStorage[Constants.STATES_KEY] =
          jsonEncode(stateInfo.toJson());
    } else {
      storage.write(
          key: Constants.STATES_KEY, value: jsonEncode(stateInfo.toJson()));
    }
  }

  buildtenantsView(Tenant tenant) {
    var commonProvider = Provider.of<CommonProvider>(
        navigatorKey.currentContext!,
        listen: false);
    var languageProvider =
        Provider.of<LanguageProvider>(context, listen: false);

    final r = commonProvider.userDetails!.userRequest!.roles!
        .map((e) => e.tenantId)
        .toSet()
        .toList();
    final resulst = tenant.tenantsList!
        .where((element) => r.contains(element.code))
        .toList();
    return GestureDetector(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(tenants != null ? tenants!.name! : ""),
                Text(tenants != null ? tenants!.city!.code! : ""),
              ],
            ),
            Icon(Icons.arrow_drop_down)
          ],
        ),
        onTap: () {
          showDialog(
              barrierDismissible: false,
              context: context,
              builder: (BuildContext context) {
                return Positioned(
                    child: Stack(children: <Widget>[
                  Container(
                      margin: EdgeInsets.only(
                          left: MediaQuery.of(context).size.width > 720
                              ? MediaQuery.of(context).size.width -
                                  MediaQuery.of(context).size.width / 3
                              : 0,
                          top: 60),
                      width: MediaQuery.of(context).size.width > 720
                          ? MediaQuery.of(context).size.width / 3
                          : MediaQuery.of(context).size.width,
                      color: Colors.white,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: List.generate(resulst.length, (index) {
                          return GestureDetector(
                              onTap: () {
                                languageProvider.stateInfo!.selectedCode =
                                    resulst[index].code;
                                setSelectedState(languageProvider.stateInfo!);
                                setState(() {
                                  tenants = resulst[index];
                                });
                                Navigator.pop(context);
                              },
                              child: Material(
                                  child: Container(
                                color: index.isEven
                                    ? Colors.white
                                    : Color.fromRGBO(238, 238, 238, 1),
                                width: MediaQuery.of(context).size.width,
                                height: 45,
                                padding: EdgeInsets.all(5),
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          resulst[index].city!.name!,
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w400),
                                        ),
                                        Text(resulst[index].city!.code!,
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w400))
                                      ]),
                                ),
                              )));
                        }),
                      ))
                ]));
              });
        });
  }

  @override
  Widget build(BuildContext context) {
    var tenantProvider = Provider.of<TenantsProvider>(context, listen: false);
    return AppBar(
      title: Text(ApplicationLocalizations.of(context)
          .translate(i18.common.MGRAM_SEVA)),
      actions: [
        Container(
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
              StreamBuilder(
                  stream: tenantProvider.streamController.stream,
                  builder: (context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      return buildtenantsView(snapshot.data);
                    } else if (snapshot.hasError) {
                      return Notifiers.networkErrorPage(context, () {});
                    } else {
                      switch (snapshot.connectionState) {
                        case ConnectionState.waiting:
                          return Loaders.CircularLoader();
                        case ConnectionState.active:
                          return Loaders.CircularLoader();
                        default:
                          return Container(
                            child: Text(""),
                          );
                      }
                    }
                  })
            ]))
      ],
    );
  }
}
