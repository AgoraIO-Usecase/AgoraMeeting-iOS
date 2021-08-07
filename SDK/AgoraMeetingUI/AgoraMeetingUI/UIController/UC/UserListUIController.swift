//
//  UserListUIController.swift
//  AgoraMeetingUI
//
//  Created by ZYP on 2021/6/4.
//

import Foundation
import AgoraMeetingContext
import Toast_Swift

protocol UserListUIControllerDataSource: NSObject {
    func userListUIControllerShouldGetNavItem() -> UINavigationItem?
}

class UserListUIController: BaseUIController {
    weak var dataSource: UserListUIControllerDataSource?
    
    private var vm: UserListVM
    let view = UserListView()
    
    init(usersContext: UsersContext,
         queue: DispatchQueue) {
        vm = UserListVM(usersContext: usersContext,
                        queue: queue)
        super.init()
        setup()
        commonInit()
    }
    
    deinit {
        Log.info(text: "UserListUIController",
                 tag: "deinit")
    }
    
    func start() {
        vm.start()
    }
    
    private func setup() {}
    
    private func commonInit() {
        view.delegate = self
        vm.delegate = self
        vm.tipsDelegate = self
    }
    
    fileprivate func setRightButton(button: UIBarButtonItem) {
        let navItem = dataSource?.userListUIControllerShouldGetNavItem()
        navItem?.rightBarButtonItem = button
    }
    
    fileprivate func setTitleView(titleView: UIView) {
        let navItem = dataSource?.userListUIControllerShouldGetNavItem()
        navItem?.titleView = titleView
    }
    
    private func createSheetVC(info: UserListView.Info) -> MemberSheetVC? {
        if info.actions.count == 0 {
            return nil
        }
        
        let vc = MemberSheetVC()
        vc.set(title: info.cellInfo.title,
               image: UIImage.meetingUIImageName(info.cellInfo.headImageName))
        let cancle = MemberSheetVC.Action(title: MeetingUILocalizedString("mem_t3", comment: ""),
                                          style: .cancel,
                                          handler: nil)
        
        for action in info.actions {
            
            var title = ""
            switch action {
            case .abandonHost:
                title = MeetingUILocalizedString("mem_t8", comment: "")
                break
            case .beHost:
                title = MeetingUILocalizedString("meeting_t25", comment: "")
                break
            case .setAsHost:
                title = MeetingUILocalizedString("mem_t12", comment: "")
                break
            case .closeCamera:
                title = MeetingUILocalizedString("mem_t2", comment: "")
                break
            case .closeMic:
                title = MeetingUILocalizedString("mem_t13", comment: "")
                break
            case .kickOut:
                title = MeetingUILocalizedString("mem_t11", comment: "")
                break
            }
            
            let action = MemberSheetVC.Action(title: title,
                                              style: .default,
                                              handler: { [weak self] in
                                                guard let `self` = self else { return }
                                                self.vm.dealAction(action: action,
                                                                   info: info)
                                              })
            vc.addAction(action)
        }
        vc.addAction(cancle)
        return vc
    }
    
    fileprivate func showSheet(info: UserListView.Info) {
        guard let sheetVC = createSheetVC(info: info),
              let vc = baseDataSource?.controllerShouldGetVC() else {
            return
        }
        sheetVC.show(in: vc)
    }
}

extension UserListUIController: UserListViewDelegate {
    func userListView(view: UserListView,
                      didSelecteInfo info: UserListView.Info) {
        showSheet(info: info)
    }
    
    func userListView(view: UserListView,
                      didCahngeMode mode: UserListView.Mode) {
        vm.set(mode: mode)
    }
    
    func userListView(view: UserListView,
                      shouldSearch text: String?) {
        vm.search(text: text)
    }
    
    func userListView(view: UserListView,
                      shouldUpdateNavBarRightButton button: UIBarButtonItem) {
        setRightButton(button: button)
    }
    
    func userListView(view: UserListView,
                      shouldUpdateNavBarTitleView titleView: UIView) {
        setTitleView(titleView: titleView)
    }
}

extension UserListUIController: UserListVMDelegate {
    func userListVM(vm: UserListVM,
                    shouldUpdateInfos infos: [UserListVM.Info]) {
        view.update(dataList: infos)
    }
}
