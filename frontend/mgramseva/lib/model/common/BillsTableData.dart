import '../../utils/models.dart';

class BillsTableData{
  List<TableHeader> tableHeaders;
  List<TableDataRow> tabledata;
  bool isEmpty(){
    return tabledata.isEmpty;
  }
  BillsTableData(this.tableHeaders, this.tabledata);
}