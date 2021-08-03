import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:mgramseva/providers/authentication.dart';
import 'package:mgramseva/providers/changePassword_details_provider.dart';
import 'package:mgramseva/providers/common_provider.dart';
import 'package:mgramseva/providers/consumer_details.dart';
import 'package:mgramseva/providers/expenses_details_provider.dart';
import 'package:mgramseva/providers/language.dart';
import 'package:mgramseva/Env/app_config.dart';
import 'package:mgramseva/providers/user_edit_profile_provider.dart';

import 'package:mgramseva/providers/user_profile_provider.dart';
import 'package:mgramseva/router.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:mgramseva/routers/Routers.dart';
import 'package:mgramseva/screeens/Home.dart';

import 'package:mgramseva/screeens/SelectLanguage/languageSelection.dart';
import 'package:mgramseva/theme.dart';
import 'package:mgramseva/utils/Locilization/application_localizations.dart';
import 'package:mgramseva/utils/global_variables.dart';
import 'package:mgramseva/utils/loaders.dart';
import 'package:mgramseva/utils/notifyers.dart';
import 'package:provider/provider.dart';
import 'package:url_strategy/url_strategy.dart';

import 'providers/consumer_payment.dart';

void main() {
   setPathUrlStrategy();
  setEnvironment(Environment.dev);

  runApp(new MyApp());
}

_MyAppState myAppstate = '' as _MyAppState;

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() {
    myAppstate = _MyAppState();
    return myAppstate;
  }
}

class _MyAppState extends State<MyApp> {
  late Locale _locale = Locale('en', 'IN');

  void setLocale(Locale value) {
    setState(() {
      _locale = value;
    });
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => LanguageProvider()),
          ChangeNotifierProvider(create: (_) => ConsumerProvider()),
          ChangeNotifierProvider(create: (_) => UserProfileProvider()),
          ChangeNotifierProvider(create: (_) => CommonProvider()),
          ChangeNotifierProvider(create: (_) => AuthenticationProvider()),
          ChangeNotifierProvider(create: (_) => ExpensesDetailsProvider()),
          ChangeNotifierProvider(create: (_) => ChangePasswordProvider()),

          ChangeNotifierProvider(create: (_) => UserEditProfileProvider()),
          ChangeNotifierProvider(create: (_) => ExpensesDetailsProvider()),
          ChangeNotifierProvider(create: (_) => ConsumerPayment()),
        ],
        child: Consumer<LanguageProvider>(
            builder: (_, userProvider, child) => MaterialApp(
                  title: 'mGramSeva',
                  supportedLocales: [
                    Locale('en', 'IN'),
                    Locale('hi', 'IN'),
                    Locale.fromSubtags(languageCode: 'pn')
                  ],
                  locale: _locale,
                  localizationsDelegates: [
                    ApplicationLocalizations.delegate,
                    GlobalMaterialLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate,
                    GlobalCupertinoLocalizations.delegate,
                  ],
                  localeResolutionCallback: (locale, supportedLocales) {
                    for (var supportedLocaleLanguage in supportedLocales) {
                      if (supportedLocaleLanguage.languageCode ==
                              locale?.languageCode &&
                          supportedLocaleLanguage.countryCode ==
                              locale?.countryCode) {
                        return supportedLocaleLanguage;
                      }
                    }
                    return supportedLocales.first;
                  },
                  navigatorKey: navigatorKey,
                  initialRoute: Routes.LANDING_PAGE,
                  onGenerateRoute: router.generateRoute,
                  theme: theme,
                  // home: SelectLanguage((val) => setLocale(Locale(val, 'IN'))),
                )));
  }
}

class LandingPage extends StatefulWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  void initState() {
    WidgetsBinding.instance?.addPostFrameCallback((_) => afterViewBuild());

    super.initState();
  }

  afterViewBuild() {
    var commonProvider = Provider.of<CommonProvider>(context, listen: false);
    commonProvider.getLoginCredentails();
  }

  @override
  Widget build(BuildContext context) {
    var commonProvider = Provider.of<CommonProvider>(context, listen: false);

    return StreamBuilder(
        stream: commonProvider.userLoggedStreamCtrl.stream,
        builder: (context, AsyncSnapshot snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:

              /// While waiting for the data to load, show a loading spinner.
              return Loaders.circularLoader();
            default:
              if (snapshot.hasError) {
                return Notifiers.networkErrorPage(context, () {});
              } else {
                if (snapshot.data != null) {
                  return Home();
                }
                return SelectLanguage();
              }
          }
        });
  }
}
