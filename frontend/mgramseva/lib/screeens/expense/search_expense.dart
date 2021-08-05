import 'package:flutter/material.dart';
import 'package:mgramseva/providers/expenses_details_provider.dart';
import 'package:mgramseva/utils/Locilization/application_localizations.dart';
import 'package:mgramseva/utils/notifyers.dart';
import 'package:mgramseva/widgets/BaseAppBar.dart';
import 'package:mgramseva/widgets/BottonButtonBar.dart';
import 'package:mgramseva/widgets/DrawerWrapper.dart';
import 'package:mgramseva/widgets/FormWrapper.dart';
import 'package:mgramseva/widgets/HomeBack.dart';
import 'package:mgramseva/widgets/LabelText.dart';
import 'package:mgramseva/widgets/SelectFieldBuilder.dart';
import 'package:mgramseva/widgets/SideBar.dart';
import 'package:mgramseva/widgets/SubLabel.dart';
import 'package:mgramseva/widgets/TextFieldBuilder.dart';
import 'package:mgramseva/widgets/help.dart';
import 'package:mgramseva/utils/Constants/I18KeyConstants.dart';
import 'package:provider/provider.dart';

class SearchExpense extends StatefulWidget {
  const SearchExpense({Key? key}) : super(key: key);

  @override
  _SearchExpenseState createState() => _SearchExpenseState();
}

class _SearchExpenseState extends State<SearchExpense> {

  var vendorNameCtrl =  TextEditingController();
  String? expenseType;
  var billIdCtrl =  TextEditingController();
  bool isVisible = false;


  @override
  void initState() {
    Provider.of<ExpensesDetailsProvider>(context, listen: false)
    ..getExpenses();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: BaseAppBar(
          Text('mGramSeva'),
          AppBar(),
          <Widget>[Icon(Icons.more_vert)],
        ),
        drawer: DrawerWrapper(
          Drawer(child: SideBar()),
        ),
        body: SingleChildScrollView(
            child: FormWrapper(
              Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    HomeBack(widget: Help()),
                    Card(
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              LabelText("${ApplicationLocalizations.of(context).translate(i18.expense.SEARCH_EXPENSE_BILL)}"),
                              SubLabelText(
                                "${ApplicationLocalizations.of(context).translate(i18.expense.ENTER_VENDOR_BILL_EXPENSE)}",
                              ),
                              BuildTextField(
                                '${ApplicationLocalizations.of(context).translate(i18.expense.VENDOR_NAME)}',
                                vendorNameCtrl,
                              ),
                              Text('\n-(${ApplicationLocalizations.of(context).translate(i18.common.OR)})-', textAlign: TextAlign.center),
                              Consumer<ExpensesDetailsProvider>(
                                builder : (_, expensesDetailsProvider, child) => SelectFieldBuilder(
                                    '${ApplicationLocalizations.of(context).translate(i18.expense.EXPENSE_TYPE)}',
                                    expenseType,
                                    '',
                                    '',
                                    onChangeOfExpense,
                                    expensesDetailsProvider.getExpenseTypeList(),
                                    false, hint: '${ApplicationLocalizations.of(context).translate(i18.common.ELECTRICITY_HINT)}',),
                              ),
                              Visibility(
                                  visible: isVisible,
                                  child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Text('\n-(${ApplicationLocalizations.of(context).translate(i18.common.OR)})-', textAlign: TextAlign.center),
                                        BuildTextField(
                                          '${ApplicationLocalizations.of(context).translate(i18.common.BILL_ID)}',
                                          billIdCtrl,
                                          hint: '${ApplicationLocalizations.of(context).translate(i18.common.BILL_HINT)}',
                                        ),
                                      ])),
                               InkWell(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 25, top: 10, bottom: 10, right: 25),
                                  child: new Row(
                                    children: [
                                      new Text(
                                        isVisible ?  "\n${ApplicationLocalizations.of(context).translate(i18.common.SHOW_LESS)}" : "\n${ApplicationLocalizations.of(context).translate(i18.common.SHOW_MORE)}",
                                        style: new TextStyle(
                                            color: Colors.deepOrangeAccent),
                                      )
                                    ],
                                  ),
                                ),
                                onTap: () {
                                  setState(() {
                                    isVisible = !isVisible;
                                  });
                                },
                              ),
                            ]))
                  ]),
            )),
    bottomNavigationBar:   BottomButtonBar('${ApplicationLocalizations.of(context).translate(i18.common.SEARCH)}', onSubmit),
    );
  }

  void onChangeOfExpense(val) {
  setState(() {
    expenseType = val;
  });
  }

  void onSubmit() {
    FocusScope.of(context).nextFocus();

    if(vendorNameCtrl.text.trim().isNotEmpty || expenseType != null || billIdCtrl.text.trim().isNotEmpty) {
      var query = {
        'tenantId' :  'pb',
        'vendorName' : vendorNameCtrl.text.trim(),
        'expenseType' : expenseType,
        'challanNo' : billIdCtrl.text.trim()
      };

      query.removeWhere((key, value) => value == null || value.trim().isEmpty);

      var criteria = '';

      query.forEach((key, value) {
        switch(key){
          case 'expenseType' :
            criteria += '${ApplicationLocalizations.of(context).translate(i18.expense.EXPENSE_TYPE)} $expenseType \t';
            break;
          case 'challanNo' :
            criteria += '${ApplicationLocalizations.of(context).translate(i18.common.BILL_ID)} ${billIdCtrl.text}';
            break;
          case 'vendorName' :
            criteria += '${ApplicationLocalizations.of(context).translate(i18.expense.VENDOR_NAME)} ${vendorNameCtrl.text} \t';
            break;
        }
      });

      Provider.of<ExpensesDetailsProvider>(context, listen: false)
          .searchExpense(query, criteria, context);
    }else{
      Notifiers.getToastMessage(context,
          '${ApplicationLocalizations.of(context).translate(
              i18.expense.NO_FIELDS_FILLED)}', 'ERROR');
    }
  }
}
