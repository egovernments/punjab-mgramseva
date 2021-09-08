import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:mgramseva/model/connection/water_connections.dart';
import 'package:mgramseva/providers/common_provider.dart';
import 'package:mgramseva/routers/Routers.dart';
import 'package:mgramseva/utils/Constants/I18KeyConstants.dart';
import 'package:mgramseva/utils/Locilization/application_localizations.dart';
import 'package:mgramseva/widgets/ShortButton.dart';
import 'package:provider/provider.dart';

class SearchConnectionDetailCard extends StatelessWidget {
  final WaterConnections waterconnections;
  final Map arguments;
  SearchConnectionDetailCard(this.waterconnections, this.arguments);
  _getDetailtext(label, value, context, constraints) {
    return constraints.maxWidth > 720
        ? (Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                  width: MediaQuery.of(context).size.width / 2.5,
                  padding: EdgeInsets.only(top: 16, bottom: 4),
                  child: Text(
                    ApplicationLocalizations.of(context).translate(label),
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  )),
              Container(
                  width: MediaQuery.of(context).size.width / 3,
                  padding: EdgeInsets.only(top: 8, bottom: 3),
                  child: Text(
                      value == null
                          ? ApplicationLocalizations.of(context).translate("NA")
                          : ApplicationLocalizations.of(context)
                              .translate(value),
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w400)))
            ],
          ))
        : Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  padding: EdgeInsets.only(top: 16, bottom: 4),
                  child: Text(
                    ApplicationLocalizations.of(context).translate(label),
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  )),
              Text(
                  value == null
                      ? ApplicationLocalizations.of(context).translate("NA")
                      : ApplicationLocalizations.of(context).translate(value),
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400))
            ],
          );
  }

  @override
  Widget build(BuildContext context) {
    var commonProvider = Provider.of<CommonProvider>(context,
        listen: false);
    return LayoutBuilder(builder: (context, constraints) {
      return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
            padding: EdgeInsets.only(left: 15),
            child: Text(
              waterconnections.waterConnection!.length.toString() != null
                  ? waterconnections.waterConnection!.length.toString() +
                      " " +
                      '${waterconnections.waterConnection!.length.toString() == '1' ? ApplicationLocalizations.of(context).translate(i18.searchWaterConnection.CONNECTION_FOUND_ONE) : ApplicationLocalizations.of(context).translate(i18.searchWaterConnection.CONNECTION_FOUND)}'
                  : "0" +
                      ApplicationLocalizations.of(context).translate(
                          i18.searchWaterConnection.CONNECTION_FOUND),
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700),
              textAlign: TextAlign.left,
            )),
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: RichText(
              textAlign: TextAlign.left,
              text: TextSpan(
                  style: TextStyle(
                    fontSize: 14,
                    color: Color.fromRGBO(80, 90, 95, 1),
                  ),
                  children: [
                    TextSpan(
                      text:
                          '${ApplicationLocalizations.of(context).translate(i18.searchWaterConnection.CONNECTION_CRITERIA)}',
                    ),
                    TextSpan(
                        text: " " +
                            '${arguments.keys.first.toString() == 'mobileNumber' ? ApplicationLocalizations.of(context).translate(i18.searchWaterConnection.RESULTS_PHONE_NUM) : arguments.keys.first.toString()}' +
                            " as " +
                            '${arguments.keys.first.toString() == 'mobileNumber' ? '+91 - ' + '${arguments.values.first.toString()}' : arguments.values.first.toString()}',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic,
                            height: 1.5))
                  ])),
        ),
        Expanded(
          child: ListView.builder(
              padding: const EdgeInsets.all(0),
              itemCount: waterconnections.waterConnection!.length,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                    child: Padding(
                        padding: EdgeInsets.all(8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _getDetailtext(
                                ApplicationLocalizations.of(context).translate(
                                    i18.searchWaterConnection
                                        .NEW_CONNECTION_ID),
                                waterconnections
                                    .waterConnection![index].connectionNo,
                                context,
                                constraints),
                            _getDetailtext(
                                ApplicationLocalizations.of(context).translate(
                                    i18.searchWaterConnection
                                        .OLD_CONNECTION_ID),
                                waterconnections.waterConnection![index]
                                            .oldConnectionNo !=
                                        ""
                                    ? waterconnections
                                        .waterConnection![index].oldConnectionNo
                                    : ApplicationLocalizations.of(context)
                                        .translate("NA"),
                                context,
                                constraints),
                            _getDetailtext(
                                ApplicationLocalizations.of(context).translate(
                                    i18.searchWaterConnection
                                        .RESULTS_CONSUMER_NAME),
                                waterconnections.waterConnection![index]
                                            .connectionHolders !=
                                        null
                                    ? waterconnections.waterConnection![index]
                                        .connectionHolders!.first.name
                                    : ApplicationLocalizations.of(context)
                                        .translate("NA"),
                                context,
                                constraints),
                            _getDetailtext(
                                ApplicationLocalizations.of(context).translate(
                                    i18.searchWaterConnection
                                        .RESULTS_PHONE_NUM),
                                waterconnections.waterConnection![index]
                                            .connectionHolders !=
                                        null
                                    ? '+91 - ' +
                                        '${waterconnections.waterConnection![index].connectionHolders!.first.mobileNumber}'
                                    : ApplicationLocalizations.of(context)
                                        .translate("NA"),
                                context,
                                constraints),
                            _getDetailtext(
                                ApplicationLocalizations.of(context).translate(
                                    i18.searchWaterConnection.RESULTS_ADDRESS),
                                (waterconnections.waterConnection![index]
                                                .additionalDetails!.doorNo !=
                                            null
                                        ? waterconnections
                                                    .waterConnection![index]
                                                    .additionalDetails!
                                                    .doorNo! !=
                                                ""
                                            ? waterconnections
                                                    .waterConnection![index]
                                                    .additionalDetails!
                                                    .doorNo! +
                                                ', '
                                            : ""
                                        : "") +
                                    (waterconnections.waterConnection![index]
                                                .additionalDetails!.street !=
                                            null
                                        ? waterconnections
                                                    .waterConnection![index]
                                                    .additionalDetails!
                                                    .street! !=
                                                ""
                                            ? waterconnections
                                                    .waterConnection![index]
                                                    .additionalDetails!
                                                    .street! +
                                                ', '
                                            : ""
                                        : "") +
                                    waterconnections.waterConnection![index]
                                        .additionalDetails!.locality!
                                    + ', ' + ApplicationLocalizations.of(context)
                                    .translate(commonProvider.userDetails!.selectedtenant!.code!),
                                context,
                                constraints),
                            SizedBox(
                              height: 20,
                            ),
                            ShortButton(
                                arguments['Mode'] == 'collect'
                                    ? i18.searchWaterConnection
                                        .HOUSE_DETAILS_VIEW
                                    : arguments['Mode'] == 'receipts'
                                        ? i18.searchWaterConnection
                                            .HOUSE_DETAILS_VIEW
                                        : i18.searchWaterConnection
                                            .HOUSE_DETAILS_EDIT,
                                () => Navigator.pushNamed(
                                        context,
                                        (arguments['Mode'] == 'collect'
                                            ? Routes.HOUSEHOLD_DETAILS
                                            : arguments['Mode'] == 'receipts'
                                                ? Routes.HOUSEHOLD_DETAILS
                                                : Routes.CONSUMER_UPDATE),
                                        arguments: {
                                          "waterconnections": waterconnections
                                              .waterConnection![index],
                                          "mode": arguments['Mode']
                                        })),
                            SizedBox(
                              height: 8,
                            ),
                          ],
                        )));
              }),
        )
      ]);
    });
  }
}
