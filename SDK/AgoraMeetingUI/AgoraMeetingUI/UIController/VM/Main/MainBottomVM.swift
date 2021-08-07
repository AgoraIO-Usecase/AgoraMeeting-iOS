//
//  MainBottomVM.swift
//  AgoraMeetingUI
//
//  Created by ZYP on 2021/6/4.
//

import Foundation
import AgoraMeetingContext

protocol MainBottomVMDelegate: NSObject {
    func mainBottomVM(vm: MainBottomVM,
                      device: DeviceType,
                      shouldUpdateDeviceItem enable: Bool)
    func mainBottomVM(vm: MainBottomVM,
                      device: DeviceType,
                      didLocalDeviceStateChange state: LocalDeviceState,
                      timeCount: Int)
    func mainBottomVMShouldAllowUserInteraction(vm: MainBottomVM)
    func mainBottomVMShouldShowApproveAlter(vm: MainBottomVM,
                                            device: DeviceType)
    func mainBottomVMShouldShowMoreSheet(vm: MainBottomVM,
                                         moreInfo: MainBottomVM.MoreInfo)
    func mainBottomVMShouldShowRedDot(vm: MainBottomVM,
                                      count: Int)
}

class MainBottomVM: BaseVM {
    private let mediaContext: MediaContext
    private let roomContext: RoomContext
    private let boardContext: BoardContext
    private let usersContext: UsersContext
    private let screenContext: ScreenContext
    private let messageContext: MessagesContext
    private var calculateMessageRedDot = true
    weak var delegate: MainBottomVMDelegate?
    var chatMessageCurrentReadCount = 0
    var needUpdateChatMessageUnreadCount = true
    
    init(mediaContext: MediaContext,
         roomContext: RoomContext,
         boardContext: BoardContext,
         usersContext: UsersContext,
         screenContext: ScreenContext,
         messageContext: MessagesContext) {
        self.mediaContext = mediaContext
        self.roomContext = roomContext
        self.boardContext = boardContext
        self.usersContext = usersContext
        self.screenContext = screenContext
        self.messageContext = messageContext
        super.init()
        setup()
        commonInit()
    }
    
    deinit {
        roomContext.unregisterEventHandler(self)
        mediaContext.unregisterEventHandler(self)
        messageContext.unregisterEventHandler(self)
        Log.info(text: "MainBottomVM",
                 tag: "deinit")
    }
    
    func setup() {}
    
    func commonInit() {
        mediaContext.registerEventHandler(self)
        roomContext.registerEventHandler(self)
        messageContext.registerEventHandler(self)
        checkUserInteraction()
    }
    
    var localCameraState: LocalDeviceState {
        mediaContext.getLocalDeviceState(device: .camera)
    }
    
    var localMicState: LocalDeviceState {
        mediaContext.getLocalDeviceState(device: .mic)
    }
    
    func openLocalDevice(device: DeviceType,
                         mustApprove: Bool = false) {
        if !mustApprove {
            let permission = mediaContext.checkDevicePermission(device: device)
            if permission == .approveNeed {
                invokeMianBottomVMShouldShowApproveAlter(device: device)
                return
            }
        }
        invokeMainBottomVM(device: device,
                           shouldUpdateDeviceItem: false)
        mediaContext.openLocalDevice(device: device) { [weak self]() in
            guard let `self` = self else { return }
            self.invokeMainBottomVM(device: device,
                                    shouldUpdateDeviceItem: true)
        } fail: { [weak self](error) in
            guard let `self` = self else { return }
            self.invokeShouldShowTip(text: error.localizedMessage)
            self.invokeMainBottomVM(device: device,
                               shouldUpdateDeviceItem: true)
        }
    }
    
    func closeDevice(device: DeviceType) {
        invokeMainBottomVM(device: device,
                           shouldUpdateDeviceItem: false)
        mediaContext.closeLocalDevice(device: device) { [weak self]() in
            guard let `self` = self else { return }
            self.invokeMainBottomVM(device: device,
                                    shouldUpdateDeviceItem: true)
        } fail: { [weak self](error) in
            guard let `self` = self else { return }
            self.invokeShouldShowTip(text: error.localizedMessage)
            self.invokeMainBottomVM(device: device,
                               shouldUpdateDeviceItem: true)
        }
    }
    
    func closeAllCamera(shouldApply: Bool) {
        let userId = usersContext.getLocalUserInfo().userId
        usersContext.dealUserOperation(userId: userId,
                                       operation: .closeAllCamera,
                                       success: {},
                                       fail: { [weak self](error) in
                                        self?.invokeShouldShowTip(text: error.localizedMessage)
                                       })
        if shouldApply {
            roomContext.changeUserPermission(deviceType: .camera,
                                             access: false,
                                             success: {},
                                             fail: {_ in})
        }
    }
    
    func closeAllMic(shouldApply: Bool) {
        let userId = usersContext.getLocalUserInfo().userId
        usersContext.dealUserOperation(userId: userId,
                                       operation: .closeAllMic,
                                       success: {},
                                       fail: { [weak self](error) in
                                        self?.invokeShouldShowTip(text: error.localizedMessage)
                                       })
        if shouldApply {
            roomContext.changeUserPermission(deviceType: .mic,
                                             access: false,
                                             success: {},
                                             fail: {_ in})
        }
    }
    
