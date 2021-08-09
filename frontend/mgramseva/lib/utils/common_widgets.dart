import 'package:flutter/material.dart';

import 'common_styles.dart';

class CommonWidgets {

  Widget buildHint(String? label) {
    return Visibility(
        visible: label != null,
        child: Container(
             padding: EdgeInsets.symmetric(vertical: 5),
            alignment: Alignment.centerLeft,
            child: Text('$label', style: CommonStyles.hintStyle)));
  }
}