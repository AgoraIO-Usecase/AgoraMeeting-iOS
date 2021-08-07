//
//  MainRenderUIController+Event.swift
//  AgoraMeetingUI
//
//  Created by ZYP on 2021/6/14.
//

import Foundation

extension MainRenderUIController: RenderVMDelegate {
    func renderVMDidUpdateInfo(vm: MainRenderVM,
                               info: MainRenderVM.UpdateInfo) {
        update(info: info)
    }
    
    func renderVMShouldShowSystemViewForScreenStart(vm: MainRenderVM) {
        handleTapArPickerButton()
    }
}

extension MainRenderUIController: SpeakerViewDelegate {
    func speakerViewDidTapRightButton(_ action: RightButtonActionType) {
        switch action {
        case .changeMode:
            vm.switchToTile()
            break
        case .screenShareQuit:
            showCloseScreenAlert()
            break
        case .whiteBoardEnter:
            delegate?.mainRenderUIControllerShouldShowBoardManager()
            break
        @unknown default:
            fatalError()
        }
    }
}

extension MainRenderUIController: VideoCellDelegate {
    func videoCell(cell: VideoCell,
                   tapType: VideoCell.SheetAction,
                   info: VideoCell.Info) {
        if tapType == .upButton {
            vm.setTileTop(renderId: info.id, isTop: !cell.upButton.isSelected)
            return
        }
        vm.dealAction(tapType: tapType,
                      info: info)
    }
}
