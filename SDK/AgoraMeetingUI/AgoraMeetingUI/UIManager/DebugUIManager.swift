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
    let items = ["更新用户属性", "删除用户属性", "读取用户属性"]
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
    }
    
    func update() {
        contextPool?.usersContext.updateLocalUserProperties(properties: ["my": "ccc"],
                                                            success: {
                                                                Log.debug(text: "updateLocalUserProperties success",
                                                                          tag: "DebugUIManager")
                                                            }, fail: { _ in
                                                                
                                                            })
    }
    
    func delete() {
        contextPool?.usersContext.deleteLocalUserProperties(keys: ["my"],
                                                            success: {
                                                                Log.debug(text: "deleteLocalUserProperties success",
                                                                          tag: "DebugUIManager")
                                                            },
                                                            fail: { _ in
                                                                
                                                            })
    }
    
    func read() {
        if let userId = contextPool?.usersContext.getLocalUserInfo().userId {
            let result = contextPool?.usersContext.getUserProperties(userId: userId)
            Log.debug(text: "read: \(result ?? [:])",
                      tag: "DebugUIManager")
        }
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
            update()
            return
        }
        
        if indexPath.row == 1 {
            delete()
            return
        }
        
        if indexPath.row == 2 {
            read()
            return
        }
    }
}

extension DebugUIManager: UsersEvnetHandler {
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
    }
}
