//
//  BaseVM.swift
//  AgoraMeetingUI
//
//  Created by ZYP on 2021/6/8.
//

import Foundation

class BaseVM: NSObject {
    weak var tipsDelegate: ShowTipsProtocol?
    
    func invokeShouldShowTip(text: String) {
        if Thread.current.isMainThread {
            tipsDelegate?.shouldShowTip(text: text)
            return
        }
        
        DispatchQueue.main.sync { [weak self] in
            self?.tipsDelegate?.shouldShowTip(text: text)
        }
    }
    
    func invokeShouldShowLoading() {
        if Thread.current.isMainThread {
            tipsDelegate?.shouldShowLoading()
            return
        }
        
        DispatchQueue.main.sync { [weak self] in
            self?.tipsDelegate?.shouldShowLoading()
        }
    }
    
    func invokeShouldDismissLoading() {
        if Thread.current.isMainThread {
            tipsDelegate?.shouldDismissLoading()
            return
        }
        
        DispatchQueue.main.sync { [weak self] in
            self?.tipsDelegate?.shouldDismissLoading()
        }
    }
}
