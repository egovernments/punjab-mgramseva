import 'package:flutter/material.dart';
import 'package:mgramseva/utils/Constants/I18KeyConstants.dart';
import 'package:mgramseva/utils/Locilization/application_localizations.dart';
import 'package:mgramseva/utils/date_formats.dart';
import 'package:mgramseva/widgets/LabelText.dart';
import 'package:mgramseva/widgets/SubLabel.dart';

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
                LabelText(i18.householdRegister.HOUSEHOLD_REGISTER_LABEL),
                SubLabelText('${ApplicationLocalizations.of(context).translate(i18.householdRegister.AS_OF_DATE)} ${DateFormats.getFilteredDate(DateTime.now().toLocal().toString(), dateFormat: "dd/MM/yyyy")}')
              ]));
    });
  }
}
