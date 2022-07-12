#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint flutter_honeywell_captuvo_plugin_nullsafe.podspec' to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'flutter_honeywell_captuvo_plugin_nullsafe'
  s.version          = '1.0.0'
  s.summary          = 'Nullsafe honeywell captuvo plugin.'
  s.description      = <<-DESC
Honeywell captuvo plugin.
                       DESC
  s.homepage         = 'https://github.com/dusanstanojeviccs/flutter_honeywell_captuvo_plugin_nullsafe'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Dusan Stanojevic' => 'dusan.stanojevic.cs@gmail.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.vendored_libraries = 'Classes/libCaptuvoSDK.a'
  s.dependency 'Flutter'
  s.platform = :ios, '8.0'

  # Flutter.framework does not contain a i386 slice. Only x86_64 simulators are supported.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'VALID_ARCHS[sdk=iphonesimulator*]' => 'x86_64' }
end
