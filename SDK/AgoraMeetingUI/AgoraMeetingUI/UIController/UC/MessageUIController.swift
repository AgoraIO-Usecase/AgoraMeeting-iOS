//
//  MessageUIController.swift
//  AgoraMeetingCore
//
//  Created by ZYP on 2021/6/21.
//

import Foundation
import AgoraMeetingContext

class MessageUIController: BaseUIController {
    let view = MessageView()
    let chatVM: ChatMessageVM
    let notiVM: NotiMessageVM
    
    init(contextPool: AgoraMeetingContextPool,
         notiScheduler: NotiEventScheduler,
         queue: DispatchQueue) {
        self.chatVM = ChatMessageVM(messagesContext: contextPool.messageContext,
                                    queue: queue)
        self.notiVM = NotiMessageVM(messagesContext: contextPool.messageContext,
                                    notiScheduler: notiScheduler,
                                    queue: queue)
        super.init()
        commonInit()
    }
    
    func start() {
        chatVM.start()
    }
    
    func setup() {}
    
    func commonInit() {
        chatVM.delegate = self
        notiVM.delegate = self
        notiVM.tipsDelegate = self
        chatVM.tipsDelegate = self
        view.delegate = self
    }
}

extension MessageUIController: ChatMessageVMDelegate {
    func chatMessageVMDidUpdateChatInfos(chatInfos: [ChatMessageVM.ChatInfo]) {
        view.updateChatInfos(chatInfos: chatInfos)
        view.scrollToBottomMsg()
    }
}

extension MessageUIController: NotiMessageVMDelegate {
    func notiMessageVMDidUpdateInfos(infos: [NotiMessageVM.NotiInfo]) {
        let shouldAutoScrollBottom = view.notiInfos.count == 0 && infos.count > 0
        view.updateNotiInfos(notiInfos: infos)
        if shouldAutoScrollBottom { view.scrollToBottomNoti() }
    }
}

extension MessageUIController: MessageViewDelegate {
    func messageViewDidTapNotiButton(id: Int) {
        notiVM.dealNotifyMessageEvent(messageId: id)
    }
    
    func messageViewDidTapRetryButton(id: Int) {
        chatVM.resend(messageId: id)
    }
    
    func messageViewShouldTableViewScrollToBottom() {
        view.scrollToBottomMsg()
    }
    
    func messageViewDidTapSend(text: String) {
        chatVM.send(content: text)
    }
}
