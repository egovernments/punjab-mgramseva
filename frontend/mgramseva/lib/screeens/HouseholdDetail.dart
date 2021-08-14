import 'package:flutter/material.dart';
import 'package:mgramseva/components/HouseConnectionandBill/GenerateNewBill.dart';
import 'package:mgramseva/components/HouseConnectionandBill/HouseConnectionDetailCard.dart';
import 'package:mgramseva/components/HouseConnectionandBill/NewConsumerBill.dart';
import 'package:mgramseva/model/bill/billing.dart';
import 'package:mgramseva/model/connection/water_connection.dart';
import 'package:mgramseva/model/demand/demand_list.dart';
import 'package:mgramseva/providers/household_details_provider.dart';
import 'package:mgramseva/utils/loaders.dart';
import 'package:mgramseva/utils/notifyers.dart';
import 'package:mgramseva/widgets/BaseAppBar.dart';
import 'package:mgramseva/widgets/DrawerWrapper.dart';
import 'package:mgramseva/widgets/FormWrapper.dart';
import 'package:mgramseva/widgets/HomeBack.dart';
import 'package:mgramseva/widgets/SideBar.dart';
import 'package:provider/provider.dart';

class HouseholdDetail extends StatefulWidget {
  final String? id;
  final WaterConnection? waterconnection;

  HouseholdDetail({Key? key, this.id, this.waterconnection});
  @override
  State<StatefulWidget> createState() {
    return _HouseholdDetailState();
  }
}

class _HouseholdDetailState extends State<HouseholdDetail> {
  void initState() {
    WidgetsBinding.instance?.addPostFrameCallback((_) => afterViewBuild());
    super.initState();
  }

  afterViewBuild() {
    Provider.of<HouseHoldProvider>(context, listen: false)
      ..FetchBill(widget.waterconnection);
  }

  buildDemandView(BillList data) {
    print(data.bill);
    return Column(
      children: [GenerateNewBill(data), NewConsumerBill(data)],
    );
  }

  @override
  Widget build(BuildContext context) {
    var houseHoldProvider =
        Provider.of<HouseHoldProvider>(context, listen: false);
    return Scaffold(
        appBar: BaseAppBar(
          Text('mGramSeva'),
          AppBar(),
          <Widget>[Icon(Icons.more_vert)],
        ),
        drawer: DrawerWrapper(
          Drawer(child: SideBar()),
        ),
        body: SingleChildScrollView(
            child: FormWrapper(Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
              HomeBack(),
              HouseConnectionDetailCard(
                  waterconnection: widget.waterconnection),
              StreamBuilder(
                  stream: houseHoldProvider.streamController.stream,
                  builder: (context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      return buildDemandView(snapshot.data);
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
                  }),
            ]))));
  }
}
