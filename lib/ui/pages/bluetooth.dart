import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taaak/common/buttons/buttons.dart';
import 'package:taaak/core/providers/bluetooth_provider.dart';


class BluetoothPage extends StatelessWidget {
  const BluetoothPage({super.key});

  void turnBluetooth(BluetoothService bluetoothService) async
  {
    if (bluetoothService.bluetoothState) {
      debugPrint('stopping bluetooth');
      bluetoothService.stop();
    } else {
      debugPrint('starting bluetooth');
      bluetoothService.active();
    }
  }

  void startScanning(BluetoothService bluetoothService) async
  {

    debugPrint('scanning devices');
    // if (bluetoothService.isSearching) {
      await bluetoothService.scanForDevices();
    // }
  }


  @override
  Widget build(BuildContext context) {
    return Consumer<BluetoothService>(
      builder: (context, bluetoothService, child) {
      return Material(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 60,),
              ButtonBaseText(
                onPressed: () => turnBluetooth(bluetoothService),
                buttonText: bluetoothService.bluetoothState ? 'Turn Off Bluetooth' : 'Turn On Bluetooth',
                ),
              ButtonBaseText(
                onPressed: () => startScanning(bluetoothService),
                buttonText: 'Scan for Devices',
                ),
              // Expanded(
              //   child: ListView.builder(
              //     itemCount: bluetoothService.devices.length,
              //     itemBuilder: (context, index) {
              //       return ListTile(
              //         title: Text(bluetoothService.devices[index]),
              //       );
              //     },
              //   ),
              // ),
            ],
          ),
        ),
      );
    });
  }
}