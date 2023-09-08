import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/reports_provider.dart';
import '../../utils/localization/application_localizations.dart';
import '../../widgets/label_text.dart';
import '../../widgets/pagination.dart';
import 'generic_report_table.dart';

class ViewTable extends StatelessWidget {
  final ScrollController scrollController;
  final String tableTitle;

  ViewTable({required this.tableTitle, required this.scrollController});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
              margin: EdgeInsets.only(bottom: 2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(0.0),
              ),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    LabelText(
                        '${ApplicationLocalizations.of(context).translate(tableTitle)}'),
                  ])),
          SizedBox(
            height: 30,
          ),
          Container(
            child:
                Consumer<ReportsProvider>(builder: (_, reportProvider, child) {
              var width = constraints.maxWidth < 760
                  ? 115.0
                  : (constraints.maxWidth / 6);
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GenericReportTable(
                    reportProvider.genericTableData,
                    scrollController: scrollController,
                  ),
                  Container(
                    width: width *
                            reportProvider
                                .genericTableData.tableHeaders.length +
                        2,
                    child: Visibility(
                      visible:
                          reportProvider.genericTableData.tableData.isNotEmpty,
                      child: Pagination(
                        limit: reportProvider.limit,
                        offSet: reportProvider.offset,
                        callBack: (pageResponse) =>
                            reportProvider.onChangeOfPageLimit(
                                pageResponse, tableTitle, context),
                        isTotalCountVisible: false,
                        totalCount:
                            reportProvider.genericTableData.tableData.length,
                      ),
                    ),
                  )
                ],
              );
            }),
          ),
        ],
      );
    });
  }
}
