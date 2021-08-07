//
//  MessageVM+Chat+Handle.swift
//  AgoraMeetingCore
//
//  Created by ZYP on 2021/6/21.
//

import Foundation
import AgoraMeetingContext

extension ChatMessageVM {
    func handleUpdateChatInfosOnQueue(chatMessages: [ChatMessage]) {
        queue.sync { [weak self] in
            self?.handleUpdateChatInfos(chatMessages: chatMessages)
        }
    }
    
    func handleUpdateChatInfos(chatMessages: [ChatMessage]) {
        var temp = [ChatInfo]()
        for msg in chatMessages {
            var state = MessageSelfCellStatus.recv
            switch msg.sendState {
            case .fail:
                state = .fail
                break
            case .sending:
                state = .sending
                break
            case .success:
                state = .success
                break
            }
            let info = ChatInfo(id: msg.messageId,
                                message: msg.content,
                                timestamp: Int(msg.timestamp),
                                shouldShowTime: msg.showTime,
                                state: state,
                                isFromMyself: msg.isFromMyself,
                                userName: msg.fromUser.userName)
            temp.append(info)
        }
        chatInfos = temp
        invokeChatMessageVMDidUpdateChatInfos(chatInfos: temp)
    }
}
