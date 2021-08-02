import 'package:flutter/material.dart';
import 'package:mgramseva/components/Dashboard/BillsTable.dart';
import 'package:mgramseva/components/Dashboard/DashboardCard.dart';
import 'package:mgramseva/constants/dashboardcard.dart';
import 'package:mgramseva/widgets/DrawerWrapper.dart';
import 'package:mgramseva/widgets/GridCard.dart';
import 'package:mgramseva/widgets/BaseAppBar.dart';
import 'package:mgramseva/widgets/HomeBack.dart';
import 'package:mgramseva/widgets/ListLabelText.dart';
import 'package:mgramseva/widgets/SideBar.dart';
import 'package:mgramseva/constants/expenditurecarddetails.dart';
import 'package:mgramseva/constants/collectioncarddetails.dart';

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
        appBar: BaseAppBar(
          Text('mGramSeva'),
          AppBar(),
          <Widget>[],
        ),
        drawer: DrawerWrapper(
          Drawer(child: SideBar(_onSelectItem)),
        ),
        body: SingleChildScrollView(
            child: Container(
                padding: EdgeInsets.only(left: 18, right: 18),
                child: Container(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                      HomeBack(widget: _buildShare),
                      DashboardCard(dashboardcarddetails),
                      SizedBox(height: 15),
                      DefaultTabController(
                        length: 2,
                        child: TabBar(
                          labelColor: Theme.of(context).primaryColor,
                          unselectedLabelColor: Colors.black,
                          indicatorSize: TabBarIndicatorSize.tab,
                          controller: _tabController,
                          indicator: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey,
                                offset: Offset(0.0, 1.0), //(x,y)
                                blurRadius: 6.0,
                              ),
                            ],
                          ),
                          tabs: [
                            Tab(
                              text: "Collections",
                            ),
                            Tab(
                              text: "Expenditure",
                            ),
                          ],
                        ),
                      ),
                      new Container(
                        height: MediaQuery.of(context).size.height / 2.4,
                        child: TabBarView(
                          controller: _tabController,
                          children: [
                            GridCard(collectioncarddetails),
                            GridCard(expenditurecarddetails),
                          ],
                        ),
                      ),
                      ListLabelText("Search Expense Bills"),
                      BillsTable()
                    ])))));
  }

  Widget get _buildShare => TextButton.icon(
      onPressed: () {},
      icon: Image.asset('assets/png/whats_app.png'),
      label: Text('Share'));
}
