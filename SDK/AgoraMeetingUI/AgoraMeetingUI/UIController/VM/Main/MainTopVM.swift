//
//  MainTopVM.swift
//  AgoraMeetingUI
//
//  Created by ZYP on 2021/6/4.
//

import Foundation
import AgoraMeetingContext

protocol MainTopVMDelegate: NSObject {
    func mainTopVMShouldAllowUserInteraction(vm: MainTopVM)
    func mainTopVMShouldStartTime(vm: MainTopVM)
    func mainTopVMShouldStopTime(vm: MainTopVM)
    func mainTopVMDidChangeAudioRouteType(vm: MainTopVM,
                                          type: MeetingTopViewAudioType)
    func mainTopVMDidJoinRoom(vm: MainTopVM,
                              state: RoomJoinState)
    func mainTopVMShouldShowExitView(vm: MainTopVM,
                                     types: [MainTopVM.ExitItemType])
    func mainTopVMDidExitRoom(vm: MainTopVM,
                              type: MainTopVM.ExitType)
    func mainTopVMShouldShowCloseScreenAlert(vm: MainTopVM)
    func mainTopVMShouldShowCloseBoardAlert(vm: MainTopVM)
}

class MainTopVM: BaseVM {
    weak var delegate:MainTopVMDelegate?
    private let roomContext: RoomContext
    private let mediaContext: MediaContext
    private let boardContext: BoardContext
    private let screenContext: ScreenContext
    private let usersContext: UsersContext
    
    init(roomContext: RoomContext,
         mediaContext: MediaContext,
         boardContext: BoardContext,
         screenContext: ScreenContext,
         usersContext: UsersContext) {
        self.roomContext = roomContext
        self.mediaContext = mediaContext
        self.boardContext = boardContext
        self.screenContext = screenContext
        self.usersContext = usersContext
        super.init()
        setup()
        commonInit()
    }
    
    deinit {
        roomContext.unregisterEventHandler(self)
        mediaContext.unregisterEventHandler(self)
        Log.info(text: "MainTopVM",
                 tag: "deinit")
    }
    
    private func setup() {}
    
    private func commonInit() {
        roomContext.registerEventHandler(self)
        mediaContext.registerEventHandler(self)
        usersContext.registerEventHandler(self)
        checkUserInteraction()
    }
    
    var roomName: String {
        roomContext.getRoomInfo().roomName
    }
    
    var isRoomJoined: Bool {
        roomContext.getRoomJoinState() == .joinSuccess
    }
    
    var startTimeStamp: Int64 {
        roomContext.getRoomInfo().startTime
    }
    
    func switchLocalCamera() {
        let e = mediaContext.switchLocalCamera()
        if let error = e {
            Log.info(text: error.message,
                     tag: "switchLocalCamera")
        }
    }
    
    func genExitTypes() {
        if screenContext.isScreenSharingByMyself() {
            delegate?.mainTopVMShouldShowCloseScreenAlert(vm: self)
            return
        }
        
        if boardContext.getBoardPermission() == .admin {
            delegate?.mainTopVMShouldShowCloseBoardAlert(vm: self)
            return
        }
        
        let types: [ExitItemType] = roomContext.canCloseRoomOrNot() ? [.close, .leave] : [.leave]
        delegate?.mainTopVMShouldShowExitView(vm: self,
                                              types: types)
    }
    
    func leaveRoom() {
        roomContext.leaveRoom()
    }
    
    func closeRoom() {
        roomContext.closeRoom(success: {},
                              fail: { [weak self](e) in
                                let text = e.localizedMessage
                                self?.invokeShouldShowTip(text: text)
                              })
    }
    
    private func checkUserInteraction() {
        let state = roomContext.getRoomJoinState()
        if state == .joinSuccess {
            invokeMainTopVMShouldAllowUserInteraction()
            invokeShouldDismissLoading()
        }
    }
}

extension MainTopVM: RoomEventHandler {
    func onRoomJoined(state: RoomJoinState) {
        invokeMainTopVMDidJoinRoom(state: state)
        checkUserInteraction()
        if state == .joinSuccess {
            Log.info(text: "onRoomJoined",
                     tag: "MainTopVM")
            invokeMainTopVMShouldStartTime()
        }
    }
    
