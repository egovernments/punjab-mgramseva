@JS()
library jsconnector;

import 'dart:typed_data';
import 'package:js/js.dart';

@JS('onButtonClick')
external void onButtonClick(Uint8List value, String logo);
