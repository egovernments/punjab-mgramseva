import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mgramseva/components/Dashboard/BillsTable.dart';
import 'package:mgramseva/components/Dashboard/DashboardCard.dart';
import 'package:mgramseva/constants/dashboardcard.dart';
import 'package:mgramseva/providers/dashboard_provider.dart';
import 'package:mgramseva/utils/Constants/I18KeyConstants.dart';
import 'package:mgramseva/utils/common_methods.dart';
import 'package:mgramseva/utils/date_formats.dart';
import 'package:mgramseva/utils/models.dart';
import 'package:mgramseva/widgets/DrawerWrapper.dart';
import 'package:mgramseva/widgets/GridCard.dart';
import 'package:mgramseva/widgets/BaseAppBar.dart';
import 'package:mgramseva/widgets/HomeBack.dart';
import 'package:mgramseva/widgets/ListLabelText.dart';
import 'package:mgramseva/widgets/SideBar.dart';
import 'package:mgramseva/constants/expenditurecarddetails.dart';
import 'package:mgramseva/constants/collectioncarddetails.dart';
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
  DateTime? selectedMonth;
  late List<DateTime> dateList;
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
     dateList = CommonMethods.getPastMonthUntilFinancialYear().reversed.toList();
     selectedMonth = dateList.first;
    _tabController = new TabController(vsync: this, length: 2);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if(removeOverLay()) return false;
       return true;
      },
      child: GestureDetector(
        onTap: removeOverLay,
        child: Scaffold(
          appBar: CustomAppBar(),
          drawer: DrawerWrapper(
            Drawer(child: SideBar()),
          ),
          body: Stack(children: [
            Container(
                padding: EdgeInsets.only(left: 18, right: 18),
                child: CustomScrollView(slivers: [
                  SliverList(
                      delegate: SliverChildListDelegate([
                    HomeBack(widget: _buildShare),
                    Container(
                        key: key,
                        child: DashboardCard(dashboardcarddetails, onTapOfMonthPicker)),
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
                          text: i18.dashboard.COLLECTIONS,
                        ),
                        Tab(
                          text: i18.dashboard.EXPENDITURE,
                        ),
                      ],
                    ),
                  ])),
                  SliverFillRemaining(
                      hasScrollBody: true,
                      fillOverscroll: true,
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          SearchExpenseDashboard(
                              dashBoardType: DashBoardType.collections),
                          SearchExpenseDashboard(
                              dashBoardType: DashBoardType.Expenditure)
                        ],
                      ))
                  // ListLabelText("Search Expense Bills"),
                  // BillsTable()s
                  // SearchExpenseDashboard()
                ])),
            Align(
                alignment: Alignment.bottomRight,
                child: Consumer<DashBoardProvider>(
                    builder: (_, dashBoardProvider, child) => Pagination(limit: 10, offSet: 0, callBack: (val) {})))
          ]),
        ),
      ),
    );
  }

  Widget get _buildShare => TextButton.icon(
      onPressed: () {},
      icon: Image.asset('assets/png/whats_app.png'),
      label: Text('Share'));


  void onTapOfMonthPicker(){
    removeOverLay();
    overlayState = Overlay.of(context);

    RenderBox? box = key.currentContext!
        .findRenderObject() as RenderBox?;
    Offset position =
    box!.localToGlobal(Offset.zero);

    _overlayEntry = new OverlayEntry(
        builder: (BuildContext context) => Positioned(
            left: position.dx + box.size.width - 200,
            top: position.dy + box.size.height - 10,
            child: Material(
              color: Colors.transparent,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                width: 200,
                child:  Column(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(dateList.length, (index) {
                    var date = dateList[index];
                   return Container(
                     padding: EdgeInsets.symmetric(vertical: 8),
                      color: index/2 == 0 ? Color.fromRGBO(238, 238, 238, 1) : Color.fromRGBO(255, 255, 255, 1),
                      child: Wrap(
                        spacing: 5,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Text('${DateFormats.getMonthAndYear(selectedMonth ?? DateTime.now())}',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: selectedMonth?.year == date?.year && selectedMonth?.month == date?.month ?
                                FontWeight.bold : FontWeight.normal
                          ),
                          ),
                          Radio(value: date,
                              groupValue: selectedMonth,
                              onChanged: onChangeOfMonth)
                        ],
                      ),
                    );
                  })
              ))
            )));
    if(_overlayEntry != null)
      overlayState?.insert(_overlayEntry!);
  }

  bool removeOverLay(){
    try{
      _overlayEntry?.remove();
      return true;
    }catch(e){
      return false;
    }
  }

  void onChangeOfMonth(DateTime? date){
    removeOverLay();
   setState(() {
     selectedMonth = date;
   });
  }
}
