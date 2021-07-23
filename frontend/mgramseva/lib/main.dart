import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:mgramseva/Env/app_config.dart';
import 'package:mgramseva/providers/common_provider.dart';
import 'package:mgramseva/providers/expenses_details_provider.dart';
import 'package:mgramseva/providers/language_provider.dart';
import 'package:mgramseva/providers/user_profile_provider.dart';
import 'package:mgramseva/screeens/ConnectionResults.dart';
import 'package:mgramseva/screeens/ConsumerDetails.dart';
import 'package:mgramseva/screeens/Dashboard.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:mgramseva/screeens/GenerateBill/GenerateBill.dart';
import 'package:mgramseva/screeens/Login/Login.dart';
import 'package:mgramseva/screeens/ResetPassword/Resetpassword.dart';
import 'package:mgramseva/screeens/SearchConnection.dart';
import 'package:mgramseva/screeens/SelectLanguage/languageSelection.dart';

import 'package:mgramseva/screeens/EditProfile.dart';
import 'package:mgramseva/screeens/ExpenseDetails.dart';
import 'package:mgramseva/screeens/HouseholdDetail.dart';
import 'package:mgramseva/screeens/Updatepassword.dart';
import 'package:mgramseva/screeens/changepassword.dart';
import 'package:mgramseva/screeens/home.dart';
import 'package:mgramseva/utils/Locilization/application_localizations.dart';
import 'package:mgramseva/utils/global_variables.dart';
import 'package:provider/provider.dart';

void main() {
  setEnvironment(Environment.dev);

  runApp(new MyApp());
}

MaterialColor createMaterialColor(Color color) {
  List strengths = <double>[.05];
  final swatch = <int, Color>{};
  final int r = color.red, g = color.green, b = color.blue;

  for (int i = 1; i < 10; i++) {
    strengths.add(0.1 * i);
  }
  strengths.forEach((strength) {
    final double ds = 0.5 - strength;
    swatch[(strength * 1000).round()] = Color.fromRGBO(
      r + ((ds < 0 ? r : (255 - r)) * ds).round(),
      g + ((ds < 0 ? g : (255 - g)) * ds).round(),
      b + ((ds < 0 ? b : (255 - b)) * ds).round(),
      1,
    );
  });
  return MaterialColor(color.value, swatch);
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
    print(value);
    setState(() {
      _locale = value;
    });
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => UserProfileProvider()),
          ChangeNotifierProvider(
            create: (_) => ExpensesDetailsProvider(),
          ),
          ChangeNotifierProvider(create: (_) => CommonProvider()),
          ChangeNotifierProvider(create: (_) => LanguageProvider()),
        ],
        child: MaterialApp(
          title: 'Flutter Demo',
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
                  supportedLocaleLanguage.countryCode == locale?.countryCode) {
                return supportedLocaleLanguage;
              }
            }
            return supportedLocales.first;
          },
          navigatorKey: navigatorKey,
          initialRoute: '/',
          routes: {
            '/': (context) => SelectLanguage((val) {
                  print("value");
                  print(val);
                  setLocale(Locale(val, 'IN'));
                }),
            'login': (context) => Login(),
            'home': (context) => Home(0),
            'household/search': (context) => SearchConnection(),
            'editProfile': (context) => EditProfile(),
            'changepassword': (context) => ChangePassword(),
            'updatepassword': (context) => UpdatePassword(),
            'consumer/create': (context) => ConsumerDetails(),
            'resetpassword': (context) => ResetPassword(),
            'consumer/search': (context) => SearchConnection(),
            'expenses/add': (context) => ExpenseDetails(),
            'household/details': (context) => HouseholdDetail(),
            'dashboard': (context) => Dashboard(),
            'search/consumer': (context) => SearchConsumerResult(),
            'bill/generate': (context) => GenerateBill()
          },
          theme: ThemeData(
              // This is the theme of your application.
              //
              // Try running your application with "flutter run". You'll see the
              // application has a blue toolbar. Then, without quitting the app, try
              // changing the primarySwatch below to Colors.green and then invoke
              // "hot reload" (press "r" in the console where you ran "flutter run",
              // or simply save your changes to "hot reload" in a Flutter IDE).
              // Notice that the counter didn't reset back to zero; the application
              // is not restarted.
              textTheme: Theme.of(context).textTheme.apply(
                    fontFamily: 'Roboto',
                  ),
              primarySwatch: createMaterialColor(Color(0XFFf47738)),
              highlightColor: createMaterialColor(Color(0XFFC7E0F1)),
              hintColor: createMaterialColor(Color(0XFF3498DB))),

          // home: SelectLanguage((val) => setLocale(Locale(val, 'IN'))),
        ));
  }
}
