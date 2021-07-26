import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mgramseva/utils/Locilization/application_localizations.dart';

final String assetName = 'assets/svg/HHRegister.svg';

class HomeCard extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeCard();
  }
}

class _HomeCard extends State<HomeCard> {
  List items = [
    {
      "label": "Household Register",
      "icon": "assets/svg/HHRegister.svg",
      "link": ""
    },
    {
      "label": "Collect Payments",
      "icon": "assets/svg/collectPayment.svg",
      "link": "household/search"
    },
    {
      "label": "Download Bills & Receipts",
      "icon": "assets/svg/printReciept.svg",
      "link": ""
    },
    {
      "label": "Add Expense Record",
      "icon": "assets/svg/addexpenses.svg",
      "link": "expenses/add"
    },
    {
      "label": "Update Expenses",
      "icon": "assets/svg/updateexpenses.svg",
      "link": ""
    },
    {
      "label": "Generate Demand",
      "icon": "assets/svg/generaedemand.svg",
      "link": "bill/generate"
    },
    {
      "label": "CORE_CONSUMER_CREATE",
      "icon": "assets/svg/createconsumer.svg",
      "link": "consumer/create"
    },
    {
      "label": "Update Consumer Details",
      "icon": "assets/svg/updateconsumer.svg",
      "link": "consumer/search"
    },
    {
      "label": "GPWSC Dashboard",
      "icon": "assets/svg/dashboard.svg",
      "link": "dashboard"
    },
  ];
  List<Widget> getList() {
    List<Widget> childs = [];
    for (var i = 0; i < items.length; i++) {
      childs.add(new GridTile(
        child: new GestureDetector(
            onTap: () => Navigator.pushNamed(context, items[i]["link"],
                arguments: 'expenses'),
            child: new Card(
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgPicture.asset(items[i]["icon"],
                        semanticsLabel: 'Acme Logo'),
                    Container(
                      margin: EdgeInsets.all(10),
                      child: Center(
                          child: new Text(
                        ApplicationLocalizations.of(context)
                            .translate(items[i]["label"]),
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w400),
                        textAlign: TextAlign.center,
                      )),
                    )
                  ],
                ))),
      ));
    }
    return childs;
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
