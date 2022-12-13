import 'package:mgramseva/utils/ExcelDownload/save_file_mobile.dart'
    if (dart.library.html) 'package:mgramseva/utils/ExcelDownload/save_file_web.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';

import '../../providers/common_provider.dart';

Future<void> generateExcel(
    List<String> headers, List<List<String>> tableData) async {
  //Create a Excel document.

  //Creating a workbook.
  final Workbook workbook = Workbook();
  //Accessing via index
  final Worksheet sheet = workbook.worksheets[0];
  // sheet.showGridlines = false;

  // Enable calculation for worksheet.
  sheet.enableSheetCalculations();

  // //Set data in the worksheet.
  sheet.getRangeByName('A1:D1').columnWidth = 32.5;

  for (int i = 0; i < headers.length; i++) {
    sheet
        .getRangeByName(
            '${CommonProvider.getAlphabetsWithKeyValue()[i].label}1')
        .setText(headers[CommonProvider.getAlphabetsWithKeyValue()[i].key]);
  }

  for (int i = 2; i < tableData.length + 2; i++) {
    for (int j = 0; j < headers.length; j++) {
      sheet
          .getRangeByName(
              '${CommonProvider.getAlphabetsWithKeyValue()[j].label}$i')
          .setText(tableData[i - 2][j]);
    }
  }

  //Save and launch the excel.
  final List<int> bytes = workbook.saveAsStream();
  //Dispose the document.
  workbook.dispose();

  //Save and launch the file.
  await saveAndLaunchFile(bytes, 'HouseholdRegister.xlsx');
}
