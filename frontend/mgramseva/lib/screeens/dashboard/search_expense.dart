

import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:flutter/material.dart';
import 'package:mgramseva/components/Dashboard/BillsTable.dart';
import 'package:mgramseva/model/common/metric.dart';
import 'package:mgramseva/model/connection/water_connection.dart';
import 'package:mgramseva/model/expensesDetails/expenses_details.dart';
import 'package:mgramseva/providers/dashboard_provider.dart';
import 'package:mgramseva/screeens/dashboard/individual_tab.dart';
import 'package:mgramseva/utils/Constants/I18KeyConstants.dart';
import 'package:mgramseva/utils/Locilization/application_localizations.dart';
import 'package:mgramseva/utils/common_widgets.dart';
import 'package:mgramseva/utils/loaders.dart';
import 'package:mgramseva/utils/models.dart';
import 'package:mgramseva/utils/notifyers.dart';
import 'package:mgramseva/widgets/ListLabelText.dart';
import 'package:mgramseva/widgets/TextFieldBuilder.dart';
import 'package:mgramseva/widgets/footer.dart';
import 'package:mgramseva/widgets/grid_view.dart';
import 'package:provider/provider.dart';

class SearchExpenseDashboard extends StatefulWidget {
  final DashBoardType dashBoardType;
  const SearchExpenseDashboard({Key? key, required this.dashBoardType}) : super(key: key);

  @override
  _SearchExpenseDashboardState createState() => _SearchExpenseDashboardState();
}

class _SearchExpenseDashboardState extends State<SearchExpenseDashboard> with SingleTickerProviderStateMixin {

  @override
  void initState() {
    var dashBoardProvider = Provider.of<DashBoardProvider>(context, listen: false)
    ..limit = 10
    ..offset = 1
    ..sortBy = null
    ..selectedDashboardType = widget.dashBoardType
    ..metricInformation = null;
    WidgetsBinding.instance?.addPostFrameCallback((_) => afterViewBuild());
    super.initState();
  }

  afterViewBuild() {
    var dashBoardProvider = Provider.of<DashBoardProvider>(context, listen: false);
    dashBoardProvider.searchController.clear();
    dashBoardProvider.fetchData();
    dashBoardProvider.fetchDashboardMetricInformation(context, widget.dashBoardType == DashBoardType.Expenditure ? true : false);
    dashBoardProvider.selectedTab = 'all';
    if(widget.dashBoardType == DashBoardType.Expenditure) {

      dashBoardProvider
        ..sortBy = SortBy('challanno', false)
        ..expenseDashboardDetails?.expenseDetailList = <ExpensesDetailsModel>[]
        ..expenseDashboardDetails?.totalCount = null;
    }else{
      dashBoardProvider
        ..waterConnectionsDetails?.waterConnection = <WaterConnection>[]
        ..waterConnectionsDetails?.totalCount = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    var dashBoardProvider = Provider.of<DashBoardProvider>(context, listen: false);
    return  Column(
        children: [
          Visibility(
              visible: dashBoardProvider.selectedMonth.dateType == DateType.MONTH && dashBoardProvider.metricInformation != null,
              child: GridViewBuilder(gridList:  dashBoardProvider.metricInformation ?? <Metric>[], physics: NeverScrollableScrollPhysics())
          ),
          ListLabelText(widget.dashBoardType == DashBoardType.collections ?  i18.dashboard.SEARCH_CONSUMER_RECORDS : i18.dashboard.SEARCH_EXPENSE_BILL,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          BuildTextField(
            '',
            dashBoardProvider.searchController,
            inputBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25.0),
            ),
            prefixIcon: Padding(
                padding: EdgeInsets.all(10),
                child: Icon(Icons.search_sharp)),
            isFilled: true,
            placeHolder: widget.dashBoardType == DashBoardType.collections ? i18.dashboard.SEARCH_NAME_CONNECTION : i18.dashboard.SEARCH_BY_BILL_OR_VENDOR,
            onChange: (val) => dashBoardProvider.onSearch(val, context),
          ),
          Expanded(
            child: StreamBuilder(
                stream: dashBoardProvider.initialStreamController.stream,
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    if(snapshot.data is String){
                      return CommonWidgets.buildEmptyMessage(snapshot.data, context);
                    }
                    return _buildTabView();
                  } else if (snapshot.hasError) {
                    return Notifiers.networkErrorPage(context, () => {});
                  } else {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                        return Loaders.CircularLoader();
                      case ConnectionState.active:
                        return Loaders.CircularLoader();
                      default:
                        return Container();
                    }
                  }
                }),
          )
        ]
    );
  }

  Widget _buildTabView() {
    var dashBoardProvider = Provider.of<DashBoardProvider>(context, listen: false);
    return Consumer<DashBoardProvider>(
      builder: (_, dashBoardProvider, child)
    {
      var tabList = dashBoardProvider.selectedDashboardType == DashBoardType.Expenditure ? dashBoardProvider.getExpenseTabList(context) : dashBoardProvider.getCollectionsTabList(context);

      return DefaultTabController(
        length: tabList.length,
        // initialIndex: ,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: ButtonsTabBar(
                // controller: _tabController,
                  backgroundColor: Colors.white,
                  unselectedBackgroundColor: Color.fromRGBO(244, 119, 56, 0.12),
                  contentPadding: EdgeInsets.symmetric(
                      horizontal: 10, vertical: 3),
                  buttonMargin: EdgeInsets.symmetric(horizontal: 5),
                  labelStyle: TextStyle(color: Theme
                      .of(context)
                      .primaryColor, fontWeight: FontWeight.bold),
                  unselectedLabelStyle: TextStyle(
                      color: Theme
                          .of(context)
                          .primaryColor, fontWeight: FontWeight.w400),
                  radius: 25,
                  tabs: tabList
              ),
            ),
            Expanded(
              child: Consumer<DashBoardProvider>(
                builder: (_, dashBoardProvider, child) =>
                    TabBarView(
                        physics: NeverScrollableScrollPhysics(),
                        // controller: _tabController,
                        children: List.generate(tabList.length, (index) =>
                            IndividualTab(index: index))
                    ),
              ),
            ),
          ],
        ),
      );
      });
  }

}
