import 'package:flutter/material.dart';

class Notifications extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _NotificationsState();
  }
}

class _NotificationsState extends State<Notifications> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            child: SizedBox(
              width: 5,
              height: 100,
            ),
            color: Theme.of(context).primaryColor,
          ),
          Container(
              child: Column(
            children: [],
          )),
          Container(child: Text("*")),
        ],
      ),
    );
  }
}
