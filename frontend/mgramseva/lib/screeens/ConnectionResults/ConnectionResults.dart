import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mgramseva/model/connection/water_connections.dart';
import 'package:mgramseva/providers/search_connection_provider.dart';
import 'package:mgramseva/screeens/ConnectionResults/ConnectionDetailsCard.dart';
import 'package:mgramseva/widgets/customAppbar.dart';
import 'package:mgramseva/utils/loaders.dart';
import 'package:mgramseva/utils/notifyers.dart';
import 'package:mgramseva/widgets/DrawerWrapper.dart';
import 'package:mgramseva/widgets/FormWrapper.dart';
import 'package:mgramseva/widgets/HomeBack.dart';
import 'package:mgramseva/widgets/SideBar.dart';
import 'package:provider/provider.dart';

class SearchConsumerResult extends StatefulWidget {
  static const String routeName = 'search/consumer';
  final Map arguments;
  SearchConsumerResult(this.arguments);
  @override
  State<StatefulWidget> createState() {
    return _SearchConsumerResultState();
  }
}

class _SearchConsumerResultState extends State<SearchConsumerResult> {
  @override
  void initState() {
    WidgetsBinding.instance?.addPostFrameCallback((_) => afterViewBuild());
    super.initState();
  }

  afterViewBuild() {
    Provider.of<SearchConnectionProvider>(context, listen: false)..getresults();
  }

  buildconsumerView(WaterConnections waterConnections) {
    return SearchConnectionDetailCard(waterConnections, widget.arguments, isNameSearch: widget.arguments['isNameSearch'],);
  }

  @override
  Widget build(BuildContext context) {
    var waterconnectionsProvider =
        Provider.of<SearchConnectionProvider>(context, listen: false);

    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: CustomAppBar(),
        drawer: DrawerWrapper(
          Drawer(child: SideBar()),
        ),
        body: FormWrapper(Container(
            child: Column(children: [
          HomeBack(),
          Expanded(
              child: StreamBuilder(
                  stream: waterconnectionsProvider.streamController.stream,
                  builder: (context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      return buildconsumerView(snapshot.data);
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
                  }))
        ]))));
  }
}