    /// message RedDot Should Calculated when new message has come
    func messageRedDotShouldCalculated(count: Int) {
        if needUpdateChatMessageUnreadCount,
           count > chatMessageCurrentReadCount {
            let gap = count - chatMessageCurrentReadCount
            invokeMainBottomVMShouldShowRedDot(count: gap)
        }
        else {
            chatMessageCurrentReadCount = count
            invokeMainBottomVMShouldShowRedDot(count: 0)
        }
    }
    
    private func checkUserInteraction() {
        let state = roomContext.getRoomJoinState()
        if state == .joinSuccess {
            invokeMainBottomVMShouldAllowUserInteraction()
        }
    }
    
    func genMoreInfo() {
        let localIsHost = usersContext.getLocalUserInfo().userRole == .host
        let canCloseAllAudio = localIsHost
        let canCloseAllVideo = localIsHost
        let canStartScreen = !screenContext.isScreenSharing()
        let canEndScreen = screenContext.isScreenSharing() && screenContext.isScreenSharingByMyself()
        let info = MainBottomVM.MoreInfo(canCloseAllAudio: canCloseAllAudio,
                                         canCloseAllVideo: canCloseAllVideo,
                                         canStartScreen: canStartScreen,
                                         canEndScreen: canEndScreen)
        invokeMianBottomVMShouldShowMoreSheet(moreInfo: info)
    }
    
    func startBoard() {
        boardContext.openBoardSharing {
            
        } fail: { [weak self](error) in
            self?.invokeShouldShowTip(text: error.localizedMessage)
        }
    }
    
    func setMessageRedDotHandle(needUpdate: Bool) {
        needUpdateChatMessageUnreadCount = needUpdate
        if !needUpdate {
            chatMessageCurrentReadCount = messageContext.getChatMessages().count
            invokeMainBottomVMShouldShowRedDot(count: 0)
        }
    }
    
    func copyShareInfo() {
        let roomName = roomContext.getRoomInfo().roomName
        let invitedName = usersContext.getLocalUserInfo().userName
        let psd = roomContext.getRoomInfo().roomPwd
        let info = ShareInfo(roomName: roomName, invitedName: invitedName, psd: psd)
        let pasteboard = UIPasteboard.general
        let webLink = "https://solutions.agora.io/meeting/web"
        let androidLink = "https://agora-adc-artifacts.oss-cn-beijing.aliyuncs.com/apk/app-AgoraMeeting.apk"
        let iOSLink = "https://apps.apple.com/cn/app/agora-meeting/id1515428313"
        var str = ""
        let roomNameInd = MeetingUILocalizedString("invite_t1")
        let roomPsdInd = MeetingUILocalizedString("invite_t2")
        let invitedInd = MeetingUILocalizedString("invite_t3")
        let webInd = MeetingUILocalizedString("invite_t4")
        let androidInd = MeetingUILocalizedString("invite_t5")
        let iOSInd = MeetingUILocalizedString("invite_t6")
        str += roomNameInd + info.roomName
        str += "\n"
        str += roomPsdInd + info.psd
        str += "\n"
        str += invitedInd + info.invitedName
        str += "\n"
        str += webInd + webLink
        str += "\n"
        str += androidInd + androidLink
        str += "\n"
        str += iOSInd + iOSLink
        pasteboard.string = str
        
        invokeShouldShowTip(text: MeetingUILocalizedString("meeting_t51"))
    }
}

extension MainBottomVM: MediaEventHandler {
    func onLocalAudioRouteUpdated(route: AudioRoute) {}
    
    func onLocalDeviceStateUpdated(device: DeviceType,
                                   state: LocalDeviceState,
                                   time: Int) {
        Log.info(text: "\(device)-\(state)-\(time)",
                 tag: "MainBottomVM")
        invokeMainBottomVM(device: device,
                           didLocalDeviceStateChange: state,
                           timeCount: time)
    }
}

extension MainBottomVM: RoomEventHandler {
    func onRoomJoined(state: RoomJoinState) {
        checkUserInteraction()
    }
    
    func onRoomClosed(reason: RoomClosedReason) {}
    func onUserPermissionUpdated(device: DeviceType,
                                 access: Bool) {}
}

extension MainBottomVM: MessagesEventHandler {
    func onChatMessagesUpdated(msgs: [ChatMessage]) {
        messageRedDotShouldCalculated(count: msgs.count)
    }
    
    func onNotifyMessagesUpdated(msgs: [NotifyMessage]) {}
}


extension MainBottomVM { /** info **/
    struct MoreInfo {
        let canCloseAllAudio: Bool
        let canCloseAllVideo: Bool
        let canStartScreen: Bool
        let canEndScreen: Bool
    }
    
    struct ShareInfo {
        let roomName: String
        let invitedName: String
        let psd: String
        let link = "https://videocall.agora.io/#/391830718"
    }
}



