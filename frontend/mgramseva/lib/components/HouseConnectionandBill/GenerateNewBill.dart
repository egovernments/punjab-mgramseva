import 'package:flutter/material.dart';
import 'package:mgramseva/model/connection/water_connection.dart';
import 'package:mgramseva/model/demand/demand_list.dart';
import 'package:mgramseva/providers/demand_details_provider.dart';
import 'package:mgramseva/routers/Routers.dart';
import 'package:mgramseva/utils/Constants/I18KeyConstants.dart';
import 'package:mgramseva/utils/Locilization/application_localizations.dart';
import 'package:mgramseva/utils/date_formats.dart';
import 'package:mgramseva/utils/loaders.dart';
import 'package:mgramseva/utils/notifyers.dart';
import 'package:mgramseva/widgets/Info.dart';
import 'package:mgramseva/widgets/ListLabelText.dart';
import 'package:mgramseva/widgets/ShortButton.dart';
import 'package:provider/provider.dart';

class GenerateNewBill extends StatefulWidget {
  final WaterConnection? waterconnection;
  GenerateNewBill(this.waterconnection);
  @override
  State<StatefulWidget> createState() {
    return _GenerateNewBillState();
  }
}

class _GenerateNewBillState extends State<GenerateNewBill> {
  @override
  void initState() {
    WidgetsBinding.instance?.addPostFrameCallback((_) => afterViewBuild());
    super.initState();
  }

  afterViewBuild() {
    Provider.of<DemadDetailProvider>(context, listen: false)
      ..fetchDemandDetails(widget.waterconnection);
  }

  _getLabeltext(label, value, context) {
    return Container(
        padding: EdgeInsets.only(top: 16, bottom: 16),
        child: (Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                padding: EdgeInsets.only(right: 16),
                width: MediaQuery.of(context).size.width / 3,
                child: Text(
                  ApplicationLocalizations.of(context).translate(label),
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                )),
            Text(ApplicationLocalizations.of(context).translate(value),
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400))
          ],
        )));
  }

  buidDemandview(DemandList demandList) {
    int? num = demandList.demands?.first.auditDetails?.createdTime;
    return Column(
      children: [
        Container(
            padding: EdgeInsets.only(top: 24, bottom: 8.0),
            child: ListLabelText(i18.generateBillDetails.GENERATE_BILL_LABEL)),
        Card(
            child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _getLabeltext(
                            i18.generateBillDetails.LAST_BILL_GENERATION_DATE,
                            DateFormats.timeStampToDate(
                                    demandList.demands?.first.auditDetails
                                        ?.createdTime,
                                    format: "dd-MM-yyyy")
                                .toString(),
                            context),
                        Padding(
                            padding: EdgeInsets.all(16),
                            child: Text(
                              DateTime.now()
                                          .difference(DateTime
                                              .fromMillisecondsSinceEpoch(num!))
                                          .inDays ==
                                      0
                                  ? ApplicationLocalizations.of(context)
                                      .translate(i18.generateBillDetails.TODAY)
                                  : DateTime.now()
                                          .difference(DateTime
                                              .fromMillisecondsSinceEpoch(num))
                                          .inDays
                                          .toString() +
                                      " " +
                                      ApplicationLocalizations.of(context)
                                          .translate(
                                              i18.generateBillDetails.DAYS_AGO),
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor),
                            ))
                      ],
                    ),
                    _getLabeltext(
                        i18.generateBillDetails.PREVIOUS_METER_READING,
                        demandList.demands?.first.meterReadings == null
                            ? widget.waterconnection!.additionalDetails!
                                        .meterReading ==
                                    null
                                ? "NA".toString()
                                : widget.waterconnection?.additionalDetails!
                                    .meterReading
                                    .toString()
                            : demandList.demands?.first.meterReadings!.first
                                .currentReading
                                .toString(),
                        context),
                    _getLabeltext(
                        i18.generateBillDetails.PENDING_AMOUNT,
                        ('₹' +
                            demandList.demands!
                                .map((element) =>
                                    element.demandDetails!.first.taxAmount)
                                .toList()
                                .reduce((a, b) => a! + b!)
                                .toString()),
                        context),
                    ShortButton(
                        i18.generateBillDetails.GENERATE_NEW_BTN_LABEL,
                        () => {
                              Navigator.pushNamed(context, Routes.BILL_GENERATE,
                                  arguments: widget.waterconnection)
                            }),
                    SizedBox(
                      height: 10,
                    ),
                    demandList.demands?.length == 1
                        ? Info(ApplicationLocalizations.of(context)
                            .translate(i18.generateBillDetails.INFO_TEXT))
                        : Text("")
                  ],
                )))
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    var billpaymentsProvider =
        Provider.of<DemadDetailProvider>(context, listen: false);
    return StreamBuilder(
        stream: billpaymentsProvider.streamController.stream,
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return buidDemandview(snapshot.data);
          } else if (snapshot.hasError) {
            return Notifiers.networkErrorPage(context, () {});
          } else {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return Loaders.CircularLoader();
              case ConnectionState.active:
                return Loaders.CircularLoader();
              default:
                return Container();
            }
          }
        });
  }
}
