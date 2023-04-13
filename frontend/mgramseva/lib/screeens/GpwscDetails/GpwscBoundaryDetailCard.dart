import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mgramseva/utils/Constants/I18KeyConstants.dart';

import '../../utils/Locilization/application_localizations.dart';
import '../../widgets/LabelText.dart';
import 'GpwscCard.dart';

class GpwscBoundaryDetailCard extends StatelessWidget {
  const GpwscBoundaryDetailCard({
    Key? key
  }) : super(key: key);
  _getLabeltext(label, value, context) {
    return (Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
              padding: EdgeInsets.only(top: 16, bottom: 16),
              width: MediaQuery.of(context).size.width / 3,
              child: Text(
                ApplicationLocalizations.of(context).translate(label),
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              )),
          new Flexible(
              child: Container(
                  padding: EdgeInsets.only(top: 16, bottom: 16, left: 8),
                  child: Text(
                      ApplicationLocalizations.of(context).translate(value),
                      maxLines: 3,
                      softWrap: true,
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w400))))
        ]));
  }
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return GpwscCard(
            children: [
              LabelText(i18.dashboard.GPWSC_DETAILS),
              Padding(
                padding: constraints.maxWidth > 760 ? const EdgeInsets.all(20.0) : const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    _getLabeltext("${ApplicationLocalizations.of(context).translate(i18.common.VILLAGE_CODE)}", "VL-7487478", context),
                    _getLabeltext("${ApplicationLocalizations.of(context).translate(i18.common.VILLAGE_NAME)}", "Lodhipur", context),
                    _getLabeltext("${ApplicationLocalizations.of(context).translate(i18.common.SECTION_CODE)}", "Agampur-S560", context),
                    _getLabeltext("${ApplicationLocalizations.of(context).translate(i18.common.SUB_DIVISION_CODE)}", "DIV1038SD10131", context),
                    _getLabeltext("${ApplicationLocalizations.of(context).translate(i18.common.PROJECT_SCHEME_CODE)}", "7374", context)
                  ],
                ),
              )
            ],
      );
    });
  }
}