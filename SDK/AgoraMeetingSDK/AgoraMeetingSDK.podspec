
Pod::Spec.new do |s|
  s.name             = 'AgoraMeetingSDK'
  s.version          = '1.0.2.1'
  s.summary          = 'A short description of AgoraMeetingSDK.'
  
  s.pod_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64', 'DEFINES_MODULE' => 'YES' }
  s.user_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64', 'DEFINES_MODULE' => 'YES' }
  
  s.homepage         = 'https://agora.io'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Agora Lab' => 'devlope@agora.io' }
  s.source           = { :git => 'https://github.com/AgoraIO-Usecase/AgoraMeeting-iOS.git', :tag => 'v_sdk_1.0.2.1' }
  s.ios.deployment_target = '11.0'
  s.source_files = 'SDK/AgoraMeetingSDK/AgoraMeetingSDK/MeetingSDK.swift'
  s.swift_versions = "5.0"
  s.dependency 'AgoraMeetingUI', '=> 1.0.2.1'
end



