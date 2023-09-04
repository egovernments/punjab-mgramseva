import 'package:flutter/material.dart';
import 'package:mgramseva/components/dashboard/bills_table.dart';
import 'package:provider/provider.dart';

import '../../model/common/BillsTableData.dart';
import '../../providers/reports_provider.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/drawer_wrapper.dart';
import '../../widgets/home_back.dart';
import '../../widgets/side_bar.dart';

class GenericReportTable extends StatelessWidget{
  final BillsTableData billsTableData;

  GenericReportTable(this.billsTableData);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: Container(
              width: constraints.maxWidth,
              height: constraints.maxHeight-50,
              child: Consumer<ReportsProvider>(

                builder: (context, reportsProvider,child) {
                  var width =
                  constraints.maxWidth < 760 ? 115.0 : (constraints.maxWidth / 6);
                  return BillsTable(height: (52.0 * billsTableData.tabledata.length + 1),
                      scrollPhysics: NeverScrollableScrollPhysics(),headerList: billsTableData.tableHeaders, tableData: billsTableData.tabledata, leftColumnWidth: width,
                    rightColumnWidth:
                    width * (billsTableData.tableHeaders.length - 1),);
                }
              ),
            ),
          );
        }
      );
  }

}