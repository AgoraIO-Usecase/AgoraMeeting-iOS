//
//  MainNotifyVM+Event.swift
//  AgoraMeetingUI
//
//  Created by ZYP on 2021/6/22.
//

import Foundation

import AgoraMeetingContext

extension MainNotifyVM: MessagesEventHandler {
    func onChatMessagesUpdated(msgs: [ChatMessage]) {}
    func onNotifyMessagesUpdated(msgs: [NotifyMessage]) {
        notiScheduler.setNotis(notis: msgs)
    }
    func onPrivateChatMessageReceived(content: String,
                                      fromUser: UserInfo){}
}

extension MainNotifyVM: NotiSchedulerEventHandle {
    func onNotiInfosChange(infos: [NotiEventScheduler.Info]) {
        handleUpdateOnQueue(infos: infos)
    }
}

extension MainNotifyVM: NotiEventSchedulerDelegate {
    func notiEventSchedulerShouldGoToSetUIManager() {
        invokeMainNotifyVMShouldGoToSetUIManager()
    }
    
    func notiEventSchedulerDidGetRecordFiles(recordFiles: [RecordFile]) {
//        invokeMainNotifyVMShouldGoToRecordReplayPage(url: url)
    }
}
