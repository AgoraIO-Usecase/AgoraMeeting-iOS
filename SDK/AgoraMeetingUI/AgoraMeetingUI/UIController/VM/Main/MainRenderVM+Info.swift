//
//  MainRenderVM+Info.swift
//  AgoraMeetingUI
//
//  Created by ZYP on 2021/6/8.
//

import Foundation
import AgoraMeetingContext
import DifferenceKit

extension MainRenderVM { /** Info **/
    struct UpdateInfo: Equatable {
        var videoCellInfos: [VideoCellInfo]
        var audioCellInfos: [AudioCellInfo]
        var videoCellMiniInfos: [VideoCellMiniInfo]
        let mode: MeetingViewMode
        var speakerInfo: SpeakerModel?
        var showRightButton: Bool
        var selectedInfo: RenderInfo?
        
        static func == (lhs: Self, rhs: Self) -> Bool {
            if lhs.mode != rhs.mode { return false }
            switch lhs.mode {
            case .videoFlow:
                return lhs.videoCellInfos == rhs.videoCellInfos
            case .audioFlow:
                return lhs.audioCellInfos == rhs.audioCellInfos
            case .speaker:
                let result = lhs.showRightButton == rhs.showRightButton
                var other = true
                if lhs.speakerInfo == nil && rhs.speakerInfo == nil {
                    other = true
                }
                if lhs.speakerInfo != nil && rhs.speakerInfo == nil {
                    other = false
                }
                if lhs.speakerInfo == nil && rhs.speakerInfo != nil {
                    other = false
                }
                if lhs.speakerInfo != nil && rhs.speakerInfo != nil {
                    other = lhs.speakerInfo!.isEqualToModel(rhs.speakerInfo!)
                }
                return result && other && lhs.videoCellMiniInfos == rhs.videoCellMiniInfos
            @unknown default:
                fatalError()
            }
        }
        
        static var empty: UpdateInfo {
            return UpdateInfo(videoCellInfos: [],
                              audioCellInfos: [],
                              videoCellMiniInfos: [],
                              mode: .videoFlow,
                              speakerInfo: nil,
                              showRightButton: false,
                              selectedInfo: nil)
            
            
        }
        
        struct Update<Element: Equatable>: Equatable {
            let updates: [Element]
            let adds: [Element]
            let deletes: [Element]
            
            static var empty: Update<Element> {
                return Update<Element>(updates: [], adds: [], deletes: [])
            }
            
            static func == (lhs: Self, rhs: Self) -> Bool {
                return lhs.updates == rhs.updates &&
                    lhs.adds == rhs.adds &&
                    lhs.deletes == rhs.deletes
            }
        }
        
    }
    
    typealias VideoCellInfo = VideoCell.Info
    typealias VideoCellMiniInfo = VideoCellMini.Info
    
    struct AudioCellInfo: Equatable, Differentiable {
        let id: String
        let headImageName: String
        let name: String
        let audioEnable: Bool
        let userId: String
        
        var differenceIdentifier: String {
            return id
        }
        
        func isContentEqual(to source: MainRenderVM.AudioCellInfo) -> Bool {
            let rhs = source
            return headImageName == rhs.headImageName &&
                name == rhs.name &&
                audioEnable == rhs.audioEnable
        }
    }
}

extension VideoCellMini.Info: Differentiable {
    typealias DifferenceIdentifier = String
    
    var differenceIdentifier: String {
        return id
    }
    
    func isContentEqual(to source: VideoCellMini.Info) -> Bool {
        let rhs = source
        return isHost == rhs.isHost &&
            enableAudio == rhs.enableAudio &&
            name == rhs.name &&
            headImageName == rhs.headImageName &&
            showHeadImage == rhs.showHeadImage &&
            hasDisplayInMainScreen == rhs.hasDisplayInMainScreen &&
            type == rhs.type &&
            isMe == rhs.isMe &&
            streamId == rhs.streamId &&
            board == rhs.board
    }
}

extension VideoCell.Info: Differentiable {
    var differenceIdentifier: String {
        return id
    }
    
    func isContentEqual(to source: VideoCell.Info) -> Bool {
        return isHost == source.isHost &&
            isUp == source.isUp &&
            enableAudio == source.enableAudio &&
            name == source.name &&
            showMeunButton == source.showMeunButton &&
            headImageName == source.headImageName &&
            showHeadImage == source.showHeadImage &&
            streamId == source.streamId &&
            sheetInfos == source.sheetInfos
    }
}

extension SpeakerModel {
    func isEqualToModel(_ model: SpeakerModel) -> Bool {
        return model.name == name &&
            model.hasAudio == hasAudio &&
            model.isHost == isHost &&
            model.isLocalUser == isLocalUser &&
            model.type == type
    }
}

extension Array where Element == UserOperation {
    var toSheetInfos: [VideoCellSheetView.Info] {
        map({ op -> VideoCellSheetView.Info? in
            switch op {
            case .closeCamera:
                return VideoCellSheetView.Info(actionType: .closeVideo)
            case .abandonHost:
                return VideoCellSheetView.Info(actionType: .abandonHost)
            case .closeMic:
                return VideoCellSheetView.Info(actionType: .closeAudio)
            case .kickOut:
                return VideoCellSheetView.Info(actionType: .remove)
            case .beHost:
                return VideoCellSheetView.Info(actionType: .becomeHost)
            case .setAsHost:
                return VideoCellSheetView.Info(actionType: .setAsHost)
            case .closeAllMic:
                return nil
            case .closeAllCamera:
                return nil
            }
        })
        .compactMap({ $0 })
    }
}

extension RenderInfoType {
    var cellMiniInfoType: VideoCellMini.Info.InfoType {
        switch self {
        case .board:
            return .board
        case .screenSharing:
            return .screen
        case .media:
            return .video
        }
    }
    
    var speakType: SpeakerModelType {
        switch self {
        case .board:
            return .board
        case .screenSharing:
            return .screen
        case .media:
            return .video
        }
    }
}
