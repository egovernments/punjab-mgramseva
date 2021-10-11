import 'package:flutter/material.dart';
import 'package:mgramseva/components/Notifications/notificationsList.dart';
import 'package:mgramseva/providers/common_provider.dart';
import 'package:mgramseva/providers/notifications_provider.dart';
import 'package:mgramseva/utils/error_logging.dart';
import 'package:mgramseva/utils/global_variables.dart';
import 'package:mgramseva/widgets/DrawerWrapper.dart';
import 'package:mgramseva/widgets/SideBar.dart';
import 'package:mgramseva/widgets/customAppbar.dart';
import 'package:provider/provider.dart';
class NotificationScreen extends StatefulWidget {

  State<StatefulWidget> createState() {
    return _NotificationScreen();
  }
}


class _NotificationScreen extends State<NotificationScreen> {

  void initState() {
    WidgetsBinding.instance?.addPostFrameCallback((_) => afterViewBuild());
    super.initState();
  }
  afterViewBuild(){
    var commonProvider =
    Provider.of<CommonProvider>(context, listen: false);
    try {
      Provider.of<NotificationProvider>(context, listen: false)
        ..getNotiications({
          "tenantId": commonProvider.userDetails?.selectedtenant?.code!,
          "eventType": "SYSTEMGENERATED",
          "recepients": commonProvider.userDetails?.userRequest?.uuid,
        }, {
          "tenantId": commonProvider.userDetails?.selectedtenant?.code!,
          "eventType": "SYSTEMGENERATED",
          "roles": commonProvider.userDetails?.userRequest?.roles!
              .map((e) => e.code.toString())
              .join(',')
              .toString(),
        });
    }
    catch (e, s) {
      ErrorHandler().allExceptionsHandler(navigatorKey.currentContext!, e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(),
    drawer: DrawerWrapper(
    Drawer(child: SideBar()),
    ),
    body: SingleChildScrollView(
    child: NotificationsList(close : false)
    ));
  }
}
