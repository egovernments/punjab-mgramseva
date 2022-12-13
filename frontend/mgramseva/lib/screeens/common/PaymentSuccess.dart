import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mgramseva/model/Transaction/transaction.dart';
import 'package:mgramseva/model/success_handler.dart';
import 'package:mgramseva/providers/transaction_update_provider.dart';
import 'package:mgramseva/utils/Constants/I18KeyConstants.dart';
import 'package:mgramseva/widgets/NoLoginSuccesPage.dart';
import 'package:provider/provider.dart';

import '../../model/localization/language.dart';
import '../../providers/language.dart';
import '../../routers/Routers.dart';
import '../../utils/Locilization/application_localizations.dart';
import '../../widgets/NoLoginFailurePage.dart';

class PaymentSuccess extends StatefulWidget {
  final Map<String, dynamic> query;

  PaymentSuccess({Key? key, required this.query});
  @override
  State<StatefulWidget> createState() {
    return _PaymentSuccessState();
  }
}

class _PaymentSuccessState extends State<PaymentSuccess> {
  List<StateInfo>? stateList;
  Languages? selectedLanguage;
  TransactionDetails? transactionDetails;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) => afterViewBuild());
    super.initState();
  }

  afterViewBuild() async {
    var transactionUpdateProvider =
        Provider.of<TransactionUpdateProvider>(context, listen: false);
    var languageProvider =
        Provider.of<LanguageProvider>(context, listen: false);
    await transactionUpdateProvider.loadPaymentSuccessPage(
        widget.query, context);

    await languageProvider
        .getLocalizationData(context)
        .then((value) => callNotifyer());

    setState(() {
      transactionDetails = transactionUpdateProvider.transactionDetails;
    });
  }

  @override
  Widget build(BuildContext context) {
    var transactionProvider =
        Provider.of<TransactionUpdateProvider>(context, listen: false);
    var languageProvider =
        Provider.of<LanguageProvider>(context, listen: false);
    return Scaffold(
        appBar: AppBar(
          titleSpacing: 0,
          title: Text('mGramSeva'),
          automaticallyImplyLeading: true,
        ),
        body: transactionDetails != null &&
                transactionDetails!.transaction != null
            ? _buildPaymentSuccessPage(transactionDetails!, context)
            : NoLoginFailurePage(i18.payment.PAYMENT_FAILED));
  }

  Widget _buildPaymentSuccessPage(
      TransactionDetails transactionObject, BuildContext context) {
    var transactionProvider =
        Provider.of<TransactionUpdateProvider>(context, listen: false);
    return transactionObject.transaction?.txnStatus != "FAILURE"
        ? NoLoginSuccess(
            SuccessHandler(
              i18.common.PAYMENT_COMPLETE,
              '${ApplicationLocalizations.of(context).translate(i18.payment.RECEIPT_REFERENCE_WITH_MOBILE_NUMBER)} (+91 ${transactionDetails!.transaction?.user?.mobileNumber})',
              '',
              Routes.PAYMENT_SUCCESS,
              subHeader:
                  '${ApplicationLocalizations.of(context).translate(i18.payment.TRANSACTION_ID)} \n ${widget.query['eg_pg_txnid']}',
              downloadLink: i18.common.RECEIPT_DOWNLOAD,
              whatsAppShare: i18.common.SHARE_RECEIPTS,
              downloadLinkLabel: i18.common.RECEIPT_DOWNLOAD,
              subtitleFun: () => getSubtitleDynamicLocalization(
                  context,
                  transactionDetails!.transaction!.user!.mobileNumber
                          .toString() ??
                      ''),
            ),
            callBackDownload: () =>
                transactionProvider.downloadOrShareReceiptWithoutLogin(
                    context, widget.query, false),
            callBackWhatsApp: () =>
                transactionProvider.downloadOrShareReceiptWithoutLogin(
                    context, widget.query, false),
            backButton: false,
            isWithoutLogin: true,
            isConsumer: true,
          )
        : NoLoginFailurePage(i18.payment.PAYMENT_FAILED);
    ;
  }

  callNotifyer() async {
    await Future.delayed(Duration(seconds: 2));
    setState(() {});
  }

  String getSubtitleDynamicLocalization(
      BuildContext context, String mobileNumber) {
    String localizationText = '';
    localizationText =
        '${ApplicationLocalizations.of(context).translate(i18.payment.RECEIPT_REFERENCE_WITH_MOBILE_NUMBER)}';
    localizationText =
        localizationText.replaceFirst('{Number}', '(+91 - ${mobileNumber})');
    return localizationText;
  }
}
