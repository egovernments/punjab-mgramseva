import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:mgramseva/providers/common_provider.dart';
import 'package:mgramseva/utils/Locilization/application_localizations.dart';
import 'package:mgramseva/utils/error_logging.dart';
import 'package:mgramseva/utils/global_variables.dart';
import 'package:mgramseva/widgets/BottonButtonBar.dart';
import 'package:mgramseva/widgets/DrawerWrapper.dart';
import 'package:mgramseva/widgets/FormWrapper.dart';
import 'package:mgramseva/widgets/HomeBack.dart';
import 'package:mgramseva/widgets/LabelText.dart';
import 'package:mgramseva/widgets/SideBar.dart';
import 'package:mgramseva/utils/Constants/I18KeyConstants.dart';
import 'package:provider/provider.dart';

import 'customAppbar.dart';

class PaymentFeedBack extends StatefulWidget {
  const PaymentFeedBack({Key? key}) : super(key: key);

  @override
  _PaymentFeedBackState createState() => _PaymentFeedBackState();
}

class _PaymentFeedBackState extends State<PaymentFeedBack> {
  double waterSupply = 0.0;
  double supplyRegular = 0.0;
  double qualityGood = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: CustomAppBar(),
        drawer: DrawerWrapper(
          Drawer(child: SideBar()),
        ),
        body: FormWrapper(Column(
          children: [
            HomeBack(),
            Card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LabelText('Help us Help you'),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Wrap(
                      runSpacing: 8,
                      children: [
                    _buildRating('Are you happy with water supply?',
                        (rating) => onChangeOfRating(0, rating)),
                    _buildRating('Is the water supply regular?',
                        (rating) => onChangeOfRating(1, rating)),
                    _buildRating('Is the water quality good?',
                        (rating) => onChangeOfRating(2, rating)),
                  ]),
                )
              ],
            )),
            BottomButtonBar(
                i18.common.SUBMIT, onSubmit)
          ],
        )));
  }

  Widget _buildRating(String label, ValueChanged<double> callBack) {
    return Wrap(children: [
      Text(ApplicationLocalizations.of(context).translate(label),
      style: TextStyle(
        fontSize: 16,
        color: Color.fromRGBO(11, 12, 12, 1)
      ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: RatingBar.builder(
            initialRating: 0,
            minRating: 1,
            direction: Axis.horizontal,
            allowHalfRating: false,
            itemCount: 5,
            itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
            // unratedColor: Colors.transparent,
            glowColor: Colors.red,
            itemBuilder: (context, _) => Icon(
                  Icons.star,
                  color: Theme.of(context).primaryColor,
                ),
            onRatingUpdate: callBack),
      )
    ]);
  }

  void onChangeOfRating(int index, double rating) {
    switch (index) {
      case 0:
        waterSupply = rating;
        break;
      case 1:
        supplyRegular = rating;
        break;
      case 2:
        qualityGood = rating;
        break;
    }
    setState(() {});
  }

  Future<void> onSubmit() async {
    var commonProvider = Provider.of<CommonProvider>(
        navigatorKey.currentContext!,
        listen: false);

    try{
      var query = {
        "tenantId": commonProvider.userDetails?.selectedtenant?.code,
        "paymentId":"b2027123-477d-41e0-9ff9-c41c9e1ad201",
        "connectionno":"WS/400/2021-22/0162",
        "paymentid":"c92fe569-8f0f-43c4-80fb-1f09d914c58a",
        "additionaldetails":{
          "CheckList":  [ {
            "code":"HAPPY_WATER_SUPPLY",
            "type":"SINGLE_SELECT",
            "value": waterSupply.toInt().toString()
          },
            {
              "code":"WATER_QUALITY_GOOD",
              "type":"SINGLE_SELECT",
              "value": supplyRegular.toInt().toString()
            },
            {
              "code":"WATER_SUPPLY_REGULAR",
              "type":"SINGLE_SELECT",
              "value": qualityGood.toInt().toString()
            }
          ]
        }
      };

    }catch(e,s){
      ErrorHandler().allExceptionsHandler(context, e,s);
    }
  }
}
