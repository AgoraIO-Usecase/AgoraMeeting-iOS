//
//  StorageManager.swift
//  VideoConference
//
//  Created by ZYP on 2021/5/26.
//  Copyright © 2021 agora. All rights reserved.
//

import Foundation
import AgoraMeetingUI

class StorageManager {
    static var userName: String {
        set {
            UserDefaults.standard.setValue(newValue,
                                           forKey: "userName")
        }
        get {
            return (UserDefaults.standard.value(forKey: "userName") as? String) ?? ""
        }
    }
    
    static var roomName: String {
        set {
            UserDefaults.standard.setValue(newValue,
                                           forKey: "roomName")
        }
        get {
            return (UserDefaults.standard.value(forKey: "roomName") as? String) ?? ""
        }
    }
    
    static var openMic: Bool {
        set {
            UserDefaults.standard.setValue(newValue,
                                           forKey: "openMic")
        }
        get {
            return (UserDefaults.standard.value(forKey: "openMic") as? Bool) ?? true
        }
    }
    
    static var openCan: Bool {
        set {
            UserDefaults.standard.setValue(newValue,
                                           forKey: "openCan")
        }
        get {
            return (UserDefaults.standard.value(forKey: "openCan") as? Bool) ?? true
        }
    }
    
    static var notiType: Int {
        set {
            UserDefaults.standard.setValue(newValue,
                                           forKey: "notiType")
        }
        get {
            return (UserDefaults.standard.value(forKey: "notiType") as? Int) ?? 0
        }
    }
    
    static var uuid: String {
        set {
            UserDefaults.standard.setValue(newValue,
                                           forKey: "uuid")
        }
        get {
            var value = (UserDefaults.standard.value(forKey: "uuid") as? String)
            if value == nil {
                value = UUID().uuidString
                UserDefaults.standard.setValue(value,
                                               forKey: "uuid")
            }
            return value!
        }
    }
    
    public static var inOutNotiRestrictedType: InOutNotiRestrictedType {
        set {
            UserDefaults.standard.setValue(newValue.rawValue,
                                           forKey: "inOutNotiRestrictedTypeValue")
        }
        get {
            guard let value = (UserDefaults.standard.value(forKey: "inOutNotiRestrictedTypeValue") as? Int) else {
                UserDefaults.standard.setValue(InOutNotiRestrictedType.n50.rawValue,
                                               forKey: "inOutNotiRestrictedTypeValue")
                return .n50
            }
            return InOutNotiRestrictedType(rawValue: value)!
        }
    }

}
