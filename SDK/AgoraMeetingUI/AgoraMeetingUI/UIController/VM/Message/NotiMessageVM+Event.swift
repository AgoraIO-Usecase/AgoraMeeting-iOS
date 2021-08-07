//
//  NotiMessageVM+Event.swift
//  AgoraMeetingUI
//
//  Created by ZYP on 2021/6/22.
//

import Foundation
import AgoraMeetingContext

extension NotiMessageVM: MessagesEventHandler {
    func onChatMessagesUpdated(msgs: [ChatMessage]) {
        
    }
    
    func onNotifyMessagesUpdated(msgs: [NotifyMessage]) {
        notiScheduler.setNotis(notis: msgs)
    }
}

extension NotiMessageVM: NotiSchedulerEventHandle {
    func onNotiInfosChange(infos: [NotiEventScheduler.Info]) {
        guard infos != lastInput else {
            return
        }
        lastInput = infos
        handleUpdateNotiInfosOnQueue(infos: infos)
    }
}
