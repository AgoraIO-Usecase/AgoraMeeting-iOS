//
//  BaseUIController.swift
//  AgoraMeetingUI
//
//  Created by ZYP on 2021/6/8.
//

import Foundation

protocol BaseControllerDataSource: NSObject {
    func controllerShouldGetVC() -> UIViewController
}

class BaseUIController: NSObject, ShowTipsProtocol {
    weak var baseDataSource: BaseControllerDataSource?
    
    func shouldShowTip(text: String) {
        let vc = baseDataSource?.controllerShouldGetVC()
        vc?.view.show(toast: text)
    }
    
    func shouldShowLoading() {
        let vc = baseDataSource?.controllerShouldGetVC()
        vc?.view.showLoading()
    }
    
    func shouldDismissLoading() {
        let vc = baseDataSource?.controllerShouldGetVC()
        vc?.view.dismissLoading()
    }
}
