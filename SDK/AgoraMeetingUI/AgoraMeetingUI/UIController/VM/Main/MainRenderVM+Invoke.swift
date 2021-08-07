//
//  MainRenderVM+Invoke.swift
//  AgoraMeetingUI
//
//  Created by ZYP on 2021/6/10.
//

import Foundation

extension MainRenderVM {
    func invokeRenderVMDidUpdateInfo(info: MainRenderVM.UpdateInfo) {
        if Thread.current.isMainThread {
            delegate?.renderVMDidUpdateInfo(vm: self,
                                            info: info)
            return
        }
        
        DispatchQueue.main.async { [weak self] in
            guard let `self` = self else { return }
            self.delegate?.renderVMDidUpdateInfo(vm: self,
                                                 info: info)
        }
    }

    func invokeRenderVMShouldShowSystemViewForScreenStart() {
        if Thread.current.isMainThread {
            delegate?.renderVMShouldShowSystemViewForScreenStart(vm: self)
            return
        }
        
        DispatchQueue.main.async { [weak self] in
            guard let `self` = self else { return }
            self.delegate?.renderVMShouldShowSystemViewForScreenStart(vm: self)
        }
    }
}
