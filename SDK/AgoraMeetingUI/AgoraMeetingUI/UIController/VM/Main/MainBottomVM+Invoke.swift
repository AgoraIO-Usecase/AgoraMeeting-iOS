//
//  MainBottomVM+Invoke.swift
//  AgoraMeetingUI
//
//  Created by ZYP on 2021/6/10.
//

import Foundation
import AgoraMeetingContext

extension MainBottomVM { /** Invoke **/
    func invokeMainBottomVM(device: DeviceType,
                            shouldUpdateDeviceItem enable: Bool) {
        if Thread.current.isMainThread {
            delegate?.mainBottomVM(vm: self,
                                   device: device,
                                   shouldUpdateDeviceItem: enable)
            return
        }
        
        DispatchQueue.main.sync { [weak self] in
            guard let `self` = self else { return }
            self.delegate?.mainBottomVM(vm: self,
                                        device: device,
                                        shouldUpdateDeviceItem: enable)
        }
    }
    
    func invokeMainBottomVM(device: DeviceType,
                            didLocalDeviceStateChange state: LocalDeviceState,
                            timeCount: Int) {
        if Thread.current.isMainThread {
            delegate?.mainBottomVM(vm: self,
                                   device: device,
                                   didLocalDeviceStateChange: state,
                                   timeCount: timeCount)
            return
        }
        
        DispatchQueue.main.sync { [weak self] in
            guard let `self` = self else { return }
            self.delegate?.mainBottomVM(vm: self,
                                        device: device,
                                        didLocalDeviceStateChange: state,
                                        timeCount: timeCount)
        }
    }
    
    func invokeMainBottomVMShouldAllowUserInteraction() {
        if Thread.current.isMainThread {
            delegate?.mainBottomVMShouldAllowUserInteraction(vm: self)
            return
        }
        
        DispatchQueue.main.sync { [weak self] in
            guard let `self` = self else { return }
            self.delegate?.mainBottomVMShouldAllowUserInteraction(vm: self)
        }
    }
    
    func invokeMianBottomVMShouldShowApproveAlter(device: DeviceType) {
        if Thread.current.isMainThread {
            delegate?.mainBottomVMShouldShowApproveAlter(vm: self,
                                                         device: device)
            return
        }
        
        DispatchQueue.main.sync { [weak self] in
            guard let `self` = self else { return }
            self.delegate?.mainBottomVMShouldShowApproveAlter(vm: self,
                                                              device: device)
        }
    }
    
    func invokeMianBottomVMShouldShowMoreSheet(moreInfo: MoreInfo) {
        if Thread.current.isMainThread {
            delegate?.mainBottomVMShouldShowMoreSheet(vm: self,
                                                      moreInfo: moreInfo)
            return
        }
        
        DispatchQueue.main.sync { [weak self] in
            guard let `self` = self else { return }
            self.delegate?.mainBottomVMShouldShowMoreSheet(vm: self,
                                                           moreInfo: moreInfo)
        }
    }
    
    func invokeMainBottomVMShouldShowRedDot(count: Int) {
        if Thread.current.isMainThread {
            delegate?.mainBottomVMShouldShowRedDot(vm: self,
                                                   count: count)
            return
        }
        
        DispatchQueue.main.sync { [weak self] in
            guard let `self` = self else { return }
            self.delegate?.mainBottomVMShouldShowRedDot(vm: self,
                                                        count: count)
        }
    }
}
