import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Notifiers {
  static getToastMessage(String message, type) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 30,
        backgroundColor: type == 'ERROR' ? Colors.red : Colors.green,
        textColor: Colors.white,
        webBgColor: type == 'ERROR' ? "#FF0000" : "#00703C",
        webPosition: "center",
        webShowClose: true,
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
