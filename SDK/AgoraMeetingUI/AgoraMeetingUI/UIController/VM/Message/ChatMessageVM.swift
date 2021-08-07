//
//  ChatMessageVM.swift
//  AgoraMeetingCore
//
//  Created by ZYP on 2021/6/21.
//

import Foundation
import AgoraMeetingContext

protocol ChatMessageVMDelegate: NSObject {
    func chatMessageVMDidUpdateChatInfos(chatInfos: [ChatMessageVM.ChatInfo])
}

class ChatMessageVM: BaseVM {
    typealias ChatInfo = MessageView.ChatInfo
    let messagesContext: MessagesContext
    var chatInfos = [ChatInfo]()
    weak var delegate: ChatMessageVMDelegate?
    let queue: DispatchQueue
    
    init(messagesContext: MessagesContext,
         queue: DispatchQueue) {
        self.queue = queue
        self.messagesContext = messagesContext
        super.init()
        commonInit()
    }
    
    func commonInit() {
        messagesContext.registerEventHandler(self)
    }
    
    deinit {
        messagesContext.unregisterEventHandler(self)
        Log.info(text: "ChatMessageVM",
                 tag: "deinit")
    }
    
    func start() {
        queue.async { [unowned self] in
            let temp = messagesContext.getChatMessages()
            self.handleUpdateChatInfos(chatMessages: temp)
        }
    }
    
    func send(content: String) {
        messagesContext.sendChatMessage(content: content,
                                        success: {},
                                        fail: { [weak self](error) in
                                            self?.invokeShouldShowTip(text: error.message)
                                        })
    }
    
    func resend(messageId: MessageId) {
        messagesContext.resendChatMessage(messageId: messageId,
                                          success: {},
                                          fail: { [weak self](error) in
                                            self?.invokeShouldShowTip(text: error.message)
                                          })
    }
}

