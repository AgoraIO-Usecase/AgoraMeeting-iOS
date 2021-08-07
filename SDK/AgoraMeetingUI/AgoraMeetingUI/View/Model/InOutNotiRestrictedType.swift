//
//  NotiType.swift
//  VideoConference
//
//  Created by ZYP on 2021/2/16.
//  Copyright © 2021 agora. All rights reserved.
//

import Foundation
enum InOutNotiRestrictedType: Int, CustomStringConvertible {
    case never = 0
    case n10 = 10
    case n20 = 20
    case n30 = 30
    case n40 = 40
    case n50 = 50
    case n60 = 60
    case n70 = 70
    case n80 = 80
    case n90 = 90
    case n100 = 100
    case always = -1
    
    var description: String {
        switch self {
        case .never:
            return MeetingUILocalizedString("noti_t2", comment: "")
        case .n10:
            return "10" + MeetingUILocalizedString("noti_t3", comment: "")
        case .n20:
            return "20" + MeetingUILocalizedString("noti_t3", comment: "")
        case .n30:
            return "30" + MeetingUILocalizedString("noti_t3", comment: "")
        case .n40:
            return "40" + MeetingUILocalizedString("noti_t3", comment: "")
        case .n50:
            return "50" + MeetingUILocalizedString("noti_t3", comment: "")
        case .n60:
            return "60" + MeetingUILocalizedString("noti_t3", comment: "")
        case .n70:
            return "70" + MeetingUILocalizedString("noti_t3", comment: "")
        case .n80:
            return "80" + MeetingUILocalizedString("noti_t3", comment: "")
        case .n90:
            return "90" + MeetingUILocalizedString("noti_t3", comment: "")
        case .n100:
            return "100" + MeetingUILocalizedString("noti_t3", comment: "")
        case .always:
            return MeetingUILocalizedString("noti_t4", comment: "")
        }
    }
    
    var indexValue: Int {
        switch self {
        case .never:
            return 0
        case .n10:
            return 1
        case .n20:
            return 2
        case .n30:
            return 3
        case .n40:
            return 4
        case .n50:
            return 5
        case .n60:
            return 6
        case .n70:
            return 7
        case .n80:
            return 8
        case .n90:
            return 9
        case .n100:
            return 10
        case .always:
            return 11
        }
    }
    
}
