import 'package:flutter/material.dart';
import 'package:mgramseva/screeens/Home.dart';
import 'package:mgramseva/widgets/BaseAppBar.dart';
import 'package:mgramseva/widgets/BottonButtonBar.dart';
import 'package:mgramseva/widgets/DatePickerFieldBuilder.dart';
import 'package:mgramseva/widgets/DrawerWrapper.dart';
import 'package:mgramseva/widgets/FilePicker.dart';
import 'package:mgramseva/widgets/FormWrapper.dart';
import 'package:mgramseva/widgets/HomeBack.dart';
import 'package:mgramseva/widgets/LabelText.dart';
import 'package:mgramseva/widgets/RadioButtonFieldBuilder.dart';
import 'package:mgramseva/widgets/SelectFieldBuilder.dart';
import 'package:mgramseva/widgets/SideBar.dart';
import 'package:mgramseva/routers/Routers.dart';
import 'package:mgramseva/widgets/SubLabel.dart';
import 'package:mgramseva/widgets/TextFieldBuilder.dart';

class ExpenseDetails extends StatefulWidget {
  State<StatefulWidget> createState() {
    return _ExpenseDetailsState();
  }
}

class _ExpenseDetailsState extends State<ExpenseDetails> {
  List<Map<String, dynamic>> options = [
    {"key": "YES", "label": "Yes"},
    {"key": "NO", "label": "No"},
  ];
  List<Map<String, dynamic>> amountType = [
    {"key": "FULL", "label": "Full"},
    {"key": "PARTIAL", "label": "Partial"},
  ];

  var name = new TextEditingController();
  String _gender = 'YES';
  String _amountType = "FULL";

  _onSelectItem(int index, context) {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => Home(index),
        ),
        ModalRoute.withName(Routes.home));
  }

  final formKey = GlobalKey<FormState>();
  saveInput(context) async {
    print(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: BaseAppBar(
          Text('mGramSeva'),
          AppBar(),
          <Widget>[Icon(Icons.more_vert)],
        ),
        drawer: DrawerWrapper(
          Drawer(child: SideBar((value) => _onSelectItem(value, context))),
        ),
        body: SingleChildScrollView(
            child: FormWrapper(Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
              HomeBack(),
              Card(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                    LabelText("Expense Details"),
                    SubLabelText(
                        "Provide below Information to create Expense record"),
                    BuildTextField(
                        context, 'Vendor Name', name, '', '', saveInput, true),
                    SelectFieldBuilder(context, 'Type of Expense', name, '', '',
                        saveInput, options, true),
                    BuildTextField(
                        context, 'Amount (₹)', name, '', '', saveInput, true),
                    BasicDateField('Bill Issued Date', true),
                    RadioButtonFieldBuilder(context, 'Bill Paid', _gender, '',
                        '', true, options, saveInput),
                    RadioButtonFieldBuilder(context, 'Amount Paid', _amountType,
                        '', '', true, amountType, saveInput),
                    FilePickerDemo(),
                    SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      height: 20,
                    )
                  ]))
            ]))),
        bottomNavigationBar: BottomButtonBar('Submit', () => {}));
  }
}
