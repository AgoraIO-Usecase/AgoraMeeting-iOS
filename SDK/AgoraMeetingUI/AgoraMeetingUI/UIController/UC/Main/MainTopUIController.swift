//
//  MainTopUIController.swift
//  MeetingApaasTest
//
//  Created by ZYP on 2021/5/12.
//

import Foundation
import AgoraMeetingContext

protocol MainTopUIControllerDelegate: NSObjectProtocol {
    func mainTopUIControllerDidJoinRoom(state: RoomJoinState)
    func mainTopUIControllerDidExitRoom()
    func mainTopUIControllerShouldShowCloseScreenAlert()
    func mainTopUIControllerShouldCloseBoardAlert()
}

class MainTopUIController: BaseUIController {
    weak var delegate: MainTopUIControllerDelegate?
    
    let view = MeetingTopView.instanceFromNib()
    fileprivate let vm: MainTopVM
    
    init(contextPool: AgoraMeetingContextPool) {
        vm = MainTopVM(roomContext: contextPool.roomContext,
                       mediaContext: contextPool.mediaContext,
                       boardContext: contextPool.boardContext,
                       screenContext: contextPool.screenContext,
                       usersContext: contextPool.usersContext)
        super.init()
        setup()
        commonInit()
    }
    
    private func setup() {
        Log.info(text: "关闭了isUserInteractionEnabled")
        view.isUserInteractionEnabled = false
        setTitle()
        startTimeIfNeed()
    }
    
    private func commonInit() {
        view.delegate = self
        vm.delegate = self
        vm.tipsDelegate = self
    }
    
    private func setTitle() {
        view.title?.text = vm.roomName
    }
    
    fileprivate func startTimeIfNeed() {
        let isRoomJoined = vm.isRoomJoined
        guard isRoomJoined else {
            return
        }
        let count = vm.startTimeStamp
        view.startTimer(withCount: Int(count))
    }
    
    fileprivate func stopTime() {
        view.stopTime()
    }
    
    func showExitSheet(types: [MainTopVM.ExitItemType]) {
        let vc = AlertController(title: nil,
                                   message: nil,
                                   preferredStyle: .actionSheet)
        let a1 = UIAlertAction(title: MeetingUILocalizedString("meeting_t40", comment: ""),
                               style: .default) { (_) in
            self.vm.closeRoom()
        }
        let a2 = UIAlertAction(title: MeetingUILocalizedString("meeting_t43", comment: ""),
                               style: .default) { [weak self](_) in
            guard let self = self else { return }
            self.delegate?.mainTopUIControllerDidExitRoom()
        }
        let a3 = UIAlertAction(title: MeetingUILocalizedString("meeting_t11", comment: ""),
                               style: .cancel, handler: nil)
        if types.contains(.close) { vc.addAction(a1) }
        vc.addAction(a2)
        vc.addAction(a3)
        let currentVC = baseDataSource?.controllerShouldGetVC()
        currentVC?.present(vc,
                           animated: true,
                           completion: nil)
    }
    
    func showRoomEndAlert() {
        let vc = AlertController(title: nil,
                                   message: MeetingUILocalizedString("meeting_t3", comment: ""),
                                   preferredStyle: .alert)
        let a1 = UIAlertAction(title: MeetingUILocalizedString("meeting_t61", comment: ""),
                               style: .default,
                               handler: { [unowned self](_) in
            self.delegate?.mainTopUIControllerDidExitRoom()
        })
        vc.addAction(a1)
        let currentVC = baseDataSource?.controllerShouldGetVC()
        vc.sendToOtherForDismiss()
        currentVC?.present(vc,
                           animated: true,
                           completion: nil)
    }
    
    func showKickoutAlert() {
        let vc = AlertController(title: nil,
                                 message: MeetingUILocalizedString("meeting_t24", comment: ""),
                                 preferredStyle: .alert)
        let a1 = UIAlertAction(title: MeetingUILocalizedString("meeting_t32", comment: ""),
                               style: .default,
                               handler: { [weak self](_) in
                                guard let self = self else { return }
                                self.delegate?.mainTopUIControllerDidExitRoom()
                               })
        vc.addAction(a1)
        let mainVC = baseDataSource?.controllerShouldGetVC()
        vc.sendToOtherForDismiss()
        mainVC?.present(vc,
                        animated: true,
                        completion: nil)
    }
    
    func leaveRoom() {
        vm.leaveRoom()
    }
    
    deinit {
        Log.info(text: "MainTopUIController", tag: "deinit")
    }
}

extension MainTopUIController: MeetingTopViewDelegate {
    func meetingTopViewDidTapShareButton() {}
    
    func meetingTopViewDidTapCameraButton() {
        vm.switchLocalCamera()
    }
    
    func meetingTopViewDidTapLeaveButton() {
        vm.genExitTypes()
    }
}

extension MainTopUIController: MainTopVMDelegate {
    func mainTopVMShouldShowCloseScreenAlert(vm: MainTopVM) {
        delegate?.mainTopUIControllerShouldShowCloseScreenAlert()
    }
    
    func mainTopVMShouldShowCloseBoardAlert(vm: MainTopVM) {
        delegate?.mainTopUIControllerShouldCloseBoardAlert()
    }
    
    func mainTopVMDidExitRoom(vm: MainTopVM,
                              type: MainTopVM.ExitType) {
        switch type {
        case .leaveByMe:
            delegate?.mainTopUIControllerDidExitRoom()
            break
        case .closeByMe:
            delegate?.mainTopUIControllerDidExitRoom()
            break
        case .closeByHostOrUpToTimeOrNoBody, .closeBySignalConnectedTimeOut:
            showRoomEndAlert()
            break
        case .beKickout:
            showKickoutAlert()
            break
        }
    }
    
    func mainTopVMShouldAllowUserInteraction(vm: MainTopVM) {
        view.isUserInteractionEnabled = true
        shouldDismissLoading()
    }
    
    func mainTopVMDidJoinRoom(vm: MainTopVM,
                              state: RoomJoinState) {
        delegate?.mainTopUIControllerDidJoinRoom(state: state)
    }
    
    func mainTopVMShouldStartTime(vm: MainTopVM) {
        startTimeIfNeed()
    }
    
    func mainTopVMShouldStopTime(vm: MainTopVM) {
        view.stopTime()
    }
    
    func mainTopVMDidChangeAudioRouteType(vm: MainTopVM,
                                          type: MeetingTopViewAudioType) {
        view.setAudioRouting(type)
    }
    
    func mainTopVMShouldShowExitView(vm: MainTopVM,
                                     types: [MainTopVM.ExitItemType]) {
        showExitSheet(types: types)
    }
}



