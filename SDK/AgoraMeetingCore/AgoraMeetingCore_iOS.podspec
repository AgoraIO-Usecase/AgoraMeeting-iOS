Pod::Spec.new do |spec|
spec.name         = "AgoraMeetingCore_iOS"
spec.version      = "1.1.5"
spec.summary      = "AgoraMeetingCore"
spec.description  = "Agora Meeting Core"

spec.homepage     = "https://agora.io"
spec.license      = "MIT"
spec.author       = { "Agora Lab" => "developer@agora.io" }
spec.platform = :ios
spec.ios.deployment_target = "10.0"
spec.swift_versions = "5.0"
spec.source = { :http => 'https://download.agora.io/sdk/release/AgoraMeetingCore-1.1.5-1-20211201.zip', :sha1 => '6844f5b7ccfa44e9f30f1297130694105b33d74c' }
spec.pod_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64', 'DEFINES_MODULE' => 'YES' }
spec.user_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64', 'DEFINES_MODULE' => 'YES' }

spec.default_subspec = 'All'
spec.subspec 'All' do |fwSpec|
    fwSpec.source_files = [
      "Frameworks/Dummy.swift"
    ]
    fwSpec.vendored_frameworks = [
      "Frameworks/*.framework"
    ]
    fwSpec.dependency 'AgoraLog', '1.0.2'
    fwSpec.dependency 'DifferenceKit'
    fwSpec.dependency 'Armin', '1.0.6'
    fwSpec.dependency 'AgoraLog', '1.0.2'
    fwSpec.dependency 'YYModel', '1.0.4'
    fwSpec.dependency 'AgoraRtm_iOS', '1.4.8'
    fwSpec.dependency 'AgoraRtcEngine_iOS', '3.4.5'
    fwSpec.dependency 'SSZipArchive', '2.2.3'
    fwSpec.dependency 'AliyunOSSiOS', '2.10.8'
    fwSpec.dependency 'AFNetworking', '4.0.1'
    fwSpec.dependency 'CocoaLumberjack', '3.6.2'
    fwSpec.dependency 'Whiteboard', '2.12.28'
    fwSpec.dependency 'HyphenateChat'
end

spec.subspec 'Context' do |cSpec|
    cSpec.source_files = [
      "Frameworks/Dummy.swift"
    ]
    cSpec.vendored_frameworks = [
      "Frameworks/AgoraMeetingContext.framework",
    ]
end

end
