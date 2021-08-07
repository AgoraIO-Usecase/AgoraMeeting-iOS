//
//  Toast_Swift+Extension.swift
//  AgoraMeetingUI
//
//  Created by ZYP on 2021/6/4.
//

import Foundation
import Toast_Swift

extension UIView {
    func show(toast: String) {
        makeToast(toast,
                  position: .center)
    }
    
    func showLoading() {
        ToastManager.shared.style.activitySize = CGSize(width: 60,
                                                        height: 60)
        ToastManager.shared.style.activityBackgroundColor = .white
        ToastManager.shared.style.activityIndicatorColor = .gray
        makeToastActivity(.center)
    }
    
    func dismissLoading() {
        hideToastActivity()
    }
}
