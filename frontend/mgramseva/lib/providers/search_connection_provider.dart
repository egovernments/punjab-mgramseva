import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mgramseva/model/connection/search_connection.dart';
import 'package:mgramseva/model/connection/water_connections.dart';
import 'package:mgramseva/providers/common_provider.dart';
import 'package:mgramseva/providers/language.dart';
import 'package:mgramseva/repository/search_connection_repo.dart';
import 'package:mgramseva/routers/Routers.dart';
import 'package:mgramseva/utils/Constants/I18KeyConstants.dart';
import 'package:mgramseva/utils/global_variables.dart';
import 'package:mgramseva/utils/loaders.dart';
import 'package:mgramseva/utils/notifyers.dart';
import 'package:provider/provider.dart';

class SearchConnectionProvider with ChangeNotifier {
  late WaterConnections waterConnections;
  final formKey = GlobalKey<FormState>();
  var autoValidation = false;
  var streamController = StreamController.broadcast();
  SearchConnection searchconnection = SearchConnection();

  dispose() {
    streamController.close();
    super.dispose();
  }

  getdetails(value, controller) {
    if (value.length == 0) {
      for (var i = 0; i < searchconnection.controllers.length; i++) {
        searchconnection.controllers[i] = false;
      }
    } else {
      for (var i = 0; i < searchconnection.controllers.length; i++) {
        searchconnection.controllers[i] = true;
      }

      searchconnection.controllers[controller] = false;
    }
    print(searchconnection.controllers);
    notifyListeners();
  }

  void callNotifyer() {
    notifyListeners();
  }

  getresults() {
    return streamController.add(waterConnections);
  }

  void validatesearchConnectionDetails(context) async {
    var commonProvider = Provider.of<CommonProvider>(
        navigatorKey.currentContext!,
        listen: false);
    if (formKey.currentState!.validate()) {
      searchconnection.setValues();
      try {
        Loaders.showLoadingDialog(context);
        var inputJson = searchconnection.toJson();
        inputJson.removeWhere((key, value) => key == null || value == "");
        print(inputJson);
        var connectionresults = SearchConnectionRepository().getconnection({
          "tenantId": commonProvider.userDetails!.selectedtenant!.code,
          ...inputJson
        });
        if (connectionresults != null) {
          connectionresults.then((value) => {
                if (value.waterConnection!.length > 0)
                  {
                    print(value),
                    waterConnections = value,
                    Navigator.pushNamed(context, Routes.SEARCH_CONSUMER_RESULT,
                        arguments: inputJson)
                  }
                else
                  {
                    Notifiers.getToastMessage(context,
                        i18.searchWaterConnection.NO_CONNECTION_FOUND, "ERROR")
                  }
              });
          Navigator.pop(context);

          try {} catch (e) {
            streamController.addError('error');
          }
        }
      } catch (e) {
        Navigator.pop(context);
      }
    } else {
      autoValidation = true;
    }
  }
}
