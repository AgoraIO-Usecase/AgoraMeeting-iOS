//
//  VideoCellMini2.swift
//  AgoraMeetingUI
//
//  Created by ZYP on 2021/8/12.
//

import UIKit

final class VideoCellMiniLocal: VideoCellMini {
    override func prepareForReuse() {
        super.prepareForReuse()
        meunButton.isSelected = false
        sheetView.isHidden = true
    }
}

final class VideoCellMiniRemote: VideoCellMini {
    override func prepareForReuse() {
        super.prepareForReuse()
        meunButton.isSelected = false
        sheetView.isHidden = true
        if let inerView = videoView.subviews.first {
            inerView.removeFromSuperview()
        }
    }
}

class VideoCellMini: VideoCell {
    private let displayLabel = UILabel()
    final var infoMini: Info?
    override var headImageViewSize: CGSize { CGSize(width: 36, height: 36) }
    
    override func setup() {
        super.setup()
        upButton.isHidden = true
        meunButton.isHidden = true
        displayLabel.text = MeetingUILocalizedString("ui_t2", comment: "")
        displayLabel.font = UIFont.systemFont(ofSize: 9)
        displayLabel.textColor = .white
        contentView.addSubview(displayLabel)
        
        displayLabel.translatesAutoresizingMaskIntoConstraints = false
        displayLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        displayLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        
        bottomView.backgroundColor = UIColor(white: 0, alpha: 0.55)
    }
    
    func config(info: Info) {
        self.infoMini = info
        headImageView.image = UIImage.meetingUIImageName(info.headImageName)
        switch info.type {
        case .video:
            videoView.isHidden = info.showHeadImage
            displayLabel.text = MeetingUILocalizedString("ui_t2", comment: "")
            displayLabel.isHidden = !info.hasDisplayInMainScreen
            headImageView.isHidden = !info.showHeadImage
            break
        case .board:
            headImageView.isHidden = true
            break
        case .screen:
            if info.isMe {
                displayLabel.text = MeetingUILocalizedString("ui_t3", comment: "")
                displayLabel.isHidden = false
            }
            else {
                displayLabel.isHidden = true
            }
            videoView.isHidden = false
            headImageView.isHidden = true
            break
        }
        
        let bottomInfo = BottomView.Info(showHost: info.isHost,
                                         audioOpen: info.enableAudio,
                                         name: info.name)
        bottomView.setInfo(info: bottomInfo)
        contentView.layoutIfNeeded()
    }
    
}

extension VideoCellMini {
    struct Info: Equatable {
        let id: String
        let isHost: Bool
        let enableAudio: Bool
        let name: String
        let headImageName: String
        let showHeadImage: Bool
        let hasVideo: Bool
        let hasDisplayInMainScreen: Bool
        let type: InfoType
        let isMe: Bool
        let streamId: String
        let userId: String
        let board: BoardInfo?
        
        enum InfoType: Int {
            case video = 0
            case screen = 1
            case board = 2
        }
        
        static func == (lhs: Self, rhs: Self) -> Bool {
            return lhs.id == rhs.id &&
                lhs.isHost == rhs.isHost &&
                lhs.enableAudio == rhs.enableAudio &&
                lhs.name == rhs.name &&
                lhs.headImageName == rhs.headImageName &&
                lhs.showHeadImage == rhs.showHeadImage &&
                lhs.hasDisplayInMainScreen == rhs.hasDisplayInMainScreen &&
                lhs.type == rhs.type &&
                lhs.isMe == rhs.isMe &&
                lhs.streamId == rhs.streamId &&
                lhs.userId == rhs.userId &&
                lhs.board == rhs.board &&
                lhs.hasVideo == rhs.hasVideo 
        }
        
        struct BoardInfo: Equatable {
            let id: String
            let token: String
            
            static var empty: BoardInfo {
                return BoardInfo(id: "", token: "")
            }
            
            static func == (lhs: Self, rhs: Self) -> Bool {
                return lhs.id == rhs.id &&
                    lhs.token == rhs.token
            }
        }
    }
}
