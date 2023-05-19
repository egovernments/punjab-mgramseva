import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_focus_watcher/flutter_focus_watcher.dart';
import 'package:mgramseva/screeens/GpwscDetails/GpwscRateCard.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';

import '../../providers/dashboard_provider.dart';
import '../../providers/ifix_hierarchy_provider.dart';
import '../../utils/global_variables.dart';
import '../../widgets/DrawerWrapper.dart';
import '../../widgets/HomeBack.dart';
import '../../widgets/SideBar.dart';
import '../../widgets/customAppbar.dart';
import '../../widgets/custom_overlay/show_overlay.dart';
import '../../widgets/footer.dart';
import 'GpwscBoundaryDetailCard.dart';

class GpwscDetails extends StatefulWidget {
  const GpwscDetails({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _GpwscDetails();
  }
}

class _GpwscDetails extends State<GpwscDetails>
    with SingleTickerProviderStateMixin {
  GlobalKey key = GlobalKey();
  ScreenshotController screenshotController = ScreenshotController();
  ScrollController scrollController = ScrollController();
  var takeScreenShot = false;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    var departmentProvider = Provider.of<IfixHierarchyProvider>(navigatorKey.currentContext!, listen: false);
    departmentProvider.getDepartments();
    departmentProvider.getBillingSlabs();
    WidgetsBinding.instance.addPostFrameCallback((_) => afterViewBuild());
  }

  afterViewBuild() {
    var dashBoardProvider =
        Provider.of<DashBoardProvider>(context, listen: false);
    dashBoardProvider.fetchUserFeedbackDetails(context);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          if (CustomOVerlay.removeOverLay()) return false;
          return true;
        },
        child: GestureDetector(
          onTap: () => CustomOVerlay.removeOverLay(),
          child: FocusWatcher(
              child: Scaffold(
            appBar: CustomAppBar(),
            drawer: DrawerWrapper(
              Drawer(child: SideBar()),
            ),
            backgroundColor: Color.fromRGBO(238, 238, 238, 1),
            body: LayoutBuilder(
              builder: (context, constraints) => Container(
                alignment: Alignment.center,
                margin: constraints.maxWidth < 760
                    ? null
                    : EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width / 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        HomeBack(callback: onClickOfBackButton),
                      ],
                    ),
                    Container(
                      key: key,
                      color: Color.fromRGBO(238, 238, 238, 1),
                      padding: EdgeInsets.only(left: 8, right: 8),
                      height:  constraints.maxHeight-50,
                      child: SingleChildScrollView(
                        controller: scrollController,
                        child: Column(
                          children: [
                            GpwscBoundaryDetailCard(),
                            SizedBox(height: 10,),
                            GpwscRateCard(rateType: "Non_Metered"),
                            SizedBox(height: 10,),
                            GpwscRateCard(rateType: "Metered"),
                            Footer()
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )),
        ));
  }

  void onClickOfBackButton() {
    CustomOVerlay.removeOverLay();
    Navigator.pop(context);
  }
}
