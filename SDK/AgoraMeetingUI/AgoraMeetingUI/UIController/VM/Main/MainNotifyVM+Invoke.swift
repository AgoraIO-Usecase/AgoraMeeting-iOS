//
//  MainNotifyVM+Invoke.swift
//  AgoraMeetingUI
//
//  Created by ZYP on 2021/6/23.
//

import Foundation

extension MainNotifyVM {
    func invokeMainNotifyVMShoudChangeHidden(hidden: Bool) {
        if Thread.current.isMainThread {
            delegate?.mainNotifyVM(vm: self,
                                   shoudChangeHidden: hidden)
            return
        }
        
        DispatchQueue.main.async { [weak self] in
            guard let `self` = self else { return }
            self.delegate?.mainNotifyVM(vm: self,
                                        shoudChangeHidden: hidden)
        }
    }
    
    func invokeMainNotifyVMShoudUpdateInfos(infos: [MeetingMessageModel]) {
        if Thread.current.isMainThread {
            delegate?.mainNotifyVM(vm: self,
                                   shoudUpdateInfos: infos)
            return
        }
        
        DispatchQueue.main.async { [weak self] in
            guard let `self` = self else { return }
            self.delegate?.mainNotifyVM(vm: self,
                                        shoudUpdateInfos: infos)
        }
    }
    
    func invokeMainNotifyVMShouldGoToSetUIManager() {
        if Thread.current.isMainThread {
            delegate?.mainNotifyVMShouldGoToSetUIManager(vm: self)
            return
        }
        
        DispatchQueue.main.async { [weak self] in
            guard let `self` = self else { return }
            self.delegate?.mainNotifyVMShouldGoToSetUIManager(vm: self)
        }
    }
    
//    func invokeMainNotifyVMShouldGoToRecordReplayPage(url: URL) {
//        if Thread.current.isMainThread {
//            delegate?.mainNotifyVMShouldGoToRecordReplayPage(vm: self,
//                                                             url: url)
//            return
//        }
//
//        DispatchQueue.main.async { [weak self] in
//            guard let `self` = self else { return }
//            self.delegate?.mainNotifyVMShouldGoToRecordReplayPage(vm: self,
//                                                                  url: url)
//        }
//    }
}
