import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mgramseva/model/expensesDetails/expenses_details.dart';
import 'package:mgramseva/providers/expenses_details_provider.dart';
import 'package:mgramseva/screeens/customAppbar.dart';
import 'package:mgramseva/utils/Locilization/application_localizations.dart';
import 'package:mgramseva/utils/common_widgets.dart';
import 'package:mgramseva/utils/constants.dart';
import 'package:mgramseva/utils/date_formats.dart';
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
import 'package:mgramseva/widgets/SubLabel.dart';
import 'package:mgramseva/widgets/TextFieldBuilder.dart';
import 'package:mgramseva/widgets/auto_complete.dart';
import 'package:mgramseva/widgets/help.dart';
import 'package:provider/provider.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:mgramseva/utils/Constants/I18KeyConstants.dart';

class ExpenseDetails extends StatefulWidget {
  final String? id;
  final ExpensesDetailsModel? expensesDetails;

  const ExpenseDetails({Key? key, this.id, this.expensesDetails}) : super(key: key);
  State<StatefulWidget> createState() {
    return _ExpenseDetailsState();
  }
}

class _ExpenseDetailsState extends State<ExpenseDetails> {

  @override
  void initState() {
    WidgetsBinding.instance?.addPostFrameCallback((_) => afterViewBuild());
    super.initState();
  }

  afterViewBuild() {
    Provider.of<ExpensesDetailsProvider>(context, listen: false)
      ..formKey = GlobalKey<FormState>()
      ..suggestionsBoxController = SuggestionsBoxController()
      ..expenditureDetails = ExpensesDetailsModel()
      ..autoValidation = false
      ..getExpensesDetails(context, widget.expensesDetails, widget.id)
      ..getExpenses()
      ..fetchVendors();
  }

