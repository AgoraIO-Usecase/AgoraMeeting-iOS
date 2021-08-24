//
//  VideoCell2.swift
//  AgoraMeetingUI
//
//  Created by ZYP on 2021/8/11.
//

import UIKit

protocol VideoCellDelegate: NSObject {
    func videoCell(cell: VideoCell,
                   tapType: VideoCell.SheetAction,
                   info: VideoCell.Info)
}

class VideoCellLocal: VideoCell {
    override func prepareForReuse() {
        super.prepareForReuse()
        meunButton.isSelected = false
        sheetView.isHidden = true
    }
}

class VideoCellRemote: VideoCell {
    override func prepareForReuse() {
        super.prepareForReuse()
        meunButton.isSelected = false
        sheetView.isHidden = true
        videoView.backgroundColor = .clear
    }
}

class VideoCell: UICollectionViewCell {
    let videoView = UIView()
    let videoMaskImageView = UIImageView()
    let headImageView = UIImageView()
    let upButton = UIButton()
    let meunButton = UIButton()
    let bottomView = BottomView()
    let sheetView = VideoCellSheetView()
    open var headImageViewSize: CGSize {
        CGSize(width: 72, height: 72)
    }
    let bottomViewHeight: CGFloat = 17
    var sheetViewHeightConstraint: NSLayoutConstraint?
    weak var delegate: VideoCellDelegate?
    final var info: Info?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        contentView.backgroundColor =  UIColor(hex: 0x434343)
        videoView.backgroundColor = .clear
        videoMaskImageView.image = UIImage.meetingUIImageName("video-mask")
        upButton.setImage(UIImage.meetingUIImageName("置顶默认状态"),
                          for: .normal)
        upButton.setImage(UIImage.meetingUIImageName("置顶点击后状态"),
                          for: .selected)
        meunButton.setImage(UIImage.meetingUIImageName("更多操作"),
                            for: .normal)
        headImageView.layer.cornerRadius = headImageViewSize.height/2
        headImageView.layer.masksToBounds = true
        sheetView.isHidden = true
        
        contentView.addSubview(videoView)
        contentView.addSubview(videoMaskImageView)
        contentView.addSubview(headImageView)
        contentView.addSubview(upButton)
        contentView.addSubview(meunButton)
        contentView.addSubview(bottomView)
        contentView.addSubview(sheetView)
        
        videoView.translatesAutoresizingMaskIntoConstraints = false
        videoMaskImageView.translatesAutoresizingMaskIntoConstraints = false
        headImageView.translatesAutoresizingMaskIntoConstraints = false
        upButton.translatesAutoresizingMaskIntoConstraints = false
        meunButton.translatesAutoresizingMaskIntoConstraints = false
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        sheetView.translatesAutoresizingMaskIntoConstraints = false
        
        videoView.leftAnchor
            .constraint(equalTo: contentView.leftAnchor)
            .isActive = true
        videoView.rightAnchor
            .constraint(equalTo: contentView.rightAnchor)
            .isActive = true
        videoView.topAnchor
            .constraint(equalTo: contentView.topAnchor)
            .isActive = true
        videoView.bottomAnchor
            .constraint(equalTo: contentView.bottomAnchor)
            .isActive = true
        
        videoMaskImageView.leftAnchor
            .constraint(equalTo: contentView.leftAnchor)
            .isActive = true
        videoMaskImageView.rightAnchor
            .constraint(equalTo: contentView.rightAnchor)
            .isActive = true
        videoMaskImageView.bottomAnchor
            .constraint(equalTo: contentView.bottomAnchor)
            .isActive = true
        
        headImageView.centerXAnchor
            .constraint(equalTo: contentView.centerXAnchor)
            .isActive = true
        headImageView.centerYAnchor
            .constraint(equalTo: contentView.centerYAnchor)
            .isActive = true
        headImageView.heightAnchor
            .constraint(equalToConstant: headImageViewSize.height)
            .isActive = true
        headImageView.widthAnchor
            .constraint(equalToConstant: headImageViewSize.width)
            .isActive = true
        
