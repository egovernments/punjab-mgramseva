
import 'package:flutter/material.dart';
import 'package:mgramseva/components/Dashboard/BillsTable.dart';
import 'package:mgramseva/components/HouseholdRegister/HouseholdTable.dart';
import 'package:mgramseva/model/connection/water_connection.dart';
import 'package:mgramseva/model/expensesDetails/expenses_details.dart';
import 'package:mgramseva/providers/dashboard_provider.dart';
import 'package:mgramseva/providers/household_register_provider.dart';
import 'package:mgramseva/utils/Locilization/application_localizations.dart';
import 'package:mgramseva/utils/common_widgets.dart';
import 'package:mgramseva/utils/loaders.dart';
import 'package:mgramseva/utils/models.dart';
import 'package:mgramseva/utils/notifyers.dart';
import 'package:provider/provider.dart';
import 'package:mgramseva/utils/Constants/I18KeyConstants.dart';

class HouseholdList extends StatefulWidget {
  final int index;
  const HouseholdList({Key? key, required this.index}) : super(key: key);

  @override
  _HouseholdListState createState() => _HouseholdListState();
}

class _HouseholdListState extends State<HouseholdList> {

  @override
  void initState() {
    WidgetsBinding.instance?.addPostFrameCallback((_) => afterViewBuild());
    super.initState();
  }

  afterViewBuild(){
    var householdProvider = Provider.of<HouseholdRegisterProvider>(context, listen: false)
      ..limit = 10
      ..offset = 1
      ..sortBy = null;

      householdProvider
        ..waterConnectionsDetails?.waterConnection = <WaterConnection>[]
        ..waterConnectionsDetails?.totalCount = null;

      if(widget.index == 0) {
        householdProvider.selectedTab = 'all';
      }else if(widget.index == 1){
        householdProvider.selectedTab = 'PAID';
      }else{
        householdProvider.selectedTab = 'PENDING';
      }
      householdProvider.fetchCollectionsDashBoardDetails(context, householdProvider.limit, householdProvider.offset, true);
  }

  @override
  Widget build(BuildContext context) {
    var householdProvider = Provider.of<HouseholdRegisterProvider>(context, listen: false);
    return StreamBuilder(
        stream: householdProvider.streamController.stream,
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


  Widget _buildTabView(List<dynamic> expenseList) {
    var householdProvider = Provider.of<HouseholdRegisterProvider>(context, listen: false);

    return LayoutBuilder(
        builder : (context, constraints) {
          var width = constraints.maxWidth < 760 ? 145.0  : (constraints.maxWidth / 3);
          var tableData = householdProvider.getCollectionsData(widget.index, expenseList  as List<WaterConnection>);
          return tableData == null || tableData.isEmpty ?
          CommonWidgets.buildEmptyMessage(ApplicationLocalizations.of(context).translate(i18.dashboard.NO_RECORDS_MSG), context)
              : HouseholdTable
            (headerList: householdProvider.collectionHeaderList,
            tableData:  tableData,
            leftColumnWidth: width,
            rightColumnWidth: width * 3,
          );
        }
    );
  }
}
