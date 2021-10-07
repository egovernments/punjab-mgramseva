
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:mgramseva/providers/revenuedashboard_provider.dart';
import 'package:mgramseva/utils/Locilization/application_localizations.dart';
import 'package:mgramseva/utils/models.dart';
import 'package:mgramseva/widgets/LabelText.dart';
import 'package:provider/provider.dart';
import 'package:mgramseva/utils/Constants/I18KeyConstants.dart';

class RevenueCharts extends StatefulWidget {
  const RevenueCharts({Key? key}) : super(key: key);

  @override
  _RevenueChartsState createState() => _RevenueChartsState();
}

class _RevenueChartsState extends State<RevenueCharts> {
  @override
  Widget build(BuildContext context) {
    return  LayoutBuilder(
            builder: (context, constraints) => Container(
            color: Color.fromRGBO(238, 238, 238, 1),
            child: constraints.maxWidth > 760 ?  _buildDesktopView() : _buildMobileView(),
          ),
    );
  }
  
  
  Widget _buildMobileView() {
    return _buildChartWithCardView(
      Consumer<RevenueDashboard>(
          builder : (_, revenueProvider, child) =>
              getGraphView(revenueProvider.selectedIndex)
      ),
      _buildActions()
    );
  }
  
  
  Widget _buildDesktopView(){
    var revenueProvider = Provider.of<RevenueDashboard>(context, listen: false);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: _buildChartWithCardView(_buildStackedCharts(), _buildButton(revenueProvider.getTabs(context).first))),
        SizedBox(width: 8),
        Expanded(child: _buildChartWithCardView(_buildLineCharts(true), _buildButton(revenueProvider.getTabs(context).last))),
      ],
    );
  }

  Widget _buildChartWithCardView(Widget chart, Widget action){
    return Card(
      margin: EdgeInsets.all(0.0),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Text('${ApplicationLocalizations.of(context).translate(i18.dashboard.REVENUE_EXPENDITURE_TREND)}',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700
                ),
              ),
            ),
            action,
            chart
          ],
        ),
      ),
    );
  }

  Widget _buildActions() {
    return Consumer<RevenueDashboard>(
      builder : (_, revenueProvider, child) {
        var tabs = revenueProvider.getTabs(context);
        return Wrap(
            spacing: 10,
            children: List.generate(tabs.length, (index) => _buildButton(tabs[index], index, revenueProvider.setSelectedTab))
        );
      },
    );
  }

  Widget _buildStackedCharts(){
    var revenue = [
      Legend('Residential', Color.fromRGBO(64, 106, 187, 1)),
      Legend('Commercial', Color.fromRGBO(188, 211, 255, 1))];

    var expense = [
      Legend('Electricity', Color.fromRGBO(19, 216, 204, 1)),
      Legend('Salaries', Color.fromRGBO(47, 197, 229, 1)),
      Legend('Operations', Color.fromRGBO(251, 192, 45, 1)),
      Legend('Others', Color.fromRGBO(244, 119, 56, 1)),
    ];

    return Column(children : [
      Container(
          height: 250,
          child : StackedBarChart.withSampleData()
      ),
     Container(
       padding: const EdgeInsets.only(top: 8),
       height: 90,
       child: Row(
         mainAxisAlignment: MainAxisAlignment.start,
         crossAxisAlignment: CrossAxisAlignment.start,
         children: [
           _buildStackedLegends(i18.dashboard.REVENUE, revenue),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: VerticalDivider(color: Colors.grey, width: 2, thickness: 2,),
            ),
           Expanded(child: _buildStackedLegends(i18.dashboard.EXPENDITURE, expense))
         ],
       ),
     )
    ]);
  }

  Widget _buildStackedLegends(String label, List<Legend> legends){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children : [
        Padding(
          padding: const EdgeInsets.symmetric(vertical : 8.0),
          child: Text('${ApplicationLocalizations.of(context).translate(label)}',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700
          ),
          ),
        ),
        Expanded(
          child: Wrap(
            direction: Axis.vertical,
            spacing: 8,
            runSpacing: 10,
            children: legends.map((e) => _buildLegend(e.label, e.color)).toList()
          ),
        )
      ]
    );
  }


  Widget _buildLineCharts([bool isDeskTopView = false]){
    return Column(children : [
      Container(
          height: 250,
        child : SimpleLineChart.withSampleData()
      ),
    Container(
        padding: const EdgeInsets.only(top : 16.0),
        height: isDeskTopView ? 90 : null,
        alignment: isDeskTopView ? Alignment.center : null,
        child: Wrap(
          spacing: 20,
          children: [
            _buildLegend(i18.dashboard.REVENUE, Color.fromRGBO(64, 106, 187, 1)),
            _buildLegend(i18.dashboard.EXPENDITURE, Color.fromRGBO(11, 12, 12, 1)),
          ],
        ),
    )
    ]);
  }

  Widget getGraphView(int index){
    switch(index){
      case 0 :
       return _buildStackedCharts();
      case 1 :
        return _buildLineCharts();
      default :
        return Container();
    }
  }

  Widget _buildLegend(String label, Color color){
    return Wrap(
      spacing: 8,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Container(
          height: 12,
          width: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle
          ),
        ),
        Text('${ApplicationLocalizations.of(context).translate(label)}',
        style: TextStyle(
          fontSize: 12,
          color: Color.fromRGBO(11, 12, 12, 1)
        ),
        )
      ],
    );
  }

  Widget _buildButton(String label, [int? index, Function(int)? callBack]){
    var revenueProvider = Provider.of<RevenueDashboard>(context, listen: false);

    return OutlinedButton(
      onPressed: () => callBack != null && index != null ? callBack(index) : (){},
    style: OutlinedButton.styleFrom(
    side: BorderSide(width: 1.0, color: (revenueProvider.selectedIndex == index) || index == null ? Theme.of(context).primaryColor : Color.fromRGBO(238, 238, 238, 1)),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3.0)),
    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 9)
    ),
      child: Text("${ApplicationLocalizations.of(context).translate(label)}",
      style: TextStyle(
        color: (revenueProvider.selectedIndex == index) || index == null ? Theme.of(context).primaryColor : Color.fromRGBO(80, 90, 95, 1),
        fontSize: 14
      ),
      ),
    );
  }
}



