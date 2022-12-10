import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mgramseva/model/success_handler.dart';
import 'package:mgramseva/providers/transaction_update_provider.dart';
import 'package:mgramseva/utils/Constants/I18KeyConstants.dart';
import 'package:mgramseva/widgets/CommonSuccessPage.dart';
import 'package:provider/provider.dart';

import '../../providers/language.dart';
import '../../routers/Routers.dart';
import '../../utils/Locilization/application_localizations.dart';
import '../../utils/common_widgets.dart';
import '../../utils/loaders.dart';
import '../../utils/notifiers.dart';

class PaymentSuccess extends StatefulWidget {
  final Map<String, dynamic> query;

  PaymentSuccess({Key? key, required this.query});
  @override
  State<StatefulWidget> createState() {
    return _PaymentSuccessState();
  }
}

class _PaymentSuccessState extends State<PaymentSuccess> {
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var transactionProvider =
        Provider.of<TransactionUpdateProvider>(context, listen: false);
    var languageProvider =
        Provider.of<LanguageProvider>(context, listen: false);
    return Scaffold(
      // drawer: DrawerWrapper(
      //   Drawer(child: CommonSideBar()),
      // ),
      appBar: AppBar(
        titleSpacing: 0,
        title: Image(
            width: 130,
            image: NetworkImage(
              languageProvider.stateInfo!.logoUrlWhite!,
            )),
        automaticallyImplyLeading: true,
        actions: [_buildDropDown()],
      ),
      body: StreamBuilder(
          stream: transactionProvider.transactionController.stream,
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data is String) {
                return CommonWidgets.buildEmptyMessage(snapshot.data, context);
              }
              return _buildPaymentSuccessPage(context);
            } else if (snapshot.hasError) {
              return Notifiers.networkErrorPage(
                  context,
                  () => transactionProvider.loadPaymentSuccessPage(
                      widget.query, context));
            } else {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return Loaders.circularLoader();
                case ConnectionState.active:
                  return Loaders.circularLoader();
                default:
                  return Container();
              }
            }
          }),
    );
  }

  Widget _buildPaymentSuccessPage(BuildContext context) {
    var transactionProvider =
        Provider.of<TransactionUpdateProvider>(context, listen: false);
    return CommonSuccess(
      SuccessHandler(
        i18.common.PAYMENT_COMPLETE,
        '${ApplicationLocalizations.of(context).translate(i18.payment.RECEIPT_REFERENCE_WITH_MOBILE_NUMBER)} (+91 ${widget.query['mobileNumber']})',
        '',
        Routes.PAYMENT_SUCCESS,
        subHeader:
            '${ApplicationLocalizations.of(context).translate(i18.payment.TRANSACTION_ID)} \n ${widget.query['txnId']}',
        downloadLink: i18.common.RECEIPT_DOWNLOAD,
        whatsAppShare: i18.common.SHARE_RECEIPTS,
        downloadLinkLabel: i18.common.RECEIPT_DOWNLOAD,
        subtitleFun: () => getSubtitleDynamicLocalization(
            context, widget.query['mobileNumber']),
      ),
      callBackDownload: () => transactionProvider
          .downloadOrShareReceiptWithoutLogin(context, widget.query, false),
      callBackWhatsApp: () => transactionProvider
          .downloadOrShareReceiptWithoutLogin(context, widget.query, false),
      backButton: false,
      isWithoutLogin: true,
      isConsumer: widget.query['isConsumer'] == 'true' ? true : false,
    );
  }

  Widget _buildDropDown() {
    var languageProvider =
        Provider.of<LanguageProvider>(context, listen: false);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: DropdownButton(
          value: languageProvider.selectedLanguage,
          style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 16),
          items: dropDownItems,
          onChanged: onChangeOfLanguage),
    );
  }

  get dropDownItems {
    var languageProvider =
        Provider.of<LanguageProvider>(context, listen: false);
    return languageProvider.stateInfo!.languages!.map((value) {
      return DropdownMenuItem(
        value: value,
        child: Text('${value.label}'),
      );
    }).toList();
  }

  void onChangeOfLanguage(value) {
    var languageProvider =
        Provider.of<LanguageProvider>(context, listen: false);

    languageProvider.onSelectionOfLanguage(
        value!, languageProvider.stateInfo!.languages ?? []);
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
