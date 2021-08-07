//
//  BoardUIController.swift
//  AgoraMeetingUI
//
//  Created by ZYP on 2021/6/14.
//

import Foundation
import WhiteModule
import AgoraMeetingContext
import Whiteboard

class BoardUIController: BaseUIController {
    let view = BoardView()
    var vm: BoardVM!
    var rightButton: UIBarButtonItem?
    
    init(boardContext: BoardContext) {
        vm = BoardVM(boardContext: boardContext)
        super.init()
        vm.tipsDelegate = self
    }
    
    func renderView() {
        view.leftView.delegate = self
        view.colorView.delegate = self
        let permission = vm.getPermission()
        let canWrite = permission != .noPremission
        vm.render(view: view.whiteBoardView,
                  canWrite: canWrite)
        vm.delegate = self
        updateRightButton(permission: permission)
        handleWritable(permission: permission)
    }
    
    func updateRightButton(permission: BoardPermission) {
        switch permission {
        case .admin:
            let item = UIBarButtonItem(title: MeetingUILocalizedString("wb_t4", comment: ""),
                                       style: .plain,
                                       target: self,
                                       action: #selector(closeBoardAction))
            item.tintColor = UIColor(hex: 0xFF5F51)
            view.leftView.isHidden = false
            rightButton = item
            let current = baseDataSource?.controllerShouldGetVC()
            current?.navigationItem.rightBarButtonItem = rightButton
            break
        case .noPremission:
            let item = UIBarButtonItem(title: MeetingUILocalizedString("wb_t1", comment: ""),
                                       style: .plain,
                                       target: self,
                                       action: #selector(requestInteractAction))
            item.tintColor = UIColor(hex: 0x4DA1FF)
            rightButton = item
            view.leftView.isHidden = true
            rightButton = item
            let current = baseDataSource?.controllerShouldGetVC()
            current?.navigationItem.rightBarButtonItem = rightButton
            break
        case .interact:
            let item = UIBarButtonItem(title: MeetingUILocalizedString("wb_t2", comment: ""),
                                       style: .plain,
                                       target: self,
                                       action: #selector(abandonInteractAction))
            item.tintColor = UIColor(hex: 0x4DA1FF)
            view.leftView.isHidden = false
            rightButton = item
            let current = baseDataSource?.controllerShouldGetVC()
            current?.navigationItem.rightBarButtonItem = rightButton
            break
        }
    }
    
    func handleWritable(permission: BoardPermission) {
        switch permission {
        case .noPremission:
            vm.setWritable(writable: false)
            break
        default:
            vm.setWritable(writable: true)
            break
        }
    }
}
