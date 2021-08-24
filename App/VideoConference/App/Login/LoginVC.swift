//
//  LoginVC.swift
//  VideoConference
//
//  Created by ZYP on 2021/2/4.
//  Copyright © 2021 agora. All rights reserved.
//

import UIKit
import ReplayKit
import AVKit
import AgoraMeetingCore
import AgoraMeetingSDK
import AgoraMeetingUI

class LoginVC: BaseViewController {
    @IBOutlet weak var textFieldBgView: UIView!
    @IBOutlet weak var cameraSwitch: UISwitch!
    @IBOutlet weak var micSwitch: UISwitch!
    @IBOutlet weak var joinButton: UIButton!
    @IBOutlet weak var roomNameTextField: UITextField!
    @IBOutlet weak var roomPsdTextField: UITextField!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var roomNameMaskView: UIView!
    @IBOutlet weak var roomPsdMaskView: UIView!
    @IBOutlet weak var userNameMaskView: UIView!
    @IBOutlet weak var tipsButton: UIButton!
    @IBOutlet weak var signalImageView: UIImageView!
    
    @IBOutlet weak var signalViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var textFieldAreaTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var switchAreaTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var joinButtonTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var tipsViewAreaTopConstraint: NSLayoutConstraint!
    
    private let tipView2 = LoginTipsView()
    let vm = LoginVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        showTermVCIfNeed()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        cameraSwitch.isOn = StorageManager.openCan
        micSwitch.isOn = StorageManager.openMic
        userNameTextField.text = StorageManager.userName
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false,
                                                     animated: animated)
        StorageManager.userName = userNameTextField.text!
    }
    
    func setup() {
        tipView2.isHidden = true
        view.addSubview(tipView2)
        tipView2.translatesAutoresizingMaskIntoConstraints = false
        let height: CGFloat = NSLocalizedString("login_t0", comment: "") == "请输入房间名" ? 103 : 130
        
        NSLayoutConstraint.activate([tipView2.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -33),
                                     tipView2.topAnchor.constraint(equalTo: tipsButton.centerYAnchor, constant: 8),
                                     tipView2.widthAnchor.constraint(equalToConstant: 261),
                                     tipView2.heightAnchor.constraint(equalToConstant: height)])
        
        userNameTextField.text = StorageManager.userName
        
        view.backgroundColor = .white
        vm.delegate = self
        textFieldBgView.layer.borderWidth = 1
        textFieldBgView.layer.borderColor = UIColor(hex: 0xE9EFF4).cgColor
        textFieldBgView.layer.cornerRadius = 2
        
        vm.checkUpdate()
        
        #if DEBUG
        roomNameTextField.text = StorageManager.roomName
        #elseif TestFlightDevEnv
        roomNameTextField.text = StorageManager.roomName
        #endif
        
        roomNameTextField.delegate = self
        roomPsdTextField.delegate = self
        userNameTextField.delegate = self
        
        roomNameMaskView.isHidden = true
        roomNameMaskView.layer.borderWidth = 1
        roomNameMaskView.layer.borderColor = UIColor(hex: 0x4DA1FF).cgColor
        roomNameMaskView.layer.cornerRadius = 2
        roomNameMaskView.isUserInteractionEnabled = false
        
        roomPsdMaskView.isHidden = true
        roomPsdMaskView.layer.borderWidth = 1
        roomPsdMaskView.layer.borderColor = UIColor(hex: 0x4DA1FF).cgColor
        roomPsdMaskView.layer.cornerRadius = 2
        roomPsdMaskView.isUserInteractionEnabled = false
        
        userNameMaskView.isHidden = true
        userNameMaskView.layer.borderWidth = 1
        userNameMaskView.layer.borderColor = UIColor(hex: 0x4DA1FF).cgColor
        userNameMaskView.layer.cornerRadius = 2
        userNameMaskView.isUserInteractionEnabled = false
        
        
        let baseScreenHeight: CGFloat = 844
        let contentHeight: CGFloat = 24 + 42 + 25.5 + 150 + 103 + 42 + 55
        var scale = (UIScreen.main.bounds.size.height - contentHeight) / (baseScreenHeight - contentHeight)
        if scale < 0 { scale = 0.25 }
        signalViewTopConstraint.constant = 40 * scale
        textFieldAreaTopConstraint.constant = 40 * scale
        switchAreaTopConstraint.constant = 40 * scale
        joinButtonTopConstraint.constant = 33 * scale
        tipsViewAreaTopConstraint.constant = 30 * scale
    }
    
    @IBAction func onSwitchCamera(_ sender: Any) {
        StorageManager.openCan = cameraSwitch.isOn
        tipView2.isHidden = true
    }
    
    @IBAction func onSwitchMic(_ sender: Any) {
        StorageManager.openMic = micSwitch.isOn
        tipView2.isHidden = true
    }
    
    @IBAction func onClickJoin(_ sender: UIButton) {
        view.endEditing(true)

        let userName = userNameTextField.text!
        let roomPsd = roomPsdTextField.text!
        let roomName = roomNameTextField.text!
        if let tipString = LoginVM.checkInputValid(userName: userName, roomPsd: roomPsd, roomName: roomName) {
            show(tipString)
            return
        }

        showLoading()
        let enableVideo = cameraSwitch.isOn
        let enableAudio = micSwitch.isOn
        let info = LoginVM.Info(userName: userName,
                                roomName: roomName,
                                password: roomPsd,
                                enableVideo: enableVideo,
                                enableAudio: enableAudio,
                                userId: vm.currentUserId,
                                roomId: roomName.md5(),
                                localUserProperties: ["my": "aaa"])
        vm.entryRoom(info: info)
    }
    
    @IBAction func onClickTip(_ sender: Any) {
        tipView2.isHidden = !tipView2.isHidden
    }
    
    @IBAction func onClickSet(_ sender: Any) {
        let loginSetVC = LoginSetVC()
        navigationController?.pushViewController(loginSetVC,
                                                 animated: true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        tipView2.isHidden = true
        view.endEditing(true)
    }
    
    func showUpdateAlertVC() {
        let vc = UIAlertController(title:  NSLocalizedString("login_t9", comment: ""), message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: NSLocalizedString("login_t7", comment: ""), style: .default) { (_) in
            if let url = URL(string: "https://apps.apple.com/cn/app/agora-meeting/id1515428313") {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
        vc.addAction(action)
        present(vc, animated: true, completion: nil)
    }
    
    func showTermVCIfNeed() {
        if !TermsAndPolicyVC.getPolicyPopped(),
           let termsVC = TermsAndPolicyVC.loadFromStoryboard("Policy",
                                                             "terms") {
            termsVC.fromSetting = false
            termsVC.show(in: self)
        }
    }
    
    func showScoreVC() {
        let vc = ScoreAlertVC()
        vc.submitBlock = { score in
            self.vm.submitScore(score: score)
        }
        vc.show(in: self)
    }
}

extension LoginVC: LoginVMDelegate {
    func loginVMDidSuccessEntryRoomWithInfo(info: LoginVM.Info,
                                            nvc: AgoraMeetingUI) {
        dismissLoading()
        present(nvc,
                animated: true,
                completion: nil)
    }
    
    func loginVMShouldChangeJoinButtonEnable(enable: Bool) {
        joinButton.isEnabled = enable
    }
    
    func loginVMShouldShowUpdateVersion() {
        showUpdateAlertVC()
    }
    
    /// MeetingVCDelegate
    func meetingVCDidExitRoom() {
        vm.startNetworkTest()
    }
    
    func loginVMShouldUpdateNetworkIcon(imageName: String) {
        signalImageView.image = UIImage(named: imageName)
    }
    
    func loginVMDidFailEntryRoomWithTips(tips: String) {
        dismissLoading()
        show(tips)
    }
    
    func loginVMShouldShowScoreVC() {
        showScoreVC()
    }
}

extension LoginVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if let count = textField.text?.count {
            if textField == roomNameTextField, count == 50 {
                if string == "" { return true }
                let tips = NSLocalizedString("login_t4", comment: "")
                show(tips)
                return false
            }
            if textField == userNameTextField, count == 20 {
                if string == "" { return true }
                let tips = NSLocalizedString("login_t5", comment: "")
                show(tips)
                return false
            }
            if textField == roomPsdTextField, count == 20 {
                if string == "" { return true }
                let tips = NSLocalizedString("login_t6", comment: "")
                show(tips)
                return false
            }
        }
        
        return !string.containsEmoji
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if roomNameTextField == textField {
            roomNameMaskView.isHidden = false
        }
        if roomPsdTextField == textField {
            roomPsdMaskView.isHidden = false
        }
        if userNameTextField == textField {
            userNameMaskView.isHidden = false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if roomNameTextField == textField {
            roomNameMaskView.isHidden = true
        }
        if roomPsdTextField == textField {
            roomPsdMaskView.isHidden = true
        }
        if userNameTextField == textField {
            userNameMaskView.isHidden = true
        }
    }
}
