//
//  DebugUIManager.swift
//  AgoraMeetingUI
//
//  Created by ZYP on 2021/8/24.
//

import UIKit
import AgoraMeetingContext

class DebugUIManager: UIViewController {

    let tableView = UITableView(frame: .zero, style: .grouped)
    let items = ["更新用户属性", "读取用户属性", "更新房间属性", "读取房间属性", "发送私聊消息"]
    var contextPool: AgoraMeetingContextPool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        commonInit()
    }
    
    private func setup() {
        tableView.register(UITableViewCell.self,
                           forCellReuseIdentifier: "cell")
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
    }
    
    private func commonInit() {
        contextPool?.usersContext.registerEventHandler(self)
        contextPool?.messageContext.registerEventHandler(self)
    }
    
    func updateUserProperty() {
        contextPool?.usersContext.updateLocalUserProperties(properties: ["my": "ccc"],
                                                            success: {
                                                                Log.debug(text: "updateLocalUserProperties success",
                                                                          tag: "DebugUIManager")
                                                            }, fail: { _ in
                                                                
                                                            })
    }
    
    func readUserProperty() {
        if let userId = contextPool?.usersContext.getLocalUserInfo().userId {
            let result = contextPool?.usersContext
                .getUserProperties(userId: userId)
            let text = "\(result ?? [:])"
            Log.debug(text: "read: \(result ?? [:])",
                      tag: "DebugUIManager")
            let vc = UIAlertController(title: "读取",
                                       message: "UserProperty: \(text)",
                                       preferredStyle: .alert)
            vc.addAction(.init(title: "关闭",
                               style: .default,
                               handler: nil))
            present(vc,
                    animated: true,
                    completion: nil)
        }
    }
    
    func updateRoomProperty() {
        contextPool?.roomContext.updateFlexRoomProperties(properties: ["user" : "123",
                                                                       "other" : "88ji"],
                                                          success: {
                                                            Log.debug(text: "updateFlexRoomProperties success",
                                                                      tag: "DebugUIManager")
                                                          },
                                                          fail: { _ in })
    }
    
    func readRoomProperty() {
        let flexRoomProperties = contextPool?.roomContext.getFlexRoomProperties()
        let text = "\(flexRoomProperties ?? [:])"
        Log.debug(text: "read: \(flexRoomProperties ?? [:])", tag: "DebugUIManager")
        
        let vc = UIAlertController(title: "读取",
                                   message: "RoomProperty: \(text)",
                                   preferredStyle: .alert)
        vc.addAction(.init(title: "关闭",
                           style: .default,
                           handler: nil))
        present(vc,
                animated: true,
                completion: nil)
    }
    
    func sendPrivateMsg() {
        guard let targetUserId = contextPool?.usersContext.getUserInfoList().filter({ !$0.isMe }).first?.userId else {
            return
        }
        
        contextPool?.messageContext.sendPrivateChatMessage(targetUserId: targetUserId,
                                                           content: "hello",
                                                           success: {
                                                            Log.info(text: "发送成功", tag: "DebugUIManager")
                                                           }, fail: {error in
                                                            Log.error(error: error, tag: "DebugUIManager")
                                                           })
    }
}

extension DebugUIManager: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = items[indexPath.row]
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath,
                              animated: true)
        if indexPath.row == 0 {
            updateUserProperty()
            return
        }
        
        if indexPath.row == 1 {
            readUserProperty()
            return
        }
        
        if indexPath.row == 2 {
            updateRoomProperty()
            return
        }
        
        if indexPath.row == 3 {
            readRoomProperty()
            return
        }
        
        if indexPath.row == 4 {
            sendPrivateMsg()
        }
    }
}

extension DebugUIManager: UsersEventHandler {
    func onUserListUpdated(userList: [UserDetailInfo]) {
        
    }
    
    func onKickedOut() {
        
    }
    
    func onLocalConnectStateChanged(state: ConnectState) {
        
    }
    
    func onUserPropertiesUpdated(userId: String,
                                 full: UserProperties) {
        Log.debug(text: "fill:\(full)",
                  tag: "DebugUIManager")
        DispatchQueue.main.async { [weak self] in
            self?.view.show(toast: "收到消息UserProperties")
        }
    }
}

extension DebugUIManager: MessagesEventHandler {
    func onChatMessagesUpdated(msgs: [ChatMessage]) {
        
    }
    
    func onNotifyMessagesUpdated(msgs: [NotifyMessage]) {
        
    }
    
    func onPrivateChatMessageReceived(content: String, fromUser: UserInfo) {
        DispatchQueue.main.async { [weak self] in
            self?.view.show(toast: "收到消息")
        }
    }
}
