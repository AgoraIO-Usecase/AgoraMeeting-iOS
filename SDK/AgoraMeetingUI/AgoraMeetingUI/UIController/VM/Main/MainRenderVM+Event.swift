//
//  MainRenderVM+Event.swift
//  AgoraMeetingUI
//
//  Created by ZYP on 2021/6/10.
//

import Foundation
import AgoraMeetingContext

extension MainRenderVM: RenderEventHandler {
    func onRenderInfoUpdated(renders: [RenderInfo]) {
        eventScheduler.set(renders: renders)
    }
}

extension MainRenderVM: ScreenEventHandler {
    func onScreenStateUpdated(isOpen: Bool) {
        handleScreen()
    }
}

extension MainRenderVM: EventSchedulerDelegate {
    func eventSchedulerDidUpdate(updateInfo: UpdateInfo) {
        invokeRenderVMDidUpdateInfo(info: updateInfo)
    }
}
