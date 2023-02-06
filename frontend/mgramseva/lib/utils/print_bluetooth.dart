import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:flutter/material.dart';
import 'package:mgramseva/utils/Constants/I18KeyConstants.dart';
import 'package:nearby_connections/nearby_connections.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';

import 'Locilization/application_localizations.dart';

class PrintBluetooth {
  static bool connected = false;

  static setConnect(String mac, value, context) async {
    if (connected) {
      PrintBluetooth.printTicket(value, context);
      Navigator.of(context).pop();
    } else {
      final result =
          await PrintBluetoothThermal.connect(macPrinterAddress: mac);

      if (result) {
        connected = true;
        PrintBluetooth.printTicket(value, context);
        Navigator.of(context).pop();
      }
    }
  }

  static Future<void> showMyDialog(context, value) async {
    connected = false;
    Widget setupAlertDialogContainer(
        List<BluetoothInfo> availableBluetoothDevices, context) {
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
                String select = availableBluetoothDevices[index].macAdress;
                setConnect(select, value, context);
              },
              title: Text('${availableBluetoothDevices[index].name}'),
              subtitle: Text(ApplicationLocalizations.of(context)
                  .translate(i18.consumerReciepts.CLICK_TO_CONNECT)),
            );
          },
        ),
      );
    }

    final List<BluetoothInfo> availableBluetoothDevices =
        await PrintBluetoothThermal.pairedBluetooths;
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(ApplicationLocalizations.of(context)
              .translate(i18.consumerReciepts.CONNECT_TO_DEVICE)),
          content:
              setupAlertDialogContainer(availableBluetoothDevices, context),
          actions: <Widget>[
            TextButton(
              child: Text(ApplicationLocalizations.of(context)
                  .translate(i18.consumerReciepts.CLOSE)),
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
    bool? isPermissionGranted =
        await PrintBluetoothThermal.isPermissionBluetoothGranted;
    print(isPermissionGranted);
    if (!isPermissionGranted) {
      Nearby().askBluetoothPermission();
    }
    bool? isConnected = await PrintBluetoothThermal.connectionStatus;
    if (isConnected) {
      List<int> bytes = await getTicket(value);
      final result = await PrintBluetoothThermal.writeBytes(bytes);
    } else {
      PrintBluetooth.showMyDialog(context, value);
      print(ApplicationLocalizations.of(context)
          .translate(i18.consumerReciepts.CONNECTION_NOT_ESTABLISHED));
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
