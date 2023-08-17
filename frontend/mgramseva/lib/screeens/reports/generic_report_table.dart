import 'package:flutter/material.dart';
import 'package:mgramseva/components/dashboard/bills_table.dart';
import 'package:provider/provider.dart';

import '../../providers/reports_provider.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/drawer_wrapper.dart';
import '../../widgets/home_back.dart';
import '../../widgets/side_bar.dart';

class GenericReportTable extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      drawer: DrawerWrapper(
        Drawer(child: SideBar()),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              HomeBack(),
              SingleChildScrollView(
                child: Container(
                  width: constraints.maxWidth,
                  height: constraints.maxHeight-50,
                  child: Consumer<ReportsProvider>(

                    builder: (context, reportsProvider,child) {
                      var width =
                      constraints.maxWidth < 760 ? 115.0 : (constraints.maxWidth / 6);
                      return BillsTable(height: (52.0 * reportsProvider.getCollectionsData(reportsProvider.billreports!).length + 1),
                          scrollPhysics: NeverScrollableScrollPhysics(),headerList: reportsProvider.collectionHeaderList, tableData: reportsProvider.getCollectionsData(reportsProvider.billreports!), leftColumnWidth: width,
                        rightColumnWidth:
                        width * (reportsProvider.collectionHeaderList.length - 1),);
                    }
                  ),
                ),
              ),
            ],
          );
        }
      ),
    );
  }

}