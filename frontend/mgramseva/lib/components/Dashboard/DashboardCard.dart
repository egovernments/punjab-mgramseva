import 'package:flutter/material.dart';
import 'package:mgramseva/utils/date_formats.dart';
import 'package:mgramseva/widgets/LabelText.dart';
import 'package:mgramseva/widgets/SubLabel.dart';
import 'package:mgramseva/utils/Constants/I18KeyConstants.dart';

class DashboardCard extends StatelessWidget {
  final List<Map<String, Object>> data;
  DashboardCard(this.data);
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Card(
        margin: EdgeInsets.only(bottom: 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0.0),
          ),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
        LabelText(i18.dashboard.DASHBOARD),
        Padding(
          padding: const EdgeInsets.only(right: 5, bottom: 12),
          child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children : [
                Text(DateFormats.getMonthAndYear(DateTime.now()),
                style: Theme.of(context).textTheme.subtitle1?.apply(color: Theme.of(context).primaryColor),
                ),
                Icon(Icons.arrow_drop_down)
                ]),
        )
      ]));
    });
  }
}
