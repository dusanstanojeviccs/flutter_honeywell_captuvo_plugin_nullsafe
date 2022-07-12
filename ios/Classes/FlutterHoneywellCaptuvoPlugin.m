#import "FlutterHoneywellCaptuvoPlugin.h"
#import "Captuvo.h"

@interface FlutterHoneywellCaptuvoPlugin () <FlutterStreamHandler, CaptuvoEventsProtocol>
@end

@implementation FlutterHoneywellCaptuvoPlugin {
  FlutterEventSink _eventSink;
}

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterHoneywellCaptuvoPlugin* instance = [[FlutterHoneywellCaptuvoPlugin alloc] init];

  FlutterMethodChannel* methodChannel = [FlutterMethodChannel methodChannelWithName:@"flutter_honeywell_captuvo_plugin_method_channel" binaryMessenger:[registrar messenger]];
  [registrar addMethodCallDelegate:instance channel:methodChannel];

  FlutterEventChannel* eventChannel = [FlutterEventChannel eventChannelWithName:@"flutter_honeywell_captuvo_plugin_event_channel" binaryMessenger:[registrar messenger]];
  [eventChannel setStreamHandler:instance];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"startDecoderHardware" isEqualToString:call.method]) {
    ProtocolConnectionStatus status = [[Captuvo sharedCaptuvoDevice] startDecoderHardware];
    NSString* statusIndex = [NSString stringWithFormat:@"%d", status];
    result(statusIndex);
  } else if ([@"stopDecoderHardware" isEqualToString:call.method]) {
    [[Captuvo sharedCaptuvoDevice] stopDecoderHardware];
  } else if ([@"startDecoderScanning" isEqualToString:call.method]) {
    [[Captuvo sharedCaptuvoDevice] startDecoderScanning];
  } else if ([@"stopDecoderScanning" isEqualToString:call.method]) {
    [[Captuvo sharedCaptuvoDevice] stopDecoderScanning];
  } else {
    result(FlutterMethodNotImplemented);
  }
}

#pragma mark FlutterStreamHandler impl

- (FlutterError*)onListenWithArguments:(id)arguments eventSink:(FlutterEventSink)eventSink {
  _eventSink = eventSink;
  [[Captuvo sharedCaptuvoDevice] addCaptuvoDelegate:self];
  return nil;
}

- (FlutterError*)onCancelWithArguments:(id)arguments {
  [[Captuvo sharedCaptuvoDevice] removeCaptuvoDelegate:self];
  _eventSink = nil;
  return nil;
}

#pragma mark CaptuvoEventsProtocol impl

- (void)captuvoConnected {
  if (!_eventSink) return;

  _eventSink(@"{\"event\": \"connection\", \"isConnected\": true}");
}

- (void)captuvoDisconnected {
  if (!_eventSink) return;

  _eventSink(@"{\"event\": \"connection\", \"isConnected\": false}");
}

- (void)decoderDataReceived:(NSString*) data {
  if (!_eventSink) return;

  _eventSink([NSString stringWithFormat:@"{\"event\": \"dataReceived\", \"data\": \"%@\"}", data]);
}

@end
