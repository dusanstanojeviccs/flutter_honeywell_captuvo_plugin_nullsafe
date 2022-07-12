Important: This package is based on the flutter_honeywell_captuvo_plugin that can be found at https://github.com/entegyopensource/flutter_honeywell_captuvo_plugin written by @entegyopensource.

The goal of this repository is to add null safety, update the documentation for the project and to allow usage in modern flutter applications.

# Flutter Honeywell Captuvo Plugin
Flutter wrapper for the Honeywell Captuvo SL22/42 iOS API with null safety.

## Usage

Make sure you have the following added into the `ios/Info.plist`:
```
	<key>UISupportedExternalAccessoryProtocols</key>
	<array>
		<string>com.honeywell.scansled.protocol.decoder</string>
	</array>
```

There is only one main import that you should add into your dart files:
`import 'package:flutter_honeywell_captuvo_plugin/flutter_honeywell_captuvo_plugin.dart';`

To use the SL22 or SL42 device we have to make sure we start it by calling:
`FlutterHoneywellCaptuvoPlugin.startDecoderHardware();`

To get notified when the connection occurs we can use `decoderConnectionStream` here is a full example:
```
class _MyAppState extends State<MyApp> {
  StreamSubscription decoderConnectionStreamSubscription;

  @override
  void initState() {
    super.initState();
    FlutterHoneywellCaptuvoPlugin.startDecoderHardware();
    decoderConnectionStreamSubscription = FlutterHoneywellCaptuvoPlugin
        .decoderConnectionStream
        .listen((isConnected) {
      if (isConnected) {
        FlutterHoneywellCaptuvoPlugin.startDecoderHardware();
      }
    });
  }

  @override
  void dispose() {
    decoderConnectionStreamSubscription?.cancel();
    super.dispose();
  }
}
```

The last step is to get notified of barcode scanning changes:
```
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
      if (isConnected) {
        FlutterHoneywellCaptuvoPlugin.startDecoderHardware();
      }
    });

    decoderScanDataStreamSubscription = FlutterHoneywellCaptuvoPlugin
        .decoderScanDataStream
        .listen((barcode) {
      print(barcode);
    });
  }

  @override
  void dispose() {
    decoderConnectionStreamSubscription?.cancel();
    decoderScanDataStreamSubscription?.cancel();
    super.dispose();
  }
}
```

See the provided example app for more.
