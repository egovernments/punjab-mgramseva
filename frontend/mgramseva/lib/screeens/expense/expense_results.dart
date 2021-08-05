

import 'package:flutter/material.dart';
import 'package:mgramseva/model/expensesDetails/expenses_details.dart';
import 'package:mgramseva/routers/Routers.dart';
import 'package:mgramseva/utils/Locilization/application_localizations.dart';
import 'package:mgramseva/utils/date_formats.dart';
import 'package:mgramseva/widgets/BaseAppBar.dart';
import 'package:mgramseva/widgets/LabelText.dart';
import 'package:mgramseva/widgets/ShortButton.dart';
import 'package:mgramseva/utils/Constants/I18KeyConstants.dart';

class ExpenseResults extends StatelessWidget {
  final List<ExpensesDetailsModel> searchResult;

  const ExpenseResults({Key? key, required this.searchResult}) : super(key: key);

  @override
  Widget build(BuildContext context) {
  return  Scaffold(
      appBar: BaseAppBar(
        Text('mGramSeva'),
        AppBar(),
        <Widget>[Icon(Icons.more_vert)],
      ),
     body : LayoutBuilder(builder: (context, constraints) {
       return Column(
           crossAxisAlignment: CrossAxisAlignment.start,
           children: [
         // ignore: unnecessary_null_comparison
         LabelText("${searchResult.length} ${ApplicationLocalizations.of(context).translate(i18.common.CONSUMERS_FOUND)}"),
         Padding(
           padding: const EdgeInsets.all(15.0),
           child: RichText(
               textAlign: TextAlign.left,
               text: TextSpan(
             style: TextStyle(fontSize: 14),
             children: [
               TextSpan(text: '${ApplicationLocalizations.of(context).translate(i18.expense.FOLLOWING_EXPENDITURE_BILL_MATCH)}',
               ),
               TextSpan(text: '${ApplicationLocalizations.of(context).translate(i18.common.PHONE_NUMBER)} +91 - 7731045306',
                   style: TextStyle(fontWeight: FontWeight.bold, fontStyle: FontStyle.italic)
               )
             ]
           )),
         ),
         Expanded(
           child: ListView.builder(
               padding: const EdgeInsets.all(8),
               itemCount: searchResult.length,
               itemBuilder: (BuildContext context, int index) {
                 var expense = searchResult[index];
                 return Card(
                     child: Padding(
                         padding: EdgeInsets.all(15),
                         child: Column(
                           crossAxisAlignment: CrossAxisAlignment.start,
                           children: [
                             _getDetailtext(
                                 "${ApplicationLocalizations.of(context).translate(i18.expense.VENDOR_NAME)}",
                                 expense.vendorId,
                                 context),
                             _getDetailtext(
                                 "${ApplicationLocalizations.of(context).translate(i18.common.BILL_ID)}",
                                 expense.challanNo,
                                 context),
                             _getDetailtext(
                                 "${ApplicationLocalizations.of(context).translate(i18.expense.EXPENSE_TYPE)}",
                                 expense.expenseType,
                                 context),
                             _getDetailtext(
                                 "${ApplicationLocalizations.of(context).translate(i18.common.AMOUNT)}",
                                 expense.expensesAmount.first.amount,
                                 context),
                             _getDetailtext(
                                 "${ApplicationLocalizations.of(context).translate(i18.expense.BILL_DATE)}",
                                DateFormats.timeStampToDate(expense.billDate!.toInt()),
                                 context),
                             _getDetailtext(
                                 "${ApplicationLocalizations.of(context).translate(i18.common.STATUS)}",
                                 expense.applicationStatus,
                                 context),
                             SizedBox(
                               height: 20,
                             ),
                             ShortButton(
                                 '${ApplicationLocalizations.of(context).translate(i18.expense.UPDATE_EXPENDITURE)}',
                                     () => Navigator.pushNamed(
                                     context, Routes.HOUSEHOLD_DETAILS)),
                             SizedBox(
                               height: 20,
                             ),
                           ],
                         )));
               }),
         )
       ]);
     })
   );
  }


  _getDetailtext(label, value, context) {
    return (Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
            padding: EdgeInsets.only(top: 16, bottom: 16),
            child: Text(
              label,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            )),
        Text('$value', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400))
      ],
    ));
  }
}
