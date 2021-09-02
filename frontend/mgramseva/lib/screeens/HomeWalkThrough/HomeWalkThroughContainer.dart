import 'package:flutter/material.dart';
import 'package:mgramseva/providers/common_provider.dart';
import 'package:mgramseva/providers/home_provider.dart';
import 'package:mgramseva/providers/notifications_provider.dart';
import 'package:mgramseva/screeens/ConsumerDetails/Pointer.dart';
import 'package:mgramseva/utils/Constants/I18KeyConstants.dart';
import 'package:mgramseva/utils/Locilization/application_localizations.dart';
import 'package:mgramseva/utils/constants.dart';
import 'package:provider/provider.dart';

class HomeWalkThroughContainer extends StatefulWidget {
  final Function? onnext;

  HomeWalkThroughContainer(this.onnext);
  @override
  State<StatefulWidget> createState() {
    return _HomeWalkThroughContainerState();
  }
}

class _HomeWalkThroughContainerState extends State<HomeWalkThroughContainer> {
  int active = 0;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeProvider>(builder: (_, homeProvider, child) {
      RenderBox? box = homeProvider
          .homeWalkthrougList[homeProvider.activeindex].key!.currentContext!
          .findRenderObject() as RenderBox?;
      Offset position = box!.localToGlobal(Offset.zero);
      return Stack(children: [
        Positioned(
            left: position.dx,
            top: position.dy,
            child: Container(
                width: box.size.width,
                height: box.size.height,
                child: Card(
                    child: Container(
                        width: box.size.width,
                        height: box.size.height,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Card(
                                elevation: 0,
                                margin: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 10),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(
                                        homeProvider
                                            .homeWalkthrougList[
                                                homeProvider.activeindex]
                                            .icon,
                                        size: 35),
                                    Container(
                                      margin: EdgeInsets.all(10),
                                      child: Center(
                                          child: new Text(
                                        ApplicationLocalizations.of(context)
                                            .translate(homeProvider
                                                .homeWalkthrougList[
                                                    homeProvider.activeindex]
                                                .label),
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400),
                                        textAlign: TextAlign.center,
                                      )),
                                    )
                                  ],
                                ))
                          ],
                        ))))),
      Consumer<NotificationProvider>(builder: (_, notificationProvider, child) =>
      Positioned(
            left: position.dx + 5,
            top: notificationProvider.enableNotification == true ? box.size.height + position.dy : (homeProvider.activeindex == 6 ||
                    homeProvider.activeindex == 7 ||
                    homeProvider.activeindex == 8)
                ? position.dy - 25
                : box.size.height + position.dy,
            child: CustomPaint(
              painter: TrianglePainter(
                strokeColor: Colors.white,
                strokeWidth: 5,
                paintingStyle: PaintingStyle.fill,
              ),
              child: Container(
                height: 30,
                width: 50,
              ),
            ))),
      Consumer<NotificationProvider>(builder: (_, notificationProvider, child) =>
      Positioned(
            left: ((homeProvider.activeindex + 1) % 3 == 0)
                ? position.dx - 140
                : position.dx,
            top: notificationProvider.enableNotification == true ? box.size.height + position.dy + 25 : (homeProvider.activeindex == 6 ||
                    homeProvider.activeindex == 7 ||
                    homeProvider.activeindex == 8)
                ? position.dy -
                    box.size.height -
                    (MediaQuery.of(context).size.width > 720 ? 55 : 25)
                : box.size.height + position.dy + 25,
            child: Container(
                width: MediaQuery.of(context).size.width > 720
                    ? MediaQuery.of(context).size.width / 3
                    : MediaQuery.of(context).size.width / 1.4,
                height: 160,
                alignment: Alignment.centerRight,
                padding: EdgeInsets.only(right: 15),
                child: Card(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                      Padding(
                          padding: EdgeInsets.only(
                            top: 20,
                            left: 10,
                            right: 10,
                          ),
                          child: Text(
                            ApplicationLocalizations.of(context).translate(
                                homeProvider
                                    .homeWalkthrougList[
                                        homeProvider.activeindex]
                                    .name),
                            style: TextStyle(
                                fontSize: 14,
                                color: Theme.of(context).primaryColorLight),
                            textAlign: TextAlign.start,
                          )),
                      homeProvider.activeindex ==
                              homeProvider.homeWalkthrougList.length - 1
                          ? Padding(
                              padding: EdgeInsets.only(
                                  top: 10, right: 20, bottom: 10),
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    GestureDetector(
                                        onTap: () async {
                                          homeProvider.activeindex = 0;
                                          Navigator.pop(context);
                                          Provider.of<CommonProvider>(context,
                                              listen: false)
                                            ..walkThroughCondition(
                                                false, Constants.HOME_KEY);
                                          setState(() {
                                            active = 0;
                                          });
                                        },
                                        child: Container(
                                          margin: EdgeInsets.all(5.0),
                                          height: 35,
                                          width: 80,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                            color:
                                                Theme.of(context).primaryColor,
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey,
                                                offset:
                                                    Offset(0.0, 1.0), //(x,y)
                                                blurRadius: 6.0,
                                              ),
                                            ],
                                          ),
                                          child: Center(
                                              child: Text(
                                            ApplicationLocalizations.of(context)
                                                .translate(i18.common.END),
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 12),
                                          )),
                                        ))
                                  ]))
                          : Padding(
                              padding: EdgeInsets.all(0),
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    TextButton(
                                        onPressed: () async {
                                          homeProvider.activeindex = 0;
                                          Navigator.pop(context);
                                          Provider.of<CommonProvider>(context,
                                              listen: false)
                                            ..walkThroughCondition(
                                                false, Constants.HOME_KEY);
                                          setState(() {
                                            active = 0;
                                          });
                                        },
                                        child: Text(
                                            ApplicationLocalizations.of(context)
                                                .translate(i18.common.SKIP),
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Theme.of(context)
                                                    .primaryColorLight))),
                                    GestureDetector(
                                        onTap: () async {
                                          if (homeProvider.homeWalkthrougList
                                                      .length -
                                                  1 <=
                                              active) {
                                            homeProvider.activeindex = 0;
                                            Navigator.pop(context);
                                            setState(() {
                                              active = 0;
                                            });
                                          } else {
                                            widget.onnext!(
                                                homeProvider.activeindex);
                                            await Scrollable.ensureVisible(
                                                homeProvider
                                                    .homeWalkthrougList[
                                                        homeProvider
                                                            .activeindex]
                                                    .key!
                                                    .currentContext!,
                                                duration: new Duration(
                                                    milliseconds: 100));

                                            setState(() {
                                              active = active + 1;
                                            });
                                          }
                                        },
                                        child: Container(
                                          margin: EdgeInsets.all(5.0),
                                          height: 35,
                                          width: 80,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                            color:
                                                Theme.of(context).primaryColor,
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey,
                                                offset:
                                                    Offset(0.0, 1.0), //(x,y)
                                                blurRadius: 6.0,
                                              ),
                                            ],
                                          ),
                                          child: Center(
                                              child: Text(
                                            ApplicationLocalizations.of(context)
                                                .translate(i18.common.NEXT),
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 12),
                                          )),
                                        ))
                                  ]))
                    ])))))
      ]);
    });
  }
}
