//
//  AboutVC.swift
//  VideoConference
//
//  Created by ZYP on 2021/7/7.
//  Copyright © 2021 agora. All rights reserved.
//

import UIKit
import AgoraMeetingSDK

class AboutVC: BaseViewController {

    let aboutView = Bundle.main.loadNibNamed("AboutView",
                                             owner: nil,
                                             options: nil)!.first as! AboutView
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        commonInit()
        layoutView()
        navigationItem.backButtonTitle = ""
    }
    
    func setup() {
        title = NSLocalizedString("ab_t2", comment: "")
        aboutView.setVersion(text: versionString)
    }
    
    func commonInit() {
        aboutView.delegate = self
    }
    
    func layoutView() {
        view.addSubview(aboutView)
        aboutView.translatesAutoresizingMaskIntoConstraints = false
        aboutView.leftAnchor
            .constraint(equalTo: view.leftAnchor)
            .isActive = true
        aboutView.rightAnchor
            .constraint(equalTo: view.rightAnchor)
            .isActive = true
        aboutView.topAnchor
            .constraint(equalTo: view.topAnchor)
            .isActive = true
        aboutView.bottomAnchor
            .constraint(equalTo: view.bottomAnchor)
            .isActive = true
    }
    
    var versionString: String {
        
        #if DEBUG
        let config = "(DEBUG)"
        #elseif DevRelease
        let config = "(DevRelease)"
        #elseif PreRelease
        let config = "(PreRelease)"
        #elseif TestFlightDevEnv
        let config = "(TestFlightDevEnv)"
        #else
        let config = "(Release)"
        #endif
        
        let infoDict = Bundle.main.infoDictionary!
        let version = (infoDict["CFBundleShortVersionString"] as! String)
        let buildVersion = (infoDict["CFBundleVersion"] as! String)
        let appVersionStr = version + "(\(buildVersion))" + "\(config)"
        let appTime = (infoDict["AppBuildTime"] as? String) ?? ""
        let versionInd = NSLocalizedString("ab_t5", comment: "")
        let timeInd = NSLocalizedString("ab_t6", comment: "")
        let videoSDKInd = NSLocalizedString("ab_t7", comment: "")
        let rtmSDKInd = NSLocalizedString("ab_t8", comment: "")
        let whiteboardSDKInd = NSLocalizedString("ab_t9", comment: "")
        
        let appVersion = versionInd + "\(appVersionStr)\(timeInd)\(appTime)"
        
        let rtcVersionStr = MeetingSDK.getRtcVersionName()
        let rtcVersion = "\(videoSDKInd)\(rtcVersionStr)"
        
        let rtmVersionStr = MeetingSDK.getRtmVersionName()
        let rtmVersion = "\(rtmSDKInd)\(rtmVersionStr)"
         
        let boardVersionStr = MeetingSDK.getWhiteBoardVersionName()
        let boardVersion = "\(whiteboardSDKInd)\(boardVersionStr)"
        return appVersion + "\n" + rtcVersion + rtmVersion + "\n" + boardVersion
    }
}

extension AboutVC: AboutViewDelegate {
    func aboutViewDidTapDisclaimerButton() {
        let vc = BrowserVC(contentType: .disclaimer)
        navigationController?.pushViewController(vc,
                                                 animated: true)
    }
    
    func aboutViewDidTapPrivacyButton() {
        if let termsVC = TermsAndPolicyVC.loadFromStoryboard("Policy",
                                                             "terms") {
            termsVC.fromSetting = true
            termsVC.show(in: self)
        }
    }
    
    func aboutViewDidTapDocButton() {
        guard let url = URL(string: "https://docs.agora.io") else {
            return
        }
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
    func aboutViewDidTapRegisterButton() {
        let string = NSLocalizedString("ab_t1", comment: "") == "免责声明" ? "https://sso.agora.io/cn/v3/signup" : "https://sso.agora.io/en/v3/signup"
        guard let url = URL(string: string) else {
            return
        }
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
}
