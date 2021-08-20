import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mgramseva/utils/Constants/I18KeyConstants.dart';
import 'package:mgramseva/utils/constants.dart';
import 'package:mgramseva/utils/global_variables.dart';
import 'package:mgramseva/widgets/RadioButtonFieldBuilder.dart';
import 'package:mgramseva/widgets/TextFieldBuilder.dart';

var json = [
  {
    "name": "Start creating a consumer record by entering consumers name",
    "widget": BuildTextField(
      i18.consumer.CONSUMER_NAME,
      TextEditingController(),
      isRequired: true,
    ),
  },
  {
    "name": "Start creating a consumer record by entering consumers name",
    "widget": RadioButtonFieldBuilder(
      navigatorKey.currentContext!,
      i18.common.GENDER,
      "",
      '',
      '',
      true,
      Constants.GENDER,
      (val) => {},
    )
  },
  {
    "name": "Add Father’s name of the consumer",
    "widget": BuildTextField(
      i18.consumer.FATHER_SPOUSE_NAME,
      TextEditingController(),
      isRequired: true,
    ),
  },
];

class ConsumerWalkThrough {
  final List<ConsumerWalkWidgets> consumerWalkThrough = json
      .map((e) => ConsumerWalkWidgets(
          name: e['name'] as String, widget: e['widget'] as Widget))
      .toList();
}

class ConsumerWalkWidgets {
  final String name;
  final Widget widget;
  bool isActive = false;
  GlobalKey? key;
  ConsumerWalkWidgets({required this.name, required this.widget});
}
