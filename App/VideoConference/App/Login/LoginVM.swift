//
//  LoginVM.swift
//  VideoConference
//
//  Created by ZYP on 2021/2/14.
//  Copyright © 2021 agora. All rights reserved.
//

import UIKit
import AgoraMeetingCore
import AgoraMeetingSDK
import AgoraMeetingUI
import AgoraMeetingContext
import AgoraSceneStatistic

protocol LoginVMDelegate: NSObject {
    func loginVMDidFailEntryRoomWithTips(tips: String)
    func loginVMDidSuccessEntryRoomWithInfo(info: LoginVM.Info, nvc: AgoraMeetingUI)
    func loginVMShouldUpdateNetworkIcon(imageName: String)
    func loginVMShouldShowUpdateVersion()
    func loginVMShouldChangeJoinButtonEnable(enable: Bool)
    func loginVMShouldShowScoreVC()
}

class LoginVM: NSObject {
    weak var delegate: LoginVMDelegate?
    let currentUserId = StorageManager.uuid
    var sdk: MeetingSDK = MeetingSDK(config: .init(appId: KeyCenter.agoraAppid(),
                                                   logLevel: .info))
    let service = AgoraSceneStatistic()
    
    override init() {
        super.init()
        commonInit()
    }
    
    func commonInit() {
        sdk.networkQualityDelegate = self
        startNetworkTest()
    }
    
    func startNetworkTest() {
        sdk.enableNetQualityCheck()
    }
    
    func stopNetworkTest() {
        sdk.disableNetQualityCheck()
    }
    
    static func checkInputValid(userName: String,
                                roomPsd: String,
                                roomName: String) -> String? {
        
        if roomName.count == 0 {
            return NSLocalizedString("login_t0", comment: "")
        }
        if userName.count == 0 {
            return NSLocalizedString("login_t1", comment: "")
        }
        if roomName.count < 3 {
            return NSLocalizedString("login_t2", comment: "")
        }
        if roomName.count > 50 {
            return NSLocalizedString("login_t4", comment: "")
        }
        if userName.count <= 0 {
            return NSLocalizedString("login_t1", comment: "")
        }
        if userName.count < 3 {
            return NSLocalizedString("login_t3", comment: "")
        }
        if userName.count > 20 {
            return NSLocalizedString("login_t5", comment: "")
        }
        if roomPsd.count > 20 {
            return NSLocalizedString("login_t6", comment: "")
        }
        return nil
    }
    
    func entryRoom(info: Info) {
        let launchConfig = createLaunchConfig(info: info)
        sdk.exitRoomDelegate = self
        stopNetworkTest()
        sdk.launch(launchConfig: launchConfig) { [weak self](nvc) in
            StorageManager.roomName = info.roomName
            self?.delegate?.loginVMDidSuccessEntryRoomWithInfo(info: info,
                                                               nvc: nvc)
        } fail: { [weak self](error) in
            self?.delegate?.loginVMDidFailEntryRoomWithTips(tips: error.localizedMessage)
            self?.startNetworkTest()
        }
    }
    
    private func createLaunchConfig(info: Info) -> LaunchConfig {
        let duration = 45 * 60
        let appId = KeyCenter.agoraAppid()
        let rtmToken = TokenBuilder.buildToken(appId,
                                               appCertificate: KeyCenter.appCertificate(),
                                               userUuid: info.userId)
        let userInoutLimitNumber = StorageManager.inOutNotiRestrictedType.rawValue
        return LaunchConfig(userId: info.userId,
                            userName: info.userName,
                            roomId: info.roomId,
                            roomName: info.roomName,
                            roomPassword: info.password,
                            duration: duration,
                            maxPeople: 1000,
                            openCamera: info.enableVideo,
                            openMic: info.enableAudio,
                            token: rtmToken,
                            userInoutLimitNumber: userInoutLimitNumber,
                            localUserProperties: info.localUserProperties)
    }
    
    func signalImageName(type: NetworkQuality) -> String {
        switch type {
        case .excellent:
            return "signal_good"
        case .good:
            return "signal_bad"
        case .poor:
            return "signal_poor"
        default:
            return "signal_unknown"
        }
    }
    
    func checkUpdate() {
        guard let infoDict = Bundle.main.infoDictionary,
              let appVersion = (infoDict["CFBundleShortVersionString"] as? String) else {
            return
        }
        MeetingServerApi.host = host
        MeetingServerApi.checkUpdate(appVersion: appVersion,
                                     shouldUpdate: { [weak self] in
                                        self?.delegate?.loginVMShouldShowUpdateVersion()
                                     })
    }
    
    var host: String {
        return "https://api.agora.io"
    }
    
    func submitScore(score: ASScore) {
        service.context = AgoraSceneStatisticContext()
        service.context.os = "ios"
        service.context.device = getDeviceInfo() ?? "unknow"
        service.context.app = "Agora Meeting"
        service.context.useCase = "meeting"
        service.context.userId = "testUserId"
        service.context.sessionId = "testSessionId"
        let values = [AgoraUserRatingValue(type: .callQuality, value: CGFloat(score.value1)),
                      AgoraUserRatingValue(type: .functionCompleteness, value: CGFloat(score.value2)),
                      AgoraUserRatingValue(type: .generalExperience, value: CGFloat(score.value3))]
        service.userRating(values, comment: score.text) {
            
        } fail: { (code) in

        }
    }
    
    func getDeviceInfo() -> String? {
        var systemInfo = utsname()
        uname(&systemInfo)
        let platform = withUnsafePointer(to: &systemInfo.machine.0) { ptr in
            return String(cString: ptr)
        }
        guard let bundlePath = Bundle.main.path(forResource: "DeviceInfo", ofType: "plist"), let dicData = NSDictionary(contentsOfFile: bundlePath) else {
            return platform
        }
        guard let plat = dicData[platform] as? String else {
            return platform
        }
        return plat
    }
}

extension LoginVM {
    struct Info {
        let userName: String
        let roomName: String
        let password: String
        let enableVideo: Bool
        let enableAudio: Bool
        let userId: String
        let roomId: String
        let localUserProperties: UserProperties
    }
}

extension LoginVM: NetworkQualityDelegate {
    func networkQuailtyDidUpdate(quality: NetworkQuality) {
        let imageName = signalImageName(type: quality)
        invokeShouldUpdateNetworkIcon(imageName: imageName)
    }
}

extension LoginVM: ExitRoomDelegate {
    func onExit(cache: RoomCache) {
        startNetworkTest()
        invokeShouldShowScoreVC()
    }
}

extension LoginVM {
    func invokeShouldUpdateNetworkIcon(imageName: String) {
        if Thread.current.isMainThread {
            delegate?.loginVMShouldUpdateNetworkIcon(imageName: imageName)
            return
        }
        
        DispatchQueue.main.async { [weak self] in
            guard let `self` = self else { return }
            self.delegate?.loginVMShouldUpdateNetworkIcon(imageName: imageName)
        }
    }
    
    func invokeShouldShowScoreVC() {
        if Thread.current.isMainThread {
            delegate?.loginVMShouldShowScoreVC()
            return
        }
        
        DispatchQueue.main.async { [weak self] in
            guard let `self` = self else { return }
            self.delegate?.loginVMShouldShowScoreVC()
        }
    }
    
    
}