class StackedBarChart extends StatelessWidget {
  final dynamic seriesList;
  final bool? animate;

  StackedBarChart(this.seriesList, {this.animate});

  /// Creates a stacked [BarChart] with sample data and no transition.
  factory StackedBarChart.withSampleData() {
    return new StackedBarChart(
      createSampleData(),
      // Disable animations for image tests.
      animate: false,

    );
  }


  @override
  Widget build(BuildContext context) {
    return new charts.BarChart(
      seriesList,
      animate: animate,
      defaultRenderer: new charts.BarRendererConfig(
        groupingType: charts.BarGroupingType.groupedStacked,
        maxBarWidthPx: 8,
          cornerStrategy: const charts.ConstCornerStrategy(30),
      ),
    );
  }

  /// Create series list with multiple series
  static List<charts.Series<OrdinalSales, String>> createSampleData() {
    final desktopSalesDataA = [
      new OrdinalSales('2014', 5),
      new OrdinalSales('2015', 25),
      new OrdinalSales('2016', 100),
      new OrdinalSales('2017', 75),
    ];

    final tableSalesDataA = [
      new OrdinalSales('2014', 25),
      new OrdinalSales('2015', 50),
      new OrdinalSales('2016', 10),
      new OrdinalSales('2017', 20),
    ];

    final mobileSalesDataA = [
      new OrdinalSales('2014', 10),
      new OrdinalSales('2015', 15),
      new OrdinalSales('2016', 50),
      new OrdinalSales('2017', 45),
    ];

    final desktopSalesDataB = [
      new OrdinalSales('2014', 5),
      new OrdinalSales('2015', 25),
      new OrdinalSales('2016', 100),
      new OrdinalSales('2017', 75),
    ];

    final tableSalesDataB = [
      new OrdinalSales('2014', 25),
      new OrdinalSales('2015', 50),
      new OrdinalSales('2016', 10),
      new OrdinalSales('2017', 20),
    ];

    final mobileSalesDataB = [
      new OrdinalSales('2014', 10),
      new OrdinalSales('2015', 15),
      new OrdinalSales('2016', 50),
      new OrdinalSales('2017', 45),
    ];

    return [
      new charts.Series<OrdinalSales, String>(
        id: 'Desktop A',
        seriesCategory: 'A',
        domainFn: (OrdinalSales sales, _) => sales.year,
        measureFn: (OrdinalSales sales, _) => sales.sales,
        data: desktopSalesDataA,
      ),
      new charts.Series<OrdinalSales, String>(
        id: 'Tablet A',
        seriesCategory: 'A',
        domainFn: (OrdinalSales sales, _) => sales.year,
        measureFn: (OrdinalSales sales, _) => sales.sales,
        data: tableSalesDataA,
      ),
      new charts.Series<OrdinalSales, String>(
        id: 'Mobile A',
        seriesCategory: 'A',
        domainFn: (OrdinalSales sales, _) => sales.year,
        measureFn: (OrdinalSales sales, _) => sales.sales,
        data: mobileSalesDataA,
      ),
      new charts.Series<OrdinalSales, String>(
        id: 'Desktop B',
        seriesCategory: 'B',
        domainFn: (OrdinalSales sales, _) => sales.year,
        measureFn: (OrdinalSales sales, _) => sales.sales,
        data: desktopSalesDataB,
      ),
      new charts.Series<OrdinalSales, String>(
        id: 'Tablet B',
        seriesCategory: 'B',
        domainFn: (OrdinalSales sales, _) => sales.year,
        measureFn: (OrdinalSales sales, _) => sales.sales,
        data: tableSalesDataB,
      ),
      new charts.Series<OrdinalSales, String>(
        id: 'Mobile B',
        seriesCategory: 'B',
        domainFn: (OrdinalSales sales, _) => sales.year,
        measureFn: (OrdinalSales sales, _) => sales.sales,
        data: mobileSalesDataB,
      ),
    ];
  }
}


