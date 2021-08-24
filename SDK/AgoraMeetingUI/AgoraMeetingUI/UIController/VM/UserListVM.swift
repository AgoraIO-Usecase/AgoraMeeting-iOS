//
//  UserListVM.swift
//  AgoraMeetingUI
//
//  Created by ZYP on 2021/6/4.
//

import Foundation
import AgoraMeetingContext

protocol UserListVMDelegate: ShowTipsProtocol {
    func userListVM(vm: UserListVM, shouldUpdateInfos infos: [UserListVM.Info])
}

class UserListVM: BaseVM {
    typealias Mode = UserListView.Mode
    typealias Info = UserListView.Info
    typealias Action = UserListView.Info.ActionType
    
    weak var delegate: UserListVMDelegate?
    private let usersContext: UsersContext
    private var mode: UserListView.Mode = .normal
    private var searchText: String?
    fileprivate var users = [UserDetailInfo]()
    private let queue: DispatchQueue
    
    init(usersContext: UsersContext,
         queue: DispatchQueue) {
        self.queue = queue
        self.usersContext = usersContext
        super.init()
        setup()
        commonInit()
    }
    
    deinit {
        usersContext.unregisterEventHandler(self)
        Log.info(text: "UserListVM",
                 tag: "deinit")
    }
    
    func start() {
        update()
    }
    
    private func setup() {
        users = usersContext.getUserInfoList()
    }
    
    private func commonInit() {
        usersContext.registerEventHandler(self)
    }
    
    fileprivate func update() {
        let output = createOutput()
        DispatchQueue.main.async { [weak self] in
            guard let `self` = self else { return }
            self.delegate?.userListVM(vm: self, shouldUpdateInfos: output)
        }
    }
    
    private func createOutput() -> [Info] {
        if mode == .searching, let text = searchText {
            return createSearchUsers(text: text).sorted(by: sortHandle(lhs:rhs:))
        }
        return users.map({ $0.toInfo }).sorted(by: sortHandle(lhs:rhs:))
    }
    
    private func createSearchUsers(text: String) -> [Info] {
        let data = users
        var temp = [Info]()
        for user in data {
            var info = user.toInfo
            let title = info.cellInfo.title
            if title.contains(text) {
                let range = (NSString(string: title)).range(of: text)
                let attributedString = NSMutableAttributedString(string: title)
                attributedString.addAttribute(.foregroundColor,
                                              value: UIColor(hex: 0x4DA1FF),
                                              range: range)
                info.cellInfo.setAttributeTitle(attributedTitle: attributedString)
                temp.append(info)
            }
        }
        return temp
    }
    
    fileprivate func saveUsers(userList:  [UserDetailInfo]) {
        queue.sync { [unowned self] in
            self.users = userList
            self.update()
        }
    }
    
    func dealAction(action: Action,
                    info: Info) {
        guard let userInfo = usersContext.getUserInfoList().filter({ info.userId == $0.userId }).first,
              let operation = UserOperation(rawValue: action.rawValue) else {
            return
        }
        usersContext.dealUserOperation(userId: userInfo.userId,
                                       operation: operation,
                                       success: {},
                                       fail: { [weak self](e) in
                                        guard let `self` = self else { return }
                                        self.invokeShouldShowTip(text: e.localizedMessage)
                                       })
    }
    
    private func sortHandle(lhs: Info, rhs: Info) -> Bool {
        var lhsValue = 0
        var rhsValue = 0
        
        lhs.cellInfo.isHost ? lhsValue += 10 : nil
        rhs.cellInfo.isHost ? rhsValue += 10 : nil
        
        lhs.isMe ? lhsValue += 100 : nil
        rhs.isMe ? rhsValue += 100 : nil
        
        if lhsValue == rhsValue { return true }
        
        return lhsValue > rhsValue
    }
}

extension UserListVM { /** public **/
    func set(mode: Mode) {
        queue.sync { [unowned self] in
            self.mode = mode
            update()
        }
    }
    
    func search(text: String?) {
        queue.sync { [unowned self] in
            self.searchText = text
            self.update()
        }
    }
}

extension UserListVM: UsersEvnetHandler {
    func onKickedOut() {}
    func onLocalConnectStateChanged(state: ConnectState) {}
    
    func onUserListUpdated(userList: [UserDetailInfo]) {
        saveUsers(userList: userList)
    }
    
    func onUserPropertiesUpdated(userId: String,
                                 full: UserProperties) {
        
    }
}

extension UserDetailInfo {
    fileprivate var toInfo: UserListVM.Info {
        let headImageName = String.headImageName(userName: userName.md5())
        let isHost = userRole == .host
        
        var title = userName
        if isHost, isMe {
            title +=  MeetingUILocalizedString("mem_t15", comment: "")
        }
        else if isHost {
            title += MeetingUILocalizedString("mem_t16", comment: "")
        }
        else if isMe {
            title += MeetingUILocalizedString("mem_t17", comment: "")
        }
        let uiInfo = UserCell.Info(headImageName: headImageName,
                                   title: title,
                                   name: userName,
                                   userId: userId,
                                   isHost: isHost,
                                   hasShare: isSharing,
                                   videoEnable: hasVideo,
                                   audioEnable: hasAudio,
                                   attributedTitle: NSMutableAttributedString(string: title))
        let actions = options.map({ UserListVM.Info.ActionType(rawValue: $0.rawValue)! })
        return UserListVM.Info(userId: userId,
                               cellInfo: uiInfo,
                               actions: actions,
                               isMe: isMe)
    }
}
