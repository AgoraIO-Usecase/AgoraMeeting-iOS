//
//  NotiMessageVM.swift
//  AgoraMeetingUI
//
//  Created by ZYP on 2021/6/22.
//

import Foundation
import AgoraMeetingContext

protocol NotiMessageVMDelegate: NSObject {
    func notiMessageVMDidUpdateInfos(infos: [NotiMessageVM.NotiInfo])
}

class NotiMessageVM: BaseVM {
    typealias NotiInfo = MessageView.NotiInfo
    let messagesContext: MessagesContext
    let queue: DispatchQueue
    var notiInfos = [NotiInfo]()
    let notiScheduler: NotiEventScheduler
    weak var delegate: NotiMessageVMDelegate?
    var lastInput: [NotiEventScheduler.Info]?
    
    init(messagesContext: MessagesContext,
         notiScheduler: NotiEventScheduler,
         queue: DispatchQueue) {
        self.queue = queue
        self.messagesContext = messagesContext
        self.notiScheduler = notiScheduler
        super.init()
        commonInit()
    }
    
    func commonInit() {
        notiScheduler.registerEventHandler(self)
        messagesContext.registerEventHandler(self)
    }
    
    deinit {
        notiScheduler.unregisterEventHandler(self)
        messagesContext.unregisterEventHandler(self)
        Log.info(text: "NotiMessageVM",
                 tag: "deinit")
    }
    
    func dealNotifyMessageEvent(messageId: MessageId) {
        queue.async { [weak self] in
            self?.notiScheduler
                .dealNotifyMessageEvent(messageId: messageId,
                                        success: {},
                                        fail: { [weak self](error) in
                                            self?.invokeShouldShowTip(text: error.localizedMessage)
                                        })
        }
    }
}
