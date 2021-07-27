import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mgramseva/icons/home_icons_icons.dart';
import 'package:mgramseva/utils/Locilization/application_localizations.dart';
import 'package:mgramseva/utils/constants.dart';

final String assetName = 'assets/svg/HHRegister.svg';

class HomeCard extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeCard();
  }
}

class _HomeCard extends State<HomeCard> {

  List<Widget> getList() {
      return Constants.HOME_ITEMS.map((item) =>  GridTile(
        child: new GestureDetector(
            onTap: () => Navigator.pushNamed(context, item.link),
            child: new Card(
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(item.iconData, size: 35),
                    Container(

                      margin: EdgeInsets.all(10),
                      child: Center(
                          child: new Text(
                        ApplicationLocalizations.of(context)
                            .translate(item.label),
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w400),
                        textAlign: TextAlign.center,
                      )),
                    )
                  ],
                ))),
      )).toList();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth < 760) {
        return Container(
            height: MediaQuery.of(context).size.height * .75,
            child: (new GridView.count(
              crossAxisCount: 3,
              childAspectRatio: .8,
              children: getList(),
            )));
      } else {
        return Container(
            margin: EdgeInsets.all(75),
            child: (new GridView.count(
              crossAxisCount: 3,
              childAspectRatio: 3,
              children: getList(),
            )));
      }
    });
  }
}
