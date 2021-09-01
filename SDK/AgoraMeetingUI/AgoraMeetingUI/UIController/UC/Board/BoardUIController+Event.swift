//
//  BoardUIController+Event.swift
//  AgoraMeetingUI
//
//  Created by ZYP on 2021/6/14.
//

import Foundation
import Whiteboard
import AgoraMeetingContext

extension BoardUIController: BoardVMDelegate {
    func boardVM(vm: BoardVM,
                 didUpdate permission: BoardPermission) {
        updateRightButton(permission: permission)
        handleWritable(permission: permission)
    }
    
    func boardVMDidCloseBoard(vm: BoardVM) {
        let current = baseDataSource?.controllerShouldGetVC()
        current?.navigationController?.popViewController(animated: true)
    }
}

extension BoardUIController: EEWhiteboardToolDelegate, EEColorShowViewDelegate {
    func eeColorShowViewDidSelecteColor(_ colorString: String) {
        let params = UIColor.convert(toRGB: UIColor(hexString: colorString)) as! [Int]
        vm.setStrokeColor(color: params)
    }
    
    func eeWhiteboardToolDidTapButton(action: EEWhiteboardToolView.ActionType) {
        switch action {
        case .color:
            view.colorView.isHidden = !view.colorView.isHidden
            break
        case .select:
            vm.setApplianceAction(action: .selector)
            break
        case .pan:
            vm.setApplianceAction(action: .pencil)
            break
        case .text:
            vm.setApplianceAction(action: .text)
            break
        case .eraser:
            vm.setApplianceAction(action: .eraser)
            break
        case .rantangle:
            vm.setApplianceAction(action: .rectangle)
            break
        case .ellipse:
            vm.setApplianceAction(action: .ellipse)
            break
        }
    }
    
    func eeWhiteboardToolDidTapButtonClean() {
        vm.cleanBoard()
    }
}

extension BoardUIController {
    @objc func closeBoardAction() {
        vm.closeBoardShare()
    }
    
    @objc func requestInteractAction() {
        vm.applyBoardInteract()
    }
    
    @objc func abandonInteractAction() {
        vm.cancelBoardInteract()
    }
}
