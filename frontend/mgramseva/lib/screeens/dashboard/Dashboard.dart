import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mgramseva/components/Dashboard/BillsTable.dart';
import 'package:mgramseva/components/Dashboard/DashboardCard.dart';
import 'package:mgramseva/model/common/metric.dart';
import 'package:mgramseva/model/file/file_store.dart';
import 'package:mgramseva/providers/common_provider.dart';
import 'package:mgramseva/providers/dashboard_provider.dart';
import 'package:mgramseva/repository/core_repo.dart';
import 'package:mgramseva/utils/Constants/I18KeyConstants.dart';
import 'package:mgramseva/utils/Locilization/application_localizations.dart';
import 'package:mgramseva/utils/common_methods.dart';
import 'package:mgramseva/utils/date_formats.dart';
import 'package:mgramseva/utils/error_logging.dart';
import 'package:mgramseva/utils/global_variables.dart';
import 'package:mgramseva/utils/loaders.dart';
import 'package:mgramseva/utils/models.dart';
import 'package:mgramseva/widgets/DrawerWrapper.dart';
import 'package:mgramseva/widgets/GridCard.dart';
import 'package:mgramseva/widgets/BaseAppBar.dart';
import 'package:mgramseva/widgets/HomeBack.dart';
import 'package:mgramseva/widgets/LabelText.dart';
import 'package:mgramseva/widgets/ListLabelText.dart';
import 'package:mgramseva/widgets/SideBar.dart';
import 'package:mgramseva/widgets/grid_view.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';
import '../../widgets/customAppbar.dart';
import 'revenue_dashboard/revenue_dashboard.dart';
import 'search_expense.dart';
import 'package:mgramseva/widgets/pagination.dart';
import 'package:universal_html/html.dart' as html;
import 'package:flutter_share_me/flutter_share_me.dart';

class Dashboard extends StatefulWidget {
  final int initialTabIndex;
  final DatePeriod? selectedMonth;

  const Dashboard({Key? key, this.initialTabIndex = 0, this.selectedMonth}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _Dashboard();
  }
}

