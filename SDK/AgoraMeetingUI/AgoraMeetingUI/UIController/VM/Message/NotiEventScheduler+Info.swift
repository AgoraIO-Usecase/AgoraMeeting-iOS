//
//  NotiEventScheduler+Info.swift
//  AgoraMeetingUI
//
//  Created by ZYP on 2021/6/22.
//

import Foundation
import AgoraMeetingContext

extension NotiEventScheduler {
    struct Info: Equatable {
        let id: Int
        let type: NotifyMessageType
        var count: Int
        let sender: UserInfo
        let showTime: Bool
        var actionSuccess: Bool
        let timestamp: TimeInterval
        let payload: NotifyMessage.Payload
        
        mutating func updateForCount() {
            if count > 0 {
                count -= 1
            }
        }
        
        mutating func updateForSuccess() {
            actionSuccess = true
            count = 0
        }
        
        init(noti: NotifyMessage,
             showTime: Bool) {
            self.id = noti.messageId
            self.type = noti.type
            self.sender = noti.sender
            self.showTime = showTime
            self.count = (noti.type == .userApproveApplyCam || noti.type == .userApproveApplyMic) ? 20 : 0
            self.actionSuccess = false
            self.timestamp = noti.timestamp
            self.payload = noti.payload
        }
        
        static func == (lhs: Info, rhs: Info) -> Bool {
            return lhs.id == rhs.id
                && lhs.count == rhs.count
                && lhs.actionSuccess == rhs.actionSuccess
        }
        
    }
}

extension NotifyMessageType {
    var hasAction: Bool {
        switch self {
        case .userApproveApplyCam,
             .userApproveApplyMic,
             .adminChangeNoHost,
             .sysPermissionCamDenied,
             .sysPermissionMicDenied,
             .notifyInOutOverMaxLimit,
             .notifyInOutClosed:
            return true
        default:
            return false
        }
    }
}

