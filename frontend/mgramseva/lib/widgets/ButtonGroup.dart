import 'package:flutter/material.dart';

class ButtonGroup extends StatelessWidget {
  final String label;
  ButtonGroup(this.label);
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return new Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(),
          Container(
            alignment: Alignment.centerLeft,
            width: constraints.maxWidth > 760
                ? MediaQuery.of(context).size.width / 2
                : MediaQuery.of(context).size.width,
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Row(
                    children: <Widget>[
                      Expanded(
                          child: OutlinedButton(
                        onPressed: null,
                        style: ButtonStyle(
                          shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(0.0))),
                        ),
                        child: Padding(
                            padding: EdgeInsets.all(15),
                            child: const Text(
                              "Share Bill",
                              style: TextStyle(
                                  color: Color(0XFFf47738),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500),
                            )),
                      )),
                      SizedBox(width: 5),
                      Expanded(
                          child: new ElevatedButton(
                        style: ElevatedButton.styleFrom(),
                        child: Padding(
                            padding: EdgeInsets.only(top: 15, bottom: 15),
                            child: new Text(label,
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500))),
                        onPressed: () => Navigator.pushNamed(context, "home"),
                      ))
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      );
    });
  }
}
