//
//  MeetingUI.swift
//  MeetingUI
//
//  Created by ZYP on 2021/5/23.
//

import UIKit
import AgoraMeetingContext

public class AgoraMeetingUI: UINavigationController {
    var firstVC: UIViewController { return mainUIManager }
    var mainUIManager: MainUIManager!
    var contextPool: AgoraMeetingContextPool!
    let queue = DispatchQueue(label: "com.meetingui.ui.vm")
    
    public init(contextPool: AgoraMeetingContextPool) {
        let vc = MainUIManager(contextPool: contextPool,
                               queue: queue)
        super.init(rootViewController: vc)
        self.mainUIManager = vc
        self.contextPool = contextPool
        self.mainUIManager.routerDelegate = self
    }
    
    public override init(nibName nibNameOrNil: String?,
                         bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil,
                   bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.backButtonTitle = ""
        navigationBar.tintColor = UIColor(hex: 0x323c47)
        navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(hex: 0x030303)]
    }
}

extension AgoraMeetingUI: UIManagerRouterProtocol {
    func pushSettingManagerFrom(_ uimanager: UIViewController) {
        let vc = SettingUIManager(contextPool: contextPool)
        vc.routerDelegate = self
        uimanager.navigationController?
            .pushViewController(vc,
                                animated: true)
    }
    
    func pushMessageManagerFrom(_ uimanager: UIViewController) {
        let vc = MessageUIManager(contextPool: contextPool,
                                  notiScheduler: mainUIManager.notiScheduler,
                                  queue: queue)
        vc.delegate = self
        uimanager.navigationController?
            .pushViewController(vc,
                                animated: true)
    }
    
    func pushBoardManagerFrom(_ uimanager: UIViewController) {
        let vc = BoardUIManager(contextPool: contextPool)
        uimanager.navigationController?
            .pushViewController(vc,
                                animated: true)
    }
    
    func pushUsersManagerFrom(_ uimanager: UIViewController) {
        let vc = UserListUIManager(userContext: contextPool.usersContext,
                                   queue: queue)
        uimanager.navigationController?
            .pushViewController(vc,
                                animated: true)
    }
}

extension AgoraMeetingUI: MessageUIManagerDelegate {
    func messageUIManagerDidAppear() {
        mainUIManager.setMessageRedDotHandle(needUpdate: false)
    }
    
    func messageUIManagerDidDisappear() {
        mainUIManager.setMessageRedDotHandle(needUpdate: true)
    }
}

public func MeetingUILocalizedString(_ key: String,
                                     comment: String = "") -> String {
    return NSLocalizedString(key,
                             bundle: .meetingUI(),
                             comment: comment)
}
