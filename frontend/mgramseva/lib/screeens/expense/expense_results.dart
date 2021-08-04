

import 'package:flutter/material.dart';
import 'package:mgramseva/model/expensesDetails/expenses_details.dart';
import 'package:mgramseva/utils/date_formats.dart';
import 'package:mgramseva/widgets/BaseAppBar.dart';
import 'package:mgramseva/widgets/LabelText.dart';
import 'package:mgramseva/widgets/ShortButton.dart';

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
       return Column(children: [
         // ignore: unnecessary_null_comparison
         LabelText("${searchResult.length} consumer(s) Found"),
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
                                 "Vendor Name",
                                 expense.vendorName,
                                 context),
                             _getDetailtext(
                                 "Bill ID",
                                 expense.billId,
                                 context),
                             _getDetailtext(
                                 "Type of Expense",
                                 expense.expenseType,
                                 context),
                             _getDetailtext(
                                 "Amount",
                                 expense.expensesAmount.first.amount,
                                 context),
                             _getDetailtext(
                                 "Bill Date",
                                DateFormats.timeStampToDate(expense.billDate!.toInt()),
                                 context),
                             _getDetailtext(
                                 "Status",
                                 expense.status,
                                 context),
                             SizedBox(
                               height: 20,
                             ),
                             ShortButton(
                                 'Update Expenditure',
                                     () => Navigator.pushNamed(
                                     context, 'household/details')),
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
