import 'package:flutter/material.dart';
import 'package:mgramseva/utils/Constants/I18KeyConstants.dart';
import 'package:mgramseva/utils/constants.dart';
import 'package:mgramseva/utils/global_variables.dart';
import 'package:mgramseva/widgets/RadioButtonFieldBuilder.dart';
import 'package:mgramseva/widgets/SelectFieldBuilder.dart';
import 'package:mgramseva/widgets/TextFieldBuilder.dart';

var json = [
  {
    "name": (i18.consumerWalkThroughMsg.CONSUMER_NAME_MSG),
    "widget": BuildTextField(
      i18.consumer.CONSUMER_NAME,
      TextEditingController(),
      isRequired: true,
    ),
  },
  {
    "name": (i18.consumerWalkThroughMsg.CONSUMER_GENDER_MSG),
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
    "name": (i18.consumerWalkThroughMsg.CONSUMER_FATHER_MSG),
    "widget": BuildTextField(
      i18.consumer.FATHER_SPOUSE_NAME,
      TextEditingController(),
      isRequired: true,
    ),
  },
  {
    "name": (i18.consumerWalkThroughMsg.CONSUMER_MOBILE_MSG),
    "widget": BuildTextField(
      i18.common.PHONE_NUMBER,
      TextEditingController(),
      isRequired: true,
      maxLength: 10,
    ),
  },
  {
    "name": (i18.consumerWalkThroughMsg.CONSUMER_OLD_ID_MSG),
    "widget": BuildTextField(
      i18.consumer.OLD_CONNECTION_ID,
      TextEditingController(),
      isRequired: true,
    ),
  },
  {
    "name": (i18.consumerWalkThroughMsg.CONSUMER_WARD_MSG),
    "widget": SelectFieldBuilder(
      i18.consumer.WARD,
      '',
      '',
      '',
      (val) => {},
      [],
      true,
    )
  },
  {
    "name": (i18.consumerWalkThroughMsg.CONSUMER_PROPERTY_TYPE_MSG),
    "widget": SelectFieldBuilder(
      i18.consumer.PROPERTY_TYPE,
      '',
      '',
      '',
      (val) => {},
      [],
      true,
    )
  },
  {
    "name": (i18.consumerWalkThroughMsg.CONSUMER_SERVICE_TYPE_MSG),
    "widget": SelectFieldBuilder(
      i18.consumer.SERVICE_TYPE,
      '',
      '',
      '',
      (val) => {},
      [],
      true,
    )
  },
  {
    "name": (i18.consumerWalkThroughMsg.CONSUMER_ARREARS_MSG),
    "widget": BuildTextField(
      i18.consumer.ARREARS,
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
