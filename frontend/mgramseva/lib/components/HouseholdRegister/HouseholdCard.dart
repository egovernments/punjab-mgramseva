import 'package:flutter/material.dart';
import 'package:mgramseva/providers/dashboard_provider.dart';
import 'package:mgramseva/utils/date_formats.dart';
import 'package:mgramseva/widgets/LabelText.dart';
import 'package:mgramseva/widgets/SubLabel.dart';
import 'package:mgramseva/utils/Constants/I18KeyConstants.dart';
import 'package:provider/provider.dart';

class HouseholdCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Card(
          margin: EdgeInsets.only(bottom: 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0.0),
          ),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                LabelText('Household Register'),
                SubLabelText('As of date ${DateFormats.getFilteredDate(DateTime.now().toLocal().toString(), dateFormat: "dd/MM/yyyy")}')
              ]));
    });
  }
}
