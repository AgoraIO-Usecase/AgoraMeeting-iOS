//
//  AlertController.swift
//  AgoraMeetingUI
//
//  Created by ZYP on 2021/7/6.
//

import UIKit

class AlertController: UIAlertController {
    private var priority = Priority.low
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(didRecvNoti),
                                               name: NSNotification.Name("com.meeting.ui.alert.hiden"),
                                               object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func sendToOtherForDismiss() {
        priority = .hight
        NotificationCenter.default.post(name: NSNotification.Name("com.meeting.ui.alert.hiden"),
                                        object: nil,
                                        userInfo: nil)
    }
    
    @objc func didRecvNoti() {
        guard priority == .low else {
            return
        }
        
        dismiss(animated: true,
                completion: nil)
    }
    
}

extension AlertController {
    enum Priority {
        case low
        case hight
    }
}
