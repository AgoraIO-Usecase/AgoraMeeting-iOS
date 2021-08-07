#
# Be sure to run `pod lib lint AgoraMeetingSDK.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'AgoraMeetingSDK'
  s.version          = '0.0.1'
  s.summary          = 'A short description of AgoraMeetingSDK.'
  
  s.pod_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64', 'DEFINES_MODULE' => 'YES' }
  s.user_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64', 'DEFINES_MODULE' => 'YES' }
  
  s.homepage         = 'https://agora.io'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Agora Lab' => 'devlope@agora.io' }
  s.source           = { :git => 'https://github.com/AgoraIO-Usecase/AgoraMeeting-iOS.git', :tag => 'v_sdk_0.0.1' }
  s.ios.deployment_target = '11.0'
  s.source_files = 'SDK/AgoraMeetingSDK/AgoraMeetingSDK/**/*.{swift}'
  s.static_framework = true
  s.swift_versions = "5.0"
  s.dependency 'AgoraMeetingUI'
end



