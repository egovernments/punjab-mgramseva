import 'package:flutter/material.dart';
import 'package:mgramseva/Env/app_config.dart';
import 'package:mgramseva/utils/constants.dart';

class Footer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(25),
      child: Image(
          width: 140,
          image: NetworkImage(
            "$apiBaseUrl${Constants.DIGIT_FOOTER_ENDPOINT}",
          )),
    );
  }
}
