import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:mgramseva/model/common/metric.dart';
import 'package:mgramseva/providers/common_provider.dart';
import 'package:mgramseva/providers/dashboard_provider.dart';
import 'package:mgramseva/providers/language.dart';
import 'package:mgramseva/utils/Constants/I18KeyConstants.dart';
import 'package:mgramseva/utils/Locilization/application_localizations.dart';
import 'package:mgramseva/utils/date_formats.dart';
import 'package:mgramseva/utils/global_variables.dart';
import 'package:mgramseva/utils/models.dart';
import 'package:mgramseva/utils/pdf.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:provider/provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:universal_html/html.dart' as html;

class DashboardPdfCreator {
  final List<String> headers;
  final List<List<String>> tableData;
  // final List<Metric> gridList;
  BuildContext buildContext;
  final Map feedBack;

  DashboardPdfCreator(
      this.buildContext, this.headers, this.tableData, this.feedBack);

  pdfPreview() async {
    var pdf = pw.Document();
    final ttf = await Provider.of<CommonProvider>(buildContext, listen: false)
        .getPdfFontFamily();

    final mgramSevaLogo = await PdfUtils.mgramSevaLogo;
    final digitLogo = await PdfUtils.powerdByDigit;

    var icons =
        pw.Font.ttf(await rootBundle.load('assets/icons/fonts/PdfIcons.ttf'));

    // pdf.addPage(pw.MultiPage(
    //     pageFormat: PdfPageFormat.a4,
    //     footer: (_) => PdfUtils.pdfFooter(digitLogo),
    //     build: (pw.Context context) {
    //       return [
    //         PdfUtils.buildAppBar(buildContext, mgramSevaLogo, icons),
    //         _buildDashboardView(buildContext, feedBack, icons),
    //         _buildGridView(gridList, buildContext),
    //         pw.Container(
    //             margin: pw.EdgeInsets.only(top: 14, bottom: 3),
    //             child: pw.Text('Expenditure All Records',
    //                 style: pw.TextStyle(
    //                     fontSize: 14, fontWeight: pw.FontWeight.bold))),
    //         _buildTable(ttf),
    //         PdfUtils.pdfFooter(digitLogo)
    //       ];
    //     }));

    // Provider.of<CommonProvider>(buildContext, listen: false).sharePdfOnWhatsApp(buildContext, pdf, 'expenditure', '<link>');

    if (kIsWeb) {
      final blob = html.Blob([await pdf.save()]);
      final url = html.Url.createObjectUrlFromBlob(blob);
      final anchor = html.document.createElement('a') as html.AnchorElement
        ..href = url
        ..style.display = 'none'
        ..download = 'dashboard.pdf';
      html.document.body?.children.add(anchor);
      anchor.click();
      html.document.body?.children.remove(anchor);
      html.Url.revokeObjectUrl(url);
    } else {
      final Directory directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/example.pdf');
      await file.writeAsBytes(await pdf.save());
      // Navigator.pushReplacement(buildContext,
      //     MaterialPageRoute(builder: (_) => PdfPreview(path: file.path)));
    }
  }

  // pw.Widget _buildGridView(List<Metric> gridList, BuildContext context) {
  //   var dashBoardProvider = Provider.of<DashBoardProvider>(
  //       navigatorKey.currentContext!,
  //       listen: false);

  //   var crossAxisCount = 3;
  //   var incrementer = 3;
  //   return pw
  //       .Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
  //     pw.Container(
  //         decoration: pw.BoxDecoration(
  //           color: PdfColor.fromHex('#fafafa'),
  //         ),
  //         width: 200,
  //         alignment: pw.Alignment.centerLeft,
  //         padding: pw.EdgeInsets.symmetric(vertical: 5, horizontal: 10),
  //         margin: pw.EdgeInsets.only(top: 8, bottom: 3),
  //         child: pw.Text(
  //             '${ApplicationLocalizations.of(context).translate('${dashBoardProvider.selectedDashboardType == DashBoardType.Expenditure ? i18.dashboard.EXPENDITURE : i18.dashboard.COLLECTIONS}')}',
  //             style:
  //                 pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold))),
  //     pw.Container(
  //         height: 60,
  //         color: PdfColor.fromHex('#fafafa'),
  //         child: pw.GridView(
  //             crossAxisCount: crossAxisCount,
  //             children: List.generate(gridList.length, (index) {
  //               var item = gridList[index];
  //               if (incrementer == index) {
  //                 incrementer += crossAxisCount;
  //               }
  //               return pw.Container(
  //                   decoration: pw.BoxDecoration(
  //                     border: index == (incrementer - crossAxisCount)
  //                         ? null
  //                         : pw.Border(
  //                             left: pw.BorderSide(
  //                               width: 1.0, /*color: Colors.grey*/
  //                             ),
  //                           ),
  //                     // color: Colors.white,
  //                   ),
  //                   alignment: pw.Alignment.center,
  //                   padding:
  //                       pw.EdgeInsets.symmetric(vertical: 3, horizontal: 16),
  //                   child: pw.Column(
  //                       crossAxisAlignment: pw.CrossAxisAlignment.center,
  //                       mainAxisAlignment: pw.MainAxisAlignment.center,
  //                       children: [
  //                         pw.Text(
  //                           '${item.type == 'amount' ? '₹' : ''}${ApplicationLocalizations.of(context).translate('${item.label}')}',
  //                           textAlign: pw.TextAlign.center,
  //                           style: pw.TextStyle(
  //                             fontSize: 16,
  //                             fontWeight: pw.FontWeight.bold,
  //                           ),
  //                         ),
  //                         pw.SizedBox(height: 3),
  //                         pw.Text(
  //                           ApplicationLocalizations.of(context)
  //                               .translate('${item.value}'),
  //                           textAlign: pw.TextAlign.center,
  //                           style: pw.TextStyle(fontSize: 14),
  //                         )
  //                       ]));
  //             })))
  //   ]);
  // }

