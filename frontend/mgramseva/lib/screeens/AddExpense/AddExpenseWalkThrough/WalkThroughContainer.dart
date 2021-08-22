import 'package:flutter/material.dart';
import 'package:mgramseva/providers/consumer_details_provider.dart';
import 'package:mgramseva/providers/expenses_details_provider.dart';
import 'package:mgramseva/screeens/ConsumerDetails/Pointer.dart';
import 'package:mgramseva/utils/Constants/I18KeyConstants.dart';
import 'package:provider/provider.dart';

class ExpenseWalkThroughContainer extends StatefulWidget {
  final Function? onnext;

  ExpenseWalkThroughContainer(this.onnext);
  @override
  State<StatefulWidget> createState() {
    return _ExpenseWalkThroughContainerState();
  }
}

class _ExpenseWalkThroughContainerState extends State<ExpenseWalkThroughContainer> {
  int active = 0;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ExpensesDetailsProvider>(builder: (_, expenseProvider, child) {
      RenderBox? box = expenseProvider
          .expenseWalkthrougList[expenseProvider.activeindex]
          .key!
          .currentContext!
          .findRenderObject() as RenderBox?;
      Offset position = box!.localToGlobal(Offset.zero);
      print(expenseProvider.activeindex);
      return Stack(children: [
        Positioned(
            left: position.dx,
            top: position.dy,
            child: Container(
                child: Card(
                    child: Column(
                      children: [
                        expenseProvider
                            .expenseWalkthrougList[expenseProvider.activeindex].widget,
                      ],
                    )))),
        Positioned(
            right: box.size.width / 3,
            top: box.size.height + position.dy,
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
            top: box.size.height + position.dy + 25,
            child: Container(
                width: MediaQuery.of(context).size.width / 2,
                alignment: Alignment.centerRight,
                padding: EdgeInsets.only(right: 8),
                child: Card(
                    child: Column(children: [
                      Padding(
                          padding: EdgeInsets.all(10),
                          child: Text(
                            expenseProvider
                                .expenseWalkthrougList[expenseProvider.activeindex]
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
                                      expenseProvider.activeindex = 0;
                                      Navigator.pop(context);
                                      setState(() {
                                        active = 0;
                                      });
                                    },
                                    child: Text(i18.common.SKIP)),
                                ElevatedButton(
                                    onPressed: () async {
                                      if (expenseProvider
                                          .expenseWalkthrougList.length -
                                          1 <=
                                          active) {
                                        expenseProvider.activeindex = 0;
                                        Navigator.pop(context);
                                        setState(() {
                                          active = 0;
                                        });
                                      } else {
                                        widget
                                            .onnext!(expenseProvider.activeindex);
                                        await Scrollable.ensureVisible(
                                            expenseProvider
                                                .expenseWalkthrougList[
                                            expenseProvider.activeindex]
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
