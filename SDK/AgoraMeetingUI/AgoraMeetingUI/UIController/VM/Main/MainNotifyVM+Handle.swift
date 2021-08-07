//
//  MainNotifyVM+Handle.swift
//  AgoraMeetingUI
//
//  Created by ZYP on 2021/6/23.
//

import Foundation
import AgoraMeetingContext

extension MainNotifyVM {
    func handleUpdateOnQueue(infos: [NotiEventScheduler.Info]) {
        queue.async { [weak self] in
            self?.handleUpdate(infos: infos)
        }
    }
    
    func handleUpdate(infos: [NotiEventScheduler.Info]) {
        notUpdateTime += 1
        if infos.count == 0 {
            notUpdateTime = 0
            invokeMainNotifyVMShoudChangeHidden(hidden: true)
            return
        }
        let id = infos.last!.id
        
        /// get last 3 info
        var temp = [NotiEventScheduler.Info]()
        if infos.count >= 3 {
            temp = [infos[id-2], infos[id-1], infos[id]]
        }
        else if infos.count == 2 {
            temp = [infos[id-1], infos[id]]
        }
        else {
            temp = infos
        }
        
        /// check
        if lastInput == temp {
            checkNoUpdate()
            return
        }
        lastInput = temp
        notUpdateTime = 0
        
        /// map data
        let results = temp.map { (info) -> MeetingMessageModel in
            let m = MeetingMessageModel()
            m.messageId = info.id
            m.info = info.tipsMsg
            m.name = info.sender.userName
            m.buttonEnable = info.buttonEnable
            m.buttonTitle = info.buttonTitle
            m.remianCount = UInt(info.count)
            m.showButton = info.type.hasAction
            return m
        }
        invokeMainNotifyVMShoudUpdateInfos(infos: results)
        invokeMainNotifyVMShoudChangeHidden(hidden: false)
    }
    
    func checkNoUpdate() {
        if notUpdateTime > showViewTimeOutWhenNoNewData {
            notUpdateTime = 0
            invokeMainNotifyVMShoudChangeHidden(hidden: true)
        }
    }
}
