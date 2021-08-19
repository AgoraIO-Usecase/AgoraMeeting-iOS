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
        var lastTimeStamp = chatInfos.last?.timestamp ?? 0
        var lastIsSelf = chatInfos.last?.isFromMyself ?? false
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
            
            let shouldShowTime = calculatedShowTime(id: msg.messageId,
                                                    isFromMyself: msg.isFromMyself,
                                                    timestamp: msg.timestamp,
                                                    lastTimeStamp: lastTimeStamp,
                                                    lastIsSelf: lastIsSelf)
            let info = ChatInfo(id: msg.messageId,
                                message: msg.content,
                                timestamp: Int(msg.timestamp),
                                shouldShowTime: shouldShowTime,
                                state: state,
                                isFromMyself: msg.isFromMyself,
                                userName: msg.fromUser.userName)
            temp.append(info)
            lastTimeStamp = Int(msg.timestamp)
            lastIsSelf = msg.isFromMyself
        }
        chatInfos = temp
        invokeChatMessageVMDidUpdateChatInfos(chatInfos: temp)
    }
    
    private func calculatedShowTime(id: Int,
                                    isFromMyself: Bool,
                                    timestamp: TimeInterval,
                                    lastTimeStamp: Int,
                                    lastIsSelf: Bool) -> Bool {
        if id <= (chatInfos.last?.id ?? -1) { /** has include **/
            return chatInfos[id].shouldShowTime
        }
        if lastTimeStamp == 0 {
            return true
        }
        let isSamePeer = isFromMyself == lastIsSelf
        let shouldShowTime = Int(timestamp) - lastTimeStamp > 60
        return isSamePeer && shouldShowTime
    }
}