  pw.Widget _buildDashboardView(
      BuildContext context, Map feedBack, pw.Font icons) {
    var dashBoardProvider = Provider.of<DashBoardProvider>(
        navigatorKey.currentContext!,
        listen: false);

    return pw.Container(
        color: PdfColor.fromHex('#fafafa'),
        padding: pw.EdgeInsets.symmetric(vertical: 3, horizontal: 8),
        margin: pw.EdgeInsets.symmetric(vertical: 3),
        child: pw.Column(mainAxisSize: pw.MainAxisSize.min, children: [
          pw.Padding(
              padding: pw.EdgeInsets.symmetric(vertical: 8),
              child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text(
                        '${ApplicationLocalizations.of(context).translate(i18.dashboard.DASHBOARD)}',
                        style: pw.TextStyle(
                            fontSize: 16, fontWeight: pw.FontWeight.bold)),
                    pw.Text(
                        DateFormats.getMonthAndYear(
                            dashBoardProvider.selectedMonth, context),
                        style: pw.TextStyle(color: PdfColor.fromHex('#F47738')))
                  ])),
          if (feedBack.isNotEmpty) _buildRatingView(context, feedBack, icons)
        ]));
  }

  pw.Widget _buildRatingView(
      BuildContext context, Map feedBack, pw.Font icons) {
    Map feedBackDetails = Map.from(feedBack);
    feedBackDetails.remove('count');
    return pw.Container(
        height: 60,
        child: pw.GridView(
          crossAxisCount: 3,
          // childAspectRatio: 1.2,
          children: List.generate(
            feedBackDetails.keys.length,
            (index) => pw.Container(
                decoration: pw.BoxDecoration(
                  // color: PdfColor.fromHex('#00703C'),
                  border: index == 0
                      ? null
                      : pw.Border(
                          left: pw.BorderSide(
                          width: 1.0, /*color: Colors.grey*/
                        )),
                  // color: Colors.white,
                ),
                padding: pw.EdgeInsets.all(12),
                child: pw.Center(
                  child: pw.Column(
                      mainAxisAlignment: pw.MainAxisAlignment.center,
                      crossAxisAlignment: pw.CrossAxisAlignment.center,
                      children: [
                        pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.center,
                          children: [
                            pw.Text(
                              feedBackDetails.values.toList()[index].toString(),
                              textAlign: pw.TextAlign.center,
                              style: pw.TextStyle(
                                fontSize: 14,
                                fontWeight: pw.FontWeight.bold,
                              ),
                            ),
                            pw.Icon(pw.IconData(0xe801),
                                color: PdfColor.fromHex('#F47738'),
                                font: icons),
                          ],
                        ),
                        pw.Expanded(
                          child: pw.Padding(
                            padding: const pw.EdgeInsets.only(top: 5.0),
                            child: pw.Text(
                              '${ApplicationLocalizations.of(context).translate('DASHBOARD_${feedBackDetails.keys.toList()[index].toString()}')}',
                              textAlign: pw.TextAlign.center,
                            ),
                          ),
                        )
                      ]),
                )),
          ).toList(),
        ));
  }

  pw.Table _buildTable(pw.Font ttf) {
    // return pw.Table(
    //    children: tableData.map((e) => pw.TableRow(
    //      children: e.map((text) => pw.Container(
    //        child: pw.Text('${text}',
    //           style : pw.TextStyle(
    //                font: ttf,
    //                fontSize: 12
    //            )
    //        )
    //      )).toList()
    //    )).toList()
    //  );
    return pw.Table.fromTextArray(
        headers: headers,
        headerStyle: pw.TextStyle(font: ttf, fontWeight: pw.FontWeight.bold),
        cellStyle: pw.TextStyle(font: ttf, fontSize: 12),
        cellAlignment: pw.Alignment.center,
        data: tableData,
        oddRowDecoration: pw.BoxDecoration(color: PdfColor.fromHex('#EEEEEE'))
        //headerDecoration: pw.BoxDecoration(color: PdfColor.fromRYB(0.98, 0.60, 0.01))
        );
  }
}
