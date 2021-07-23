import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Notifiers {
  static getToastMessage(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  static Widget networkErrorPage(context, VoidCallback callBack) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "Unable to connect to the server",
            style: TextStyle(color: Colors.black, fontSize: 18),
          ),
          Padding(
            padding: EdgeInsets.all(12.0),
            child: RaisedButton(
              onPressed: callBack,
              child: Text(
                'Retry',
                style: TextStyle(color: Colors.white),
              ),
            ),
          )
        ],
      ),
    );
  }
}
