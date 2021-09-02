import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:mgramseva/model/success_handler.dart';
import 'package:mgramseva/providers/common_provider.dart';
import 'package:mgramseva/repository/core_repo.dart';
import 'package:mgramseva/routers/Routers.dart';
import 'package:mgramseva/utils/Locilization/application_localizations.dart';
import 'package:mgramseva/utils/error_logging.dart';
import 'package:mgramseva/utils/global_variables.dart';
import 'package:mgramseva/utils/loaders.dart';
import 'package:mgramseva/widgets/BottonButtonBar.dart';
import 'package:mgramseva/widgets/DrawerWrapper.dart';
import 'package:mgramseva/widgets/FormWrapper.dart';
import 'package:mgramseva/widgets/HomeBack.dart';
import 'package:mgramseva/widgets/LabelText.dart';
import 'package:mgramseva/widgets/ShortButton.dart';
import 'package:mgramseva/widgets/SideBar.dart';
import 'package:mgramseva/utils/Constants/I18KeyConstants.dart';
import 'package:mgramseva/widgets/footer.dart';
import 'package:mgramseva/widgets/help.dart';
import 'package:provider/provider.dart';

import 'customAppbar.dart';

class PaymentFeedBack extends StatefulWidget {
  final Map query;
  const PaymentFeedBack({Key? key, required this.query}) : super(key: key);

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
        body: SingleChildScrollView(
          child: FormWrapper(Column(
            children: [
              HomeBack(),
              Card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LabelText(i18.postPaymentFeedback.HELP_US_HELP_YOU),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                    child: Text(ApplicationLocalizations.of(context).translate(i18.postPaymentFeedback.SURVEY_REQUEST)),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Wrap(
                        runSpacing: 8,
                        children: [
                      _buildRating(i18.postPaymentFeedback.HAPPY_WITH_WATER_SUPPLY,
                          (rating) => onChangeOfRating(0, rating)),
                      _buildRating(i18.postPaymentFeedback.IS_WATER_SUPPLY_REGULAR,
                          (rating) => onChangeOfRating(1, rating)),
                      _buildRating(i18.postPaymentFeedback.IS_WATER_QUALITY_GOOD,
                          (rating) => onChangeOfRating(2, rating)),
                    ]),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                    child: ShortButton(
                        i18.common.SUBMIT, onSubmit),
                  )
                ],
              )),
              Footer()
            ],
          )),
        ));
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

    Loaders.showLoadingDialog(context);

    try{
      var body = {
        "RequestInfo" : {
        "authToken" : commonProvider.userDetails?.accessToken,
          "userInfo" : commonProvider.userDetails?.userRequest?.toJson()
        },
        'feedback' : {
          "tenantId": commonProvider.userDetails?.selectedtenant?.code,
          "paymentId": widget.query['paymentId'],
          "connectionno":widget.query['connectionno'],
          "paymentid": widget.query['paymentid'],
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
        }
      };

      var res = await CoreRepository().submitFeedBack(body);

      Navigator.pop(context);

      navigatorKey.currentState?.pushNamed(Routes.SUCCESS_VIEW,
          arguments: SuccessHandler(
              i18.postPaymentFeedback.FEED_BACK_SUBMITTED_SUCCESSFULLY,
              i18.postPaymentFeedback.FEEDBACK_RESPONSE_SUBMITTED_SUCCESSFULLY,
              i18.common.BACK_HOME, Routes.EXPENSES_ADD));
    }catch(e,s){
      Navigator.pop(context);
      ErrorHandler().allExceptionsHandler(context, e,s);
    }
  }
}
