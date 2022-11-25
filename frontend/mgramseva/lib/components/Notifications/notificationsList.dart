import 'package:flutter/material.dart';
import 'package:mgramseva/model/Events/events_List.dart';
import 'package:mgramseva/providers/notifications_provider.dart';
import 'package:mgramseva/routers/Routers.dart';
import 'package:mgramseva/utils/Constants/I18KeyConstants.dart';
import 'package:mgramseva/utils/Locilization/application_localizations.dart';
import 'package:mgramseva/utils/loaders.dart';
import 'package:mgramseva/utils/notifyers.dart';
import 'package:mgramseva/widgets/ButtonLink.dart';
import 'package:mgramseva/widgets/ListLabelText.dart';
import 'package:mgramseva/widgets/Notifications.dart';
import 'package:provider/provider.dart';

class NotificationsList extends StatefulWidget {
  final bool close;
  const NotificationsList({Key? key, required this.close})
      : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return NotificationsListState();
  }
}

class NotificationsListState extends State<NotificationsList> {
  buildNotificationsView(List<Events>? events) {
    return LayoutBuilder(builder: (context, constraints) {
      return Column(mainAxisSize: MainAxisSize.min, children: [
        events!.length > 0
            ? Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ListLabelText(ApplicationLocalizations.of(context)
                    .translate(i18.common.NOTIFICATIONS) +
                " (" +
                events.length.toString() +
                ")"),
              (events.length > 0)? Center(
                  child: ButtonLink(i18.common.VIEW_ALL, () => Navigator.pushNamed(context, Routes.NOTIFICATIONS))) : Text(""),
            ])
            : Text(""),
        ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: events.length,
            itemBuilder: (context, i) {
              var item = events[i];
              callBack() {
                Provider.of<NotificationProvider>(context, listen: false)
              ..updateNotify(item, events);
              }
              return Notifications(item, callBack, widget.close);
            }),
        (events.length > 0)? Center(
            child: ButtonLink(i18.common.VIEW_ALL, () => Navigator.pushNamed(context, Routes.NOTIFICATIONS))) : Text(""),
      ]);
    });
  }

  @override
  Widget build(BuildContext context) {
    var billpaymentsProvider =
        Provider.of<NotificationProvider>(context, listen: false);
    return StreamBuilder(
        stream: billpaymentsProvider.streamController.stream,
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return buildNotificationsView(snapshot.data);
          } else if (snapshot.hasError) {
            return Notifiers.networkErrorPage(context, () {});
          } else {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return Loaders.CircularLoader();
              case ConnectionState.active:
                return Loaders.CircularLoader();
              default:
                return Container();
            }
          }
        });
  }
}
