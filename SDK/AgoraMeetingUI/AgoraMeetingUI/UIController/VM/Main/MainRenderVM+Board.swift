//
//  MainRenderVM+Board.swift
//  AgoraMeetingUI
//
//  Created by ZYP on 2021/6/16.
//

import Foundation
import AgoraMeetingContext

extension MainRenderVM {
    func closeBoardShare() {
        boardContext.closeBoardSharing(success: {}, fail: { [weak self](error) in
            self?.invokeShouldShowTip(text: error.localizedMessage)
        })
    }
}
