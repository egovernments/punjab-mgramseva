import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_focus_watcher/flutter_focus_watcher.dart';
import 'package:mgramseva/model/connection/search_connection.dart';
import 'package:mgramseva/providers/search_connection_provider.dart';
import 'package:mgramseva/utils/TestingKeys/testing_keys.dart';
import 'package:mgramseva/widgets/customAppbar.dart';
import 'package:mgramseva/utils/Constants/I18KeyConstants.dart';
import 'package:mgramseva/utils/Locilization/application_localizations.dart';
import 'package:mgramseva/widgets/BottonButtonBar.dart';
import 'package:mgramseva/widgets/DrawerWrapper.dart';
import 'package:mgramseva/widgets/FormWrapper.dart';
import 'package:mgramseva/widgets/HomeBack.dart';
import 'package:mgramseva/widgets/LabelText.dart';
import 'package:mgramseva/widgets/SideBar.dart';
import 'package:mgramseva/widgets/SubLabel.dart';
import 'package:mgramseva/widgets/TextFieldBuilder.dart';
import 'package:mgramseva/widgets/footer.dart';
import 'package:provider/provider.dart';

import '../../providers/language.dart';
import '../../utils/global_variables.dart';

class SearchConsumerConnection extends StatefulWidget {
  final Map? arguments;
  SearchConsumerConnection(this.arguments);
  State<StatefulWidget> createState() {
    return _SearchConsumerConnectionState();
  }
}

class _SearchConsumerConnectionState extends State<SearchConsumerConnection> {
  var isVisible = true;

