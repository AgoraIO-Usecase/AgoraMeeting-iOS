//
//  MeetingError+Extension.swift
//  AgoraMeetingUI
//
//  Created by ZYP on 2021/7/1.
//

import Foundation
import AgoraMeetingContext

extension MeetingError {
    public var localizedMessage: String {
        switch domain {
        case .local:
            return rebaceLocal(code: code)
        case .rte: /** from rte **/
            return "rte: " + message
        case .http: /** from http provider **/
            return rebaseHttp(code: code)
        case .meetingServer: /** from http provider **/
            return rebaseMeetingServer(code: code)
        }
    }
    
    func rebaceLocal(code: Int) -> String {
        guard let key = LocalErrorKey(rawValue: code) else {
            return "\(code) unknow local error"
        }
        
        switch key {
        case .roomNameEmpty:
            return MeetingUILocalizedString("login_t0")
        case .roomNameLengthIllegal:
            return MeetingUILocalizedString("")
        case .roomNameContainEmoji:
            return MeetingUILocalizedString("")
        case .userNameEmpty:
            return MeetingUILocalizedString("login_t1")
        case .userNameLengthIllegal:
            return MeetingUILocalizedString("")
        case .userNameContainEmoji:
            return MeetingUILocalizedString("")
        case .roomPasswordLengthIllegal:
            return MeetingUILocalizedString("")
        case .roomPasswordContainEmoji:
            return MeetingUILocalizedString("")
        case .roomIdEmpty:
            return MeetingUILocalizedString("")
        case .userIdEmpty:
            return MeetingUILocalizedString("")
        case .roomJoinStateIllegal:
            return message
        case .userRoleIllegal:
            return message
        case .roomHasHostExist:
            return message
        case .boardStateIllegal:
            return message
        case .screenStateIllegal:
            return message
        case .messageNotiExist:
            return message
        case .userIdNotExist:
            return message
        case .noBoardInRoom:
            return message
        }
    }
    
    func rebaseMeetingServer(code: Int) -> String {
        switch (code) {
            case 32403100:
                return MeetingUILocalizedString("meetingServer_t1")
            case 32409200:
                return MeetingUILocalizedString("meetingServer_t2")
            case 32409201:
                return MeetingUILocalizedString("meetingServer_t3")
            case 32409202:
                return MeetingUILocalizedString("meetingServer_t4")
            case 32409203:
                return MeetingUILocalizedString("meetingServer_t5")
            case 32410200:
                return MeetingUILocalizedString("meetingServer_t6")
            case 32410201:
                return MeetingUILocalizedString("meetingServer_t7")
            case 32400000:
                return MeetingUILocalizedString("meetingServer_t8")
            case 32400001:
                return MeetingUILocalizedString("meetingServer_t9")
            case 32400002:
                return MeetingUILocalizedString("meetingServer_t10")
            case 32400003:
                return MeetingUILocalizedString("meetingServer_t11")
            case 32400004:
                return MeetingUILocalizedString("meetingServer_t12")
            case 32400005:
                return MeetingUILocalizedString("meetingServer_t13")
            case 32403300:
                return MeetingUILocalizedString("meetingServer_t14")
            case 32403420:
                return MeetingUILocalizedString("meetingServer_t15")
            case 32404300:
                return MeetingUILocalizedString("meetingServer_t16")
            case 32404420:
                return MeetingUILocalizedString("meetingServer_t17")
            case 32409300:
                return MeetingUILocalizedString("meetingServer_t18")
            case 32409420:
                return MeetingUILocalizedString("meetingServer_t19")
            case 30404420:
                return MeetingUILocalizedString("meetingServer_t20")
            case 20403002:
                return MeetingUILocalizedString("meetingServer_t22")
            case 20403001:
                return MeetingUILocalizedString("meetingServer_t23")
            case 20410100:
                return MeetingUILocalizedString("meetingServer_t24")
            
            default:
                return "\(code) " + message
        }
    }
    
    func rebaseHttp(code: Int) -> String {
        switch code {
        case -1009:
            return MeetingUILocalizedString("meetingServer_t21")
        default:
            return message
        }
    }
}
