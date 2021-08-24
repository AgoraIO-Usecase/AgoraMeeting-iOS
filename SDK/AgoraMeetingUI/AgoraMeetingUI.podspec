Pod::Spec.new do |s|
  s.name             = 'AgoraMeetingUI'
  s.version          = '1.0.2'
  s.summary          = 'AgoraMeetingUI'
  s.homepage         = 'https://agora.io'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Agora Lab' => 'develope@agora.io' }
  s.source           = { :git => 'https://github.com/AgoraIO-Usecase/AgoraMeeting-iOS.git', :tag => 'v_ui_1.0.2' }
  s.pod_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64', 'DEFINES_MODULE' => 'YES' }
  s.user_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64', 'DEFINES_MODULE' => 'YES' }
  s.ios.deployment_target = '11.0'
  s.source_files = 'SDK/AgoraMeetingUI/AgoraMeetingUI/**/*.{h,m,swift}'
  s.resource_bundles = {
    'AgoraMeetingUI' => ['SDK/AgoraMeetingUI/AgoraMeetingUI/Assets/Image/*.xcassets', 'SDK/AgoraMeetingUI/AgoraMeetingUI/Assets/Xib/**/*', 'SDK/AgoraMeetingUI/AgoraMeetingUI/Assets/Localizable/*.lproj/*.strings', 'AgoraMeetingUI/Assets/Other/*']
  }
  s.swift_versions = "5.0"
  s.dependency 'Presentr'
  s.dependency 'Toast-Swift'
  s.dependency 'DifferenceKit'
  s.dependency 'AgoraMeetingCore_iOS', '1.0.2'
end
