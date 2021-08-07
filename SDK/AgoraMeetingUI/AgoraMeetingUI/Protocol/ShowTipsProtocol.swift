//
//  ShowTipsProtocol.swift
//  AgoraMeetingUI
//
//  Created by ZYP on 2021/6/4.
//

import Foundation

protocol ShowTipsProtocol: NSObject {
    func shouldShowTip(text: String)
    func shouldShowLoading()
    func shouldDismissLoading()
}
