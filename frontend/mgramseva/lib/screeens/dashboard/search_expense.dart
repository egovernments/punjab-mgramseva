

import 'package:flutter/material.dart';
import 'package:mgramseva/components/Dashboard/BillsTable.dart';
import 'package:mgramseva/providers/dashboard_provider.dart';
import 'package:mgramseva/widgets/ListLabelText.dart';
import 'package:mgramseva/widgets/TextFieldBuilder.dart';
import 'package:provider/provider.dart';

class SearchExpenseDashboard extends StatefulWidget {
  const SearchExpenseDashboard({Key? key}) : super(key: key);

  @override
  _SearchExpenseDashboardState createState() => _SearchExpenseDashboardState();
}

class _SearchExpenseDashboardState extends State<SearchExpenseDashboard> with SingleTickerProviderStateMixin {

  late TabController _tabController;
  late List<Tab> _tabList;

  @override
  void initState() {
    _tabList = [Tab(text: 'All'), Tab(text: 'Paid'), Tab(text: 'Pending')];
    _tabController = new TabController(vsync: this, length: _tabList.length);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var dashBoardProvider = Provider.of<DashBoardProvider>(context, listen: false);
    return  Column(
        children: [
          ListLabelText("Search Expense Bills"),
          BuildTextField(
              '',
              dashBoardProvider.searchController,
          ),
          Expanded(
            child: Column(
              children: [
                TabBar(
                  labelColor: Theme.of(context).primaryColor,
                  unselectedLabelColor: Colors.black,
                  indicatorSize: TabBarIndicatorSize.tab,
                  controller: _tabController,
                  // indicator: BoxDecoration(
                  //   color: Colors.white,
                  //   boxShadow: [
                  //     BoxShadow(
                  //       color: Colors.grey,
                  //       offset: Offset(0.0, 1.0), //(x,y)
                  //       blurRadius: 6.0,
                  //     ),
                  //   ],
                  // ),
                  tabs: _tabList.map((e) => e).toList(),
                ),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: _tabList.map((e) => BillsTable()).toList()
                  ),
                ),
              ],
            ),
          )
        ]
    );
  }
}
