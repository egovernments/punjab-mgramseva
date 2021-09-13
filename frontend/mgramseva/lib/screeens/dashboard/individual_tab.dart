
import 'package:flutter/material.dart';
import 'package:mgramseva/components/Dashboard/BillsTable.dart';
import 'package:mgramseva/model/connection/water_connection.dart';
import 'package:mgramseva/model/expensesDetails/expenses_details.dart';
import 'package:mgramseva/providers/dashboard_provider.dart';
import 'package:mgramseva/utils/Locilization/application_localizations.dart';
import 'package:mgramseva/utils/common_widgets.dart';
import 'package:mgramseva/utils/loaders.dart';
import 'package:mgramseva/utils/models.dart';
import 'package:mgramseva/utils/notifyers.dart';
import 'package:provider/provider.dart';
import 'package:mgramseva/utils/Constants/I18KeyConstants.dart';

class IndividualTab extends StatefulWidget {
  final int index;
  const IndividualTab({Key? key, required this.index}) : super(key: key);

  @override
  _IndividualTabState createState() => _IndividualTabState();
}

class _IndividualTabState extends State<IndividualTab> {

  @override
  void initState() {
    WidgetsBinding.instance?.addPostFrameCallback((_) => afterViewBuild());
    super.initState();
  }

  afterViewBuild(){
    var dashBoardProvider = Provider.of<DashBoardProvider>(context, listen: false)
      ..limit = 10
      ..offset = 1
      ..sortBy = null;
    if(dashBoardProvider.selectedDashboardType ==  DashBoardType.Expenditure){

      dashBoardProvider
        ..sortBy = SortBy('challanno', false)
        ..expenseDashboardDetails?.expenseDetailList = <ExpensesDetailsModel>[]
        ..expenseDashboardDetails?.totalCount = null;

      if(widget.index == 0) {
        dashBoardProvider.selectedTab = 'all';
      }else if(widget.index == 1){
        dashBoardProvider.selectedTab = 'ACTIVE';
      }else{
        dashBoardProvider.selectedTab = 'PAID';
      }

      dashBoardProvider.fetchExpenseDashBoardDetails(
          context, dashBoardProvider.limit, dashBoardProvider.offset, true);
    }else{
      dashBoardProvider
        ..waterConnectionsDetails?.waterConnection = <WaterConnection>[]
        ..waterConnectionsDetails?.totalCount = null;

      if(widget.index == 0) {
        dashBoardProvider.selectedTab = 'all';
      }else {
        dashBoardProvider.selectedTab = dashBoardProvider.propertyTaxList[widget.index].code ?? '';
      }
      dashBoardProvider.fetchCollectionsDashBoardDetails(context, dashBoardProvider.limit, dashBoardProvider.offset, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    var dashBoardProvider = Provider.of<DashBoardProvider>(context, listen: false);
   return StreamBuilder(
        stream: dashBoardProvider.streamController.stream,
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            if(snapshot.data is String){
              return CommonWidgets.buildEmptyMessage(snapshot.data, context);
            }
            return _buildTabView(snapshot.data);
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
        });
  }


  Widget _buildView(List<dynamic> expenseList){
    var dashBoardProvider = Provider.of<DashBoardProvider>(context, listen: false);

    return LayoutBuilder(
        builder : (context, constraints) {
          var width = constraints.maxWidth < 760 ?  (expenseList is List<ExpensesDetailsModel> ? 180.0 : 145.0)  : (constraints.maxWidth / (expenseList is List<ExpensesDetailsModel> ? 5 : 3));
          var tableData = expenseList is List<ExpensesDetailsModel> ?  dashBoardProvider.getExpenseData(widget.index, expenseList as List<ExpensesDetailsModel>) : dashBoardProvider.getCollectionsData(widget.index, expenseList  as List<WaterConnection>);
          return tableData == null || tableData.isEmpty ?
          CommonWidgets.buildEmptyMessage(ApplicationLocalizations.of(context).translate(i18.dashboard.NO_RECORDS_MSG), context)
              : BillsTable
            (headerList: expenseList is List<ExpensesDetailsModel> ? dashBoardProvider.expenseHeaderList : dashBoardProvider.collectionHeaderList,
            tableData:  tableData,
            leftColumnWidth: width,
            rightColumnWidth: expenseList is List<ExpensesDetailsModel> ? width * 5 : width * 3,
          );
        }
    );
  }


  Widget _buildTabView(List<dynamic> expenseList) {
    var dashBoardProvider = Provider.of<DashBoardProvider>(context, listen: false);

    return LayoutBuilder(
        builder : (context, constraints) {
          var width = constraints.maxWidth < 760 ?  (expenseList is List<ExpensesDetailsModel> ? 180.0 : 145.0)  : (constraints.maxWidth / (expenseList is List<ExpensesDetailsModel> ? 5 : 3));
          var tableData = expenseList is List<ExpensesDetailsModel> ? dashBoardProvider.getExpenseData(widget.index, expenseList as List<ExpensesDetailsModel>) : dashBoardProvider.getCollectionsData(widget.index, expenseList  as List<WaterConnection>);
          return tableData == null || tableData.isEmpty ?
          CommonWidgets.buildEmptyMessage(ApplicationLocalizations.of(context).translate(i18.dashboard.NO_RECORDS_MSG), context)
              : BillsTable
            (headerList: expenseList is List<ExpensesDetailsModel> ? dashBoardProvider.expenseHeaderList : dashBoardProvider.collectionHeaderList,
            tableData:  tableData,
            leftColumnWidth: width,
            rightColumnWidth: expenseList is List<ExpensesDetailsModel> ? width * 5 : width * 3,
          );
        }
    );
  }
}
