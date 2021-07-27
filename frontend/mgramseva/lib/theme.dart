

   import 'package:flutter/material.dart';

ThemeData get theme => ThemeData(
   primarySwatch: createMaterialColor(Color(0XFFf47738)),
   highlightColor: createMaterialColor(Color(0XFFC7E0F1)),
   hintColor: createMaterialColor(Color(0XFF3498DB)),
   // accentColor:  Color(0xff0B4B66),

   appBarTheme: AppBarTheme(
     backgroundColor:  Color(0xff0B4B66),
     centerTitle: false,
   ),

  /// Background color
  // scaffoldBackgroundColor: Color.fromRGBO(238, 238, 238, 1),

  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      textStyle: TextStyle(color: Colors.black, fontSize: 16),
      // padding: EdgeInsets.symmetric(vertical: 10),
    )
  ),

  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0)),
      padding: EdgeInsets.symmetric(vertical: 15),
      textStyle: TextStyle(
          fontSize: 19, fontWeight: FontWeight.w500)
    )
  ),

    outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0)),
      textStyle: TextStyle(
          color: Color(0XFFf47738),
          fontSize: 19,
          fontWeight: FontWeight.w500),
      padding: EdgeInsets.symmetric(vertical : 15),
    )
),


  inputDecorationTheme: InputDecorationTheme(
    contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
    border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.zero)),
    prefixStyle: TextStyle(color: Colors.black),
    errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.zero),
        borderSide: BorderSide( color: Colors.red)),
    focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.zero),
        borderSide: BorderSide(color: Colors.red)),
    errorStyle: TextStyle(fontSize: 15, fontStyle: FontStyle.italic),
    disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.zero),
        borderSide: BorderSide(color: Colors.grey)),
  )

);


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