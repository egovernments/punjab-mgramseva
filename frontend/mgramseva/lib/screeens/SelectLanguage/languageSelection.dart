import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mgramseva/models/language.dart';
import 'package:mgramseva/providers/language.dart';
import 'package:mgramseva/screeens/SelectLanguage/DesktopView.dart';
import 'package:mgramseva/screeens/SelectLanguage/MobileView.dart';
import 'package:mgramseva/services/Locilization.dart';
import 'package:mgramseva/services/MDMS.dart';
import 'package:mgramseva/utils/loaders.dart';
import 'package:mgramseva/utils/notifyers.dart';
import 'package:provider/provider.dart';

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
    var languageProvider = Provider.of<LanguageProvider>(context, listen: false);
    languageProvider.getLocalizationData();
    // getMDMD().then((value) => {
    //       setState(() {
    //         _data = (json.decode(utf8.decode(value.bodyBytes))['MdmsRes']
    //             ['common-masters']['StateInfo']);
    //       })
    //     });
  }

  @override
  Widget build(BuildContext context) {
    var languageProvider = Provider.of<LanguageProvider>(context, listen: false);

    return Scaffold(body:
    StreamBuilder(
        stream: languageProvider.streamController.stream,
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return _buildView(snapshot.data);
          } else if (snapshot.hasError) {
            return Notifiers.networkErrorPage(
                context, (){});
          } else {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return Loaders.CircularLoader();
              case ConnectionState.active:
                return Loaders.CircularLoader();
              default:
                return Container();
            }
          }
        })
   );
  }

  Widget _buildView(List<StateInfo> stateList) {
    return  LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth < 760) {
        return LanguageSelectMobileView(stateList.first);
      } else {
        return _data.length > 0 ? LanguageSelectionDesktopView(_data[0], isSelected, _setLanguage):Text("Loading");
      }
    });
  }
}
