//
//  SettingUIController.swift
//  AgoraMeetingUI
//
//  Created by ZYP on 2021/6/17.
//

import Foundation
import AgoraMeetingContext

class SettingUIController: BaseUIController {
    let vm: SettingVM
    let view: SettingView
    
    init(contextPool: AgoraMeetingContextPool) {
        self.vm = SettingVM(roomContext: contextPool.roomContext,
                            platformContext: contextPool.platformContext,
                            messageContext: contextPool.messageContext,
                            userContext: contextPool.usersContext)
        self.view = SettingView()
        super.init()
        setup()
        commonInit()
    }
    
    func setup() {}
    
    func commonInit() {
        view.delegate = self
        vm.delegate = self
        vm.tipsDelegate = self
    }
    
    func start() {
        vm.start()
    }
}

extension SettingUIController: SettingViewDelegate {
    func settingViewDidTapVideoPermission(value: Bool) {
        vm.changeUserPermission(shouldApply: value,
                                device: .camera)
    }
    
    func settingViewDidTapAudioPermission(value: Bool) {
        vm.changeUserPermission(shouldApply: value,
                                device: .mic)
    }
    
    func settingViewDidSelectedUploadLogItem() {
        vm.uploadLog()
    }
    
    func settingViewDidSelectedNotiTypeItem() {
        guard let current = baseDataSource?.controllerShouldGetVC() else {
            return
        }
        let vc = SelectedNotiTypeVC()
        let selected = vm.currentInOutNotiRestrictedType
        vc.delegate = self
        vc.show(in: current,
                selected: selected)
    }
}

extension SettingUIController: SettingVMDelegate {
    func settingVMDidUpdateInfo(info: SettingView.Info) {
        view.updateInfo(info: info)
    }
}

extension SettingUIController: SelectedNotiTypeVCDelegate {
    func selectedNotiTypeVCDidTapSureButton(type: InOutNotiRestrictedType) {
        vm.setInOutNotiRestrictedType(type: type)
    }
}
