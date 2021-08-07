//
//  MessageView.swift
//  VideoConference
//
//  Created by ZYP on 2021/2/23.
//  Copyright © 2021 agora. All rights reserved.
//

import Foundation

protocol MessageViewDelegate: NSObject {
    func messageViewShouldTableViewScrollToBottom()
    func messageViewDidTapSend(text: String)
    func messageViewDidTapRetryButton(id: Int)
    func messageViewDidTapNotiButton(id: Int)
}

class MessageView: UIView {
    let topView = MessageTopView()
    let bottomView = Bundle.meetingUI().loadNibNamed("MessageInputView", owner: nil, options: nil)?.first as! MessageInputView
    let textInputViewHeight: CGFloat = UIScreen.supportFaceID() ? 100 : 78
    let tableView1 = UITableView(frame: .zero, style: .plain)
    let tableView2 = UITableView(frame: .zero, style: .plain)
    var bottomConstraint: NSLayoutConstraint?
    var heightConstraint: NSLayoutConstraint?
    weak var delegate: MessageViewDelegate?
    var chatInfos = [ChatInfo]()
    var notiInfos = [NotiInfo]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        backgroundColor = .white
        
        tableView1.tableFooterView = UIView()
        tableView1.separatorStyle = .none
        tableView1.allowsSelection = false
        tableView1.backgroundColor = UIColor(hex: 0xEDEEEF)
        
        tableView2.tableFooterView = UIView()
        tableView2.separatorStyle = .none
        tableView2.allowsSelection = false
        tableView2.backgroundColor = UIColor(hex: 0xEDEEEF)
        tableView2.isHidden = true
        
        addSubview(tableView1)
        addSubview(tableView2)
        addSubview(bottomView)
        addSubview(topView)
        
        topView.translatesAutoresizingMaskIntoConstraints = false
        tableView1.translatesAutoresizingMaskIntoConstraints = false
        tableView2.translatesAutoresizingMaskIntoConstraints = false
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        
        bottomView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        bottomView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        heightConstraint = bottomView.heightAnchor.constraint(equalToConstant: textInputViewHeight)
        bottomConstraint = bottomView.bottomAnchor.constraint(equalTo: bottomAnchor)
        heightConstraint?.isActive = true
        bottomConstraint?.isActive = true
        
