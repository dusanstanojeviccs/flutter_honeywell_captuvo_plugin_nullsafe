library flutter_honeywell_captuvo_plugin_nullsafe;

import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';

enum ProtocolConnectionStatus {
  protocolConnectionStatusConnected, // A successful connection was made
  protocolConnectionStatusAlreadyConnected, // The protocol is already connected
  protocolConnectionStatusBatteryDepleted, // The protocol is unable to be connected due to low battery
  protocolConnectionStatusUnableToConnectIncompatibleSledFirmware, // The protocol was unable to be connected due to an error
  protocolConnectionStatusUnableToConnect, // The protocol was unable to be connected due to an error
  protocolConnectionUnableToConnectNOAccessary, // Protocol connection fail, the Sled was not connected to apple device
  protocolConnectionUnableToConnectNOProtocal, // does not recognize the specified protocol or there was no corressponding Protocal defined in plist or there was an error communicating with the SLed.

  notSupported,
  error,
}

class FlutterHoneywellCaptuvoPlugin {
  static const MethodChannel _methodChannel =
      MethodChannel('flutter_honeywell_captuvo_plugin_method_channel');
  static const EventChannel _eventChannel =
      EventChannel('flutter_honeywell_captuvo_plugin_event_channel');
  static Stream<Map<String, dynamic>>? _eventStrem;

  /// This method is used to turn on the decoder hardware in the device.
  ///
  /// It will retry to turn on the decoder hardware every 250ms until
  /// success or timeout. This must be called before any other decoder
  /// methods. Until this method is called the decoder hardware is not
  /// initialized. Use [stopDecoderHarware] to shut down the decoder
  /// hardware.
  /// This method will always return [ProtocolConnectionStatus.notSupported]
  /// if called on android.
  static Future<ProtocolConnectionStatus> startDecoderHardware() async {
    final String statusIndex =
        await _methodChannel.invokeMethod('startDecoderHardware');
    return ProtocolConnectionStatus.values[int.tryParse(statusIndex) ??
        (ProtocolConnectionStatus.values.length - 1)];
  }

  /// This method is used to turn off the decoder hardware in the device.
  ///
  /// Once this method is called the decoder hardware is deactivated.
  /// No scanning methods can be called until [startDecoderHardware]
  /// is called again to re-initialize the decoder hardware.
  static Future<void> stopDecoderHardware() async {
    await _methodChannel.invokeMethod('stopDecoderHardware');
  }

  /// This method starts scanning for a qr/barcode.
  ///
  /// This method will start the qr/barcode scanning in the same way
  /// as pressing the hardware scan button on the device, the scanner
  /// will search for a barcode until either it finds one, time-outs
  /// or the [stopDecoderScanning] method is called.
  static Future<void> startDecoderScanning() async {
    await _methodChannel.invokeMethod('startDecoderScanning');
  }

  /// This method stops active scanning.
  ///
  /// This method can be used to stop the scanner after
  /// [startDecoderScanning] was called. If the device is not
  /// currently scanning this will have no effect.
  static Future<void> stopDecoderScanning() async {
    await _methodChannel.invokeMethod('stopDecoderScanning');
  }

  static Stream<Map<String, dynamic>> get _decoderEventStream {
    return (_eventStrem ??=
        _eventChannel.receiveBroadcastStream().map((msg) => jsonDecode(msg)));
  }

  /// This stream reports the connection status of the scanner device.
  ///
  /// After the device is initialized via [startDecoderHardware], this
  /// stream will report on its connection status, [false] will be
  /// dispatched when the device is disconnectead and [true] on
  /// reconnection.
  static Stream<bool> get decoderConnectionStream => _decoderEventStream
      .where((msg) => msg["event"] == "connection")
      .map((msg) => msg["isConnected"]);

  /// This stream reports the data (qr/barcode values) scanned by the device.
  ///
  /// After the device is initialized via [startDecoderHardware] and if
  /// it is currently scanning ([startDecoderScanning] or hardware button),
  /// this stream will report any scanned data.
  static Stream<String> get decoderScanDataStream => _decoderEventStream
      .where((msg) => msg["event"] == "dataReceived")
      .map((msg) => msg["data"]);
}
