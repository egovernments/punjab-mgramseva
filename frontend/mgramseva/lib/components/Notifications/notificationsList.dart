import 'package:flutter/material.dart';
import 'package:mgramseva/model/Events/events_List.dart';
import 'package:mgramseva/providers/common_provider.dart';
import 'package:mgramseva/providers/notifications_provider.dart';
import 'package:mgramseva/utils/Constants/I18KeyConstants.dart';
import 'package:mgramseva/utils/Locilization/application_localizations.dart';
import 'package:mgramseva/utils/loaders.dart';
import 'package:mgramseva/utils/notifyers.dart';
import 'package:mgramseva/widgets/ListLabelText.dart';
import 'package:mgramseva/widgets/Notifications.dart';
import 'package:provider/provider.dart';

class NotificationsList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return NotificationsListState();
  }
}

class NotificationsListState extends State<NotificationsList> {
  @override
  void initState() {
    WidgetsBinding.instance?.addPostFrameCallback((_) => afterViewBuild());
    super.initState();
  }

  afterViewBuild() {
    var commonProvider = Provider.of<CommonProvider>(context, listen: false);

    Provider.of<NotificationProvider>(context, listen: false)
      ..getNotiications({
        "tenantId": commonProvider.userDetails!.selectedtenant!.code,
        "eventType": "SYSTEMGENERATED",
        "recepients": commonProvider.userDetails!.userRequest!.uuid
      });
  }

  buildNotificationsView(EventsList events) {
    return LayoutBuilder(builder: (context, constraints) {
      return Column(children: [
        ListLabelText(ApplicationLocalizations.of(context)
                .translate(i18.common.NOTIFICATIONS) +
            " (" +
            events.events!.length.toString() +
            ")"),
        for (var item in events.events!) Notifications(item)
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
