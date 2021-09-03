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
import 'package:mgramseva/widgets/CommonSuccessPage.dart';
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
  final bool isFromTakeSurveyBtn;
  const PaymentFeedBack({Key? key, required this.query, this.isFromTakeSurveyBtn = false}) : super(key: key);

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
        body: SingleChildScrollView(
          child: FormWrapper(Column(
            children: [
              Visibility(
                  visible: widget.isFromTakeSurveyBtn,
                  child: HomeBack()),
              Card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LabelText('Help us Help you'),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                    child: Text('Thank you for making payment towards your water bill.'
                        ' Please take this short survey to help us improve water supply facilities at mgramseva'),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                      _buildRating('Are you happy with water supply?',
                          (rating) => onChangeOfRating(0, rating)),
                      _buildRating('Is the water supply regular?',
                          (rating) => onChangeOfRating(1, rating)),
                      _buildRating('Is the water quality good?',
                          (rating) => onChangeOfRating(2, rating)),
                    ]),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                    child: ShortButton(
                        'Submit', (waterSupply > 0.0 && supplyRegular > 0.0 && qualityGood > 0.0) ? onSubmit : null),
                  )
                ],
              )),
              Footer()
            ],
          )),
        ));
  }

  Widget _buildRating(String label, ValueChanged<double> callBack) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
      Text(ApplicationLocalizations.of(context).translate(label),
      style: TextStyle(
        fontSize: 16,
        color: Color.fromRGBO(11, 12, 12, 1)
      ),
      ),
      Align(
        alignment: Alignment.centerLeft,
        child: Padding(
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
        ),
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
        'feedback' : {
          "tenantId": widget.query['tenantId'],
          "paymentId": widget.query['paymentId'],
          "connectionno":widget.query['connectionno'],
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
      
      Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (_) => CommonSuccess(SuccessHandler(
              'Feedback Submitted Successfully',
              'Thank you for providing feedback. Your response has been submitted successfully.',
              '', Routes.FEED_BACK_SUBMITTED_SUCCESSFULLY), backButton: false, isWithoutLogin: true),
          settings: RouteSettings(name: '/feedBack/success')));
    }catch(e,s){
      Navigator.pop(context);
      ErrorHandler().allExceptionsHandler(context, e,s);
    }
  }
}
