//
//  MainRenderUIController+ScreenShare.swift
//  AgoraMeetingUI
//
//  Created by ZYP on 2021/6/16.
//

import Foundation
import ReplayKit
import AVKit

extension MainRenderUIController {
    func addSystemBroadcastPickerView() {
        if #available(iOS 12.0, *) {
            let rpPickerView = RPSystemBroadcastPickerView()
            rpPickerView.frame = CGRect(x: UIScreen.width/2 - 30, y: UIScreen.height/2 - 30 - 30, width: 60, height: 60)
            rpPickerView.showsMicrophoneButton = false
            if let url = Bundle.main.url(forResource: "ScreenSharingBroadcast", withExtension: "appex", subdirectory: "PlugIns") {
                if let bundle = Bundle(url: url) {
                    rpPickerView.preferredExtension = bundle.bundleIdentifier
                }
            }
            rpPickerView.isHidden = true
            view.addSubview(rpPickerView)
            self.rpPickerView = rpPickerView
        }
    }
    
    func handleTapArPickerButton() {
        if #available(iOS 12.0, *) {
            for view in rpPickerView.subviews {
                if let btn = view as? UIButton {
                    Log.info(text: "did auto handleTapArPickerButton")
                    if let systemVersion = Double(UIDevice.current.systemVersion.split(separator: ".").first ?? "0"),
                       systemVersion >= 12.0,
                       systemVersion < 13.0 {
                        btn.sendActions(for: .allTouchEvents)
                    }
                    else {
                        btn.sendActions(for: .touchUpInside)
                    }
                }
            }
        }
    }
    
    func sendToScreenShareExitIfNeed() {
        /// screen share app will exit
        let center = CFNotificationCenterGetDarwinNotifyCenter()
        let name = CFNotificationName("com.videoconference.exit" as CFString)
        let userInfo = [String : String]() as CFDictionary
        CFNotificationCenterPostNotification(center, name, nil, userInfo, true)
    }
}