        topView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor).isActive = true
        topView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        topView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        topView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        tableView1.topAnchor.constraint(equalTo: topView.bottomAnchor).isActive = true
        tableView1.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        tableView1.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        tableView1.bottomAnchor.constraint(equalTo: bottomView.topAnchor).isActive = true
        
        tableView2.topAnchor.constraint(equalTo: topView.bottomAnchor).isActive = true
        tableView2.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        tableView2.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        tableView2.bottomAnchor.constraint(equalTo: bottomView.bottomAnchor).isActive = true
    }
    
    func commonInit() {
        tableView1.register(UINib(nibName: "MessageCell", bundle: .meetingUI()), forCellReuseIdentifier: "MessageCell")
        tableView1.register(UINib(nibName: "MessageSelfCell", bundle: .meetingUI()), forCellReuseIdentifier: "MessageSelfCell")
        tableView1.estimatedRowHeight = 100
        tableView1.rowHeight = UITableView.automaticDimension
        tableView1.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
        tableView1.delegate = self
        tableView1.dataSource = self
        
        tableView2.register(NotiCell.self, forCellReuseIdentifier: "NotiCell")
        tableView2.estimatedRowHeight = 100
        tableView2.rowHeight = UITableView.automaticDimension
        tableView2.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
        tableView2.delegate = self
        tableView2.dataSource = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(noti:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(noti:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        bottomView.textField.delegate = self
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(gesture))
        addGestureRecognizer(tapGestureRecognizer)
        
        bottomView.sendButton.addTarget(self, action: #selector(buttonTap(btn:)), for: .touchUpInside)
        
        topView.delegate = self
    }
    
    @objc func keyboardWillShow(noti: Notification) {
        let kFrame = noti.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
        let duration = noti.userInfo![UIResponder.keyboardAnimationDurationUserInfoKey] as! Double
        UIView.animate(withDuration: duration) {
            self.bottomConstraint?.constant = kFrame.size.height * -1
            self.heightConstraint?.constant = 65
            self.layoutIfNeeded()
            self.delegate?.messageViewShouldTableViewScrollToBottom()
        }
    }
    
    @objc func keyboardWillHide(noti: Notification) {
        let duration = noti.userInfo![UIResponder.keyboardAnimationDurationUserInfoKey] as! Double
        UIView.animate(withDuration: duration) {
            self.bottomConstraint?.constant = 0
            self.heightConstraint?.constant = self.textInputViewHeight
            self.layoutIfNeeded()
        }
    }
    
    @objc func gesture() {
        endEditing(true)
    }
    
    @objc func buttonTap(btn: UIButton) {
        if let text = bottomView.textField.text {
            delegate?.messageViewDidTapSend(text: text)
            bottomView.textField.text = ""
        }
    }
    
    func updateChatInfos(chatInfos: [ChatInfo]) {
        self.chatInfos = chatInfos
        tableView1.reloadData()
    }
    
    func updateNotiInfos(notiInfos: [NotiInfo]) {
        self.notiInfos = notiInfos
        tableView2.reloadData()
    }
    
    func scrollToBottomMsg() {
        if chatInfos.count > 0 {
            let idnexPath = IndexPath(row: chatInfos.count - 1, section: 0)
            tableView1.scrollToRow(at: idnexPath, at: .top, animated: true)
        }
    }
    
    func scrollToBottomNoti() {
        if notiInfos.count > 0 {
            let idnexPath = IndexPath(row: notiInfos.count - 1, section: 0)
            tableView2.scrollToRow(at: idnexPath, at: .top, animated: true)
        }
    }
}

extension MessageView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableView == tableView1 ? chatInfos.count : notiInfos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == tableView1 {
            let info = chatInfos[indexPath.row]
            if info.isFromMyself {
                let cell = tableView.dequeueReusableCell(withIdentifier: "MessageSelfCell", for: indexPath) as! MessageSelfCell
                cell.update(withTime: Int(info.timestamp), message: info.message)
                cell.update(info.state)
                cell.updateTimeShow(info.shouldShowTime)
                cell.indexPath = indexPath
                cell.delegate = self
                return cell
            }
            else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell") as! MessageCell
                cell.update(withTime: Int(info.timestamp), message: info.message, username: info.userName)
                cell.updateTimeShow(info.shouldShowTime)
                return cell
            }
        }
        
        /// for tableView2
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotiCell", for: indexPath) as! NotiCell
        let info = notiInfos[indexPath.row]
        cell.setInfo(info: info)
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == tableView1 { return UITableView.automaticDimension }
        let info = notiInfos[indexPath.row]
        return info.cellHeight
    }
    
}

extension MessageView: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        bottomView.sendButton.isEnabled = string.count > 0
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let text = textField.text, text.count > 0 {
            delegate?.messageViewDidTapSend(text: text)
            bottomView.textField.text = ""
        }
        return textField.text?.count ?? 0 > 0
    }
}

extension MessageView: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        let name = NSStringFromClass(type(of: touch.view!)).components(separatedBy: ".").last!
        if name == "UITableViewCellContentView" {
            return true
        }
        return true
    }
}

extension MessageView: MessageTopViewDelegate {
    func messageTopViewDidSelectedTyep(type: MessageTopView.SelectedType) {
        endEditing(true)
        switch type {
        case .left:
            bottomView.isHidden = false
            tableView1.isHidden = false
            tableView2.isHidden = true
            break
        case .right:
            bottomView.isHidden = true
            tableView1.isHidden = true
            tableView2.isHidden = false
            break
        }
    }
}

extension MessageView: MessageSelfCellDelegate {
    func messageSelfCelldidTapFailButton(_ indexPath: IndexPath) {
        let info = chatInfos[indexPath.row]
        delegate?.messageViewDidTapRetryButton(id: info.id)
    }
}

extension MessageView: NotiCellDelegate {
    func notiCellDidTapButton(info: NotiCell.Info) {
        delegate?.messageViewDidTapNotiButton(id: info.id)
    }
}

extension MessageView {
    struct ChatInfo {
        let id: Int
        let message: String
        let timestamp: Int
        let shouldShowTime: Bool
        let state: MessageSelfCellStatus
        let isFromMyself: Bool
        let userName: String
    }
    
    typealias NotiInfo = NotiCell.Info
}


