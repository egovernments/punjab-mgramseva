import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mgramseva/model/expensesDetails/expenses_details.dart';
import 'package:mgramseva/providers/expenses_details_provider.dart';
import 'package:mgramseva/screeens/AddExpense/AddExpenseWalkThrough/expenseWalkThrough.dart';
import 'package:mgramseva/widgets/customAppbar.dart';
import 'package:mgramseva/utils/Locilization/application_localizations.dart';
import 'package:mgramseva/utils/common_methods.dart';
import 'package:mgramseva/utils/common_widgets.dart';
import 'package:mgramseva/utils/constants.dart';
import 'package:mgramseva/utils/date_formats.dart';
import 'package:mgramseva/utils/loaders.dart';
import 'package:mgramseva/utils/notifyers.dart';
import 'package:mgramseva/utils/validators/Validators.dart';
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
import 'package:mgramseva/widgets/footer.dart';
import 'package:mgramseva/widgets/help.dart';
import 'package:provider/provider.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:mgramseva/utils/Constants/I18KeyConstants.dart';

import 'AddExpenseWalkThrough/WalkThroughContainer.dart';

class ExpenseDetails extends StatefulWidget {
  final String? id;
  final ExpensesDetailsModel? expensesDetails;

  const ExpenseDetails({Key? key, this.id, this.expensesDetails})
      : super(key: key);
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
      ..fetchVendors()
      ..setwalkthrough(ExpenseWalkThrough().expenseWalkThrough.map((e) {
        e.key = GlobalKey();
        return e;
      }).toList());
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
            child: Column(children: [
          StreamBuilder(
              stream: expensesDetailsProvider.streamController.stream,
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data is String) {
                    return CommonWidgets.buildEmptyMessage(
                        snapshot.data, context);
                  }
                  return _buildUserView(snapshot.data);
                } else if (snapshot.hasError) {
                  return Notifiers.networkErrorPage(
                      context,
                      () => expensesDetailsProvider.getExpensesDetails(
                          context, widget.expensesDetails, widget.id));
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
              }),
          Footer()
        ])),
        bottomNavigationBar: Consumer<ExpensesDetailsProvider>(
          builder: (_, expensesDetailsProvider, child) => BottomButtonBar(
              i18.common.SUBMIT,
              (isUpdate &&
                          (expensesDetailsProvider
                                  .expenditureDetails?.allowEdit ??
                              false)) ||
                      ((isUpdate &&
                              !(expensesDetailsProvider
                                      .expenditureDetails?.allowEdit ??
                                  false) &&
                              (expensesDetailsProvider
                                      .expenditureDetails?.isBillCancelled ??
                                  false)) ||
                          !isUpdate)
                  ? () => expensesDetailsProvider.validateExpensesDetails(
                      context, isUpdate)
                  : null),
        ));
  }

  saveInput(context) async {
    print(context);
  }

  Widget _buildUserView(ExpensesDetailsModel expenseDetails) {
    return FormWrapper(Consumer<ExpensesDetailsProvider>(
        builder: (_, expenseProvider, child) => Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HomeBack(
                      widget: Help(
                    callBack: () => showGeneralDialog(
                      barrierLabel: "Label",
                      barrierDismissible: false,
                      barrierColor: Colors.black.withOpacity(0.5),
                      transitionDuration: Duration(milliseconds: 700),
                      context: context,
                      pageBuilder: (context, anim1, anim2) {
                        return ExpenseWalkThroughContainer((index) =>
                            expenseProvider.incrementindex(
                                index,
                                expenseProvider
                                    .expenseWalkthrougList[index + 1].key));
                      },
                      transitionBuilder: (context, anim1, anim2, child) {
                        return SlideTransition(
                          position:
                              Tween(begin: Offset(0, 1), end: Offset(0, 0))
                                  .animate(anim1),
                          child: child,
                        );
                      },
                    ),walkThroughKey: Constants.ADD_EXPENSE_KEY,
                  )),
                  Card(
                      child: Consumer<ExpensesDetailsProvider>(
                    builder: (_, expensesDetailsProvider, child) => Form(
                      key: expensesDetailsProvider.formKey,
                      autovalidateMode: expensesDetailsProvider.autoValidation
                          ? AutovalidateMode.always
                          : AutovalidateMode.disabled,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            LabelText(isUpdate
                                ? i18.expense.EDIT_EXPENSE_BILL
                                : i18.expense.EXPENSE_DETAILS),
                            SubLabelText(isUpdate
                                ? i18.expense.UPDATE_SUBMIT_EXPENDITURE
                                : i18.expense.PROVIDE_INFO_TO_CREATE_EXPENSE),
                            if (isUpdate)
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
                              true,
                              isEnabled: expenseDetails.allowEdit,
                              requiredMessage:
                                  i18.expense.SELECT_EXPENDITURE_CATEGORY,
                              contextkey:
                                  expenseProvider.expenseWalkthrougList[0].key,
                            ),
                            AutoCompleteView(
                              labelText: i18.expense.VENDOR_NAME,
                              controller: expenseDetails.vendorNameCtrl,
                              suggestionsBoxController: expensesDetailsProvider
                                  .suggestionsBoxController,
                              onSuggestionSelected:
                                  expensesDetailsProvider.onSuggestionSelected,
                              callBack:
                                  expensesDetailsProvider.onSearchVendorList,
                              listTile: buildTile,
                              isRequired: true,
                              isEnabled: expenseDetails.allowEdit,
                              requiredMessage:
                                  i18.expense.MENTION_NAME_OF_VENDOR,
                              inputFormatter: [FilteringTextInputFormatter.allow(
                                  RegExp("[a-zA-Z ]"))],
                              contextkey:
                                  expenseProvider.expenseWalkthrougList[1].key,
                            ),
                            if (expensesDetailsProvider.isNewVendor())
                              BuildTextField(
                                '${i18.common.MOBILE_NUMBER}',
                                expenseDetails.mobileNumberController,
                                isRequired: true,
                                prefixText: '+91 - ',
                                textInputType: TextInputType.number,
                                validator: Validators.mobileNumberValidator,
                                maxLength: 10,
                                inputFormatter: [
                                  FilteringTextInputFormatter.allow(
                                      RegExp("[0-9]"))
                                ],
                              ),
                            BuildTextField(
                              '${i18.expense.AMOUNT}',
                              expenseDetails.expensesAmount!.first.amountCtrl,
                              isRequired: true,
                              textInputType: TextInputType.number,
                              inputFormatter: [
                                FilteringTextInputFormatter.allow(
                                    RegExp("[0-9]"))
                              ],
                              labelSuffix: '(₹)',
                              isDisabled: (expenseDetails.allowEdit ?? true)
                                  ? false
                                  : true,
                              requiredMessage:
                                  i18.expense.AMOUNT_MENTIONED_IN_THE_BILL,
                              validator: Validators.amountValidator,
                              contextkey:
                                  expenseProvider.expenseWalkthrougList[2].key,
                            ),
                            BasicDateField(
                              i18.expense.BILL_DATE,
                              true,
                              expenseDetails.billDateCtrl,
                              firstDate: expenseDetails.billIssuedDateCtrl.text
                                      .trim()
                                      .isEmpty
                                  ? null
                                  : DateFormats.getFormattedDateToDateTime(
                                      expenseDetails.billIssuedDateCtrl.text
                                          .trim(),
                                    ),
                              initialDate:
                                  DateFormats.getFormattedDateToDateTime(
                                expenseDetails.billDateCtrl.text.trim(),
                              ),
                              lastDate: DateTime.now(),
                              onChangeOfDate:
                                  expensesDetailsProvider.onChangeOfDate,
                              isEnabled: expenseDetails.allowEdit,
                              requiredMessage:
                                  i18.expense.DATE_BILL_ENTERED_IN_RECORDS,
                              contextkey:
                                  expenseProvider.expenseWalkthrougList[3].key,
                            ),
                            BasicDateField(
                              i18.expense.PARTY_BILL_DATE,
                              false,
                              expenseDetails.billIssuedDateCtrl,
                              initialDate:
                                  DateFormats.getFormattedDateToDateTime(
                                expenseDetails.billIssuedDateCtrl.text.trim(),
                              ),
                              lastDate: expenseDetails.billDateCtrl.text
                                      .trim()
                                      .isEmpty
                                  ? DateTime.now()
                                  : DateFormats.getFormattedDateToDateTime(
                                      expenseDetails.billDateCtrl.text.trim()),
                              onChangeOfDate:
                                  expensesDetailsProvider.onChangeOfDate,
                              isEnabled: expenseDetails.allowEdit,
                              contextkey:
                                  expenseProvider.expenseWalkthrougList[4].key,
                            ),
                            RadioButtonFieldBuilder(
                                context,
                                i18.expense.HAS_THIS_BILL_PAID,
                                expenseDetails.isBillPaid,
                                '',
                                '',
                                true,
                                Constants.EXPENSESTYPE,
                                expensesDetailsProvider.onChangeOfBillPaid,
                                isEnabled: expenseDetails.allowEdit),
                            if (expenseDetails.isBillPaid ?? false)
                              BasicDateField(i18.expense.PAYMENT_DATE, true,
                                  expenseDetails.paidDateCtrl,
                                  firstDate:
                                      DateFormats.getFormattedDateToDateTime(
                                          expenseDetails.billDateCtrl.text
                                              .trim()),
                                  lastDate: DateTime.now(),
                                  initialDate:
                                      DateFormats.getFormattedDateToDateTime(
                                          expenseDetails.paidDateCtrl.text
                                              .trim()),
                                  onChangeOfDate:
                                      expensesDetailsProvider.onChangeOfDate,
                                  isEnabled: expenseDetails.allowEdit),
                            if (isUpdate &&
                                expenseDetails.fileStoreList != null && expenseDetails.fileStoreList!.isNotEmpty)
                              Container(
                                margin: const EdgeInsets.only(
                                    top: 20.0, bottom: 5, right: 20, left: 20),
                                alignment: Alignment.centerLeft,
                                child: Wrap(
                                  direction: Axis.vertical,
                                  children: [
                                    Text(
                                        ApplicationLocalizations.of(context)
                                            .translate(i18.common.ATTACHMENTS),
                                        style: TextStyle(
                                            fontSize: 19,
                                            fontWeight: FontWeight.normal)),
                                    Wrap(
                                        children: expenseDetails.fileStoreList!
                                            .map<Widget>((e) => InkWell(
                                                  onTap: () =>
                                                      expensesDetailsProvider
                                                          .onTapOfAttachment(e, context),
                                                  child: Container(
                                                    width: 50,
                                                    margin:
                                                        EdgeInsets.symmetric(
                                                            vertical: 10,
                                                            horizontal: 5),
                                                    child: Wrap(
                                                      runSpacing: 5,
                                                   spacing: 8,
                                                   children : [
                                                     Image.asset('assets/png/attachment.png'),
                                                     Text('${CommonMethods.getExtension(e.url ?? '')}',
                                                     maxLines: 2,
                                                     overflow: TextOverflow.ellipsis,
                                                     )
                                                    ]
                                                  )),
                                                ))
                                            .toList())
                                  ],
                                ),
                              ),
                            if (expenseDetails.allowEdit ?? true)
                              FilePickerDemo(
                                callBack:
                                    expensesDetailsProvider.fileStoreIdCallBack,
                                extensions: ['jpg', 'pdf', 'png'],
                                contextkey: expenseProvider
                                    .expenseWalkthrougList[5].key,
                              ),
                            if (isUpdate)
                              Container(
                                alignment: Alignment.centerLeft,
                                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 18),
                                child: Wrap(
                                  direction: Axis.horizontal,
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  spacing: 8,
                                  children: [
                                    SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: Checkbox(
                                          value: expenseDetails.isBillCancelled,
                                          onChanged: expensesDetailsProvider
                                              .onChangeOfCheckBox),
                                    ),
                                    Text(
                                        ApplicationLocalizations.of(context)
                                            .translate(i18.expense
                                                .MARK_BILL_HAS_CANCELLED),
                                        style: TextStyle(
                                            fontSize: 19,
                                            fontWeight: FontWeight.normal))
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
                ])));
  }

  Widget buildTile(context, vendor) => Container(
      padding: EdgeInsets.symmetric(vertical: 6, horizontal: 5),
      child: Text('${vendor?.name}', style: TextStyle(fontSize: 18)));

  bool get isUpdate => widget.id != null || widget.expensesDetails != null;
}
