import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mgramseva/providers/dashboard_provider.dart';
import 'package:mgramseva/utils/Locilization/application_localizations.dart';
import 'package:mgramseva/utils/date_formats.dart';
import 'package:mgramseva/utils/models.dart';
import 'package:mgramseva/widgets/LabelText.dart';
import 'package:mgramseva/widgets/SubLabel.dart';
import 'package:mgramseva/utils/Constants/I18KeyConstants.dart';
import 'package:provider/provider.dart';

class DashboardCard extends StatelessWidget {

  var rating = [
    {
      "label" : "User Satisfaction",
      "rating" : "1.5"
    },
    {
      "label" : "Quality water supply",
      "rating" : "1.5"
    },
    {
      "label" : "Sufficient water supply",
      "rating" : "1.5"
    },
  ];

  final Function() onMonthSelection;
  DashboardCard(this.onMonthSelection);
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Card(
          margin: EdgeInsets.only(bottom: 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0.0),
          ),
          child: Column(
              mainAxisSize: MainAxisSize.min,
              children : [ Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    LabelText(i18.dashboard.DASHBOARD),
                    InkWell(
                      onTap: onMonthSelection,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 5, bottom: 12),
                        child: Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children : [
                              Consumer<DashBoardProvider>(
                                builder: (_,dashBoardProvider, child) => Text(DateFormats.getMonthAndYear(dashBoardProvider.selectedMonth, context),
                                  style: Theme.of(context).textTheme.subtitle1?.apply(color: Theme.of(context).primaryColor),
                                ),
                              ),
                              Icon(Icons.arrow_drop_down)
                            ]),
                      ),
                    )
                  ]),
                Padding(
                  padding: constraints.maxWidth > 760 ? const EdgeInsets.all(20.0) : const EdgeInsets.all(8.0),
                  child: Consumer<DashBoardProvider>(
                    builder: (_,dashBoardProvider, child) =>Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GridView.count(
                            crossAxisCount: 3,
                            // childAspectRatio: constraints.maxWidth < 760 ? 1.2 : 3,
                            childAspectRatio: constraints.maxWidth > 760 ?  (1 / .3) : 1.0,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            children: List.generate(rating.length, (index) =>
                                GridTile(
                                  child: Container(
                                      decoration: BoxDecoration(
                                        border: index == 0 ? null : Border(
                                            left:
                                            BorderSide(width: 1.0, color: Colors.grey)),
                                        color: Colors.white,
                                      ),
                                      padding: EdgeInsets.all(12),
                                      child: new Center(
                                        child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  new Text(
                                                    rating[index]["rating"].toString(),
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.w700,
                                                    ),
                                                  ),
                                                  Icon(Icons.star,
                                                      color:
                                                      Theme.of(context).primaryColor),
                                                ],
                                              ),
                                              Expanded(
                                                child: Text(
                                                  '${ApplicationLocalizations.of(context).translate(rating[index]["label"].toString())}',
                                                  textAlign: TextAlign.center,
                                                ),
                                              )
                                            ]),
                                      )),
                                )
                            ).toList(),
                          ),
                          SizedBox(height: 10),
                          Text("230 ${ApplicationLocalizations.of(context).translate(i18.dashboard.USER_GAVE_FEEDBACK)}",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                fontSize: 12,
                                color: Color.fromRGBO(11, 12, 12, 1),
                                fontWeight: FontWeight.w400
                            ),
                          ),
                          SizedBox(height: 10)
                        ]),
                  ),
                )
              ]
          ));
    });
  }
}