    func onRoomClosed(reason: RoomClosedReason) {
        invokeMainTopVMShouldStopTime()
        switch reason {
        case .endByMySelf:
            invokeMainTopVMDidExitRoom(type: .closeByMe)
            break
        case .rtmReconnectTimeOut:
            invokeMainTopVMDidExitRoom(type: .closeBySignalConnectedTimeOut)
            break
        case .endByHostOrUpToTimeOrNoBody:
            invokeMainTopVMDidExitRoom(type: .closeByHostOrUpToTimeOrNoBody)
            break
        }
    }
    
    func onUserPermissionUpdated(device: DeviceType,
                                 access: Bool) {}
}

extension MainTopVM: MediaEventHandler {
    func onLocalAudioRouteUpdated(route: AudioRoute) {
        var type = MeetingTopViewAudioType.openSpreak
        switch route {
        case .headSet, .headSetNoMic, .headSetBluetooth:
            type = .ear
            break
        default:
            break
        }
        invokeMainTopVMDidChangeAudioRouteType(type: type)
    }
    
    func onLocalDeviceStateUpdated(device: DeviceType,
                                   state: LocalDeviceState,
                                   time: Int) {}
}

extension MainTopVM: UsersEvnetHandler {
    func onUserListUpdated(userList: [UserDetailInfo]) {}
    
    func onLocalConnectStateChanged(state: ConnectState) {
        Log.info(text: "\(state)",
                 tag: "onLocalConnectStateChanged")
    }
    
    func onKickedOut() {
        invokeMainTopVMDidExitRoom(type: .beKickout)
    }
    
    func onUserPropertiesUpdated(userId: String,
                                 full: UserProperties) {
        Log.info(text: "\(full)",
                 tag: "onUserPropertiesUpdated")
    }
}

extension MainTopVM { /** Invoke **/
    
    func invokeMainTopVMShouldAllowUserInteraction() {
        if Thread.current.isMainThread {
            delegate?.mainTopVMShouldAllowUserInteraction(vm: self)
            return
        }
        DispatchQueue.main.sync { [weak self] in
            guard let `self` = self else { return }
            delegate?.mainTopVMShouldAllowUserInteraction(vm: self)
        }
    }
    
    func invokeMainTopVMShouldStartTime() {
        if Thread.current.isMainThread {
            delegate?.mainTopVMShouldStartTime(vm: self)
            return
        }
        DispatchQueue.main.sync { [weak self] in
            guard let `self` = self else { return }
            delegate?.mainTopVMShouldStartTime(vm: self)
        }
    }
    
    func invokeMainTopVMShouldStopTime() {
        if Thread.current.isMainThread {
            delegate?.mainTopVMShouldStopTime(vm: self)
            return
        }
        DispatchQueue.main.sync { [weak self] in
            guard let `self` = self else { return }
            delegate?.mainTopVMShouldStopTime(vm: self)
        }
    }
    
    func invokeMainTopVMDidChangeAudioRouteType(type: MeetingTopViewAudioType) {
        if Thread.current.isMainThread {
            delegate?.mainTopVMDidChangeAudioRouteType(vm: self,
                                                       type: type)
            return
        }
        
        DispatchQueue.main.sync { [weak self] in
            guard let `self` = self else { return }
            delegate?.mainTopVMDidChangeAudioRouteType(vm: self,
                                                       type: type)
        }
    }
    
    func invokeMainTopVMDidJoinRoom(state: RoomJoinState) {
        if Thread.current.isMainThread {
            delegate?.mainTopVMDidJoinRoom(vm: self, state: state)
            return
        }
        DispatchQueue.main.sync { [weak self] in
            guard let `self` = self else { return }
            delegate?.mainTopVMDidJoinRoom(vm: self, state: state)
        }
    }
    
    func invokeMainTopVMDidExitRoom(type: ExitType) {
        if Thread.current.isMainThread {
            delegate?.mainTopVMDidExitRoom(vm: self,
                                           type: type)
            return
        }
        DispatchQueue.main.sync { [weak self] in
            guard let `self` = self else { return }
            delegate?.mainTopVMDidExitRoom(vm: self,
                                           type: type)
        }
    }
}

extension MainTopVM { /** Info **/
    enum ExitItemType {
        case leave
        case close
    }
    
    enum ExitType {
        case leaveByMe
        case closeByMe
        case closeByHostOrUpToTimeOrNoBody
        case closeBySignalConnectedTimeOut
        case beKickout
    }
}
