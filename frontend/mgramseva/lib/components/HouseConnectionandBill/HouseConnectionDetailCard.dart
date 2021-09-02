import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mgramseva/model/connection/water_connection.dart';
import 'package:mgramseva/utils/Constants/I18KeyConstants.dart';
import 'package:mgramseva/utils/Locilization/application_localizations.dart';

class HouseConnectionDetailCard extends StatelessWidget {
  final WaterConnection? waterconnection;
  HouseConnectionDetailCard({this.waterconnection});
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
                  padding: EdgeInsets.only(top: 16, bottom: 16),
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
    return Card(
        child: Padding(
            padding: EdgeInsets.all(15),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 16, bottom: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          width: MediaQuery.of(context).size.width / 3.3,
                          child: Text(
                            "${ApplicationLocalizations.of(context).translate(
                              i18.consumer.CONSUMER_CONNECTION_ID,
                            )} ",
                            style: TextStyle(
                                fontSize: 17, fontWeight: FontWeight.w700),
                          )),
                      Container(
                          alignment: Alignment.topCenter,
                          child: Text(
                            waterconnection!.connectionNo!,
                            style: TextStyle(
                                fontSize: 17, fontWeight: FontWeight.w700),
                          )),
                    ],
                  ),
                ),
                _getLabeltext(i18.searchWaterConnection.RESULTS_CONSUMER_NAME,
                    waterconnection!.connectionHolders!.first.name, context),
                _getLabeltext(
                    i18.consumer.FATHER_SPOUSE_NAME,
                    waterconnection!
                        .connectionHolders!.first.fatherOrHusbandName,
                    context),
                _getLabeltext(
                    i18.searchWaterConnection.RESULTS_PHONE_NUM,
                    waterconnection!.connectionHolders!.first.mobileNumber,
                    context),
                _getLabeltext(i18.searchWaterConnection.OLD_CONNECTION_ID,
                    waterconnection!.oldConnectionNo, context),
                _getLabeltext(
                    i18.searchWaterConnection.RESULTS_ADDRESS,
                    (waterconnection!.additionalDetails!.doorNo != null
                            ? waterconnection!.additionalDetails!.doorNo!
                            : "") +
                        (waterconnection!.additionalDetails!.street != null
                            ? waterconnection!.additionalDetails!.street!
                            : "") +
                        waterconnection!.additionalDetails!.locality!,
                    context),
                _getLabeltext(i18.searchWaterConnection.PROPERTY_TYPE,
                    waterconnection!.additionalDetails!.propertyType, context),
                _getLabeltext(i18.consumer.SERVICE_TYPE,
                    waterconnection!.connectionType, context),
                waterconnection!.meterId == null
                    ? Text("")
                    : _getLabeltext(
                        i18.searchWaterConnection.METER_NUMBER,
                        waterconnection!.meterId,
                        context,
                      ),
              ],
            )));
  }
}
