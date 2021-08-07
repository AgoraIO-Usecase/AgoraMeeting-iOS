//
//  MainNotifyVM.swift
//  AgoraMeetingUI
//
//  Created by ZYP on 2021/6/22.
//

import Foundation
import AgoraMeetingContext

protocol MainNotifyVMDelegate: NSObject {
    func mainNotifyVM(vm: MainNotifyVM,
                      shoudChangeHidden hidden: Bool)
    func mainNotifyVM(vm: MainNotifyVM,
                      shoudUpdateInfos infos: [MeetingMessageModel])
    func mainNotifyVMShouldGoToSetUIManager(vm: MainNotifyVM)
    func mainNotifyVMShouldGoToRecordReplayPage(vm: MainNotifyVM,
                                                url: URL)
}

class MainNotifyVM: BaseVM {
    let messagesContext: MessagesContext
    let queue: DispatchQueue
    let notiScheduler: NotiEventScheduler
    weak var delegate: MainNotifyVMDelegate?
    var currentMaxId = -1
    var notUpdateTime = 0
    var lastInput = [NotiEventScheduler.Info]()
    let showViewTimeOutWhenNoNewData = 10
    
    init(messagesContext: MessagesContext,
         queue: DispatchQueue) {
        self.queue = queue
        self.messagesContext = messagesContext
        self.notiScheduler = NotiEventScheduler(messageContext: messagesContext)
        super.init()
        commonInit()
    }
    
    deinit {
        notiScheduler.unregisterEventHandler(self)
        messagesContext.unregisterEventHandler(self)
        Log.info(text: "MainNotifyVM",
                 tag: "deinit")
    }
    
    func commonInit() {
        notiScheduler.delegate = self
        notiScheduler.registerEventHandler(self)
        messagesContext.registerEventHandler(self)
    }
    
    func dealNotifyMessageEvent(messageId: MessageId) {
        notiScheduler.dealNotifyMessageEvent(messageId: messageId,
                                             success: {},
                                             fail: { [weak self](error) in
                                                self?.invokeShouldShowTip(text: error.localizedMessage)
                                             })
    }
}
