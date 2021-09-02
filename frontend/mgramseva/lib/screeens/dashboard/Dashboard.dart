import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mgramseva/components/Dashboard/BillsTable.dart';
import 'package:mgramseva/components/Dashboard/DashboardCard.dart';
import 'package:mgramseva/providers/dashboard_provider.dart';
import 'package:mgramseva/utils/Constants/I18KeyConstants.dart';
import 'package:mgramseva/utils/Locilization/application_localizations.dart';
import 'package:mgramseva/utils/common_methods.dart';
import 'package:mgramseva/utils/date_formats.dart';
import 'package:mgramseva/utils/models.dart';
import 'package:mgramseva/widgets/DrawerWrapper.dart';
import 'package:mgramseva/widgets/GridCard.dart';
import 'package:mgramseva/widgets/BaseAppBar.dart';
import 'package:mgramseva/widgets/HomeBack.dart';
import 'package:mgramseva/widgets/ListLabelText.dart';
import 'package:mgramseva/widgets/SideBar.dart';
import 'package:provider/provider.dart';
import '../customAppbar.dart';
import 'search_expense.dart';
import 'package:mgramseva/widgets/pagination.dart';

class Dashboard extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _Dashboard();
  }
}

class _Dashboard extends State<Dashboard> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  OverlayState? overlayState;
  OverlayEntry? _overlayEntry;
  GlobalKey key = GlobalKey();
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    var dashBoardProvider =
        Provider.of<DashBoardProvider>(context, listen: false)
          ..dateList =
              CommonMethods.getPastMonthUntilFinancialYear().reversed.toList();
    dashBoardProvider.selectedMonth = dashBoardProvider.dateList.first;
    dashBoardProvider.debounce = null;
    _tabController = new TabController(vsync: this, length: 2);
    _tabController.addListener(() {
      FocusScope.of(context).unfocus();
      dashBoardProvider.debounce = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    var dashBoardProvider =
        Provider.of<DashBoardProvider>(context, listen: false);

    return WillPopScope(
      onWillPop: () async {
        if (dashBoardProvider.removeOverLay(_overlayEntry)) return false;
        return true;
      },
      child: GestureDetector(
        onTap: () => dashBoardProvider.removeOverLay(_overlayEntry),
        child: Scaffold(
          appBar: CustomAppBar(),
          drawer: DrawerWrapper(
            Drawer(child: SideBar()),
          ),
          body: LayoutBuilder( builder: (context, constraints) =>
             Container(
               alignment: Alignment.center,
               margin: constraints.maxWidth < 760 ? null : EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width /25),
              child: Stack(children: [
                SingleChildScrollView(
                  child:
                   Container(
                        padding: EdgeInsets.only(left: 18, right: 18),
                        height: MediaQuery.of(context).size.height - 56 - 50 - MediaQuery.of(context).padding.top,
                        child: CustomScrollView(slivers: [
                          SliverList(
                              delegate: SliverChildListDelegate([
                            HomeBack(widget: _buildShare),
                              Container(
                                key: key,
                                child: DashboardCard(onTapOfMonthPicker)),
                            TabBar(
                              labelColor: Theme.of(context).primaryColor,
                              unselectedLabelColor: Colors.black,
                              labelStyle:
                                  TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                              indicatorSize: TabBarIndicatorSize.tab,
                              controller: _tabController,
                              indicator: BoxDecoration(
                                color: Colors.white,
                                border: Border(
                                  bottom: BorderSide(
                                      width: 2, color: Theme.of(context).primaryColor),
                                ),
                              ),
                              tabs: [
                                Tab(
                                  text: ApplicationLocalizations.of(context).translate(i18.dashboard.COLLECTIONS),
                                ),
                                Tab(
                                  text: ApplicationLocalizations.of(context).translate(i18.dashboard.EXPENDITURE),
                                ),
                              ],
                            ),
                          ])),
                          SliverFillRemaining(
                              hasScrollBody: true,
                              fillOverscroll: true,
                              child: TabBarView(
                                physics: NeverScrollableScrollPhysics(),
                                controller: _tabController,
                                children: [
                                  SearchExpenseDashboard(
                                      dashBoardType: DashBoardType.collections),
                                  SearchExpenseDashboard(
                                      dashBoardType: DashBoardType.Expenditure)
                                ],
                              ))
                        ])),
                  ),
                Align(
                    alignment: Alignment.bottomRight,
                    child: Consumer<DashBoardProvider>(
                        builder: (_, dashBoardProvider, child) {
                      var totalCount = (dashBoardProvider.selectedDashboardType ==
                                  DashBoardType.Expenditure
                              ? dashBoardProvider
                                  ?.expenseDashboardDetails?.totalCount
                              : dashBoardProvider
                                  .waterConnectionsDetails?.totalCount) ??
                          0;
                      return Visibility(
                          visible: totalCount > 0,
                          child: Pagination(
                              limit: dashBoardProvider.limit,
                              offSet: dashBoardProvider.offset,
                              callBack: (pageResponse) => dashBoardProvider
                                  .onChangeOfPageLimit(pageResponse, context),
                              totalCount: totalCount));
                    }))
              ]),
            ),
          ),
        ),
      ),
    );
  }

  Widget get _buildShare => TextButton.icon(
      onPressed: () {},
      icon: Image.asset('assets/png/whats_app.png'),
      label: Text(i18.common.SHARE));

  void onTapOfMonthPicker() {
    var dashBoardProvider =
        Provider.of<DashBoardProvider>(context, listen: false);

    dashBoardProvider.removeOverLay(_overlayEntry);
    overlayState = Overlay.of(context);

    RenderBox? box = key.currentContext!.findRenderObject() as RenderBox?;
    Offset position = box!.localToGlobal(Offset.zero);

    _overlayEntry = new OverlayEntry(
        builder: (BuildContext context) => Positioned(
            left: position.dx + box.size.width - 195,
            top: position.dy + box.size.height - 10,
            child: Material(
                color: Colors.transparent,
                child: Container(
                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(5.0),
                        bottomLeft: Radius.circular(5.0),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(.5),
                          blurRadius: 20.0, // soften the shadow
                          spreadRadius: 0.0, //extend the shadow
                          offset: Offset(
                            5.0, // Move to right 10  horizontally
                            5.0, // Move to bottom 10 Vertically
                          ),
                        )
                      ],
                    ),
                    child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: List.generate(
                            dashBoardProvider.dateList.length, (index) {
                          var date = dashBoardProvider.dateList[index];
                          return InkWell(
                            onTap: () => dashBoardProvider.onChangeOfDate(
                                date, context, _overlayEntry),
                            child: Container(
                              width: 190,
                              decoration: index ==
                                      dashBoardProvider.dateList.length - 1
                                  ? BoxDecoration(
                                      color: index % 2 == 0
                                          ? Color.fromRGBO(238, 238, 238, 1)
                                          : Color.fromRGBO(255, 255, 255, 1),
                                      borderRadius: BorderRadius.only(
                                        bottomRight: Radius.circular(5.0),
                                        bottomLeft: Radius.circular(5.0),
                                      ))
                                  : BoxDecoration(
                                      color: index % 2 == 0
                                          ? Color.fromRGBO(238, 238, 238, 1)
                                          : Color.fromRGBO(255, 255, 255, 1),
                                    ),
                              padding: EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 8),
                              child: Wrap(
                                spacing: 5,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                alignment: WrapAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '${DateFormats.getMonthAndYear(dashBoardProvider.dateList[index])}',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: dashBoardProvider
                                                        .selectedMonth?.year ==
                                                    date?.year &&
                                                dashBoardProvider
                                                        .selectedMonth?.month ==
                                                    date?.month
                                            ? FontWeight.bold
                                            : FontWeight.normal),
                                  ),
                                  Radio(
                                      value: date,
                                      groupValue:
                                          dashBoardProvider.selectedMonth,
                                      onChanged: (date) =>
                                          dashBoardProvider.onChangeOfDate(
                                              date as DateTime,
                                              context,
                                              _overlayEntry))
                                ],
                              ),
                            ),
                          );
                        }))))));
    if (_overlayEntry != null) overlayState?.insert(_overlayEntry!);
  }
}
