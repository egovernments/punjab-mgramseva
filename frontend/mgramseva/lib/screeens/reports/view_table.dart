import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../../providers/reports_provider.dart';
import '../../widgets/home_back.dart';
import 'generic_report_table.dart';

class ViewTable extends StatelessWidget{
  final Function showTable;
  ViewTable(this.showTable);
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (context, constraints) { return Container(
          child: Column(
          children: [Consumer<ReportsProvider>(
            builder: (_, reportProvider, child) =>GenericReportTable(reportProvider.genericTableData))],
      ),
        );
    });
  }

}