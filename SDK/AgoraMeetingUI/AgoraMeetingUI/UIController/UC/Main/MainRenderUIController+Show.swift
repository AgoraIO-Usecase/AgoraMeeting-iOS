//
//  MainRenderUIController+Show.swift
//  AgoraMeetingUI
//
//  Created by ZYP on 2021/6/16.
//

import Foundation

extension MainRenderUIController {
    func showOpenScreenAlert() {
        let title = MeetingUILocalizedString("meeting_t53", comment: "")
        let vc = AlertController(title: title,
                                 message: nil,
                                 preferredStyle: .alert)
        let action1Title = MeetingUILocalizedString("meeting_t52", comment: "")
        let action1 = UIAlertAction(title: action1Title, style: .default) { (_) in
            self.vm.openScreenSharing()
        }
        let action2Title = MeetingUILocalizedString("meeting_t11", comment: "")
        let action2 = UIAlertAction(title: action2Title,
                                    style: .default,
                                    handler: nil)
        vc.addAction(action2)
        vc.addAction(action1)
        let current = baseDataSource?.controllerShouldGetVC()
        current?.present(vc,
                         animated: true,
                         completion: nil)
    }
    
    func showCloseScreenAlert() {
        let title = MeetingUILocalizedString("meeting_t55", comment: "")
        let vc = AlertController(title: title,
                                 message: nil,
                                 preferredStyle: .alert)
        let action1Title = MeetingUILocalizedString("meeting_t39", comment: "")
        let action1 = UIAlertAction(title: action1Title, style: .default) { (_) in
            self.vm.closeScreenSharing()
        }
        let action2Title = MeetingUILocalizedString("meeting_t11", comment: "")
        let action2 = UIAlertAction(title: action2Title,
                                    style: .default,
                                    handler: nil)
        vc.addAction(action2)
        vc.addAction(action1)
        let current = baseDataSource?.controllerShouldGetVC()
        current?.present(vc,
                         animated: true,
                         completion: nil)
    }
    
    func showEndBoardAlert() {
        let title = MeetingUILocalizedString("meeting_t54", comment: "")
        let vc = AlertController(title: title,
                                 message: nil,
                                 preferredStyle: .alert)
        let action1Title = MeetingUILocalizedString("meeting_t39", comment: "")
        let action1 = UIAlertAction(title: action1Title,
                                    style: .default) { [unowned self](_) in
            self.vm.closeBoardShare()
        }
        let action2Title = MeetingUILocalizedString("meeting_t11", comment: "")
        let action2 = UIAlertAction(title: action2Title,
                                    style: .default,
                                    handler: nil)
        vc.addAction(action2)
        vc.addAction(action1)
        let current = baseDataSource?.controllerShouldGetVC()
        current?.present(vc,
                         animated: true,
                         completion: nil)
    }
    
    
}
