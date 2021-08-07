//
//  MessageVM+Event.swift
//  AgoraMeetingUI
//
//  Created by ZYP on 2021/6/21.
//

import Foundation
import AgoraMeetingContext

extension ChatMessageVM: MessagesEventHandler {
    func onChatMessagesUpdated(msgs: [ChatMessage]) {
        handleUpdateChatInfosOnQueue(chatMessages: msgs)
    }
    
    func onNotifyMessagesUpdated(msgs: [NotifyMessage]) {
        
    }
}
