

import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:flutter/material.dart';
import 'package:mgramseva/components/Dashboard/BillsTable.dart';
import 'package:mgramseva/model/connection/water_connection.dart';
import 'package:mgramseva/model/dashboard/expense_dashboard.dart';
import 'package:mgramseva/model/expensesDetails/expenses_details.dart';
import 'package:mgramseva/providers/dashboard_provider.dart';
import 'package:mgramseva/providers/household_register_provider.dart';
import 'package:mgramseva/screeens/HouseholdRegister/HouseholdList.dart';
import 'package:mgramseva/screeens/dashboard/individual_tab.dart';
import 'package:mgramseva/utils/Constants/I18KeyConstants.dart';
import 'package:mgramseva/utils/Locilization/application_localizations.dart';
import 'package:mgramseva/utils/common_widgets.dart';
import 'package:mgramseva/utils/loaders.dart';
import 'package:mgramseva/utils/models.dart';
import 'package:mgramseva/utils/notifyers.dart';
import 'package:mgramseva/widgets/ListLabelText.dart';
import 'package:mgramseva/widgets/TextFieldBuilder.dart';
import 'package:provider/provider.dart';

class HouseholdSearch extends StatefulWidget {

  @override
  _HouseholdSearchState createState() => _HouseholdSearchState();
}

class _HouseholdSearchState extends State<HouseholdSearch> with SingleTickerProviderStateMixin {

  @override
  void initState() {
    var householdRegisterProvider = Provider.of<HouseholdRegisterProvider>(context, listen: false)
      ..limit = 10
      ..offset = 1
      ..sortBy = null;
    WidgetsBinding.instance?.addPostFrameCallback((_) => afterViewBuild());
    super.initState();
  }

  afterViewBuild() {
    var householdRegisterProvider = Provider.of<HouseholdRegisterProvider>(context, listen: false);
    householdRegisterProvider.searchController.clear();
    householdRegisterProvider.fetchData();
    householdRegisterProvider.selectedTab = 'all';
      householdRegisterProvider
        ..waterConnectionsDetails?.waterConnection = <WaterConnection>[]
        ..waterConnectionsDetails?.totalCount = null;

  }

  @override
  Widget build(BuildContext context) {
    var householdRegisterProvider = Provider.of<HouseholdRegisterProvider>(context, listen: false);
    return  Column(
        children: [
          BuildTextField(
            '',
            householdRegisterProvider.searchController,
            inputBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25.0),
            ),
            prefixIcon: Padding(
                padding: EdgeInsets.all(10),
                child: Icon(Icons.search_sharp)),
            isFilled: true,
            placeHolder: i18.dashboard.SEARCH_NAME_CONNECTION,
            onChange: (val) => householdRegisterProvider.onSearch(val, context),
          ),
          Expanded(
            child: StreamBuilder(
                stream: householdRegisterProvider.initialStreamController.stream,
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    if(snapshot.data is String){
                      return CommonWidgets.buildEmptyMessage(snapshot.data, context);
                    }
                    return _buildTabView();
                  } else if (snapshot.hasError) {
                    return Notifiers.networkErrorPage(context, () => {});
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
          )
        ]
    );
  }

  Widget _buildTabView() {
    var householdRegisterProvider = Provider.of<HouseholdRegisterProvider>(context, listen: false);
    return Consumer<HouseholdRegisterProvider>(
        builder: (_, householdRegisterProvider, child)
        {
          var tabList = householdRegisterProvider.getCollectionsTabList(context);

          return DefaultTabController(
            length: tabList.length,
            // initialIndex: ,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: ButtonsTabBar(
                    // controller: _tabController,
                      backgroundColor: Colors.white,
                      unselectedBackgroundColor: Color.fromRGBO(244, 119, 56, 0.12),
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: 10, vertical: 3),
                      buttonMargin: EdgeInsets.symmetric(horizontal: 5),
                      labelStyle: TextStyle(color: Theme
                          .of(context)
                          .primaryColor, fontWeight: FontWeight.bold),
                      unselectedLabelStyle: TextStyle(
                          color: Theme
                              .of(context)
                              .primaryColor, fontWeight: FontWeight.w400),
                      radius: 25,
                      tabs: tabList
                  ),
                ),
                //SizedBox(height: 10,),
                TextButton.icon(
                  onPressed: () => {},
                  icon: Icon(Icons.download_sharp),
                  label: Text('Download (${householdRegisterProvider.getCollectionsCount(0)} records)',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
                Expanded(
                  child: Consumer<HouseholdRegisterProvider>(
                    builder: (_, householdRegisterProvider, child) =>
                        TabBarView(
                            physics: NeverScrollableScrollPhysics(),
                            // controller: _tabController,
                            children: List.generate(tabList.length, (index) =>
                                HouseholdList(index: index))
                        ),
                  ),
                ),
              ],
            ),
          );
        });
  }

}
