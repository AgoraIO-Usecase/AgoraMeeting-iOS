//
//  MainBottomUIController+Show.swift
//  AgoraMeetingUI
//
//  Created by ZYP on 2021/6/10.
//

import Foundation

extension MainBottomUIController {
    func showRequestMicAlert() {
        let vc = AlertController(title: nil,
                                 message: MeetingUILocalizedString("meeting_t16", comment: ""),
                                 preferredStyle: .alert)
        let a1 = UIAlertAction(title: MeetingUILocalizedString("meeting_t33", comment: ""),
                               style: .default,
                               handler: { [unowned self](_) in
                                self.vm.openLocalDevice(device: .mic,
                                                        mustApprove: true)
                               })
        let a2 = UIAlertAction(title: MeetingUILocalizedString("meeting_t11", comment: ""),
                               style: .default,
                               handler: nil)
        vc.addAction(a2)
        vc.addAction(a1)
        let currentVC = baseDataSource?.controllerShouldGetVC()
        currentVC?.present(vc,
                           animated: true,
                           completion: nil)
    }
    
    func showRequestCameraAlert() {
        let vc = AlertController(title: nil,
                                 message: MeetingUILocalizedString("meeting_t15", comment: ""),
                                 preferredStyle: .alert)
        let a1 = UIAlertAction(title: MeetingUILocalizedString("meeting_t33", comment: ""),
                               style: .default,
                               handler: {  [unowned self](_) in
                                self.vm.openLocalDevice(device: .camera,
                                                        mustApprove: true)
                               })
        let a2 = UIAlertAction(title: MeetingUILocalizedString("meeting_t11", comment: ""),
                               style: .default,
                               handler: nil)
        vc.addAction(a2)
        vc.addAction(a1)
        let currentVC = baseDataSource?.controllerShouldGetVC()
        currentVC?.present(vc,
                           animated: true,
                           completion: nil)
    }
    
    func showMoreAlert(info: MainBottomVM.MoreInfo) {
        let vc = AlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let action1 = UIAlertAction(title: MeetingUILocalizedString("meeting_t44", comment: ""),
                                    style: .default,
                                    handler: { [unowned self](_) in
                                        self.vm.copyShareInfo()
                                    })
        let action2 = UIAlertAction(title: MeetingUILocalizedString("meeting_t6", comment: ""),
                                    style: .default,
                                    handler: { [unowned self]_ in
                                        self.showCLoseAllMicAlert()
                                    })
        let action3 = UIAlertAction(title: MeetingUILocalizedString("meeting_t5", comment: ""),
                                    style: .default,
                                    handler: { [unowned self]_ in
                                        self.showCloseAllCameraAlert()
                                    })
        let action4 = UIAlertAction(title: MeetingUILocalizedString("meeting_t17", comment: ""),
                                    style: .default,
                                    handler: { [unowned self](_) in
                                        self.delegate?.mainBottomUIControllerDidTapStartScreen()
                                    })
        let action5 = UIAlertAction(title: MeetingUILocalizedString("meeting_t62", comment: ""),
                                    style: .default,
                                    handler: { [unowned self](_) in
                                        self.delegate?.mainBottomUIControllerDidTapEndScreen()
                                    })
        let action6 = UIAlertAction(title: MeetingUILocalizedString("meeting_t10", comment: ""),
                                    style: .default,
                                    handler: { [unowned self](_) in
                                        self.vm.startBoard()
                                    })
        let action7 = UIAlertAction(title: MeetingUILocalizedString("meeting_t41", comment: ""),
                                    style: .default,
                                    handler: { [unowned self](_) in
                                        self.delegate?.mainBottomUIControllerDidTapSetting()
                                    })
        let action8 = UIAlertAction(title: MeetingUILocalizedString("meeting_t11", comment: ""),
                                    style: .cancel,
                                    handler: nil)
        
        vc.addAction(action1)
        info.canCloseAllAudio ? vc.addAction(action2) : nil
        info.canCloseAllVideo ? vc.addAction(action3) : nil
        info.canStartScreen ? vc.addAction(action4) : nil
        info.canEndScreen ? vc.addAction(action5) : nil
        vc.addAction(action6)
        vc.addAction(action7)
        vc.addAction(action8)
        let currentVC = baseDataSource?.controllerShouldGetVC()
        currentVC?.present(vc, animated: true, completion: nil)
    }
    
    func showCloseAllCameraAlert() {
        guard let currentVC = baseDataSource?.controllerShouldGetVC() else {
            return
        }
        let vc = ASCheckBoxAlertVC()
        vc.delegate = self
        vc.show(in: currentVC,
                style: .video)
    }
    
    func showCLoseAllMicAlert() {
        guard let currentVC = baseDataSource?.controllerShouldGetVC() else {
            return
        }
        let vc = ASCheckBoxAlertVC()
        vc.delegate = self
        vc.show(in: currentVC,
                style: .audio)
    }
}