  @override
  void initState() {
    Provider.of<SearchConnectionProvider>(context, listen: false)
      ..searchconnection = SearchConnection();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var searchConnectionProvider =
        Provider.of<SearchConnectionProvider>(context, listen: false);
    var languageProvider = Provider.of<LanguageProvider>(
        navigatorKey.currentContext!,
        listen: false);
    return FocusWatcher(
        child: Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
          appBar: CustomAppBar(),
          drawer: DrawerWrapper(
            Drawer(child: SideBar()),
          ),
          body: SingleChildScrollView(
            child: Column(children: [
              FormWrapper(Consumer<SearchConnectionProvider>(
                builder: (_, searchConnectionProvider, child) => Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HomeBack(),
                  Card(
                    child: Form(
                        key: searchConnectionProvider.formKey,
                        autovalidateMode:
                            searchConnectionProvider.autoValidation
                                ? AutovalidateMode.always
                                : AutovalidateMode.disabled,
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              LabelText(i18.searchWaterConnection
                                  .SEARCH_CONNECTION_LABEL),
                              SubLabelText(i18.searchWaterConnection
                                  .SEARCH_CONNECTION_SUBLABEL),
                              BuildTextField(
                                i18.searchWaterConnection.OWNER_MOB_NUM,
                                searchConnectionProvider
                                    .searchconnection.mobileCtrl,
                                prefixText: '+91 - ',
                                textInputType: TextInputType.number,
                                maxLength: 10,
                                pattern: (searchConnectionProvider
                                                .searchconnection
                                                .controllers[0] ==
                                            null ||
                                        searchConnectionProvider
                                                .searchconnection
                                                .controllers[0] ==
                                            false)
                                    ? (r'^(?:[+0]9)?[0-9]{10}$')
                                    : '',
                                message: i18.validators
                                    .MOBILE_NUMBER_SHOULD_BE_10_DIGIT,
                                inputFormatter: [
                                  FilteringTextInputFormatter.allow(
                                      RegExp("[0-9]"))
                                ],
                                isDisabled: searchConnectionProvider
                                    .searchconnection.controllers[0],
                                onChange: (value) => searchConnectionProvider
                                    .getdetails(value, 0),
                                key: Keys.searchConnection.SEARCH_PHONE_NUMBER_KEY,
                              ),
                              Text(
                                '\n${ApplicationLocalizations.of(context).translate(i18.common.OR)}',
                                textAlign: TextAlign.center,
                              ),
                              BuildTextField(
                                i18.searchWaterConnection.CONSUMER_NAME,
                                searchConnectionProvider
                                    .searchconnection.nameCtrl,
                                isDisabled: searchConnectionProvider
                                    .searchconnection.controllers[1],
                                inputFormatter: [
                                  FilteringTextInputFormatter.allow(
                                      RegExp(languageProvider.selectedLanguage!.enableRegEx
                                          ? languageProvider.selectedLanguage!.regEx.toString().split('^').last
                                          : "[A-Za-z ]"))
                                ],
                                onChange: (value) => searchConnectionProvider
                                    .getdetails(value, 1),
                                hint: ApplicationLocalizations.of(context)
                                    .translate(
                                        i18.searchWaterConnection.NAME_HINT),
                                key: Keys.searchConnection.SEARCH_NAME_KEY,
                              ),
                              Visibility(
                                  visible: !isVisible,
                                  child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                            '\n${ApplicationLocalizations.of(context).translate(i18.common.OR)}',
                                            textAlign: TextAlign.center),
                                        BuildTextField(
                                          i18.searchWaterConnection
                                              .OLD_CONNECTION_ID,
                                          searchConnectionProvider
                                              .searchconnection
                                              .oldConnectionCtrl,
                                          isDisabled: searchConnectionProvider
                                              .searchconnection.controllers[2],
                                          onChange: (value) =>
                                              searchConnectionProvider
                                                  .getdetails(value, 2),
                                          inputFormatter: [
                                            FilteringTextInputFormatter.allow(
                                                RegExp("[a-zA-Z0-9-\/]"))],
                                          hint: ApplicationLocalizations.of(
                                                  context)
                                              .translate(i18
                                                  .searchWaterConnection
                                                  .OLD_CONNECTION_HINT),
                                          key: Keys.searchConnection.SEARCH_OLD_ID_KEY,
                                        ),
                                        Text(
                                            '\n${ApplicationLocalizations.of(context).translate(i18.common.OR)}',
                                            textAlign: TextAlign.center),
                                        BuildTextField(
                                          i18.searchWaterConnection
                                              .NEW_CONNECTION_ID,
                                          searchConnectionProvider
                                              .searchconnection
                                              .newConnectionCtrl,
                                          inputFormatter: [
                                        FilteringTextInputFormatter.allow(
                                        RegExp("[a-zA-Z0-9-\/]"))],
                                          isDisabled: searchConnectionProvider
                                              .searchconnection.controllers[3],
                                          onChange: (value) =>
                                              searchConnectionProvider
                                                  .getdetails(value, 3),
                                          hint: ApplicationLocalizations.of(
                                                  context)
                                              .translate(i18
                                                  .searchWaterConnection
                                                  .NEW_CONNECTION_HINT),
                                          key: Keys.searchConnection.SEARCH_NEW_ID_KEY,
                                        ),
                                      ])),
                              new InkWell(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 25, top: 10, bottom: 10, right: 25),
                                  child: new Row(
                                    children: [
                                      new Text(
                                        '\n${ApplicationLocalizations.of(context).translate(isVisible ? i18.common.SHOW_MORE : i18.common.SHOW_LESS)}',
                                        style: new TextStyle(
                                            color: Colors.deepOrangeAccent),
                                        key: Keys.searchConnection.SHOW_MORE_BTN,
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
                            ]))),
              ]),
        )),
        Footer()
      ])),
      bottomNavigationBar: BottomButtonBar(
          i18.searchWaterConnection.SEARCH_CONNECTION_BUTTON,
          () => searchConnectionProvider.validatesearchConnectionDetails(
              context, widget.arguments, (searchConnectionProvider.searchconnection.controllers[1] == false)
              ? true : false),
      key: Keys.searchConnection.SEARCH_BTN_KEY,),
    ));
  }
}
