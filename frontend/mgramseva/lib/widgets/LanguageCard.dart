import 'package:flutter/material.dart';

class LanguageCard extends StatelessWidget {
  final String text;
  final String value;
  final bool selected;
  final int widthprect;
  final double cpadding;
  final double cmargin;

  final Function widgetFun;
  LanguageCard(this.text, this.value, this.selected, this.widgetFun,
      this.widthprect, this.cpadding, this.cmargin);

  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
        onTap: () => this.widgetFun(this.value),
        child: Container(
            margin: new EdgeInsets.all(cmargin),
            width: MediaQuery.of(context).size.width / widthprect,
            padding: new EdgeInsets.all(cpadding),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                color: this.selected
                    ? Theme.of(context).primaryColor
                    : Colors.white),
            child: Center(
                child: new Text(
              this.text,
              style: new TextStyle(
                  fontWeight: FontWeight.bold,
                  color: this.selected ? Colors.white : Colors.black),
            ))));
  }
}
