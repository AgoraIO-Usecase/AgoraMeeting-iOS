#
# Be sure to run `pod lib lint AgoraMeetingUI.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'AgoraMeetingUI'
  s.version          = '1.1.5'
  s.summary          = 'AgoraMeetingUI'
  
  s.description      = <<-DESC
  TODO: Add long description of the pod here.
  DESC
  
  s.homepage         = 'https://github.com/zyp/AgoraMeetingUI'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'ZYP' => 'zhuyuping@agora.io' }
  s.source           = { :git => 'https://github.com/zyp/AgoraMeetingUI.git', :tag => s.version.to_s }
  
  s.ios.deployment_target = '11.0'
  s.source_files = 'AgoraMeetingUI/**/*.{h,m,swift}'
  s.resource_bundles = {
    'AgoraMeetingUI' => ['AgoraMeetingUI/Assets/Image/*.xcassets', 'AgoraMeetingUI/Assets/Xib/**/*', 'AgoraMeetingUI/Assets/Localizable/*.lproj/*.strings', 'AgoraMeetingUI/Assets/Other/*']
  }
  s.dependency 'AgoraMeetingCore_iOS', '1.1.5'
  s.dependency 'Presentr'
  s.dependency 'Whiteboard'
  s.dependency 'Toast-Swift'
  s.dependency 'AgoraLog'
  s.dependency 'DifferenceKit'
end
