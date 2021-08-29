import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:horizontal_data_table/horizontal_data_table.dart';
import 'package:mgramseva/utils/models.dart';
import 'package:mgramseva/widgets/ScrollParent.dart';

class BillsTable extends StatefulWidget {
  final List<TableHeader> headerList;
  final List<TableDataRow> tableData;

  BillsTable({Key? key, required this.headerList, required this.tableData}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _BillsTable();
  }
}

class _BillsTable extends State<BillsTable> {
  final ScrollController controller = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Container(
        child: HorizontalDataTable(
            leftHandSideColumnWidth: constraints.maxWidth < 760
                ? 150
                : MediaQuery.of(context).size.width / 5,
            rightHandSideColumnWidth: constraints.maxWidth < 760
                ? 750
                : MediaQuery.of(context).size.width - 300,
            isFixedHeader: true,
            headerWidgets: _getTitleWidget(constraints),
            leftSideItemBuilder: _generateFirstColumnRow,
            rightSideItemBuilder: _generateRightHandSideColumnRow,
            itemCount: widget.tableData.length,
            // rowSeparatorWidget: const Divider(
            //   color: Colors.black54,
            //   height: 1.0,
            //   thickness: 0.0,
            // ),
            leftHandSideColBackgroundColor: Color(0xFFFFFFFF),
            rightHandSideColBackgroundColor: Color(0xFFFFFFFF),
            verticalScrollbarStyle: const ScrollbarStyle(
              isAlwaysShown: true,
              thickness: 4.0,
              radius: Radius.circular(5.0),
            ),
            horizontalScrollbarStyle: const ScrollbarStyle(
              isAlwaysShown: true,
              thickness: 4.0,
              radius: Radius.circular(5.0),
            ),
            enablePullToRefresh: false),
        height: MediaQuery.of(context).size.height,
      );
    });
  }

  List<Widget> _getTitleWidget(constraints) {

    return widget.headerList.map((e) {
      if(e.isSortingRequired ?? false) {
        return  TextButton(
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
              ),
              child: _getTitleItemWidget(
                  (e.label),
                  constraints, e.isAscendingOrder),
              onPressed: e.callBack == null ? null : ()=> e.callBack!(e));
      }else{
        return _getTitleItemWidget(e.label, constraints!);
    }
    }).toList();
  }

  Widget _getTitleItemWidget(String label, constraints, [bool? isAscending]) {
    var textWidget = Text(label,
        style: TextStyle(
            fontWeight: FontWeight.w700, color: Colors.black, fontSize: 12));

    return Container(
      child: isAscending != null ?
      Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 5,
        children: [
          textWidget,
          Icon(
              isAscending! ? Icons.arrow_upward : Icons.arrow_downward_sharp
          )
        ],
      ) :
       textWidget,
      width: constraints.maxWidth < 760
          ? 187
          : (MediaQuery.of(context).size.width / 4 - 100),
      height: 56,
      padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
      alignment: Alignment.centerLeft,
    );
  }

  Widget _generateFirstColumnRow(BuildContext context, int index) {
    return LayoutBuilder(builder: (context, constraints) {
      return ScrollParent(
          controller,
          Container(
            child: Text(
              widget.tableData[index].tableRow.first.label,
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
            width: constraints.maxWidth < 760
                ? 187
                : MediaQuery.of(context).size.width / 5,
            height: 52,
            padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
            alignment: Alignment.centerLeft,
          ));
    });
  }

  Widget _generateColumnRow(
      BuildContext context, int index, String input, constraints, {TextStyle? style}) {
    return Container(
      child: Row(
        children: <Widget>[Text(input, style: style)],
      ),
       width:  constraints.maxWidth < 760 ? 187 : MediaQuery.of(context).size.width/4-100,
      height: 52,
      padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
      alignment: Alignment.centerLeft,
    );
  }

  Widget _generateRightHandSideColumnRow(BuildContext context, int index) {
    var data = widget.tableData[index];
    return LayoutBuilder(builder: (context, constraints) {
      return Container(
          color: index % 2 == 0 ? const Color(0xffEEEEEE) : Colors.white,
          child: Row(
            children: <Widget>[
              _generateColumnRow(context, index,
                  data.tableRow[1].label, constraints, style: data.tableRow[1].style),
              _generateColumnRow(context, index,
                  data.tableRow[2].label, constraints, style: data.tableRow[1].style),
              _generateColumnRow(context, index,
                  data.tableRow[3].label, constraints, style: data.tableRow[1].style),
              _generateColumnRow(context, index,
                  data.tableRow[4].label, constraints, style: data.tableRow[1].style),
            ],
          ));
    });
  }
}
