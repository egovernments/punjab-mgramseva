import 'package:flutter/material.dart';
import 'package:mgramseva/model/expensesDetails/expenses_details.dart';
import 'package:mgramseva/providers/expenses_details_provider.dart';
import 'package:mgramseva/screeens/Home.dart';
import 'package:mgramseva/utils/constants.dart';
import 'package:mgramseva/utils/loaders.dart';
import 'package:mgramseva/utils/notifyers.dart';
import 'package:mgramseva/widgets/BaseAppBar.dart';
import 'package:mgramseva/widgets/BottonButtonBar.dart';
import 'package:mgramseva/widgets/DatePickerFieldBuilder.dart';
import 'package:mgramseva/widgets/DrawerWrapper.dart';
import 'package:mgramseva/widgets/FilePicker.dart';
import 'package:mgramseva/widgets/FormWrapper.dart';
import 'package:mgramseva/widgets/HomeBack.dart';
import 'package:mgramseva/widgets/LabelText.dart';
import 'package:mgramseva/widgets/RadioButtonFieldBuilder.dart';
import 'package:mgramseva/widgets/SelectFieldBuilder.dart';
import 'package:mgramseva/widgets/SideBar.dart';
import 'package:mgramseva/routers/Routers.dart';
import 'package:mgramseva/widgets/SubLabel.dart';
import 'package:mgramseva/widgets/TextFieldBuilder.dart';
import 'package:provider/provider.dart';

class ExpenseDetails extends StatefulWidget {
  State<StatefulWidget> createState() {
    return _ExpenseDetailsState();
  }
}

class _ExpenseDetailsState extends State<ExpenseDetails> {
  String _gender = 'YES';
  String _amountType = "FULL";


  @override
  void initState() {
    WidgetsBinding.instance?.addPostFrameCallback((_) => afterViewBuild());
    super.initState();
  }

  afterViewBuild() {
        Provider.of<ExpensesDetailsProvider>(context, listen: false)
    ..formKey = GlobalKey<FormState>()
    ..autoValidation = false
    ..getExpensesDetails();
  }

  @override
  Widget build(BuildContext context) {
    var expensesDetailsProvider =
        Provider.of<ExpensesDetailsProvider>(context, listen: false);
    return Scaffold(
        appBar: BaseAppBar(
          Text('mGramSeva'),
          AppBar(),
          <Widget>[Icon(Icons.more_vert)],
        ),
        drawer: DrawerWrapper(
          Drawer(child: SideBar((value) => _onSelectItem(value, context))),
        ),
        body: SingleChildScrollView(
            child: StreamBuilder(
                stream: expensesDetailsProvider.streamController.stream,
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    return _buildUserView(snapshot.data);
                  } else if (snapshot.hasError) {
                    return Notifiers.networkErrorPage(context, () {});
                  } else {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                        return Loaders.CircularLoader();
                      case ConnectionState.active:
                        return Loaders.CircularLoader();
                      default:
                        return Container();
                    }
                  }
                })),
        bottomNavigationBar: BottomButtonBar('Submit', expensesDetailsProvider.validateExpensesDetails));
  }

  _onSelectItem(int index, context) {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => Home(index),
        ),
        ModalRoute.withName(Routes.home));
  }

  saveInput(context) async {
    print(context);
  }

  Widget _buildUserView(ExpensesDetailsModel expenseDetails) {

    return FormWrapper(Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HomeBack(),
          Card(
              child:
              Consumer<ExpensesDetailsProvider>(
                builder: (_, expensesDetailsProvider, child) => Form(
                  key: expensesDetailsProvider.formKey,
                  autovalidateMode: expensesDetailsProvider.autoValidation ? AutovalidateMode.always : AutovalidateMode.disabled,
                  child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
                    LabelText("Expense Details"),
                    SubLabelText("Provide below Information to create Expense record"),
                    BuildTextField(
                      'Vendor Name',
                      expenseDetails.vendorNameCtrl,
                      isRequired: true,
                    ),
                    SelectFieldBuilder(
                        context,
                        'Type of Expense',
                        expenseDetails.expenseTypeCtrl,
                        '',
                        '',
                        saveInput,
                        Constants.EXPENSESTYPE,
                        true),
                    BuildTextField(
                      'Amount (₹)',
                      expenseDetails.amountCtrl,
                      isRequired: true,
                    ),
                    BasicDateField('Bill Issued Date', true, expenseDetails.billDateCtrl),
                    RadioButtonFieldBuilder(context, 'Bill Paid', _gender, '', '', true,
                        Constants.AMOUNTTYPE, saveInput),
                    RadioButtonFieldBuilder(context, 'Amount Paid', _amountType, '', '',
                        true, Constants.AMOUNTTYPE, saveInput),
                    FilePickerDemo(),
                    SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      height: 20,
                    )
                  ]),
                ),
              ))
        ]));
  }


}
