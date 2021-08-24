//
//  MeetingSDK.swift
//  MeetingApaasTest
//
//  Created by ZYP on 2021/5/11.
//

import UIKit
import AgoraMeetingUI
import AgoraMeetingContext
import AgoraMeetingCore

public class MeetingSDK: NSObject {
    public typealias SuccessBlock = (AgoraMeetingUI) -> ()
    public typealias FailBlock = (MeetingError) -> ()
    private var core: MeetingCore!
    public weak var exitRoomDelegate: ExitRoomDelegate?
    public weak var networkQualityDelegate: NetworkQualityDelegate?
    
    @objc public init(config: MeetingConfig) {
        core = MeetingCore(config: config)
        super.init()
        commonInit()
    }
    
    private func commonInit() {
        core.networkQualityDelegate = self
    }
    
    public func launch(launchConfig: LaunchConfig,
                       success: @escaping SuccessBlock,
                       fail: @escaping FailBlock) {
        core.exitRoomDelegate = self
        core.launch(lauchConfig: launchConfig,
                    success: { (contextPool) in
                        let ui = AgoraMeetingUI(contextPool: contextPool)
                        ui.modalPresentationStyle = .fullScreen
                        success(ui)
                    },
                    fail: { (e) in
                        fail(e)
                    })
    }
    
    public static func getCoreVersionName() -> String {
        MeetingCore.getCoreVersionName()
    }
    
    public static func getCoreVersionCode() -> Int {
        MeetingCore.getCoreVersionCode()
    }
    
    public static func getRtcVersionName() -> String {
        MeetingCore.getRtcVersionName()
    }
    
    public static func getRtmVersionName() -> String {
        MeetingCore.getRtmVersionName()
    }
    
    public static func getWhiteBoardVersionName() -> String {
        MeetingCore.getWhiteBoardVersionName()
    }
    
    public func enableNetQualityCheck() {
        core.enableNetQualityCheck()
    }
    
    public func disableNetQualityCheck() {
        core.disableNetQualityCheck()
    }
    
    public func setParameters(parameters: String) {
        core.setParameters(parameters: parameters)
    }
}

extension MeetingSDK: ExitRoomDelegate {
    public func onExit(cache: RoomCache) {
        exitRoomDelegate?.onExit(cache: cache)
    }
}

extension MeetingSDK: NetworkQualityDelegate {
    public func networkQuailtyDidUpdate(quality: NetworkQuality) {
        networkQualityDelegate?.networkQuailtyDidUpdate(quality: quality)
    }
}

