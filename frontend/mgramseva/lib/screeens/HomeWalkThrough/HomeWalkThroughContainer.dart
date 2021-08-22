import 'package:flutter/material.dart';
import 'package:mgramseva/providers/consumer_details_provider.dart';
import 'package:mgramseva/providers/expenses_details_provider.dart';
import 'package:mgramseva/providers/home_provider.dart';
import 'package:mgramseva/screeens/ConsumerDetails/Pointer.dart';
import 'package:mgramseva/utils/Constants/I18KeyConstants.dart';
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
          .homeWalkthrougList[homeProvider.activeindex]
          .key!
          .currentContext!
          .findRenderObject() as RenderBox?;
      Offset position = box!.localToGlobal(Offset.zero);
      print(homeProvider.activeindex);
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
                        homeProvider
                            .homeWalkthrougList[homeProvider.activeindex].widget,
                      ],
                    ))))),
        Positioned(
            left: position.dx + 5,
            top: (homeProvider.activeindex == 6 || homeProvider.activeindex == 7 || homeProvider.activeindex == 8) ? position.dy - 25 : box.size.height + position.dy,
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
            )),
        Positioned(
            left: (homeProvider.activeindex+1) % 3 == 0? position.dx - 50 : position.dx,
            top: (homeProvider.activeindex == 6 || homeProvider.activeindex == 7 || homeProvider.activeindex == 8) ?  position.dy - box.size.height - 25 : box.size.height + position.dy + 25,
            child: Container(
                width: MediaQuery.of(context).size.width > 720 ? MediaQuery.of(context).size.width/ 3 : MediaQuery.of(context).size.width / 2,
                alignment: Alignment.centerRight,
                padding: EdgeInsets.only(right: 8),
                child: Card(
                    child: Column(children: [
                      Padding(
                          padding: EdgeInsets.all(10),
                          child: Text(
                            homeProvider
                                .homeWalkthrougList[homeProvider.activeindex]
                                .name,
                            style: TextStyle(fontSize: 16),
                          )),
                      Padding(
                          padding: EdgeInsets.all(10),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton(
                                    onPressed: () async {
                                      homeProvider.activeindex = 0;
                                      Navigator.pop(context);
                                      setState(() {
                                        active = 0;
                                      });
                                    },
                                    child: Text(i18.common.SKIP)),
                                ElevatedButton(
                                    onPressed: () async {
                                      if (homeProvider
                                          .homeWalkthrougList.length -
                                          1 <=
                                          active) {
                                        homeProvider.activeindex = 0;
                                        Navigator.pop(context);
                                        setState(() {
                                          active = 0;
                                        });
                                      } else {
                                        widget
                                            .onnext!(homeProvider.activeindex);
                                        await Scrollable.ensureVisible(
                                            homeProvider
                                                .homeWalkthrougList[
                                            homeProvider.activeindex]
                                                .key!
                                                .currentContext!,
                                            duration:
                                            new Duration(milliseconds: 100));

                                        setState(() {
                                          active = active + 1;
                                        });
                                      }
                                    },
                                    child: Text(i18.common.NEXT))
                              ]))
                    ]))))
      ]);
    });
  }
}
