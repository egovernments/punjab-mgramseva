import 'package:flutter/material.dart';
import 'package:mgramseva/providers/dashboard_provider.dart';
import 'package:mgramseva/utils/date_formats.dart';
import 'package:mgramseva/widgets/LabelText.dart';
import 'package:mgramseva/widgets/SubLabel.dart';
import 'package:mgramseva/utils/Constants/I18KeyConstants.dart';
import 'package:provider/provider.dart';

class DashboardCard extends StatelessWidget {
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
          child: Row(
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
      ]));
    });
  }
}
