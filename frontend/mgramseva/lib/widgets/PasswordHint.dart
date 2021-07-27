import 'package:flutter/material.dart';

class PasswordHint extends StatelessWidget {
  final inputPassword;
  PasswordHint(this.inputPassword);
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: new BoxDecoration(color: Theme.of(context).highlightColor),
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.all(15),
      padding: EdgeInsets.all(5),
      child: (Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Row(
            children: [
              Icon(Icons.info, color: Theme.of(context).hintColor),
              Text("Password Hint",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context).hintColor))
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            children: [
              Text(
                "Minimum 6 digits",
                style: TextStyle(
                    fontSize: 16,
                    color: new RegExp(r'^(?=.{6,})').hasMatch(inputPassword)
                        ? Colors.green[900]
                        : Theme.of(context).hintColor),
              ),
              new RegExp(r'^(?=.{6,})').hasMatch(inputPassword)
                  ? Icon(
                      Icons.check,
                      color: Colors.green[900],
                    )
                  : Text("")
            ],
          ),
          SizedBox(height: 5),
          Row(children: [
            Text(
              "Atleast one special character",
              style: TextStyle(
                  fontSize: 16,
                  color: RegExp(r'^(?=.*[^A-Za-z0-9])').hasMatch(inputPassword)
                      ? Colors.green[900]
                      : Theme.of(context).hintColor),
            ),
            new RegExp(r'^(?=.*[^A-Za-z0-9])').hasMatch(inputPassword)
                ? Icon(
                    Icons.check,
                    color: Colors.green[900],
                  )
                : Text("")
          ]),
          SizedBox(height: 5),
          Row(children: [
            Text(
              "Atleast one letter",
              style: TextStyle(
                  fontSize: 16,
                  color: RegExp(r'^(?=.*[a-zA-Z])').hasMatch(inputPassword)
                      ? Colors.green[900]
                      : Theme.of(context).hintColor),
            ),
            new RegExp(r'^(?=.*[a-zA-Z])').hasMatch(inputPassword)
                ? Icon(
                    Icons.check,
                    color: Colors.green[900],
                  )
                : Text("")
          ]),
          SizedBox(height: 5),
          Row(children: [
            Text(
              "Atleast one number (0-9)",
              style: TextStyle(
                  fontSize: 16,
                  color: RegExp(r'^(?=.*?[0-9])').hasMatch(inputPassword)
                      ? Colors.green[900]
                      : Theme.of(context).hintColor),
            ),
            new RegExp(r'^(?=.*?[0-9])').hasMatch(inputPassword)
                ? Icon(
                    Icons.check,
                    color: Colors.green[900],
                  )
                : Text("")
          ])
        ],
      )),
    );
  }
}
