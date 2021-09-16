//
//  SettingVM.swift
//  AgoraMeetingUI
//
//  Created by ZYP on 2021/6/17.
//

import Foundation
import AgoraMeetingContext

protocol SettingVMDelegate: NSObject {
    func settingVMDidUpdateInfo(info: SettingView.Info)
}

class SettingVM: BaseVM {
    typealias Info = SettingView.Info
    let roomContext: RoomContext
    let platformContext: PlatformContext
    let messageContext: MessagesContext
    let userContext: UsersContext
    weak var delegate: SettingVMDelegate?
    private var info: Info = .empty
    
    init(roomContext: RoomContext,
         platformContext: PlatformContext,
         messageContext: MessagesContext,
         userContext: UsersContext) {
        self.roomContext = roomContext
        self.platformContext = platformContext
        self.messageContext = messageContext
        self.userContext = userContext
        super.init()
        commonInit()
    }
    
    func commonInit() {
        roomContext.registerEventHandler(self)
    }
    
    deinit {
        roomContext.unregisterEventHandler(self)
        Log.info(text: "SettingVM",
                 tag: "deinit")
    }
    
    func start() {
        update()
    }
    
    func update() {
        info = createInfo()
        invokeUpdate(info: info)
    }
    
    func updateForRequestting(shouldApply: Bool,
                              device: DeviceType) {
        let temp = createInfoForRequesting(shouldApply: shouldApply,
                                           device: device)
        invokeUpdate(info: temp)
    }
    
    func createInfo() -> Info {
        let room = roomContext.getRoomInfo()
        let localUserInfo = userContext.getLocalUserInfo()
        let roomName = room.roomName
        let roomPsd = room.roomPwd
        let userName = localUserInfo.userName
        let roleName = localUserInfo.userRole == .host ? MeetingUILocalizedString("set_t3", comment: "") : MeetingUILocalizedString("set_t15", comment: "")
        let headImageName = String.headImageName(userName: userName.md5())
        let micAccess = roomContext.hasMicAccess()
        let cameraAccess = roomContext.hasCameraAccess()
        let videoPermissionEnable = localUserInfo.userRole == .host
        let audioPermissionEnable = localUserInfo.userRole == .host
        let inOutNotiRestrictedName = InOutNotiRestrictedType(rawValue: messageContext.getUserInOutNotificationLimitCount())!.description
        return Info(roomName: roomName,
                    roomPsd: roomPsd,
                    userName: userName,
                    roleName: roleName,
                    headImageName: headImageName,
                    openVideoShoudApprove: !cameraAccess,
                    openAudioShoudApprove: !micAccess,
                    videoPermissionEnable: videoPermissionEnable,
                    audioPermissionEnable: audioPermissionEnable,
                    inOutNotiRestrictedName: inOutNotiRestrictedName,
                    isUploading: false)
    }
    
    func createInfoForRequesting(shouldApply: Bool,
                                 device: DeviceType) -> Info {
        var info = createInfo()
        switch device {
        case .camera:
            info.openVideoShoudApprove = shouldApply
            break
        case .mic:
            info.openAudioShoudApprove = shouldApply
            break
        }
        info.audioPermissionEnable = false
        info.videoPermissionEnable = false
        return info
    }
    
    func setInOutNotiRestrictedType(type: InOutNotiRestrictedType) {
        info.inOutNotiRestrictedName = type.description
        invokeUpdate(info: info)
        messageContext.setUserInOutNotificationLimitCount(count: type.rawValue)
    }
    
    var currentInOutNotiRestrictedType: InOutNotiRestrictedType {
        return InOutNotiRestrictedType(rawValue: messageContext.getUserInOutNotificationLimitCount())!
    }
    
    func changeUserPermission(shouldApply: Bool,
                              device: DeviceType) {
        updateForRequestting(shouldApply: shouldApply,
                             device: device)
        roomContext.changeUserPermission(deviceType: device,
                                         access: !shouldApply,
                                         success: { [weak self] in
                                            self?.updatePermission(device: device,
                                                                   access: !shouldApply)
                                            self?.updateEnable(device: device,
                                                               enable: true)
                                         },
                                         fail: { [weak self](error) in
                                            self?.invokeShouldShowTip(text: error.localizedMessage)
                                            self?.update()
                                         })
    }
    
    func invokeUpdate(info: Info) {
        if Thread.current.isMainThread {
            delegate?.settingVMDidUpdateInfo(info: info)
            return
        }
        
        DispatchQueue.main.async { [weak self] in
            self?.delegate?.settingVMDidUpdateInfo(info: info)
        }
    }
    
    func updatePermission(device: DeviceType,
                          access: Bool) {
        switch device {
        case .camera:
            info.openVideoShoudApprove = !access
            break
        case .mic:
            info.openAudioShoudApprove = !access
            break
        }
    }
    
    func updateEnable(device: DeviceType,
                      enable: Bool) {
        switch device {
        case .camera:
            info.videoPermissionEnable = enable
            break
        case .mic:
            info.audioPermissionEnable = enable
            break
        }
        invokeUpdate(info: info)
    }
    
    func updateUpload(isUpload: Bool) {
        info.isUploading = isUpload
        invokeUpdate(info: info)
    }
    
    func uploadLog() {
        guard !info.isUploading else {
            return
        }
        updateUpload(isUpload: true)
        platformContext.uploadLog { [weak self](logId) in
            guard let `self` = self else { return }
            self.updateUpload(isUpload: false)
            self.invokeShouldShowTip(text: MeetingUILocalizedString("set_t21", comment: ""))
            Log.info(text: "\(logId)", tag: "logId")
        } fail: { [weak self](error) in
            guard let `self` = self else { return }
            self.updateUpload(isUpload: false)
            if error.code == -1 {
                let msg = MeetingUILocalizedString("set_t22", comment: "")
                self.invokeShouldShowTip(text: msg)
            }
            else {
                self.invokeShouldShowTip(text: error.localizedMessage)
            }
        }
    }
}

extension SettingVM: RoomEventHandler {
    func onRoomJoined(state: RoomJoinState) {}
    
    func onRoomClosed(reason: RoomClosedReason) {}
    
    func onUserPermissionUpdated(device: DeviceType,
                                 access: Bool) {
        updatePermission(device: device,
                         access: access)
    }
    
    func onFlexRoomPropertiesChanged(properties: RoomProperties) {
        Log.debug(text: properties.description)
    }
}
