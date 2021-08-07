//
//  UserCell.swift
//  VideoConference
//
//  Created by ZYP on 2021/2/18.
//  Copyright © 2021 agora. All rights reserved.
//

import UIKit

class UserCell: UITableViewCell {

    @IBOutlet weak var headImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var hostImageVIew: UIImageView!
    @IBOutlet weak var shareImageView: UIImageView!
    @IBOutlet weak var videoImageView: UIImageView!
    @IBOutlet weak var audioImageView: UIImageView!
    var info: Info?
    static let idf = "UserCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }

    func setup() {
        headImageView.layer.cornerRadius = 15
        headImageView.layer.masksToBounds = true
    }
    
    func setInfo(info: Info) {
        self.info = info
        headImageView.image = UIImage.meetingUIImageName(info.headImageName)
        nameLabel.attributedText = info.attributedTitle
        videoImageView.image = info.videoEnable ? UIImage.meetingUIImageName("member-video1") : UIImage.meetingUIImageName("member-video0")
        audioImageView.image = info.audioEnable ? UIImage.meetingUIImageName("member-audio4") : UIImage.meetingUIImageName("member-audio0")
        
        let hostImageName = "member-host"
        let shareImageName = "member-share"
        if info.isHost, !info.hasShare {
            shareImageView.image = UIImage.meetingUIImageName(hostImageName)
            shareImageView.isHidden = false
            hostImageVIew.isHidden = true
        }
        if !info.isHost, info.hasShare {
            shareImageView.image = UIImage.meetingUIImageName(shareImageName)
            shareImageView.isHidden = false
            hostImageVIew.isHidden = true
        }
        if info.isHost, info.hasShare {
            shareImageView.image = UIImage.meetingUIImageName(shareImageName)
            shareImageView.isHidden = false
            hostImageVIew.image = UIImage.meetingUIImageName(hostImageName)
            hostImageVIew.isHidden = false
        }
        if !info.isHost, !info.hasShare {
            hostImageVIew.isHidden = true
            shareImageView.isHidden = true
        }
    }

}

extension UserCell {
    struct Info {
        let headImageName: String
        let title: String
        let name: String
        let userId: String
        let isHost: Bool
        var hasShare: Bool
        let videoEnable: Bool
        let audioEnable: Bool
        var attributedTitle: NSMutableAttributedString?
        
        mutating func setAttributeTitle(attributedTitle: NSMutableAttributedString) {
            self.attributedTitle = attributedTitle
        }
        
        mutating func setShare(share: Bool) {
            hasShare = share
        }
    }
}
