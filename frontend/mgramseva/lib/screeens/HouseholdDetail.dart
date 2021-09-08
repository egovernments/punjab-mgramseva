import 'package:flutter/material.dart';
import 'package:mgramseva/components/HouseConnectionandBill/ConsumerBillPayments.dart';
import 'package:mgramseva/components/HouseConnectionandBill/GenerateNewBill.dart';
import 'package:mgramseva/components/HouseConnectionandBill/HouseConnectionDetailCard.dart';
import 'package:mgramseva/components/HouseConnectionandBill/NewConsumerBill.dart';
import 'package:mgramseva/model/bill/billing.dart';
import 'package:mgramseva/model/connection/water_connection.dart';
import 'package:mgramseva/providers/household_details_provider.dart';
import 'package:mgramseva/routers/Routers.dart';
import 'package:mgramseva/screeens/customAppbar.dart';
import 'package:mgramseva/utils/Constants/I18KeyConstants.dart';
import 'package:mgramseva/utils/loaders.dart';
import 'package:mgramseva/utils/notifyers.dart';
import 'package:mgramseva/widgets/DrawerWrapper.dart';
import 'package:mgramseva/widgets/FormWrapper.dart';
import 'package:mgramseva/widgets/HomeBack.dart';
import 'package:mgramseva/widgets/ShortButton.dart';
import 'package:mgramseva/widgets/SideBar.dart';
import 'package:mgramseva/widgets/footer.dart';
import 'package:provider/provider.dart';

class HouseholdDetail extends StatefulWidget {
  final String? id;
  final String? mode;
  final WaterConnection? waterconnection;

  HouseholdDetail({Key? key, this.id, this.mode, this.waterconnection});
  @override
  State<StatefulWidget> createState() {
    return _HouseholdDetailState();
  }
}

class _HouseholdDetailState extends State<HouseholdDetail> {
  void initState() {
    print(widget.mode);
    WidgetsBinding.instance?.addPostFrameCallback((_) => afterViewBuild());
    super.initState();
  }

  afterViewBuild() {
    Provider.of<HouseHoldProvider>(context, listen: false)
      ..fetchDemand(widget.waterconnection, widget.id);
  }

  buildDemandView(BillList data) {
    var houseHoldProvider =
        Provider.of<HouseHoldProvider>(context, listen: false);
    return Column(
      children: [
        data.bill!.isEmpty
            ? (houseHoldProvider.waterConnection!.connectionType == 'Metered' &&
                    widget.mode == 'collect'
                ? Align(
                    alignment: Alignment.centerRight,
                    child: ShortButton(
                        i18.generateBillDetails.GENERATE_NEW_BTN_LABEL,
                        () => {
                              Navigator.pushNamed(context, Routes.BILL_GENERATE,
                                  arguments: houseHoldProvider.waterConnection)
                            }))
                : Text(""))
            : houseHoldProvider.waterConnection!.connectionType == 'Metered' &&
                    widget.mode == 'collect'
                ? GenerateNewBill(houseHoldProvider.waterConnection)
                : Text(""),
        data.bill!.isEmpty ||
                (houseHoldProvider.waterConnection?.connectionType ==
                        'Metered' &&
                    houseHoldProvider.isfirstdemand == false)
            ? Text("")
            : NewConsumerBill(
                data, widget.mode, houseHoldProvider.waterConnection),
        ConsumerBillPayments(houseHoldProvider.waterConnection)
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    var houseHoldProvider =
        Provider.of<HouseHoldProvider>(context, listen: false);
    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: CustomAppBar(),
        drawer: DrawerWrapper(
          Drawer(child: SideBar()),
        ),
        body: SingleChildScrollView(
            child: FormWrapper(Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
              HomeBack(),
              StreamBuilder(
                  stream: houseHoldProvider.streamController.stream,
                  builder: (context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      print(snapshot.hasData);
                      return Column(
                        children: [
                          HouseConnectionDetailCard(
                              waterconnection:
                                  houseHoldProvider.waterConnection),
                          buildDemandView(snapshot.data)
                        ],
                      );
                    } else if (snapshot.hasError) {
                      return Notifiers.networkErrorPage(
                          context,
                          () => houseHoldProvider
                              .fetchDemand(widget.waterconnection));
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
                  }),
              Footer()
            ]))));
  }
}
