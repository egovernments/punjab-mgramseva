import 'package:flutter/material.dart';
import 'package:mgramseva/widgets/LabelText.dart';
import 'package:mgramseva/widgets/SubLabel.dart';

class DashboardCard extends StatelessWidget {
  final List<Map<String, Object>> data;
  DashboardCard(this.data);
  @override
  Widget build(BuildContext context) {
    late int i = 0;
    return LayoutBuilder(builder: (context, constraints) {
      return Card(
          child: Column(children: [
        LabelText("Dashboard"),
        GridView.count(
            crossAxisCount: 3,
            childAspectRatio: constraints.maxWidth < 760 ? 1.2 : 3,
            // childAspectRatio: 1.2,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            children: <Widget>[
              ...data.map((
                Map e,
              ) {
                Widget _tile = GridTile(
                  child: new Card(
                      shape: RoundedRectangleBorder(
                        side: BorderSide(color: Colors.white, width: 0),
                        borderRadius: BorderRadius.circular(0),
                      ),
                      margin: EdgeInsets.zero,
                      child: Container(
                          decoration: BoxDecoration(
                            border: Border(
                                left:
                                    BorderSide(width: 1.0, color: Colors.grey)),
                            color: Colors.white,
                          ),
                          padding: EdgeInsets.all(12),
                          child: new Center(
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      new Text(
                                        e["value"].toString(),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      Icon(Icons.star,
                                          color:
                                              Theme.of(context).primaryColor),
                                    ],
                                  ),
                                  Text(
                                    e["label"].toString(),
                                    textAlign: TextAlign.center,
                                  )
                                ]),
                          ))),
                );
                i++;
                return _tile;
              })
            ]),
        SubLabelText("Feedback provided by 230 users in July 2021"),
        SizedBox(height: 10)
      ]));
    });
  }
}
