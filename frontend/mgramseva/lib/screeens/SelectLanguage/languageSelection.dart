import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mgramseva/screeens/SelectLanguage/DesktopView.dart';
import 'package:mgramseva/screeens/SelectLanguage/MobileView.dart';
import 'package:mgramseva/services/Locilization.dart';
import 'package:mgramseva/services/MDMS.dart';

// ignore: must_be_immutable
class SelectLanguage extends StatefulWidget {
  final Function changelanguage;
  SelectLanguage(this.changelanguage);
  @override
  State<StatefulWidget> createState() {
    return _SelectLanguage(this.changelanguage);
  }
}

class _SelectLanguage extends State<SelectLanguage> {
    final Function changelanguage;
  var _data=[];
  late String isSelected = 'en_IN';
  _SelectLanguage(this.changelanguage);

  _setLanguage(value) {
    setState(() {
      isSelected = value;
    });
    getLocilisation(isSelected);
    changelanguage(isSelected.split('_')[0]);

  }

  @override
  void initState() {
    super.initState();
    getMDMD().then((value) => {
          setState(() {
            _data = (json.decode(utf8.decode(value.bodyBytes))['MdmsRes']
                ['common-masters']['StateInfo']);
          })
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth < 760) {
        return LanguageSelectMobileView(_data[0], isSelected, _setLanguage);
      } else {
        return _data.length > 0 ? LanguageSelectionDesktopView(_data[0], isSelected, _setLanguage):Text("Loading");
      }
    }));
  }
}
