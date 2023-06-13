import 'package:bluetooth_thermal_printer/bluetooth_thermal_printer.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:flutter/material.dart';
import 'package:mgramseva/utils/constants/i18_key_constants.dart';

import 'localization/application_localizations.dart';
import 'global_variables.dart';

class CommonPrinter {
  static bool connected = false;

  static setConnect(String mac, value, context) async {
    if (connected) {
      CommonPrinter.printTicket(value, context);
      Navigator.of(context).pop();
    } else {
      final String? result = await BluetoothThermalPrinter.connect(mac);

      print("state conneected $result");
      if (result == "true") {
        connected = true;
        CommonPrinter.printTicket(value, context);
        Navigator.of(context).pop();
      }
    }
  }

  static Future<void> showMyDialog(context, value) async {
    connected = false;
    Widget setupAlertDialoadContainer(availableBluetoothDevices, context) {
      return Container(
        height: 300.0, // Change as per your requirement
        width: 300.0,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: availableBluetoothDevices.length > 0
              ? availableBluetoothDevices.length
              : 0,
          itemBuilder: (context, index) {
            return ListTile(
              onTap: () {
                String select = availableBluetoothDevices[index];
                List list = select.split("#");
                // String name = list[0];
                String mac = list[1];
                setConnect(mac, value, context);
              },
              title: Text('${availableBluetoothDevices[index]}'),
              subtitle: Text("Click to connect"),
            );
          },
        ),
      );
    }

    final List? availableBluetoothDevices =
        await BluetoothThermalPrinter.getBluetooths;
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Connect to Device'),
          content:
              setupAlertDialoadContainer(availableBluetoothDevices, context),
          actions: <Widget>[
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  static Future<void> printTicket(value, context) async {
    String? isConnected = await BluetoothThermalPrinter.connectionStatus;
    print(isConnected);
    if (isConnected == "true") {
      List<int> bytes = await getTicket(value);
      final result = await BluetoothThermalPrinter.writeBytes(bytes);
      print("Print $result");
    } else {
      CommonPrinter.showMyDialog(context, value);
      print("connction not established");
    }
  }

  static Future<List<int>> getTicket(value) async {
    print(value);
    List<int> bytes = [];
    CapabilityProfile profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm80, profile);
    bytes += generator.image(value);

    // ticket.feed(2);
    bytes += generator.cut();
    return bytes;
  }
}
