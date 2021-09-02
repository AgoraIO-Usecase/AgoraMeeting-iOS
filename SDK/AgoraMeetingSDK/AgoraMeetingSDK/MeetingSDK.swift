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
    @objc public weak var exitRoomDelegate: ExitRoomDelegate?
    @objc public weak var networkQualityDelegate: NetworkQualityDelegate?
    
    @objc public init(config: MeetingConfig) {
        core = MeetingCore(config: config)
        super.init()
        commonInit()
    }
    
    private func commonInit() {
        core.networkQualityDelegate = self
    }
    
    @objc public func launch(launchConfig: LaunchConfig,
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
    
    @objc public static func getCoreVersionName() -> String {
        MeetingCore.getCoreVersionName()
    }
    
    @objc public static func getCoreVersionCode() -> Int {
        MeetingCore.getCoreVersionCode()
    }
    
    @objc public static func getRtcVersionName() -> String {
        MeetingCore.getRtcVersionName()
    }
    
    @objc public static func getRtmVersionName() -> String {
        MeetingCore.getRtmVersionName()
    }
    
    @objc public static func getWhiteBoardVersionName() -> String {
        MeetingCore.getWhiteBoardVersionName()
    }
    
    @objc public func enableNetQualityCheck() {
        core.enableNetQualityCheck()
    }
    
    @objc public func disableNetQualityCheck() {
        core.disableNetQualityCheck()
    }
    
    public func setParameters(parameters: String) {
        core.setParameters(parameters: parameters)
    }
}

extension MeetingSDK: ExitRoomDelegate {
    public func onExit(cache: RoomCache,
                       existReason: ExistReason) {
        exitRoomDelegate?.onExit(cache: cache,
                                 existReason: existReason)
    }
}

extension MeetingSDK: NetworkQualityDelegate {
    public func networkQuailtyDidUpdate(quality: NetworkQuality) {
        networkQualityDelegate?.networkQuailtyDidUpdate(quality: quality)
    }
}

