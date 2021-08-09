//
//  MainRenderVM+ScreenShare.swift
//  AgoraMeetingUI
//
//  Created by ZYP on 2021/6/16.
//

import Foundation
import AgoraMeetingContext

extension MainRenderVM {
    func registerNotiFormScreenShareExtension() {
        let observer = UnsafeRawPointer(Unmanaged.passUnretained(self).toOpaque())
        let callback: CFNotificationCallback = { (_, observer, name, obj, userInfo) -> Void in
            if let observer = observer {
                let mySelf = Unmanaged<MainRenderVM>.fromOpaque(observer).takeUnretainedValue()
                mySelf.stopScreenShareByExtension()
            }
        }
        
        CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),
                                        observer,
                                        callback,
                                        "com.videoconference.shareendbyapp" as CFString,
                                        nil,
                                        .deliverImmediately)
    }
    
    func unregisterNotiFormScreenShareExtension() {
        let observer = UnsafeRawPointer(Unmanaged.passUnretained(self).toOpaque())
        CFNotificationCenterRemoveObserver(CFNotificationCenterGetDarwinNotifyCenter(),
                                           observer,
                                           CFNotificationName(rawValue: "com.videoconference.shareendbyapp" as CFString),
                                           nil)
    }
    
    func closeScreenSharing() {
        screenContext.closeScreenSharing(success: {}) { [weak self](error) in
            self?.invokeShouldShowTip(text: error.localizedMessage)
        }
    }
    
    func openScreenSharing() {
        screenContext.openScreenSharing(success: {}) { [weak self](error) in
            self?.invokeShouldShowTip(text: error.localizedMessage)
        }
    }
    
    func handleScreen() {
        if screenContext.isScreenSharing(),
           !screenContext.isScreenSharingByMyself() { /** start for other **/
            return
        }
        
        if screenContext.isScreenSharing(),
           screenContext.isScreenSharingByMyself() { /** start for me **/
            if let screenInfo = screenContext.getScreenInfo() {
                saveScreenParamInUserDefault(screenInfo: screenInfo)
                invokeRenderVMShouldShowSystemViewForScreenStart()
                return
            }
            
            Log.info(text: "no screenInfo, should close screen", tag: "MainRenderVM")
            closeScreenSharing()
        }

        if !screenContext.isScreenSharing(){ /** stop **/
            sendNotiToExtensionForStop()
            return
        }
    }
    
    func saveScreenParamInUserDefault(screenInfo: ScreenInfo) {
        let screenId = screenInfo.streamId
        let token = screenInfo.token
        let channnelId = screenInfo.channnelId
        let appId = screenInfo.appId
        let infoDict = Bundle.main.infoDictionary
        let temp = infoDict?["AppGroupId"] as? String
        if temp == nil {
            Log.errorText(text: "did not set AppGroupId in info.plist")
        }
        let appGroupId = temp ?? "group.io.agora.meetingInternal"
        let userDefault = UserDefaults(suiteName: appGroupId)
        userDefault?.setValue(appId, forKey: "appid")
        userDefault?.setValue(screenId, forKey: "screenid")
        userDefault?.setValue(token, forKey: "token")
        userDefault?.setValue(channnelId, forKey: "channelid")
        userDefault?.synchronize()
    }
    
    func sendNotiToExtensionForStop() {
        Log.info(text:"sendNotiToExtensionForStop", tag: "MainRenderVM")
        let center = CFNotificationCenterGetDarwinNotifyCenter()
        let name = CFNotificationName("com.videoconference.exit" as CFString)
        let userInfo = [String : String]() as CFDictionary
        CFNotificationCenterPostNotification(center, name, nil, userInfo, true)
    }
    
    func stopScreenShareByExtension() {
        closeScreenSharing()
    }
    
}
