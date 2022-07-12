import 'dart:async';

import 'package:flutter/material.dart';

import 'package:flutter_honeywell_captuvo_plugin_nullsafe/flutter_honeywell_captuvo_plugin_nullsafe.dart';

void main() => runApp(MaterialApp(home: MyApp()));

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  StreamSubscription decoderConnectionStreamSubscription;
  StreamSubscription decoderScanDataStreamSubscription;

  @override
  void initState() {
    super.initState();
    FlutterHoneywellCaptuvoPlugin.startDecoderHardware();
    decoderConnectionStreamSubscription = FlutterHoneywellCaptuvoPlugin
        .decoderConnectionStream
        .listen((isConnected) {
      _showMyDialog("Connection event received changed");

      if (isConnected) {
        FlutterHoneywellCaptuvoPlugin.startDecoderHardware();
      }
    });

    decoderScanDataStreamSubscription =
        FlutterHoneywellCaptuvoPlugin.decoderScanDataStream.listen((barcode) {
      _showMyDialog("Barcode: " + barcode);
    });
  }

  @override
  void dispose() {
    decoderConnectionStreamSubscription?.cancel();
    decoderScanDataStreamSubscription?.cancel();
    super.dispose();
  }

  Future<void> _showMyDialog(String message) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('AlertDialog Title'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(message),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Approve'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Captuvo SL42 API Example'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              StreamBuilder<bool>(
                stream: FlutterHoneywellCaptuvoPlugin.decoderConnectionStream,
                initialData: false,
                builder: (_, snapshot) => Text(
                    'Decoder is ${snapshot.data ? "Conencted" : "Disconnected"}'),
              ),
              const SizedBox(height: 10.0),
              StreamBuilder<String>(
                stream: FlutterHoneywellCaptuvoPlugin.decoderScanDataStream,
                initialData: "NONE",
                builder: (_, snapshot) =>
                    Text('Last scan data: ${snapshot.data}'),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: GestureDetector(
        child: Container(
          height: 100.0,
          width: 100.0,
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(50.0),
          ),
          child: Icon(Icons.scanner),
        ),
        onTapDown: (_) => FlutterHoneywellCaptuvoPlugin.startDecoderScanning(),
        onTapUp: (_) => FlutterHoneywellCaptuvoPlugin.stopDecoderScanning(),
      ),
    );
  }
}
