import 'package:flutter/material.dart';
import 'package:mgramseva/providers/consumer_details_provider.dart';
import 'package:mgramseva/screeens/ConsumerDetails/Pointer.dart';
import 'package:mgramseva/utils/Constants/I18KeyConstants.dart';
import 'package:mgramseva/utils/Locilization/application_localizations.dart';
import 'package:provider/provider.dart';

class WalkThroughContainer extends StatefulWidget {
  final Function? onnext;

  WalkThroughContainer(this.onnext);
  @override
  State<StatefulWidget> createState() {
    return _WalkhroughContainerState();
  }
}

class _WalkhroughContainerState extends State<WalkThroughContainer> {
  int active = 0;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ConsumerProvider>(builder: (_, consumerProvider, child) {
      RenderBox? box = consumerProvider
          .consmerWalkthrougList[consumerProvider.activeindex]
          .key!
          .currentContext!
          .findRenderObject() as RenderBox?;
      Offset position = box!.localToGlobal(Offset.zero);
      print(consumerProvider.activeindex);
      return Stack(children: [
        Positioned(
            left: position.dx,
            top: position.dy,
            child: Container(
                width: MediaQuery.of(context).size.width /1.1  ,
                child: Card(
                    child: Column(
              children: [
                consumerProvider
                    .consmerWalkthrougList[consumerProvider.activeindex].widget,
              ],
            )))),
        Positioned(
            right: box.size.width / 3,
            top: consumerProvider.activeindex == (consumerProvider
                .consmerWalkthrougList.length-1) ? position.dy - 25 : box.size.height + position.dy,
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
            right: position.dx,
            top: consumerProvider.activeindex == (consumerProvider
                .consmerWalkthrougList.length-1) ? position.dy - box.size.height - 75 : box.size.height + position.dy + 25,
            child: Container(
                width: MediaQuery.of(context).size.width > 720 ? MediaQuery.of(context).size.width/ 3 : MediaQuery.of(context).size.width /2,
                alignment: Alignment.centerRight,
                padding: EdgeInsets.only(right: 8),
                child: Card(
                    child: Column(children: [
                  Padding(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        consumerProvider
                            .consmerWalkthrougList[consumerProvider.activeindex]
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
                                  consumerProvider.activeindex = 0;
                                  Navigator.pop(context);
                                  setState(() {
                                    active = 0;
                                  });
                                },
                                child: Text(ApplicationLocalizations.of(context)
                                    .translate(i18.common.SKIP))),
                            ElevatedButton(
                                onPressed: () async {
                                  if (consumerProvider
                                              .consmerWalkthrougList.length -
                                          1 <=
                                      active) {
                                    consumerProvider.activeindex = 0;
                                    Navigator.pop(context);
                                    setState(() {
                                      active = 0;
                                    });
                                  } else {
                                    widget
                                        .onnext!(consumerProvider.activeindex);
                                    await Scrollable.ensureVisible(
                                        consumerProvider
                                            .consmerWalkthrougList[
                                                consumerProvider.activeindex]
                                            .key!
                                            .currentContext!,
                                        duration:
                                            new Duration(milliseconds: 100));

                                    setState(() {
                                      active = active + 1;
                                    });
                                  }
                                },
                                child: Text(ApplicationLocalizations.of(context)
          .translate(i18.common.NEXT)))
                          ]))
                ]))))
      ]);
    });
  }
}
