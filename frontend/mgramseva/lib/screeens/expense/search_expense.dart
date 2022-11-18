import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mgramseva/widgets/focus_watcher.dart';
import 'package:mgramseva/providers/common_provider.dart';
import 'package:mgramseva/providers/expenses_details_provider.dart';
import 'package:mgramseva/utils/Locilization/application_localizations.dart';
import 'package:mgramseva/utils/TestingKeys/testing_keys.dart';
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
import 'package:mgramseva/widgets/customAppbar.dart';
import 'package:mgramseva/widgets/footer.dart';
import 'package:mgramseva/utils/Constants/I18KeyConstants.dart';
import 'package:provider/provider.dart';

import '../../providers/language.dart';
import '../../utils/global_variables.dart';

class SearchExpense extends StatefulWidget {
  const SearchExpense({Key? key}) : super(key: key);

  @override
  _SearchExpenseState createState() => _SearchExpenseState();
}

class _SearchExpenseState extends State<SearchExpense> {
  var vendorNameCtrl = TextEditingController();
  String? expenseType;
  var billIdCtrl = TextEditingController();
  var expenseTypeCtrl = TextEditingController();
  bool isVisible = false;

  @override
  void initState() {
    Provider.of<ExpensesDetailsProvider>(context, listen: false)..getExpenses();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var languageProvider = Provider.of<LanguageProvider>(
        navigatorKey.currentContext!,
        listen: false);
    return KeyboardFocusWatcher(child:Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: CustomAppBar(),
      drawer: DrawerWrapper(
        Drawer(child: SideBar()),
      ),
      body: SingleChildScrollView(
          child: Column(children: [
        FormWrapper(
          Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HomeBack(),
                Card(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                      LabelText(i18.expense.SEARCH_EXPENSE_BILL),
                      SubLabelText(
                        i18.expense.ENTER_VENDOR_BILL_EXPENSE,
                      ),
                      BuildTextField(
                        i18.expense.VENDOR_NAME,
                        vendorNameCtrl,
                        key: Keys.expense.SEARCH_VENDOR_NAME,
                        inputFormatter: [
                          FilteringTextInputFormatter.allow(
                              RegExp(languageProvider.selectedLanguage!.enableRegEx
                                  ? languageProvider.selectedLanguage!.regEx.toString().split('^').last
                                  : "[A-Za-z ]"))
                        ],
                      ),
                      Text(
                          '\n${ApplicationLocalizations.of(context).translate(i18.common.OR)}',
                          textAlign: TextAlign.center),
                      Consumer<ExpensesDetailsProvider>(
                        builder: (_, expensesDetailsProvider, child) =>
                            SelectFieldBuilder(
                          i18.expense.EXPENSE_TYPE,
                          expenseType,
                          '',
                          '',
                          onChangeOfExpense,
                          expensesDetailsProvider.getExpenseTypeList(),
                          false,
                          hint:
                              '${ApplicationLocalizations.of(context).translate(i18.common.ELECTRICITY_HINT)}',
                          controller: expenseTypeCtrl,
                              key: Keys.expense.SEARCH_EXPENSE_TYPE,
                        ),
                      ),
                      Visibility(
                          visible: isVisible,
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                    '\n${ApplicationLocalizations.of(context).translate(i18.common.OR)}',
                                    textAlign: TextAlign.center),
                                BuildTextField(
                                  i18.common.BILL_ID,
                                  billIdCtrl,
                                  hint: i18.common.BILL_HINT,
                                  textCapitalization:
                                      TextCapitalization.characters,
                                  inputFormatter: [
                                    FilteringTextInputFormatter.allow(
                                        RegExp("[A-Z0-9-]"))
                                  ],
                                  key: Keys.expense.SEARCH_EXPENSE_BILL_ID,
                                ),
                              ])),
                      InkWell(
                        key: Keys.expense.SEARCH_EXPENSE_SHOW,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 25, top: 10, bottom: 10, right: 25),
                          child: new Row(
                            children: [
                              new Text(
                                isVisible
                                    ? "\n${ApplicationLocalizations.of(context).translate(i18.common.SHOW_LESS)}"
                                    : "\n${ApplicationLocalizations.of(context).translate(i18.common.SHOW_MORE)}",
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
        ),
        Footer()
      ])),
      bottomNavigationBar: BottomButtonBar(i18.common.SEARCH, onSubmit, key: Keys.expense.SEARCH_EXPENSES),
    ));
  }

  void onChangeOfExpense(val) {
    setState(() {
      expenseType = val;
    });
  }

  void onSubmit() {
    FocusScope.of(context).nextFocus();
    var commonProvider = Provider.of<CommonProvider>(context, listen: false);

    if (vendorNameCtrl.text.trim().isNotEmpty ||
        expenseType != null ||
        billIdCtrl.text.trim().isNotEmpty) {
      var query = {
        'tenantId': commonProvider.userDetails?.selectedtenant?.code,
        'vendorName': vendorNameCtrl.text.trim(),
        'expenseType': expenseType,
        'challanNo': billIdCtrl.text.trim()
      };

      query.removeWhere((key, value) => value == null || value.trim().isEmpty);



      Provider.of<ExpensesDetailsProvider>(context, listen: false)
          .searchExpense(query, () => getCrteria(query), context);
    } else {
      Notifiers.getToastMessage(context, i18.expense.NO_FIELDS_FILLED, 'ERROR');
    }
  }

  String getCrteria(Map query){
    var criteria = '';

    query.forEach((key, value) {
      switch (key) {
        case 'expenseType':
          criteria +=
          '${ApplicationLocalizations.of(context).translate(i18.expense.EXPENSE_TYPE)} ${ApplicationLocalizations.of(context).translate(expenseType ?? '')} \t';
          break;
        case 'challanNo':
          criteria +=
          '${ApplicationLocalizations.of(context).translate(i18.common.BILL_ID)} ${billIdCtrl.text}';
          break;
        case 'vendorName':
          criteria +=
          '${ApplicationLocalizations.of(context).translate(i18.expense.VENDOR_NAME)} ${vendorNameCtrl.text} \t';
          break;
      }
    });
    return criteria;
  }
}
