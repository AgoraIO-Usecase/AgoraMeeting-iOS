//
//  MainBottomUIController.swift
//  MeetingApaasTest
//
//  Created by ZYP on 2021/5/12.
//

import Foundation
import AgoraMeetingContext

protocol MainBottomUIControllerDelegate: NSObject {
    func mainBottomUIControllerDidTapUsers()
    func mainBottomUIControllerDidTapMessage()
    func mainBottomUIControllerDidTapSetting()
    func mainBottomUIControllerDidTapStartScreen()
    func mainBottomUIControllerDidTapEndScreen()
}

class MainBottomUIController: BaseUIController {
    let view = MeetingBottomView.instanceFromNib()
    var vm: MainBottomVM!
    weak var delegate: MainBottomUIControllerDelegate?
    
    init(contextPool: AgoraMeetingContextPool) {
        vm = MainBottomVM(mediaContext: contextPool.mediaContext,
                          roomContext: contextPool.roomContext,
                          boardContext: contextPool.boardContext,
                          usersContext: contextPool.usersContext,
                          screenContext: contextPool.screenContext,
                          messageContext: contextPool.messageContext)
        super.init()
        setup()
        commonInit()
    }
    
    func setup() {
        view.isUserInteractionEnabled = false
        checkState()
    }
    
    func commonInit() {
        view.delegate = self
        vm.delegate = self
        vm.tipsDelegate = self
    }
    
    deinit {
        Log.info(text: "MainBottomUIController", tag: "deinit")
    }
    
    
    func checkState() {
        let videEnable = vm.localCameraState == .open
        let audioEnable = vm.localMicState == .open
        if Thread.current.isMainThread {
            view.setVideEnable(videEnable)
            view.setAudioEnable(audioEnable)
            view.updateVideoItem(videEnable ? .active : .inactive,
                                 timeCount: 0)
            view.updateAudioItem(audioEnable ? .active : .inactive,
                                 timeCount: 0)
            return
        }
        
        DispatchQueue.main.sync { [weak self] in
            self?.view.setVideEnable(videEnable)
            self?.view.setAudioEnable(audioEnable)
            self?.view.updateVideoItem(videEnable ? .active : .inactive,
                                       timeCount: 0)
            self?.view.updateAudioItem(audioEnable ? .active : .inactive,
                                       timeCount: 0)
        }
    }
    
    func updateRedDot(count: Int) {
        view.updateImRedDotCount(count)
    }
    
    func setMessageRedDotHandle(needUpdate: Bool) {
        vm.setMessageRedDotHandle(needUpdate: needUpdate)
    }
}

extension MainBottomUIController: MeetingBottomViewDelegate {
    func meetingBottomView(_ view: MeetingBottomView,
                           didTapButtonWith type: MeetingBottomViewButtonType) {
        switch type {
        case .audio:
            let state = view.getAudioState()
            state == .active ? vm.closeDevice(device: .mic) : vm.openLocalDevice(device: .mic)
            break
        case .video:
            let state = view.getVideoState()
            state == .active ? vm.closeDevice(device: .camera) : vm.openLocalDevice(device: .camera)
            break
        case .member:
            delegate?.mainBottomUIControllerDidTapUsers()
            break
        case .chat:
            delegate?.mainBottomUIControllerDidTapMessage()
            break
        case .more:
            vm.genMoreInfo()
            break
        @unknown default:
            fatalError()
        }
    }
}

extension MainBottomUIController: MainBottomVMDelegate {
    func mainBottomVMShouldShowRedDot(vm: MainBottomVM,
                                      count: Int) {
        updateRedDot(count: count)
    }
    
    func mainBottomVMShouldShowMoreSheet(vm: MainBottomVM,
                                         moreInfo: MainBottomVM.MoreInfo) {
        showMoreAlert(info: moreInfo)
    }
    
    func mainBottomVMShouldShowApproveAlter(vm: MainBottomVM,
                                            device: DeviceType) {
        switch device {
        case .camera:
            showRequestCameraAlert()
            break
        case .mic:
            showRequestMicAlert()
            break
        }
    }
    
    func mainBottomVMShouldAllowUserInteraction(vm: MainBottomVM) {
        view.isUserInteractionEnabled = true
        checkState()
    }
    
    func mainBottomVM(vm: MainBottomVM,
                      device: DeviceType,
                      shouldUpdateDeviceItem enable: Bool) {
        switch device {
        case .camera:
            view.setVideEnable(enable)
            break
        case .mic:
            view.setAudioEnable(enable)
            break
        }
    }
    
    func mainBottomVM(vm: MainBottomVM,
                      device: DeviceType,
                      didLocalDeviceStateChange state: LocalDeviceState,
                      timeCount: Int) {
        switch device {
        case .camera:
            view.updateVideoItem(state.bottomItemState,
                                 timeCount: timeCount)
            break
        case .mic:
            view.updateAudioItem(state.bottomItemState,
                                 timeCount: timeCount)
            break
        }
    }
}

extension MainBottomUIController: ASCheckBoxAlertVCDelegate {
    func checkBoxAlertVCDidTapSureButton(checkBoxSeleted: Bool,
                                         style: ASCheckBoxAlertVC.Style) {
        switch style {
        case .audio:
            vm.closeAllMic(shouldApply: checkBoxSeleted)
            break
        case .video:
            vm.closeAllCamera(shouldApply: checkBoxSeleted)
            break
        }
    }
}

extension LocalDeviceState {
    var bottomItemState: BottomItemState {
        switch self {
        case .approving:
            return .time
        case .close:
            return .inactive
        case .open:
            return .active
        }
    }
}
