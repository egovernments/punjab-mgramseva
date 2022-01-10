import 'package:flutter/material.dart';
import 'package:mgramseva/model/expensesDetails/expenses_details.dart';
import 'package:mgramseva/routers/Routers.dart';
import 'package:mgramseva/utils/Locilization/application_localizations.dart';
import 'package:mgramseva/utils/TestingKeys/testing_keys.dart';
import 'package:mgramseva/utils/date_formats.dart';
import 'package:mgramseva/utils/models.dart';
import 'package:mgramseva/widgets/BaseAppBar.dart';
import 'package:mgramseva/widgets/DrawerWrapper.dart';
import 'package:mgramseva/widgets/HomeBack.dart';
import 'package:mgramseva/widgets/LabelText.dart';
import 'package:mgramseva/widgets/ShortButton.dart';
import 'package:mgramseva/utils/Constants/I18KeyConstants.dart';
import 'package:mgramseva/widgets/SideBar.dart';
import 'package:mgramseva/widgets/customAppbar.dart';

class ExpenseResults extends StatelessWidget {
  final SearchResult searchResult;

  const ExpenseResults({Key? key, required this.searchResult})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar:  CustomAppBar(),
        drawer: DrawerWrapper(
          Drawer(child: SideBar()),
        ),
        body: LayoutBuilder(builder: (context, constraints) {
          return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HomeBack(),
                LabelText(
                    "${searchResult.result.length} ${ApplicationLocalizations.of(context).translate(i18.common.EXPENSES_FOUND)}"),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: RichText(
                      textAlign: TextAlign.left,
                      text: TextSpan(
                          style: TextStyle(
                              fontSize: 14,
                              color: Color.fromRGBO(80, 90, 95, 1)),
                          children: [
                            TextSpan(
                              text:
                                  '${ApplicationLocalizations.of(context).translate(i18.expense.FOLLOWING_EXPENDITURE_BILL_MATCH)}',
                            ),
                            TextSpan(
                                text: ' ${searchResult.label()}',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FontStyle.italic,
                                    height: 1.5))
                          ])),
                ),
                Expanded(
                  child: ListView.builder(
                      padding: const EdgeInsets.all(8),
                      itemCount: searchResult.result.length,
                      itemBuilder: (BuildContext context, int index) {
                        var expense =
                            searchResult.result[index] as ExpensesDetailsModel;
                        return Card(
                            child: Padding(
                                padding: EdgeInsets.all(15),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _getDetailtext(i18.expense.VENDOR_NAME,
                                        expense.vendorName, context),
                                    _getDetailtext(i18.common.BILL_ID,
                                        expense.challanNo, context),
                                    _getDetailtext(i18.expense.EXPENSE_TYPE,
                                        expense.expenseType, context),
                                    _getDetailtext(i18.expense.AMOUNT,
                                        '₹ ${expense.totalAmount}', context),
                                    _getDetailtext(
                                        i18.expense.BILL_DATE,
                                        DateFormats.timeStampToDate(
                                            expense.billDate!.toInt(),
                                            format: 'dd/MM/yyyy'),
                                        context),
                                    _getDetailtext(
                                        i18.common.STATUS,
                                        ApplicationLocalizations.of(context)
                                            .translate(getApplicationStatus(
                                                expense.applicationStatus ?? '',
                                                expense)),
                                        context),
                                    Visibility(
                                      visible: expense.applicationStatus !=
                                          'CANCELLED',
                                      child: SizedBox(
                                        height: 20,
                                      ),
                                    ),
                                    Visibility(
                                      visible: expense.applicationStatus !=
                                          'CANCELLED',
                                      child: ShortButton(
                                          i18.expense.UPDATE_EXPENDITURE,
                                          () => Navigator.pushNamed(
                                              context, Routes.EXPENSE_UPDATE,
                                              arguments: expense, ), key: Keys.expense.UPDATE_EXPNEDITURE),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                  ],
                                )));
                      }),
                )
              ]);
        }));
  }

  _getDetailtext(label, value, context) {
    return (Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
            padding: EdgeInsets.only(top: 16, bottom: 16),
            child: Text(
              '${ApplicationLocalizations.of(context).translate(label)}',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            )),
        Text('${ApplicationLocalizations.of(context).translate(value)}',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400))
      ],
    ));
  }

  String getApplicationStatus(
      String status, ExpensesDetailsModel expensesDetailsModel) {
    switch (status) {
      case 'PAID':
        return i18.expense.PAID;
      case 'ACTIVE':
        if (expensesDetailsModel.isBillPaid ?? false) {
          return i18.expense.PAID;
        }
        return i18.expense.UN_PAID;
      case 'CANCELLED':
        return i18.expense.CANCELLED;
      default:
        return '';
    }
  }
}
