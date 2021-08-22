import 'package:flutter/material.dart';
import 'package:mgramseva/providers/expenses_details_provider.dart';
import 'package:mgramseva/utils/Constants/I18KeyConstants.dart';
import 'package:mgramseva/utils/Locilization/application_localizations.dart';
import 'package:mgramseva/utils/constants.dart';
import 'package:mgramseva/utils/global_variables.dart';
import 'package:mgramseva/widgets/DatePickerFieldBuilder.dart';
import 'package:mgramseva/widgets/RadioButtonFieldBuilder.dart';
import 'package:mgramseva/widgets/SelectFieldBuilder.dart';
import 'package:mgramseva/widgets/TextFieldBuilder.dart';
import 'package:mgramseva/widgets/auto_complete.dart';
import 'package:provider/provider.dart';
var expensesDetailsProvider = ExpensesDetailsProvider();

var json = [
  {
    "name": "Select the category of expenditure",
    "widget": SelectFieldBuilder(
      i18.expense.EXPENSE_TYPE,
      '',
      '',
      '',
          (val) => {},
      [],
      true,
    ),
  },
  {
    "name": "Mention the name of the vendor who raised the bill",
    "widget": AutoCompleteView(
      labelText: i18.expense.VENDOR_NAME,
      controller: TextEditingController(),
      onSuggestionSelected: (val) => {},
      callBack: expensesDetailsProvider.onSearchVendorList,
      listTile: (context, vendor) => Container(),
      isRequired: true,
    ),
  },
  {
    "name": "Add amount that is mentioned in the bill",
    "widget": BuildTextField(
      i18.expense.AMOUNT,
      TextEditingController(),
      isRequired: true,
    ),
  },
  {
    "name": "Add date on which bill is entered into records",
    "widget": BasicDateField(
              i18.expense.BILL_DATE,
                true,
              TextEditingController(),),
  },
  {
    "name": "Add date on which the bill is raised",
    "widget": BasicDateField(
      i18.expense.PAYMENT_DATE,
      true,
      TextEditingController(),),
  },
  /*{
    "name": "Attach JPEG/ PDF formats of the bill here",
    "widget": Container(
      margin: const EdgeInsets.only(
          top: 20.0, bottom: 5, right: 20, left: 20),
      alignment: Alignment.centerLeft,
      child: Wrap(
        direction: Axis.vertical,
        children: [
          Text(i18.common.ATTACHMENTS, style: TextStyle(fontSize: 19, fontWeight: FontWeight.normal)),
          Wrap(
            children: [Container(
              height: 45,
              width: 45,
              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey, width: 1.5)
              ),
              child: Text(''),
            ),
         ]
          )
        ],
      ),
    ),
  },*/
];

class ExpenseWalkThrough {
  final List<ExpenseWalkWidgets> expenseWalkThrough = json.map((e) => ExpenseWalkWidgets(
      name: e['name'] as String, widget: e['widget'] as Widget))
      .toList();
}

class ExpenseWalkWidgets {
  final String name;
  final Widget widget;
  bool isActive = false;
  GlobalKey? key;
  ExpenseWalkWidgets({required this.name, required this.widget});
}