class SimpleLineChart extends StatelessWidget {
  final dynamic seriesList;
  final bool? animate;

  SimpleLineChart(this.seriesList, {this.animate});

  /// Creates a [LineChart] with sample data and no transition.
  factory SimpleLineChart.withSampleData() {
    return new SimpleLineChart(
      _createSampleData(),
      // Disable animations for image tests.
      animate: false,
    );
  }


  @override
  Widget build(BuildContext context) {
    return new charts.LineChart(seriesList, animate: animate);
  }

  /// Create one series with sample hard coded data.
  static List<charts.Series<LinearSales, int>> _createSampleData() {
    final data = [
      new LinearSales(0, 5),
      new LinearSales(1, 25),
      new LinearSales(2, 100),
      new LinearSales(3, 75),
    ];

    final data1 = [
      new LinearSales(0, 8),
      new LinearSales(1, 12),
      new LinearSales(2, 80),
      new LinearSales(3, 70),
    ];

    return [
      new charts.Series<LinearSales, int>(
        id: 'Sales',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (LinearSales sales, _) => sales.year,
        measureFn: (LinearSales sales, _) => sales.sales,
        data: data,
      ),
      new charts.Series<LinearSales, int>(
        id: 'Sales',
        colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
        domainFn: (LinearSales sales, _) => sales.year,
        measureFn: (LinearSales sales, _) => sales.sales,
        data: data1,
      )
    ];
  }
}

/// Sample linear data type.
class LinearSales {
  final int year;
  final int sales;

  LinearSales(this.year, this.sales);
}

/// Sample ordinal data type.
class OrdinalSales {
  final String year;
  final int sales;

  OrdinalSales(this.year, this.sales);
}
