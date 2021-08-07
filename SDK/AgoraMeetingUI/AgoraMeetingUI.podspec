Pod::Spec.new do |s|
  s.name             = 'AgoraMeetingUI'
  s.version          = '0.0.1'
  s.summary          = 'AgoraMeetingUI'
  s.homepage         = 'https://agora.io'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Agora Lab' => 'develope@agora.io' }
  s.source           = { :git => 'https://github.com/AgoraIO-Usecase/AgoraMeeting-iOS.git', :tag => 'v_ui_0.0.1' }
  
  s.ios.deployment_target = '11.0'
  s.source_files = 'AgoraMeetingUI/**/*.{h,m,swift}'
  s.resource_bundles = {
    'AgoraMeetingUI' => ['AgoraMeetingUI/Assets/Image/*.xcassets', 'AgoraMeetingUI/Assets/Xib/**/*', 'AgoraMeetingUI/Assets/Localizable/*.lproj/*.strings', 'AgoraMeetingUI/Assets/Other/*']
  }

  s.dependency 'Presentr'
  s.dependency 'Toast-Swift'
  s.dependency 'AgoraLog'
  s.dependency 'DifferenceKit'
  s.dependency 'AgoraMeetingCore_iOS'
end