        bottomView.leftAnchor
            .constraint(equalTo: contentView.leftAnchor)
            .isActive = true
        bottomView.rightAnchor
            .constraint(equalTo: contentView.rightAnchor)
            .isActive = true
        bottomView.bottomAnchor
            .constraint(equalTo: contentView.bottomAnchor)
            .isActive = true
        bottomView.heightAnchor
            .constraint(equalToConstant: bottomViewHeight)
            .isActive = true
        
        upButton.topAnchor
            .constraint(equalTo: contentView.topAnchor, constant: 5)
            .isActive = true
        upButton.rightAnchor
            .constraint(equalTo: contentView.rightAnchor, constant: 5)
            .isActive = true
        upButton.heightAnchor
            .constraint(equalToConstant: 45)
            .isActive = true
        upButton.widthAnchor
            .constraint(equalToConstant: 45)
            .isActive = true
        
        meunButton.topAnchor
            .constraint(equalTo: upButton.bottomAnchor)
            .isActive = true
        meunButton.rightAnchor
            .constraint(equalTo: contentView.rightAnchor, constant: 5)
            .isActive = true
        meunButton.heightAnchor
            .constraint(equalToConstant: 45)
            .isActive = true
        meunButton.widthAnchor
            .constraint(equalToConstant: 45)
            .isActive = true
        
        sheetView.translatesAutoresizingMaskIntoConstraints = false
        sheetView.rightAnchor.constraint(equalTo: rightAnchor, constant: -8).isActive = true
        sheetView.leftAnchor.constraint(equalTo: leftAnchor, constant: 30).isActive = true
        sheetView.topAnchor.constraint(equalTo: meunButton.bottomAnchor).isActive = true
        sheetViewHeightConstraint = sheetView.heightAnchor.constraint(equalToConstant: 179)
        sheetViewHeightConstraint?.isActive = true
    }
    
    func commonInit() {
        sheetView.delegate = self
        upButton.addTarget(self,
                           action: #selector(buttonTap(_:)),
                           for: .touchUpInside)
        meunButton.addTarget(self,
                           action: #selector(buttonTap(_:)),
                           for: .touchUpInside)
    }
    
    final func config(info: Info) {
        self.info = info
        upButton.isSelected = info.isUp
        meunButton.isHidden = !info.showMeunButton
        headImageView.isHidden = !info.showHeadImage
        headImageView.image = UIImage.meetingUIImageName(info.headImageName)
        videoView.isHidden = info.showHeadImage
        contentView.layoutIfNeeded()
        meunButton.isHidden = info.sheetInfos.count == 0
        let bottomInfo = BottomView.Info(showHost: info.isHost,
                        audioOpen: info.enableAudio,
                        name: info.name)
        bottomView.setInfo(info: bottomInfo)
    }
    
    @objc func buttonTap(_ sender: UIButton) {
        if sender == upButton {
            delegate?.videoCell(cell: self, tapType: .upButton, info: info!)
        }
        
        if sender == meunButton {
            meunButton.isSelected = !meunButton.isSelected
            if meunButton.isSelected {
                sheetView.setInfos(infos: info!.sheetInfos)
            }
            sheetView.isHidden = !meunButton.isSelected
            
        }
    }
}

extension VideoCell {
    enum SheetAction {
        /** 置顶 */
        case upButton
        /** 静音 */
        case closeAudio
        /** 关闭视频 */
        case closeVideo
        /** 移除房间 */
        case remove
        /** 设置为主持人 */
        case setHost
        /** 成为主持人 */
        case becomHost
        /** 放弃主持人 */
        case abandonHost
    }
    
    struct Info: Equatable {
        let id: String
        let isHost: Bool
        let enableAudio: Bool
        let name: String
        let isUp: Bool
        var showMeunButton: Bool
        let headImageName: String
        let showHeadImage: Bool
        let hasVideo: Bool
        let isMe: Bool
        let streamId: String
        let sheetInfos: [VideoCellSheetView.Info]
        let userId: String
        
