import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mgramseva/components/Dashboard/BillsTable.dart';
import 'package:mgramseva/providers/dashboard_provider.dart';
import 'package:mgramseva/providers/revenuedashboard_provider.dart';
import 'package:mgramseva/screeens/dashboard/revenue_dashboard/revenue_charts.dart';
import 'package:mgramseva/utils/Locilization/application_localizations.dart';
import 'package:mgramseva/utils/common_widgets.dart';
import 'package:mgramseva/utils/loaders.dart';
import 'package:mgramseva/utils/models.dart';
import 'package:mgramseva/utils/notifyers.dart';
import 'package:mgramseva/widgets/footer.dart';
import 'package:provider/provider.dart';
import 'package:mgramseva/utils/Constants/I18KeyConstants.dart';

class RevenueDashBoard extends StatefulWidget {
  final bool isFromScreenshot;
  const RevenueDashBoard({Key? key, this.isFromScreenshot = false}) : super(key: key);

  @override
  _RevenueDashBoardState createState() => _RevenueDashBoardState();
}

class _RevenueDashBoardState extends State<RevenueDashBoard> {

  @override
  void initState() {
    var revenueProvider = Provider.of<RevenueDashboard>(context, listen: false);
    revenueProvider.loadRevenueDetails(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        children: [
          RevenueCharts(),
          _buildLoaderView(),
          Visibility(
            visible: !widget.isFromScreenshot,
            child: Align(
                alignment: Alignment.centerLeft,
                child: _buildNote()),
          ),
          Footer()
        ],
      ),
    );
  }

  Widget _buildLoaderView(){
    var revenueDashboard = Provider.of<RevenueDashboard>(context, listen: false);
    return StreamBuilder(
        stream: revenueDashboard.revenueStreamController.stream,
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            if(snapshot.data is String){
              return CommonWidgets.buildEmptyMessage(snapshot.data, context);
            }
            return _buildTable(snapshot.data);
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

  Widget _buildNote(){
   return Container(
     decoration: new BoxDecoration(color: Theme.of(context).highlightColor),
     width: MediaQuery.of(context).size.width,
     padding: EdgeInsets.all(8),
     child: Column(
       crossAxisAlignment: CrossAxisAlignment.start,
       children: [
         Wrap(
           spacing: 5,
           crossAxisAlignment: WrapCrossAlignment.center,
           children: [
           Icon(Icons.info, color: Theme.of(context).hintColor),
           Text(ApplicationLocalizations.of(context).translate(i18.common.NOTE),
               style: TextStyle(
                   fontSize: 18,
                   fontWeight: FontWeight.w700,
                   color: Theme.of(context).hintColor))
         ],),
         Padding(
           padding: const EdgeInsets.symmetric(vertical: 8),
           child: Text('${ApplicationLocalizations.of(context).translate(i18.dashboard.REVENUE_NOTE)}',
           style: TextStyle(fontSize: 16,
           fontWeight: FontWeight.w400,
             height: 1.5,
             color: Color.fromRGBO(52, 152, 219, 1)
           ),
           ),
         )
       ],
     ),
    );
  }


  Widget _buildTable(List<TableDataRow> tableData){
    var revenueDashboard = Provider.of<RevenueDashboard>(context, listen: false);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: LayoutBuilder(
        builder : (context, constraints) {
          var width = constraints.maxWidth < 760 ?  150.0 : constraints.maxWidth / 8;
         return BillsTable
            (headerList: revenueDashboard.revenueHeaderList,
            tableData:  tableData,
            leftColumnWidth: width,
            rightColumnWidth:  width * 7,
           height: 68 + (52.0 * tableData.length),
           scrollPhysics:  NeverScrollableScrollPhysics(),
          );
        }),
    );
  }
}
