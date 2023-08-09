import 'package:flutter/material.dart';

import '../../widgets/custom_app_bar.dart';
import '../../widgets/drawer_wrapper.dart';
import '../../widgets/side_bar.dart';

class Reports extends StatefulWidget {
  const Reports({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _Reports();
  }
}

class _Reports extends State<Reports> with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: CustomAppBar(),
      drawer: DrawerWrapper(
        Drawer(child: SideBar()),
      ),
      backgroundColor: Color.fromRGBO(238, 238, 238, 1),
      body: Column(
        children: [
          Text("Reports")
        ],
      ),
    );
  }
}
