import 'package:flutter/material.dart';
import 'package:mgramseva/components/Dashboard/BillsTable.dart';
import 'package:mgramseva/components/Dashboard/DashboardCard.dart';
import 'package:mgramseva/constants/dashboardcard.dart';
import 'package:mgramseva/utils/Constants/I18KeyConstants.dart';
import 'package:mgramseva/utils/models.dart';
import 'package:mgramseva/widgets/DrawerWrapper.dart';
import 'package:mgramseva/widgets/GridCard.dart';
import 'package:mgramseva/widgets/BaseAppBar.dart';
import 'package:mgramseva/widgets/HomeBack.dart';
import 'package:mgramseva/widgets/ListLabelText.dart';
import 'package:mgramseva/widgets/SideBar.dart';
import 'package:mgramseva/constants/expenditurecarddetails.dart';
import 'package:mgramseva/constants/collectioncarddetails.dart';
import 'customAppbar.dart';
import 'dashboard/search_expense.dart';

class Dashboard extends StatefulWidget {
  static const String routeName = 'dashboard';
  // Dashboard(Key key) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _Dashboard();
  }
}

class _Dashboard extends State<Dashboard> with SingleTickerProviderStateMixin {
  late int selectedDrawerIndex;
  int _tabIndex = 0;
  late TabController _tabController;
  _onSelectItem(int index) {
    print(index);
    setState(() => selectedDrawerIndex = index);
    Navigator.of(context).pop(); // close the drawer
  }

  void _toggleTab() {
    _tabIndex = _tabController.index + 1;
    _tabController.animateTo(_tabIndex);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(vsync: this, length: 2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(),
        drawer: DrawerWrapper(
          Drawer(child: SideBar()),
        ),
        body: Container(
            padding: EdgeInsets.only(left: 18, right: 18),
            child: CustomScrollView(
                slivers: [
                  SliverList(
                      delegate: SliverChildListDelegate([
                    HomeBack(widget: _buildShare),
                    DashboardCard(dashboardcarddetails),
                    TabBar(
                      labelColor: Theme.of(context).primaryColor,
                      unselectedLabelColor: Colors.black,
                      labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      indicatorSize: TabBarIndicatorSize.tab,
                      controller: _tabController,
                      indicator: BoxDecoration(
                        color: Colors.white,
                        border:  Border(
                          bottom: BorderSide(width: 2, color: Theme.of(context).primaryColor),
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
                          child :  TabBarView(
                      controller: _tabController,
                      children: [
                        SearchExpenseDashboard(dashBoardType: DashBoardType.collections),
                        SearchExpenseDashboard(dashBoardType: DashBoardType.Expenditure)
                      ],))
                  // ListLabelText("Search Expense Bills"),
                  // BillsTable()s
                  // SearchExpenseDashboard()
    ]
                )));
  }

  Widget get _buildShare => TextButton.icon(
      onPressed: () {},
      icon: Image.asset('assets/png/whats_app.png'),
      label: Text('Share'));
}