class _Dashboard extends State<Dashboard> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  OverlayState? overlayState;
  OverlayEntry? _overlayEntry;
  GlobalKey key = GlobalKey();
  ScreenshotController screenshotController = ScreenshotController();
  var takeScreenShot = false;

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    var dashBoardProvider =
    Provider.of<DashBoardProvider>(context, listen: false)
      ..dateList =
      CommonMethods.getPastMonthUntilFinancialYear()
      ..dateList.add(DatePeriod(DateTime.now(), DateTime.now(), DateType.LABEL, i18.dashboard.SUMMARY_REPORT))
      ..dateList.addAll(CommonMethods.getFinancialYearList());
    if(widget.selectedMonth == null) {
      dashBoardProvider.selectedMonth = dashBoardProvider.dateList.first;
    }else{
      dashBoardProvider.selectedMonth = widget.selectedMonth!;
    }


    dashBoardProvider.debounce = null;
    _tabController = new TabController(vsync: this, length: 2, initialIndex: widget.initialTabIndex);
    _tabController.addListener(() {
      FocusScope.of(context).unfocus();
      dashBoardProvider.debounce = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    var dashBoardProvider =
    Provider.of<DashBoardProvider>(context, listen: false);

    return WillPopScope(
      onWillPop: () async {
        if (dashBoardProvider.removeOverLay(_overlayEntry)) return false;
        return true;
      },
      child: GestureDetector(
        onTap: () => dashBoardProvider.removeOverLay(_overlayEntry),
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
              child: Stack(children: [
                SingleChildScrollView(
                  child: Consumer<DashBoardProvider>(
                    builder: (_, dashBoardProvider, child) => Container(
                        color: Color.fromRGBO(238, 238, 238, 1),
                        padding: EdgeInsets.only(left: 8, right: 8),
                        height: (dashBoardProvider.selectedMonth.dateType != DateType.MONTH)  ?  constraints.maxHeight : constraints.maxHeight - 50,
                        child: CustomScrollView(slivers: [
                          SliverList(
                              delegate: SliverChildListDelegate([
                                Row(
                                  mainAxisAlignment : MainAxisAlignment.spaceBetween,
                                  children: [
                                    HomeBack(),
                                    _buildShare
                                  ],
                                ),
                                Container(
                                    key: key,
                                    child: DashboardCard(onTapOfMonthPicker)),
                                Visibility(
                                  visible: !(dashBoardProvider.selectedMonth.dateType != DateType.MONTH),
                                  child: TabBar(
                                    labelColor: Theme.of(context).primaryColor,
                                    unselectedLabelColor: Colors.black,
                                    labelStyle: TextStyle(
                                        fontWeight: FontWeight.bold, fontSize: 16),
                                    indicatorSize: TabBarIndicatorSize.tab,
                                    controller: _tabController,
                                    indicator: BoxDecoration(
                                      color: Colors.white,
                                      border: Border(
                                        bottom: BorderSide(
                                            width: 2,
                                            color: Theme.of(context).primaryColor),
                                      ),
                                    ),
                                    tabs: [
                                      Tab(
                                        text: ApplicationLocalizations.of(context)
                                            .translate(i18.dashboard.COLLECTIONS),
                                      ),
                                      Tab(
                                        text: ApplicationLocalizations.of(context)
                                            .translate(i18.dashboard.EXPENDITURE),
                                      ),
                                    ],
                                  ),
                                ),
                                Visibility(
                                    visible: dashBoardProvider.selectedMonth.dateType == DateType.MONTH,
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 5),
                                      child: GridViewBuilder(gridList: a, physics: NeverScrollableScrollPhysics()),
                                    )
                                )
                              ])),
                          _buildViewBasedOnTheSelection(dashBoardProvider)
                        ])),
                  ),
                ),
                Align(
                    alignment: Alignment.bottomRight,
                    child: Consumer<DashBoardProvider>(
                        builder: (_, dashBoardProvider, child) {
                          var totalCount =
                              (dashBoardProvider.selectedDashboardType ==
                                  DashBoardType.Expenditure
                                  ? dashBoardProvider
                                  .expenseDashboardDetails?.totalCount
                                  : dashBoardProvider
                                  .waterConnectionsDetails?.totalCount) ??
                                  0;
                          return Visibility(
                              visible: totalCount > 0 && !(dashBoardProvider.selectedMonth.dateType != DateType.MONTH),
                              child: Pagination(
                                  limit: dashBoardProvider.limit,
                                  offSet: dashBoardProvider.offset,
                                  callBack: (pageResponse) => dashBoardProvider
                                      .onChangeOfPageLimit(pageResponse, context),
                                  totalCount: totalCount, isDisabled: dashBoardProvider.isLoaderEnabled));
                        }))
              ]),
            ),
          ),
        ),
      ),
    );
  }


  Widget _buildViewBasedOnTheSelection(DashBoardProvider dashBoardProvider) {
    return dashBoardProvider.selectedMonth.dateType != DateType.MONTH ? SliverToBoxAdapter(
        child: Column(
            children: [
              RevenueDashBoard(),
              Visibility(
                  visible:  takeScreenShot,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Container(
                        color : Color.fromRGBO(238, 238, 238, 1),
                        width: 900,
                        child: Screenshot(
                            controller: screenshotController,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              child: Column(children : [
                                DashboardCard((){}),
                                RevenueDashBoard(),
                              ]
                              ),
                            ))),
                  )),
            ]
        )
    ) :
    SliverFillRemaining(
        hasScrollBody: true,
        fillOverscroll: true,
        child: TabBarView(
          physics: NeverScrollableScrollPhysics(),
          controller: _tabController,
          children: [
            SearchExpenseDashboard(
                dashBoardType: DashBoardType.collections),
            SearchExpenseDashboard(
                dashBoardType: DashBoardType.Expenditure)
          ],
        )
    );
  }

  Widget get _buildShare => TextButton.icon(
      onPressed: takeScreenShotOfDashboard,
      icon: Image.asset('assets/png/whats_app.png'),
      label: Text(i18.common.SHARE));

  void onTapOfMonthPicker() {
    var dashBoardProvider =
    Provider.of<DashBoardProvider>(context, listen: false);

    dashBoardProvider.removeOverLay(_overlayEntry);
    overlayState = Overlay.of(context);

    RenderBox? box = key.currentContext!.findRenderObject() as RenderBox?;
    Offset position = box!.localToGlobal(Offset.zero);

    var height = MediaQuery.of(context).size.height;

    _overlayEntry = new OverlayEntry(
        builder: (BuildContext context) => Positioned(
            left: position.dx + box.size.width - 200,
            top: position.dy + 60  - 10,
            child: Material(
                color: Colors.transparent,
                child: Container(
                    constraints: BoxConstraints(
                        maxHeight: (height - position.dy) - 60
                    ),
                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(5.0),
                        bottomLeft: Radius.circular(5.0),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(.5),
                          blurRadius: 20.0, // soften the shadow
                          spreadRadius: 0.0, //extend the shadow
                          offset: Offset(
                            5.0, // Move to right 10  horizontally
                            5.0, // Move to bottom 10 Vertically
                          ),
                        )
                      ],
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: List.generate(
                            dashBoardProvider.dateList.length, (index) {
                          var date = dashBoardProvider.dateList[index];
                          return InkWell(
                            onTap: () => dashBoardProvider.onChangeOfDate(
                                date, context, _overlayEntry),
                            child: Container(
                              width: 195,
                              decoration: index ==
                                  dashBoardProvider.dateList.length - 1
                                  ? BoxDecoration(
                                  color: index % 2 == 0
                                      ? Color.fromRGBO(238, 238, 238, 1)
                                      : Color.fromRGBO(255, 255, 255, 1),
                                  borderRadius: BorderRadius.only(
                                    bottomRight: Radius.circular(5.0),
                                    bottomLeft: Radius.circular(5.0),
                                  ))
                                  : BoxDecoration(
                                color: index % 2 == 0
                                    ? Color.fromRGBO(238, 238, 238, 1)
                                    : Color.fromRGBO(255, 255, 255, 1),
                              ),
                              padding: EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 8),
                              child: date.dateType == DateType.LABEL ?
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                child: Text(ApplicationLocalizations.of(context)
                                    .translate(date.label ?? ''),
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Color.fromRGBO(80, 90, 95, 1)
                                  ),
                                ),
                              ) :
                              Wrap(
                                spacing: 5,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                alignment: WrapAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '${DateFormats.getMonthAndYear(date, context)}',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: dashBoardProvider
                                            .selectedMonth == date
                                            ? FontWeight.bold
                                            : FontWeight.normal),
                                  ),
                                  Radio(
                                      value: date,
                                      groupValue:
                                      dashBoardProvider.selectedMonth,
                                      onChanged: (date) =>
                                          dashBoardProvider.onChangeOfDate(
                                              date as DatePeriod,
                                              context,
                                              _overlayEntry))
                                ],
                              ),
                            ),
                          );
                        }),
                      ),
                    )))));
    if (_overlayEntry != null) overlayState?.insert(_overlayEntry!);
  }

  Future<void> takeScreenShotOfDashboard() async {
    final FlutterShareMe flutterShareMe = FlutterShareMe();
    var fileName = 'annualdashboard';

    Loaders.showLoadingDialog(context, label : '');
    setState(() {
      takeScreenShot = true;
    });

    await Future.delayed(Duration(milliseconds: 100));
    screenshotController
        .capture(
        delay: Duration(seconds: 1))
        .then((capturedImage) async {

          try {
            setState(() {
              takeScreenShot = false;
            });

            if (kIsWeb && capturedImage != null) {
              // final blob = html.Blob(
              //     [await capturedImage]);
              // final url = html.Url
              //     .createObjectUrlFromBlob(blob);
              // final anchor = html.document
              //     .createElement('a') as html
              //     .AnchorElement
              //   ..href = url
              //   ..style.display = 'none'
              //   ..download = 'some_name.png';
              // html.document.body?.children.add(
              //     anchor);
              // anchor.click();
              // html.document.body?.children.remove(
              //     anchor);
              // html.Url.revokeObjectUrl(url);

              var file = CustomFile(capturedImage, fileName, 'png');
              var response = await CoreRepository().uploadFiles(
                  <CustomFile>[file], APIConstants.API_MODULE_NAME);

              if(response.isNotEmpty){
               var commonProvider = Provider.of<CommonProvider>(context, listen: false);
               var res = await CoreRepository().fetchFiles([response.first.fileStoreId!]);
               if(res != null && res.isNotEmpty) {
                 var url = res.first.url ?? '';
                 if (url.contains(',')) {
                   url = url.split(',').first;
                 }
                 response.first.url = url;
                 commonProvider.shareonwatsapp(
                     response.first, null,
                     '<link>');
               }
              }
            } else {
              final Directory? directory = await getExternalStorageDirectory();
              final file = await File('${directory?.path}/$fileName.png')
                  .writeAsBytes(capturedImage!);
              var response = await flutterShareMe.shareToWhatsApp(
                  imagePath: file.path,
                  fileType: FileType.image);
              if(response != null && response.contains('PlatformException'))
                ErrorHandler().allExceptionsHandler(context, response );
            }
            Navigator.pop(context);
          }catch(e,s){
            Navigator.pop(context);
            ErrorHandler().allExceptionsHandler(context, e, s);
          }
    }).catchError((onError,s) {
      setState(() {
        takeScreenShot = false;
      });
      ErrorHandler().allExceptionsHandler(context, onError,s);
    });
  }

  Future<dynamic> ShowCapturedWidget(
      BuildContext context, Uint8List capturedImage) {
    return showDialog(
      useSafeArea: false,
      context: context,
      builder: (context) => Scaffold(
        appBar: AppBar(
          title: Text("Captured widget screenshot"),
        ),
        body: Center(
            child: capturedImage != null
                ? Image.memory(capturedImage)
                : Container()),
      ),
    );
  }

}

var a = [
  Metric(label: '700', value: 'Total Expenditure', type: 'amount'),
  Metric(label: '700', value: 'Total Expenditure', type: 'amount'),
  Metric(label: '700', value: 'Total Expenditure', type: 'amount'),
  Metric(label: '700', value: 'Total Expenditure', type: 'amount'),
  Metric(label: '700', value: 'Total Expenditure', type: 'amount'),
  Metric(label: '700', value: 'Total Expenditure', type: 'amount'),
  Metric(label: '700', value: 'Total Expenditure', type: 'amount'),
  Metric(label: '700', value: 'Total Expenditure', type: 'amount'),
];