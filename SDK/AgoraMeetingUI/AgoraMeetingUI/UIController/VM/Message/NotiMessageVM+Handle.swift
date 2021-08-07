//
//  NotiMessageVM+Handle.swift
//  AgoraMeetingUI
//
//  Created by ZYP on 2021/6/22.
//

import Foundation
import AgoraMeetingContext

extension NotiMessageVM {
    func handleUpdateNotiInfos(infos: [NotiEventScheduler.Info]) {
        let temp = infos.map({ $0.toNotiCellInfo })
        invokeNotiMessageVMDidUpdateInfos(infos: temp)
    }
    
    func handleUpdateNotiInfosOnQueue(infos: [NotiEventScheduler.Info]) {
        queue.async { [weak self] in
            self?.handleUpdateNotiInfos(infos: infos)
        }
    }
}

extension NotiEventScheduler.Info {
    var toNotiCellInfo: NotiCell.Info {
        let time = Date(timeIntervalSince1970: timestamp).timeString3
        let hasAction = type.hasAction
        if hasAction, count > 0, !actionSuccess {
            var info = NotiCell.Info(id: id,
                                     msg: msg,
                                     buttonTitle: buttonTitle,
                                     buttonEnable: true,
                                     timeCount: TimeInterval(count),
                                     time: time,
                                     typeValue: Int(type.rawValue),
                                     targetUserId: sender.userId,
                                     timeStamp: timestamp)
            info.showTime = showTime
            info.isFirstCell = id == 0
            return info
        }
        if hasAction, actionSuccess {
            var info = NotiCell.Info(id: id,
                                     msg: msg,
                                     buttonTitle: buttonTitle,
                                     buttonEnable: false,
                                     timeCount: TimeInterval(count),
                                     time: time,
                                     typeValue: Int(type.rawValue),
                                     targetUserId: sender.userId,
                                     timeStamp: timestamp)
            info.showTime = showTime
            info.isFirstCell = id == 0
            return info
        }
        if hasAction {
            var info = NotiCell.Info(id: id,
                                     msg: msg,
                                     buttonTitle: buttonTitle,
                                     buttonEnable: buttonEnable,
                                     time: time,
                                     typeValue: Int(type.rawValue),
                                     timeStamp: timestamp)
            info.showTime = showTime
            info.isFirstCell = id == 0
            return info
        }
        
        var info = NotiCell.Info(id: id,
                                 msg: msg,
                                 time: time,
                                 typeValue: Int(type.rawValue),
                                 timeStamp: timestamp)
        info.showTime = showTime
        info.isFirstCell = id == 0
        return info
    }
}

extension NotiEventScheduler.Info {
    var msg: String {
        switch type {
        case .adminChangeBeHost,
             .userChangeEnter,
             .userChangeLeft,
             .screenChangeOn,
             .boardChangeOn,
             .boardChangeOff,
             .boardInteractOn,
             .userApproveApplyCam,
             .userApproveApplyMic,
             .userApproveAcceptCam,
             .userApproveAcceptMic:
            return "\(sender.userName)-\(tipsMsg)"
        case .notifyInOutClosed,
             .sysPermissionCamDenied,
             .sysPermissionMicDenied,
             .adminMuteAllMic,
             .adminMuteAllCam,
             .accessChangeCamOn,
             .accessChangeMicOn,
             .accessChangeCamOff,
             .accessChangeMicOff,
             .adminMuteYourCam,
             .adminChangeNoHost,
             .adminMuteYourMic,
             .screenChangeOff,
             .notifyInOutOverMaxLimit,
             .recordClose:
            return tipsMsg
        }
    }
    
    var tipsMsg: String {
        switch type {
        case .adminMuteAllMic:
            return MeetingUILocalizedString("meeting_t8", comment: "")
        case .adminMuteAllCam:
            return MeetingUILocalizedString("meeting_t7", comment: "")
        case .accessChangeCamOn:
            return MeetingUILocalizedString("meeting_t12", comment: "")
        case .accessChangeMicOn:
            return MeetingUILocalizedString("meeting_t13", comment: "")
        case .accessChangeCamOff:
            return MeetingUILocalizedString("meeting_t19", comment: "")
        case .accessChangeMicOff:
            return MeetingUILocalizedString("meeting_t20", comment: "")
        case .adminMuteYourCam:
            return MeetingUILocalizedString("meeting_t1", comment: "")
        case .adminMuteYourMic:
            return MeetingUILocalizedString("meeting_t2", comment: "")
        case .adminChangeBeHost:
            return MeetingUILocalizedString("noti_t14", comment: "")
        case .adminChangeNoHost:
            return MeetingUILocalizedString("noti_t8", comment: "")
        case .userChangeEnter:
            return MeetingUILocalizedString("noti_t7", comment: "")
        case .userChangeLeft:
            return MeetingUILocalizedString("noti_t6", comment: "")
        case .screenChangeOn:
            return MeetingUILocalizedString("noti_t10", comment: "")
        case .screenChangeOff:
            return MeetingUILocalizedString("meeting_t18", comment: "")
        case .boardChangeOn:
            return MeetingUILocalizedString("noti_t9", comment: "")
        case .boardChangeOff:
            return MeetingUILocalizedString("noti_t11", comment: "")
        case .boardInteractOn:
            return MeetingUILocalizedString("noti_t12", comment: "")
        case .userApproveApplyCam:
            return MeetingUILocalizedString("meeting_t34", comment: "")
        case .userApproveApplyMic:
            return MeetingUILocalizedString("meeting_t35", comment: "")
        case .userApproveAcceptCam:
            return MeetingUILocalizedString("noti_t16", comment: "")
        case .userApproveAcceptMic:
            return MeetingUILocalizedString("noti_t15", comment: "")
        case .notifyInOutOverMaxLimit:
            let userInoutLimitNumber = (payload as! NotifyMessage.PayloadNotiInoutLimit).userInoutLimitNumber
            return MeetingUILocalizedString("meeting_t59", comment: "") + "\(userInoutLimitNumber)" + MeetingUILocalizedString("meeting_t60", comment: "")
        case .notifyInOutClosed:
            return MeetingUILocalizedString("meeting_t28", comment: "")
        case .sysPermissionMicDenied:
            return MeetingUILocalizedString("meeting_t45", comment: "")
        case .sysPermissionCamDenied:
            return MeetingUILocalizedString("meeting_t31", comment: "")
        case .recordClose:
            return MeetingUILocalizedString("meeting_t63", comment: "")
        }
    }
    
    var buttonTitle: String {
        switch type {
        case .userApproveApplyCam,
             .userApproveApplyMic:
            return actionSuccess ? MeetingUILocalizedString("noti_t1", comment: "") : MeetingUILocalizedString("meeting_t14", comment: "")
        case .adminChangeNoHost:
            return MeetingUILocalizedString("noti_t5", comment: "")
        case .sysPermissionCamDenied,
             .sysPermissionMicDenied:
            return MeetingUILocalizedString("noti_t13", comment: "")
        case .notifyInOutClosed,
             .notifyInOutOverMaxLimit:
            return MeetingUILocalizedString("meeting_t4", comment: "")
        default:
            return ""
        }
    }
    
    var buttonEnable: Bool {
        switch type {
        case .userApproveApplyCam,
             .userApproveApplyMic:
            if actionSuccess {
                return false
            }
            if count <= 0 && !actionSuccess {
                return false
            }
            return true
        case .adminChangeNoHost:
            return !actionSuccess
        case .notifyInOutClosed,
             .notifyInOutOverMaxLimit:
            return true
        default:
            return true
        }
    }
}
