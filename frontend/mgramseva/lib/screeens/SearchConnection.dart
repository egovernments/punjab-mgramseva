import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:mgramseva/routers/Routers.dart';
import 'package:mgramseva/widgets/BaseAppBar.dart';
import 'package:mgramseva/widgets/BottonButtonBar.dart';
import 'package:mgramseva/widgets/DrawerWrapper.dart';
import 'package:mgramseva/widgets/FormWrapper.dart';
import 'package:mgramseva/widgets/HomeBack.dart';
import 'package:mgramseva/widgets/LabelText.dart';
import 'package:mgramseva/widgets/SideBar.dart';
import 'package:mgramseva/widgets/SubLabel.dart';
import 'package:mgramseva/widgets/TextFieldBuilder.dart';
import 'Home.dart';

class SearchConnection extends StatefulWidget {
  State<StatefulWidget> createState() {
    return _SearchConnectionState();
  }
}

class _SearchConnectionState extends State<SearchConnection> {
  _onSubmit(context) {
    Navigator.pushNamed(context, 'search/consumer');
  }

  var name = new TextEditingController();
  var isVisible = true;
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
            child: FormWrapper(
          Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HomeBack(),
                Card(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                      LabelText("Search Connection"),
                      SubLabelText(
                        "Enter the consumer's mobile number or name or connection ID to get more details . Please enter only one",
                      ),
                      BuildTextField(
                        'Owner Mobile Number',
                        name,
                        prefixText: '+91-',
                        isRequired: true,
                      ),
                      Text('\n-(or)-', textAlign: TextAlign.center),
                      BuildTextField(
                        'Name of the Consumer',
                        name,
                        isRequired: true,
                      ),
                      Visibility(
                          visible: !isVisible,
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text('\n-(or)-', textAlign: TextAlign.center),
                                BuildTextField(
                                  'Old Connection ID',
                                  name,
                                  isRequired: true,
                                ),
                                Text('\n-(or)-', textAlign: TextAlign.center),
                                BuildTextField(
                                  'New Connection ID',
                                  name,
                                  isRequired: true,
                                ),
                              ])),
                      new InkWell(
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 25, top: 10, bottom: 10, right: 25),
                          child: new Row(
                            children: [
                              new Text(
                                isVisible ? "\nShow more" : "\nShow Less",
                                style: new TextStyle(
                                    color: Colors.deepOrangeAccent),
                              )
                            ],
                          ),
                        ),
                        onTap: () {
                          setState(() {
                            isVisible = !isVisible;
                          });
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                    ]))
              ]),
        )),
        bottomNavigationBar:
            BottomButtonBar('Search', () => _onSubmit(context)));
  }
}
