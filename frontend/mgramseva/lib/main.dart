import 'dart:async';
import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';

import 'package:mgramseva/providers/authentication.dart';
import 'package:mgramseva/providers/bill_generation_details_provider.dart';
import 'package:mgramseva/providers/bill_payments_provider.dart';
import 'package:mgramseva/providers/changePassword_details_provider.dart';
import 'package:mgramseva/providers/common_provider.dart';
import 'package:mgramseva/providers/consumer_details_provider.dart';
import 'package:mgramseva/providers/expenses_details_provider.dart';
import 'package:mgramseva/providers/forgot_password_provider.dart';
import 'package:mgramseva/providers/home_provider.dart';
import 'package:mgramseva/providers/household_details_provider.dart';
import 'package:mgramseva/providers/language.dart';
import 'package:mgramseva/Env/app_config.dart';
import 'package:mgramseva/providers/notifications_provider.dart';
import 'package:mgramseva/providers/reset_password_provider.dart';
import 'package:mgramseva/providers/search_connection_provider.dart';
import 'package:mgramseva/providers/tenants_provider.dart';
import 'package:mgramseva/providers/user_edit_profile_provider.dart';

import 'package:mgramseva/providers/user_profile_provider.dart';
import 'package:mgramseva/router.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:mgramseva/routers/Routers.dart';
import 'package:mgramseva/screeens/Home.dart';

import 'package:mgramseva/screeens/SelectLanguage/languageSelection.dart';
import 'package:mgramseva/theme.dart';
import 'package:mgramseva/utils/Locilization/application_localizations.dart';
import 'package:mgramseva/utils/error_logging.dart';
import 'package:mgramseva/utils/global_variables.dart';
import 'package:mgramseva/utils/loaders.dart';
import 'package:mgramseva/utils/notifyers.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:url_strategy/url_strategy.dart';

import 'providers/collect_payment.dart';
import 'providers/dashboard_provider.dart';
import 'screeens/common/collect_payment.dart';

void main() {
  setPathUrlStrategy();
  setEnvironment(Environment.dev);

  runZonedGuarded(() async {
    FlutterError.onError = (FlutterErrorDetails details) {
      FlutterError.dumpErrorToConsole(details);
      ErrorHandler.logError(details.exception.toString(), details.stack);
      // exit(1); /// to close the app smoothly
    };

    WidgetsFlutterBinding.ensureInitialized();
    await FlutterDownloader.initialize(
        debug: true // optional: set false to disable printing logs to console
        );

    runApp(MyApp());
  }, (Object error, StackTrace stack) {
    ErrorHandler.logError(error.toString(), stack);
    // exit(1); /// to close the app smoothly
  });

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
          ChangeNotifierProvider(create: (_) => ForgotPasswordProvider()),
          ChangeNotifierProvider(create: (_) => ResetPasswordProvider()),
          ChangeNotifierProvider(create: (_) => TenantsProvider()),
          ChangeNotifierProvider(create: (_) => BillGenerationProvider()),
          ChangeNotifierProvider(create: (_) => TenantsProvider()),
          ChangeNotifierProvider(create: (_) => HouseHoldProvider()),
          ChangeNotifierProvider(create: (_) => SearchConnectionProvider()),
          ChangeNotifierProvider(create: (_) => CollectPaymentProvider()),
          ChangeNotifierProvider(create: (_) => DashBoardProvider()),
          ChangeNotifierProvider(create: (_) => BillPayemntsProvider()),
          ChangeNotifierProvider(create: (_) => HomeProvider()),
          ChangeNotifierProvider(create: (_) => NotificationProvider()),
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
  ReceivePort _port = ReceivePort();

  @override
  void initState() {
    WidgetsBinding.instance?.addPostFrameCallback((_) => afterViewBuild());
    super.initState();
  }

  @override
  void dispose() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
    super.dispose();
  }

  static void downloadCallback(
      String id, DownloadTaskStatus status, int progress) {
    final SendPort send =
        IsolateNameServer.lookupPortByName('downloader_send_port')!;
    print(progress);
    send.send([id, status, progress]);
  }

  afterViewBuild() async {
    var commonProvider = Provider.of<CommonProvider>(context, listen: false);
    commonProvider.getLoginCredentails();

    await Future.delayed(Duration(seconds: 2));
    IsolateNameServer.registerPortWithName(
        _port.sendPort, 'downloader_send_port');
    _port.listen((dynamic data) {
      String id = data[0];
      DownloadTaskStatus status = data[1];
      int progress = data[2];
      setState(() {});
    });
    FlutterDownloader.registerCallback(downloadCallback);
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
