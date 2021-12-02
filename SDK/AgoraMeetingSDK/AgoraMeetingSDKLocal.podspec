#
# Be sure to run `pod lib lint AgoraMeetingSDK.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'AgoraMeetingSDK'
  s.version          = '1.1.4'
  s.summary          = 'A short description of AgoraMeetingSDK.'
  
  s.description      = <<-DESC
  TODO: Add long description of the pod here.
  DESC
  
  s.homepage         = 'https://github.com/954468540@qq.com/AgoraMeetingSDK'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'zyp' => 'zhuyuping@agora.io' }
  s.source           = { :git => 'https://github.com/954468540@qq.com/AgoraMeetingSDK.git', :tag => s.version.to_s }
  s.ios.deployment_target = '11.0'
  s.source_files = 'AgoraMeetingSDK/**/*.{swift}'
  s.dependency 'AgoraMeetingUI'
  s.static_framework = true
end