  @override
  Widget build(BuildContext context) {
    var expensesDetailsProvider =
        Provider.of<ExpensesDetailsProvider>(context, listen: false);
    return Scaffold(
        appBar: CustomAppBar(),
        drawer: DrawerWrapper(
          Drawer(child: SideBar()),
        ),
        body: SingleChildScrollView(
            child: StreamBuilder(
                stream: expensesDetailsProvider.streamController.stream,
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    if(snapshot.data is String){
                      return CommonWidgets.buildEmptyMessage(snapshot.data, context);
                    }
                    return _buildUserView(snapshot.data);
                  } else if (snapshot.hasError) {
                    return Notifiers.networkErrorPage(context, () => expensesDetailsProvider.getExpensesDetails(context, widget.expensesDetails, widget.id));
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
        bottomNavigationBar: BottomButtonBar(i18.common.SUBMIT,
            () => expensesDetailsProvider.validateExpensesDetails(context, isUpdate)));
  }

  saveInput(context) async {
    print(context);
  }

  Widget _buildUserView(ExpensesDetailsModel expenseDetails) {
    return FormWrapper(Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HomeBack(widget: Help()),
          Card(
              child: Consumer<ExpensesDetailsProvider>(
            builder: (_, expensesDetailsProvider, child) => Form(
              key: expensesDetailsProvider.formKey,
              autovalidateMode: expensesDetailsProvider.autoValidation
                  ? AutovalidateMode.always
                  : AutovalidateMode.disabled,
              child:
                  Column(mainAxisAlignment: MainAxisAlignment.start, children: [
                LabelText(isUpdate ? i18.expense.EDIT_EXPENSE_BILL : i18.expense.EXPENSE_DETAILS),
                SubLabelText(isUpdate ? i18.expense.UPDATE_SUBMIT_EXPENDITURE : i18.expense.PROVIDE_INFO_TO_CREATE_EXPENSE),
                if(isUpdate)
                  BuildTextField(
                    '${i18.common.BILL_ID}',
                     expenseDetails.challanNumberCtrl,
                    isDisabled: true,
                  ),
                SelectFieldBuilder(
                    i18.expense.EXPENSE_TYPE,
                    expenseDetails.expenseType,
                    '',
                    '',
                    expensesDetailsProvider.onChangeOfExpenses,
                    expensesDetailsProvider.getExpenseTypeList(),
                    true, isEnabled : expenseDetails.allowEdit),
                AutoCompleteView(
                    labelText: i18.expense.VENDOR_NAME,
                    controller: expenseDetails.vendorNameCtrl,
                    suggestionsBoxController:
                        expensesDetailsProvider.suggestionsBoxController,
                    onSuggestionSelected:
                        expensesDetailsProvider.onSuggestionSelected,
                    callBack: expensesDetailsProvider.onSearchVendorList,
                    listTile: buildTile,
                    isRequired: true, isEnabled : expenseDetails.allowEdit),
                BuildTextField(
                  '${i18.expense.AMOUNT}',
                  expenseDetails.expensesAmount!.first.amountCtrl,
                  isRequired: true,
                  textInputType: TextInputType.number,
                  inputFormatter: [
                    FilteringTextInputFormatter.allow(RegExp("[0-9.]"))
                  ],
                  labelSuffix: '(₹)',
                  isDisabled: (expenseDetails.allowEdit ?? true) ? false : true,
                ),
                BasicDateField(
                    i18.expense.BILL_DATE, true, expenseDetails.billDateCtrl,
                    firstDate:
                        expenseDetails.billIssuedDateCtrl.text.trim().isEmpty
                            ? null
                            : DateFormats.getFormattedDateToDateTime(
                                expenseDetails.billIssuedDateCtrl.text.trim(),
                              ),
                    initialDate: DateFormats.getFormattedDateToDateTime(
                      expenseDetails.billDateCtrl.text.trim(),
                    ),
                    lastDate: DateTime.now(),
                    onChangeOfDate: expensesDetailsProvider.onChangeOfDate, isEnabled: expenseDetails.allowEdit),
                BasicDateField(i18.expense.PARTY_BILL_DATE, false,
                    expenseDetails.billIssuedDateCtrl,
                    initialDate: DateFormats.getFormattedDateToDateTime(
                      expenseDetails.billIssuedDateCtrl.text.trim(),
                    ),
                    lastDate: expenseDetails.billDateCtrl.text.trim().isEmpty
                        ? DateTime.now()
                        : DateFormats.getFormattedDateToDateTime(
                            expenseDetails.billDateCtrl.text.trim()),
                    onChangeOfDate: expensesDetailsProvider.onChangeOfDate, isEnabled: expenseDetails.allowEdit),
                RadioButtonFieldBuilder(
                    context,
                    i18.expense.BILL_PAID,
                    expenseDetails.isBillPaid,
                    '',
                    '',
                    true,
                    Constants.EXPENSESTYPE,
                    expensesDetailsProvider.onChangeOfBillPaid, isEnabled: expenseDetails.allowEdit),
                if (expenseDetails.isBillPaid ?? false)
                  BasicDateField(i18.expense.PAYMENT_DATE, true,
                      expenseDetails.paidDateCtrl,
                      firstDate: DateFormats.getFormattedDateToDateTime(
                          expenseDetails.billIssuedDateCtrl.text.trim()),
                      lastDate: DateTime.now(),
                      initialDate: DateFormats.getFormattedDateToDateTime(
                          expenseDetails.paidDateCtrl.text.trim()),
                      onChangeOfDate: expensesDetailsProvider.onChangeOfDate, isEnabled: expenseDetails.allowEdit),
                FilePickerDemo(callBack: expensesDetailsProvider.fileStoreIdCallBack),
                if(isUpdate)
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.symmetric(vertical: 5),
                    child: Wrap(
                      direction: Axis.horizontal,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 4,
                      children: [
                        Checkbox(
                          value: expenseDetails.isBillCancelled,
                          onChanged: expensesDetailsProvider.onChangeOfCheckBox
                        ),
                        Text(i18.expense.MARK_BILL_HAS_CANCELLED, style: TextStyle(fontSize: 19, fontWeight: FontWeight.normal))
                      ],
                    ),
                  ),
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

  Widget buildTile(context, vendor) => Container(
      padding: EdgeInsets.symmetric(vertical: 6, horizontal: 5),
      child: Text('${vendor?.name}', style: TextStyle(fontSize: 18)));

  bool get isUpdate => widget.id != null || widget.expensesDetails != null;
}
