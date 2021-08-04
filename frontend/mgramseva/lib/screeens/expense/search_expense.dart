import 'package:flutter/material.dart';
import 'package:mgramseva/providers/expenses_details_provider.dart';
import 'package:mgramseva/utils/Locilization/application_localizations.dart';
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
                              LabelText("Search Expense Bills"),
                              SubLabelText(
                                "Enter the Vendor Name or Expenditure type or Bill ID to get more details. Please enter only one",
                              ),
                              BuildTextField(
                                'Vendor Name',
                                vendorNameCtrl,
                              ),
                              Text('\n-(or)-', textAlign: TextAlign.center),
                              Consumer<ExpensesDetailsProvider>(
                                builder : (_, expensesDetailsProvider, child) => SelectFieldBuilder(
                                    '${ApplicationLocalizations.of(context).translate(i18.expense.EXPENSE_TYPE)}',
                                    expenseType,
                                    '',
                                    '',
                                    onChangeOfExpense,
                                    expensesDetailsProvider.getExpenseTypeList(),
                                    false, hint: 'Eg: Electricity',),
                              ),
                              Visibility(
                                  visible: isVisible,
                                  child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Text('\n-(or)-', textAlign: TextAlign.center),
                                        BuildTextField(
                                          'Bill ID',
                                          billIdCtrl,
                                          hint: 'Eg: EB-2021-22/08/21/0123',
                                        ),
                                      ])),
                               InkWell(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 25, top: 10, bottom: 10, right: 25),
                                  child: new Row(
                                    children: [
                                      new Text(
                                        isVisible ?  "\nShow Less" : "\nShow more",
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
    bottomNavigationBar:   BottomButtonBar('Search', onSubmit),
    );
  }

  void onChangeOfExpense(val) {
  setState(() {
    expenseType = val;
  });
  }

  void onSubmit() {

    if(vendorNameCtrl.text.trim().isNotEmpty || expenseType != null || billIdCtrl.text.trim().isNotEmpty) {
      var query = {
      };

      Provider.of<ExpensesDetailsProvider>(context, listen: false)
          .searchExpense(query, context);
    }else{

    }
  }
}
