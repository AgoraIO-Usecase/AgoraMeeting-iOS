//
//  MainRenderVM+Action.swift
//  AgoraMeetingUI
//
//  Created by ZYP on 2021/6/9.
//

import Foundation
import AgoraMeetingContext

extension MainRenderVM {
    func dealAction(tapType: VideoCell.SheetAction,
                    info: VideoCell.Info) {
        let userId = info.userId
        switch tapType {
        case .upButton:
            break
        case .becomHost:
            usersContext.dealUserOperation(userId: userId,
                                           operation: .beHost,
                                           success: {}) { [weak self](error) in
                self?.invokeShouldShowTip(text: error.localizedMessage)
            }
            break
        case .abandonHost:
            usersContext.dealUserOperation(userId: userId,
                                           operation: .abandonHost,
                                           success: {}) { [weak self](error) in
                self?.invokeShouldShowTip(text: error.localizedMessage)
            }
            break
        case .setHost:
            usersContext.dealUserOperation(userId: userId,
                                           operation: .setAsHost,
                                           success: {}) { [weak self](error) in
                self?.invokeShouldShowTip(text: error.localizedMessage)
            }
            break
        case .closeAudio:
            usersContext.dealUserOperation(userId: userId,
                                           operation: .closeMic,
                                           success: {}) { [weak self](error) in
                self?.invokeShouldShowTip(text: error.localizedMessage)
            }
            break
        case .closeVideo:
            usersContext.dealUserOperation(userId: userId,
                                           operation: .closeCamera,
                                           success: {}) { [weak self](error) in
                self?.invokeShouldShowTip(text: error.localizedMessage)
            }
            break
        case .remove:
            usersContext.dealUserOperation(userId: userId,
                                           operation: .kickOut,
                                           success: {}) { [weak self](error) in
                self?.invokeShouldShowTip(text: error.localizedMessage)
            }
            break
        }
    }
}
