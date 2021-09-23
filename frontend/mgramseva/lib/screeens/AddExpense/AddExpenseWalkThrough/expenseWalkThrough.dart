import 'package:flutter/material.dart';
import 'package:mgramseva/providers/expenses_details_provider.dart';
import 'package:mgramseva/utils/Constants/I18KeyConstants.dart';
import 'package:mgramseva/widgets/DatePickerFieldBuilder.dart';
import 'package:mgramseva/widgets/FilePicker.dart';
import 'package:mgramseva/widgets/SelectFieldBuilder.dart';
import 'package:mgramseva/widgets/TextFieldBuilder.dart';
import 'package:mgramseva/widgets/auto_complete.dart';

var expensesDetailsProvider = ExpensesDetailsProvider();

var json = [
  {
    "name": (i18.expenseWalkThroughMsg.EXPENSE_TYPE_MSG),
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
    "name": (i18.expenseWalkThroughMsg.EXPENSE_VENDOR_NAME_MSG),
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
    "name": (i18.expenseWalkThroughMsg.EXPENSE_AMOUNT_MSG),
    "widget": BuildTextField(
      i18.expense.AMOUNT,
      TextEditingController(),
      isRequired: true,
    ),
  },
  {
    "name": (i18.expenseWalkThroughMsg.EXPENSE_BILL_DATE_MSG),
    "widget": BasicDateField(
      i18.expense.BILL_DATE,
      true,
      TextEditingController(),
    ),
  },
  {
    "name": (i18.expenseWalkThroughMsg.EXPENSE_PARTY_BILL_DATE_MSG),
    "widget": BasicDateField(
      i18.expense.PAYMENT_DATE,
      true,
      TextEditingController(),
    ),
  },
  {
    "name": (i18.expenseWalkThroughMsg.EXPENSE_ATTACH_BILL_MSG),
    "widget": FilePickerDemo(
      callBack: expensesDetailsProvider.fileStoreIdCallBack,
    )
  },
];

class ExpenseWalkThrough {
  final List<ExpenseWalkWidgets> expenseWalkThrough = json
      .map((e) => ExpenseWalkWidgets(
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
