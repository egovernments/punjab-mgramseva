import 'package:flutter/material.dart';
import 'package:mgramseva/components/Notifications/notificationsList.dart';
import 'package:mgramseva/providers/home_provider.dart';
import 'package:mgramseva/screeens/HomeCard.dart';
import 'package:mgramseva/utils/constants.dart';
import 'package:mgramseva/utils/role_actions.dart';
import 'package:mgramseva/widgets/DrawerWrapper.dart';
import 'package:mgramseva/widgets/Notifications.dart';
import 'package:mgramseva/widgets/SideBar.dart';
import 'package:mgramseva/widgets/footer.dart';
import 'package:mgramseva/widgets/help.dart';
import 'package:provider/provider.dart';

import 'HomeWalkThrough/HomeWalkThroughContainer.dart';
import 'HomeWalkThrough/HomeWalkThroughList.dart';
import 'customAppbar.dart';

class Home extends StatefulWidget {
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    afterViewBuild();
    super.initState();
  }

  afterViewBuild() {
    Provider.of<HomeProvider>(context, listen: false)
      ..setwalkthrough(HomeWalkThrough().homeWalkThrough.map((e) {
        e.key = GlobalKey();
        return e;
      }).toList());
  }

  @override
  Widget build(BuildContext context) {
    var homeProvider = Provider.of<HomeProvider>(context, listen: false);
    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: CustomAppBar(),
        drawer: DrawerWrapper(
          Drawer(child: SideBar()),
        ),
        body: SingleChildScrollView(
            child: LayoutBuilder(builder: (context, constraint) {
          return Column(children: [
            Align(
                alignment: Alignment.centerRight,
                child: Help(
                  callBack: () => showGeneralDialog(
                    barrierLabel: "Label",
                    barrierDismissible: false,
                    barrierColor: Colors.black.withOpacity(0.5),
                    transitionDuration: Duration(milliseconds: 700),
                    context: context,
                    pageBuilder: (context, anim1, anim2) {
                      return HomeWalkThroughContainer((index) =>
                          homeProvider.incrementindex(index,
                              homeProvider.homeWalkthrougList[index + 1].key));
                    },
                    transitionBuilder: (context, anim1, anim2, child) {
                      return SlideTransition(
                        position: Tween(begin: Offset(0, 1), end: Offset(0, 0))
                            .animate(anim1),
                        child: child,
                      );
                    },
                  ),
                  walkThroughKey: Constants.HOME_KEY,
                )),
            SizedBox(
              child: HomeCard(),
              height: 170 *
                  ((homeProvider.homeWalkthrougList.length / 3).round())
                      .toDouble(),
            ),

            NotificationsList(),
            // Notifications(),
            Footer()
          ]);
        })));
  }
}
