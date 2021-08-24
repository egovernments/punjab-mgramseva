import 'package:flutter/material.dart';

import 'package:mgramseva/model/mdms/tenants.dart';
import 'package:mgramseva/providers/common_provider.dart';

import 'package:mgramseva/providers/tenants_provider.dart';
import 'package:mgramseva/routers/Routers.dart';

import 'package:mgramseva/utils/Constants/I18KeyConstants.dart';
import 'package:mgramseva/utils/Locilization/application_localizations.dart';

import 'package:mgramseva/utils/global_variables.dart';
import 'package:mgramseva/utils/loaders.dart';
import 'package:mgramseva/utils/notifyers.dart';
import 'package:provider/provider.dart';

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
    var commonProvider = Provider.of<CommonProvider>(
        navigatorKey.currentContext!,
        listen: false);
    if (tenantProvider.tenants == null) {
      tenantProvider.getTenants();
    }
    if (commonProvider.userDetails!.selectedtenant == null) {
      final r = commonProvider.userDetails!.userRequest!.roles!
          .map((e) => e.tenantId)
          .toSet()
          .toList();

      if (r != null && tenantProvider.tenants != null) {
        final result = tenantProvider.tenants!.tenantsList!
            .where((element) => r.contains(element.code))
            .toList();
        if (result.length > 1) {
          showdialog(result);
        } else if (result.length == 1 &&
            commonProvider.userDetails!.selectedtenant == null) {
          commonProvider.setTenant(result.first);
        }
      }
    }
  }

  showdialog(result) {
    var commonProvider = Provider.of<CommonProvider>(
        navigatorKey.currentContext!,
        listen: false);
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return Stack(children: <Widget>[
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
                  children: List.generate(result.length, (index) {
                    return GestureDetector(
                        onTap: () {
                          commonProvider.setTenant(result[index]);
                          Navigator.pop(context);
                          Navigator.pushReplacementNamed(context, Routes.HOME);
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
                                    result[index].city!.name!,
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  Text(result[index].city!.code!,
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400))
                                ]),
                          ),
                        )));
                  }),
                ))
          ]);
        });
  }

  buildtenantsView(Tenant tenant) {
    var commonProvider = Provider.of<CommonProvider>(
        navigatorKey.currentContext!,
        listen: false);
    final r = commonProvider.userDetails!.userRequest!.roles!
        .map((e) => e.tenantId)
        .toSet()
        .toList();
    final result = tenant.tenantsList!
        .where((element) => r.contains(element.code))
        .toList();
    if (result.length == 1) {
      commonProvider.setTenant(result.first);
    }

    return GestureDetector(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Consumer<CommonProvider>(
                builder: (_, commonProvider, child) =>
                    commonProvider.userDetails!.selectedtenant == null
                        ? Text("")
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                                Text(commonProvider
                                    .userDetails!.selectedtenant!.code!),
                                Text(commonProvider
                                    .userDetails!.selectedtenant!.city!.code!)
                              ])),
            Icon(Icons.arrow_drop_down)
          ],
        ),
        onTap: () => showdialog(result));
  }

  @override
  Widget build(BuildContext context) {
    var tenantProvider = Provider.of<TenantsProvider>(context, listen: false);
    return AppBar(
      title: Text(ApplicationLocalizations.of(context)
          .translate(i18.common.MGRAM_SEVA)),
      actions: [
        Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width / 3,
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  tenantProvider.tenants != null
                      ? buildtenantsView(tenantProvider.tenants!)
                      : StreamBuilder(
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
