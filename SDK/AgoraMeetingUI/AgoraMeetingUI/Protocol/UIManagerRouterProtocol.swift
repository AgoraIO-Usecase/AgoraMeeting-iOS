//
//  UIManagerRouterProtocol.swift
//  MeetingUI
//
//  Created by ZYP on 2021/5/23.
//

import UIKit

protocol UIManagerRouterProtocol: NSObjectProtocol {
    func pushBoardManagerFrom(_ uimanager: UIViewController)
    func pushUsersManagerFrom(_ uimanager: UIViewController)
    func pushMessageManagerFrom(_ uimanager: UIViewController)
    func pushSettingManagerFrom(_ uimanager: UIViewController)
}
