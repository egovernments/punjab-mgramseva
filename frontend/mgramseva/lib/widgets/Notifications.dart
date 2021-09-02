import 'package:flutter/material.dart';
import 'package:mgramseva/model/Events/events_List.dart';
import 'package:mgramseva/routers/Routers.dart';
import 'package:mgramseva/utils/Constants/I18KeyConstants.dart';
import 'package:mgramseva/utils/Locilization/application_localizations.dart';

class Notifications extends StatefulWidget {
  final Events? event;
  Notifications(this.event);
  @override
  State<StatefulWidget> createState() {
    return _NotificationsState();
  }
}

class _NotificationsState extends State<Notifications> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
          decoration: BoxDecoration(
            border: Border(
              left:
                  BorderSide(width: 5.0, color: Theme.of(context).primaryColor),
            ),
            /*** The BorderRadius widget  is here ***/
            //BorderRadius.all
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                  onTap: () {
                    widget.event!.actions != null
                        ? Navigator.pushNamed(context, widget.event!.actions!)
                        : null;
                  },
                  child: Container(
                      child: Padding(
                          padding: EdgeInsets.all(8),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                  padding: EdgeInsets.all(4),
                                  child: Text(
                                    ApplicationLocalizations.of(context)
                                        .translate(widget.event!.name!),
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700),
                                  )),
                              Padding(
                                  padding: EdgeInsets.all(4),
                                  child: Text(
                                    ApplicationLocalizations.of(context)
                                        .translate(widget.event!.description!),
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400),
                                    textAlign: TextAlign.left,
                                  )),
                              Padding(
                                  padding: EdgeInsets.only(
                                      top: 24, bottom: 4, left: 4, right: 4),
                                  child: Text(
                                    DateTime.now()
                                            .difference(DateTime
                                                .fromMillisecondsSinceEpoch(
                                                    widget.event!.auditDetails!
                                                        .createdTime!))
                                            .inDays
                                            .toString() +
                                        " " +
                                        ApplicationLocalizations.of(context)
                                            .translate(i18
                                                .generateBillDetails.DAYS_AGO),
                                    style: TextStyle(
                                        color: Theme.of(context).primaryColor),
                                  ))
                            ],
                          )))),
              // Align(
              //     alignment: Alignment.topRight,
              //     child: Container(
              //         child: IconButton(
              //       icon: Icon(Icons.close),
              //       onPressed: null,
              //     ))),
            ],
          )),
    );
  }
}
