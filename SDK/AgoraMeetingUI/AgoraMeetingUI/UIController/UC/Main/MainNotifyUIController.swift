//
//  MainNotifyUIController.swift
//  MeetingApaasTest
//
//  Created by ZYP on 2021/5/12.
//

import Foundation
import AgoraMeetingContext

protocol MainNotifyUIControllerDelegate: NSObject {
    func mainNotifyUIControllerDidTapGoSetButton()
}

class MainNotifyUIController: BaseUIController {
    private let view: MeetingMessageView
    private let vm: MainNotifyVM
    weak var delegate: MainNotifyUIControllerDelegate?
    
    init(contextPool: AgoraMeetingContextPool,
         messageView: MeetingMessageView,
         queue: DispatchQueue) {
        vm = MainNotifyVM(messagesContext: contextPool.messageContext,
                          queue: queue)
        view = messageView
        super.init()
        commonInit()
    }
    
    deinit {
        Log.info(text: "MainNotifyUIController", tag: "deinit")
    }
    
    func commonInit() {
        view.delegate = self
        vm.delegate = self
        vm.tipsDelegate = self
    }
    
    var notiScheduler: NotiEventScheduler {
        return vm.notiScheduler
    }
}

extension MainNotifyUIController: MeetingMessageViewDelegate {
    func messageViewDidTapButton(_ model: MeetingMessageModel) {
        let messageId = model.messageId
        vm.dealNotifyMessageEvent(messageId: messageId)
    }
}

extension MainNotifyUIController: MainNotifyVMDelegate {
    func mainNotifyVM(vm: MainNotifyVM,
                      shoudChangeHidden hidden: Bool) {
        view.setHiddenAnimate(hidden)
    }
    
    func mainNotifyVM(vm: MainNotifyVM,
                      shoudUpdateInfos infos: [MeetingMessageModel]) {
        view.update(infos.reversed())
    }
    
    func mainNotifyVMShouldGoToSetUIManager(vm: MainNotifyVM) {
        delegate?.mainNotifyUIControllerDidTapGoSetButton()
    }
    
    func mainNotifyVMShouldGoToRecordReplayPage(vm: MainNotifyVM,
                                                url: URL) {
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
}
