//
//  AboutView.swift
//  AgoraMeetingUI
//
//  Created by ZYP on 2021/6/17.
//

import Foundation

protocol AboutViewDelegate: NSObject {
    func aboutViewDidTapDisclaimerButton()
    func aboutViewDidTapPrivacyButton()
    func aboutViewDidTapDocButton()
    func aboutViewDidTapRegisterButton()
}

class AboutView: UIView {
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var docButton: UIButton!
    @IBOutlet weak var disclaimerButton: UIButton!
    @IBOutlet weak var privacyButton: UIButton!
    @IBOutlet weak var versionLabel: UILabel!
    
    weak var delegate: AboutViewDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
        commonInit()
    }
    
    func setVersion(text: String) {
        versionLabel.text = text
    }
    
    func setup() {
        docButton.layer.masksToBounds = true
        docButton.layer.cornerRadius = 2
        docButton.layer.borderColor = UIColor(hex: 0x4DA1FF).cgColor
        docButton.layer.borderWidth = 1
        
        let att1: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 12),
            .foregroundColor: UIColor(hex: 0x2E3848),
            .underlineStyle: NSUnderlineStyle.single.rawValue]
        let attributeString1 = NSMutableAttributedString(string: NSLocalizedString("ab_t1", comment: ""),
                                                         attributes: att1)
        disclaimerButton.setAttributedTitle(attributeString1, for: .normal)
        
        let att2: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 12),
            .foregroundColor: UIColor(hex: 0x2E3848),
            .underlineStyle: NSUnderlineStyle.single.rawValue]
        let attributeString2 = NSMutableAttributedString(string: NSLocalizedString("ab_t3", comment: ""),
                                                         attributes: att2)
        privacyButton.setAttributedTitle(attributeString2, for: .normal)
    }
    
    func commonInit() {
        disclaimerButton.addTarget(self, action: #selector(buttonTap(button:)), for: .touchUpInside)
        privacyButton.addTarget(self, action: #selector(buttonTap(button:)), for: .touchUpInside)
        docButton.addTarget(self, action: #selector(buttonTap(button:)), for: .touchUpInside)
        registerButton.addTarget(self, action: #selector(buttonTap(button:)), for: .touchUpInside)
    }
    
    @objc func buttonTap(button: UIButton) {
        if button == disclaimerButton {
            delegate?.aboutViewDidTapDisclaimerButton()
            return
        }
        
        if button == privacyButton {
            delegate?.aboutViewDidTapPrivacyButton()
            return
        }
        
        if button == docButton {
            delegate?.aboutViewDidTapDocButton()
            return
        }
        
        if button == registerButton {
            delegate?.aboutViewDidTapRegisterButton()
            return
        }
    }
    
}
