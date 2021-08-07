//
//  NotiMessageVM+Invoke.swift
//  AgoraMeetingUI
//
//  Created by ZYP on 2021/6/22.
//

import Foundation

extension NotiMessageVM {
    func invokeNotiMessageVMDidUpdateInfos(infos: [NotiMessageVM.NotiInfo]) {
        if Thread.current.isMainThread {
            delegate?.notiMessageVMDidUpdateInfos(infos: infos)
            return
        }
        
        DispatchQueue.main.async { [weak self] in
            guard let `self` = self else { return }
            self.delegate?.notiMessageVMDidUpdateInfos(infos: infos)
        }
    }
}
