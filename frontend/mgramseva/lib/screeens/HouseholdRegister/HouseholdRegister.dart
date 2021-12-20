import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mgramseva/components/HouseholdRegister/HouseholdCard.dart';
import 'package:mgramseva/providers/common_provider.dart';
import 'package:mgramseva/providers/household_register_provider.dart';
import 'package:mgramseva/repository/core_repo.dart';
import 'package:mgramseva/utils/Constants/I18KeyConstants.dart';
import 'package:mgramseva/utils/Locilization/application_localizations.dart';
import 'package:mgramseva/utils/global_variables.dart';
import 'package:mgramseva/utils/loaders.dart';
import 'package:mgramseva/widgets/DrawerWrapper.dart';
import 'package:mgramseva/widgets/HomeBack.dart';
import 'package:mgramseva/widgets/SideBar.dart';
import 'package:provider/provider.dart';
import '../../widgets/customAppbar.dart';
import 'package:mgramseva/widgets/pagination.dart';
import 'package:mgramseva/utils/models.dart';
import 'HouseholdSearch.dart';

class HouseholdRegister extends StatefulWidget {
  final int initialTabIndex;

  const HouseholdRegister({Key? key, this.initialTabIndex = 0})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _HouseholdRegister();
  }
}

class _HouseholdRegister extends State<HouseholdRegister>
    with SingleTickerProviderStateMixin {
  OverlayState? overlayState;
  OverlayEntry? _overlayEntry;
  GlobalKey key = GlobalKey();

  @override
  void initState() {
    super.initState();
    var householdRegisterProvider =
        Provider.of<HouseholdRegisterProvider>(context, listen: false);
    //householdRegisterProvider.selectedDate = DateTime(DateTime.now().year, DateTime.now().month);
    householdRegisterProvider.debounce = null;
  }

  @override
  Widget build(BuildContext context) {
    var householdRegisterProvider =
        Provider.of<HouseholdRegisterProvider>(context, listen: false);

    return WillPopScope(
      onWillPop: () async {
        if (householdRegisterProvider.removeOverLay(_overlayEntry))
          return false;
        return true;
      },
      child: GestureDetector(
        onTap: () => householdRegisterProvider.removeOverLay(_overlayEntry),
        child: Scaffold(
          appBar: CustomAppBar(),
          drawer: DrawerWrapper(
            Drawer(child: SideBar()),
          ),
          body: LayoutBuilder(
            builder: (context, constraints) => Container(
              alignment: Alignment.center,
              margin: constraints.maxWidth < 760
                  ? null
                  : EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width / 25),
              child: Stack(children: [
                SingleChildScrollView(
                  child: Container(
                      color: Color.fromRGBO(238, 238, 238, 1),
                      padding: EdgeInsets.only(left: 8, right: 8),
                      height: constraints.maxHeight - 50,
                      child: CustomScrollView(slivers: [
                        SliverList(
                            delegate: SliverChildListDelegate([
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [HomeBack(), _buildShare],
                          ),
                          Container(key: key, child: HouseholdCard()),
                        ])),
                        SliverFillRemaining(
                            hasScrollBody: true,
                            fillOverscroll: true,
                            child: HouseholdSearch())
                      ])),
                ),
                Align(
                    alignment: Alignment.bottomRight,
                    child: Consumer<HouseholdRegisterProvider>(
                        builder: (_, householdRegisterProvider, child) {
                      var totalCount = (householdRegisterProvider
                              .waterConnectionsDetails?.totalCount) ??
                          0;
                      return Visibility(
                          visible: totalCount > 0,
                          child: Pagination(
                              limit: householdRegisterProvider.limit,
                              offSet: householdRegisterProvider.offset,
                              callBack: (pageResponse) =>
                                  householdRegisterProvider.onChangeOfPageLimit(
                                      pageResponse, context),
                              totalCount: totalCount,
                              isDisabled:
                                  householdRegisterProvider.isLoaderEnabled));
                    }))
              ]),
            ),
          ),
        ),
      ),
    );
  }

  Widget get _buildShare => TextButton.icon(
      onPressed: () {
        Provider.of<HouseholdRegisterProvider>(context, listen: false)
          ..createPdfForAllConnections(context, false);
      },
      icon: Image.asset('assets/png/whats_app.png'),
      label: Text(
          ApplicationLocalizations.of(context).translate(i18.common.SHARE)));
}
