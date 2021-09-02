import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:horizontal_data_table/horizontal_data_table.dart';
import 'package:mgramseva/utils/Locilization/application_localizations.dart';
import 'package:mgramseva/utils/models.dart';
import 'package:mgramseva/widgets/ScrollParent.dart';

class BillsTable extends StatefulWidget {
  final List<TableHeader> headerList;
  final List<TableDataRow> tableData;
  final double leftColumnWidth;
  final double rightColumnWidth;
  BillsTable({Key? key, required this.headerList, required this.tableData, required this.leftColumnWidth, required this.rightColumnWidth})
      : super(key: key);

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
            leftHandSideColumnWidth: widget.leftColumnWidth,
            rightHandSideColumnWidth: widget.rightColumnWidth,
            isFixedHeader: true,
            headerWidgets: _getTitleWidget(constraints),
            leftSideItemBuilder: _generateFirstColumnRow,
            rightSideItemBuilder: _generateRightHandSideColumnRow,
            itemCount: widget.tableData.length,
            elevation: 0,
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
    var index = 0;
    return widget.headerList.map((e) {
      index++;;
      if (e.isSortingRequired ?? false) {
        return TextButton(
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
            ),
            child:
                _getTitleItemWidget((e.label), constraints, isAscending : e.isAscendingOrder, isBorderRequired: (index- 1) == 0),
            onPressed: e.callBack == null ? null : () => e.callBack!(e));
      } else {
        return _getTitleItemWidget(e.label, constraints!);
      }
    }).toList();
  }

  Widget _getTitleItemWidget(String label, constraints, {bool? isAscending, bool isBorderRequired = false}) {
    var textWidget = Text(ApplicationLocalizations.of(context).translate(label),
        style: TextStyle(
            fontWeight: FontWeight.w700, color: Colors.black, fontSize: 12));

    return Container(
      decoration: isBorderRequired ? BoxDecoration(
          border: Border(
              left: tableCellBorder,
              bottom: tableCellBorder,
              right: tableCellBorder
          )
      ) : null,
      child: isAscending != null
          ? Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 5,
              children: [
                textWidget,
                Icon(isAscending
                    ? Icons.arrow_upward
                    : Icons.arrow_downward_sharp)
              ],
            )
          : textWidget,
      width: widget.leftColumnWidth,
      height: 56,
      padding: EdgeInsets.only(left: 17, right: 5, top: 6, bottom: 6),
    alignment: Alignment.centerLeft,
    );
  }

  Widget _generateFirstColumnRow(BuildContext context, int index) {
    return LayoutBuilder(builder: (context, constraints) {
      var data = widget.tableData[index].tableRow.first;
      return ScrollParent(
          controller,
          InkWell(
            onTap: () {
              if (data.callBack != null) {
                data.callBack!(data);
              }
            },
            child: Container(
              decoration: BoxDecoration(
                  border: Border(
                      left: tableCellBorder,
                      bottom: tableCellBorder,
                    right: tableCellBorder,
                  )
              ),
              child: Text(
                ApplicationLocalizations.of(context)
                    .translate(widget.tableData[index].tableRow.first.label),
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
              width: widget.leftColumnWidth,
              height: 52,
              padding: EdgeInsets.only(left: 17, right: 5, top: 6, bottom: 6),
              alignment: Alignment.centerLeft,
            ),
          ));
    });
  }

  Widget _generateColumnRow(
      BuildContext context, int index, String input, constraints,
      {TextStyle? style}) {
    return Container(
      child: Row(
        children: <Widget>[
          Text(ApplicationLocalizations.of(context).translate(input),
              style: style)
        ],
      ),
      width: widget.leftColumnWidth,
      height: 52,
      padding: EdgeInsets.only(left: 17, right: 5, top: 6, bottom: 6),
      alignment: Alignment.centerLeft,
    );
  }

  Widget _generateRightHandSideColumnRow(BuildContext context, int index) {
    var data = widget.tableData[index];
    return LayoutBuilder(builder: (context, constraints) {
      var list = <Widget>[];
      for (int i = 1; i < data.tableRow.length; i++) {
        list.add(_generateColumnRow(
            context, index, data.tableRow[i].label, constraints,
            style: data.tableRow[i].style));
      }
      return Container(
          color: index % 2 == 0 ? const Color(0xffEEEEEE) : Colors.white,
          child: Row(
            children: list
          ));
    });
  }

  BorderSide get tableCellBorder => BorderSide(
      color: Color.fromRGBO(238, 238, 238, 1),
      width: 0.5
  );
}