        static func == (lhs: Self, rhs: Self) -> Bool {
            return lhs.id == rhs.id &&
                lhs.isHost == rhs.isHost &&
                lhs.enableAudio == rhs.enableAudio &&
                lhs.name == rhs.name &&
                lhs.isUp == rhs.isUp &&
                lhs.showMeunButton == rhs.showMeunButton &&
                lhs.headImageName == rhs.headImageName &&
                lhs.showHeadImage == rhs.showHeadImage &&
                lhs.hasVideo == rhs.hasVideo &&
                lhs.isMe == rhs.isMe &&
                lhs.streamId == rhs.streamId &&
                lhs.sheetInfos == rhs.sheetInfos &&
                lhs.userId == rhs.userId
        }
        
    }
}

extension VideoCell: VideoCellSheetViewDelegate {
    func videoCellSheetViewShouldUpdateHeight(height: CGFloat) {
        sheetViewHeightConstraint?.constant = height
    }
    
    func buttonDidTap(info: VideoCellSheetView.Info) {
        switch info.actionType {
        case .closeAudio:
            delegate?.videoCell(cell: self, tapType: .closeAudio, info: self.info!)
            break
        case .closeVideo:
            delegate?.videoCell(cell: self, tapType: .closeVideo, info: self.info!)
            break
        case .remove:
            delegate?.videoCell(cell: self, tapType: .remove, info: self.info!)
            break
        case .becomeHost:
            delegate?.videoCell(cell: self, tapType: .becomHost, info: self.info!)
            break
        case .setAsHost:
            delegate?.videoCell(cell: self, tapType: .setHost, info: self.info!)
            break
        case .abandonHost:
            delegate?.videoCell(cell: self, tapType: .abandonHost, info: self.info!)
            break
        }
    }
}

extension VideoCell {
    class BottomView: UIView {
        
        struct Info {
            let showHost: Bool
            let audioOpen: Bool
            let name: String
        }
        
        let hostImageView = UIImageView()
        let audioImageView = UIImageView()
        let nameLabel = UILabel()
        var audioImageViewLeftConstraint: NSLayoutConstraint?
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            setup()
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        func setup() {
            backgroundColor = .clear
            hostImageView.image = UIImage.meetingUIImageName("state-host")
            nameLabel.font = UIFont.systemFont(ofSize: 11)
            nameLabel.textColor = .white
            
            addSubview(hostImageView)
            addSubview(audioImageView)
            addSubview(nameLabel)
            
            hostImageView.translatesAutoresizingMaskIntoConstraints = false
            audioImageView.translatesAutoresizingMaskIntoConstraints = false
            nameLabel.translatesAutoresizingMaskIntoConstraints = false
            
            hostImageView.leftAnchor
                .constraint(equalTo: leftAnchor, constant: 1)
                .isActive = true
            hostImageView.bottomAnchor
                .constraint(equalTo: bottomAnchor, constant: -0.5)
                .isActive = true
            hostImageView.heightAnchor
                .constraint(equalToConstant: 17)
                .isActive = true
            hostImageView.widthAnchor
                .constraint(equalToConstant: 17)
                .isActive = true
            
            audioImageViewLeftConstraint = audioImageView.leftAnchor
                .constraint(equalTo: leftAnchor, constant: 0)
            audioImageViewLeftConstraint?.isActive = true
            audioImageView.bottomAnchor
                .constraint(equalTo: bottomAnchor, constant: -0.5)
                .isActive = true
            audioImageView.heightAnchor
                .constraint(equalToConstant: 17)
                .isActive = true
            audioImageView.widthAnchor
                .constraint(equalToConstant: 17)
                .isActive = true
            
            nameLabel.leftAnchor
                .constraint(equalTo: audioImageView.rightAnchor)
                .isActive = true
            nameLabel.rightAnchor
                .constraint(equalTo: rightAnchor, constant: 3)
                .isActive = true
            nameLabel.heightAnchor
                .constraint(equalToConstant: 16).isActive = true
            nameLabel.centerYAnchor
                .constraint(equalTo: audioImageView.centerYAnchor)
                .isActive = true
        }
        
        func setInfo(info: Info) {
            audioImageViewLeftConstraint?.constant = info.showHost ? 16 : 1
            hostImageView.isHidden = !info.showHost
            let audioImageName = info.audioOpen ? "state-unmute" : "state-mute"
            audioImageView.image = UIImage.meetingUIImageName(audioImageName)
            nameLabel.text = info.name
        }
    }
}
