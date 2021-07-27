import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:horizontal_data_table/horizontal_data_table.dart';
import 'package:mgramseva/widgets/ScrollParent.dart';

class BillsTable extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _BillsTable();
  }
}

class _BillsTable extends State<BillsTable> {
  final ScrollController controller = ScrollController();
  static const int sortName = 0;
  bool isAscending = true;
  int sortType = sortName;

  @override
  void initState() {
    bill.initData(100);
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
            itemCount: bill.billinfo.length,
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
    return [
      TextButton(
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
          ),
          child: _getTitleItemWidget(
              'Bill ID - Vendor' +
                  (sortType == sortName ? (isAscending ? '↓' : '↑') : ''),
              constraints),
          onPressed: () {
            sortType = sortName;
            isAscending = !isAscending;
            bill.sortName(isAscending);
            setState(() {});
          }),
      _getTitleItemWidget('Expense Type', constraints),
      _getTitleItemWidget('Amount', constraints),
      _getTitleItemWidget('Bill Date', constraints),
      _getTitleItemWidget('Paid Date', constraints),
    ];
  }

  Widget _getTitleItemWidget(String label, constraints) {
    return Container(
      child: Text(label,
          style: TextStyle(
              fontWeight: FontWeight.w700, color: Colors.black, fontSize: 12)),
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
              bill.billinfo[index].billID,
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
      BuildContext context, int index, input, constraints) {
    return Container(
      child: Row(
        children: <Widget>[Text(input)],
      ),
       width:  constraints.maxWidth < 760 ? 187 : MediaQuery.of(context).size.width/4-100,
      height: 52,
      padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
      alignment: Alignment.centerLeft,
    );
  }

  Widget _generateRightHandSideColumnRow(BuildContext context, int index) {
    return LayoutBuilder(builder: (context, constraints) {
      return Container(
          color: index % 2 == 0 ? const Color(0xffEEEEEE) : Colors.white,
          child: Row(
            children: <Widget>[
              _generateColumnRow(context, index,
                  bill.billinfo[index].expenseType, constraints),
              _generateColumnRow(context, index,
                  "₹" + bill.billinfo[index].phone, constraints),
              _generateColumnRow(context, index,
                  bill.billinfo[index].registerDate, constraints),
              _generateColumnRow(context, index,
                  bill.billinfo[index].terminationDate, constraints),
            ],
          ));
    });
  }
}

Bill bill = Bill();

class Bill {
  List<BillInfo> billinfo = [];

  void initData(int size) {
    for (int i = 0; i < size; i++) {
      billinfo.add(BillInfo(
          "EB-2021-22/0_$i", 'Maintenance', '25000', '2019-01-01', 'N/A'));
    }
  }

  ///
  /// Single sort, sort Name's id
  void sortName(bool isAscending) {
    billinfo.sort((a, b) {
      int aId = int.tryParse(a.billID.replaceFirst('User_', '')) ?? 0;
      int bId = int.tryParse(b.billID.replaceFirst('User_', '')) ?? 0;
      return (aId - bId) * (isAscending ? 1 : -1);
    });
  }

  ///
}

class BillInfo {
  String billID;
  String expenseType;
  String phone;
  String registerDate;
  String terminationDate;

  BillInfo(this.billID, this.expenseType, this.phone, this.registerDate,
      this.terminationDate);
}
