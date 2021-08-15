import 'package:flutter/material.dart';
import 'package:mgramseva/constants/houseconnectiondetails.dart';
import 'package:mgramseva/model/connection/water_connection.dart';
import 'package:mgramseva/utils/Constants/I18KeyConstants.dart';
import 'package:mgramseva/utils/Locilization/application_localizations.dart';

class HouseConnectionDetailCard extends StatelessWidget {
  final WaterConnection? waterconnection;
  HouseConnectionDetailCard({this.waterconnection});
  _getLabeltext(label, value, context) {
    return (Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
            padding: EdgeInsets.only(top: 16, bottom: 16),
            width: MediaQuery.of(context).size.width / 3,
            child: Text(
              ApplicationLocalizations.of(context).translate(label),
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            )),
        Container(
            alignment: Alignment.topCenter,
            padding: EdgeInsets.only(top: 16, bottom: 16),
            child: Text(value,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400)))
      ],
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        child: Padding(
            padding: EdgeInsets.all(15),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        padding: EdgeInsets.only(top: 16, bottom: 16),
                        width: MediaQuery.of(context).size.width / 3,
                        child: Text(
                          "Connection ID : ",
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.w700),
                        )),
                    Container(
                        alignment: Alignment.topCenter,
                        padding: EdgeInsets.only(top: 16, bottom: 16),
                        child: Text(
                          waterconnection!.connectionNo!,
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.w700),
                        )),
                  ],
                ),
                _getLabeltext(i18.searchWaterConnection.CONSUMER_NAME,
                    waterconnection!.connectionHolders!.first.name, context),
                _getLabeltext(
                    "Father's Name",
                    waterconnection!
                        .connectionHolders!.first.fatherOrHusbandName,
                    context),
                _getLabeltext(
                    i18.searchWaterConnection.OWNER_MOB_NUM,
                    waterconnection!.connectionHolders!.first.mobileNumber,
                    context),
                _getLabeltext(i18.searchWaterConnection.OLD_CONNECTION_ID,
                    waterconnection!.oldConnectionNo, context),
                _getLabeltext(i18.searchWaterConnection.HOUSE_ADDRESS,
                    waterconnection!.additionalDetails!.locality, context),
                // _getLabeltext("Property Type",
                //   waterconnection!.additionalDetails!.propertyType, context),
                _getLabeltext(
                    "Service Type", waterconnection!.connectionType, context)
              ],
            )));
  }
}
