//
//  MessageVM+Invoke.swift
//  AgoraMeetingUI
//
//  Created by ZYP on 2021/6/21.
//

import Foundation


extension ChatMessageVM {
    func invokeChatMessageVMDidUpdateChatInfos(chatInfos: [ChatMessageVM.ChatInfo]) {
        if Thread.current.isMainThread {
            delegate?.chatMessageVMDidUpdateChatInfos(chatInfos: chatInfos)
            return
        }
        
        DispatchQueue.main.async { [weak self] in
            guard let `self` = self else { return }
            self.delegate?.chatMessageVMDidUpdateChatInfos(chatInfos: chatInfos)
        }
    }
}
