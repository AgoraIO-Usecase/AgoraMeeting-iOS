//
//  UserListManager.swift
//  AgoraMeetingUI
//
//  Created by ZYP on 2021/6/4.
//

import UIKit
import AgoraMeetingContext

typealias UserListVC = UserListUIManager
class UserListUIManager: UIViewController {
    var userListUC: UserListUIController!
    
    init(userContext: UsersContext,
         queue: DispatchQueue) {
        super.init(nibName: nil, bundle: nil)
        userListUC = UserListUIController(usersContext: userContext,
                                          queue: queue)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        Log.info(text: "UserListUIManager",
                 tag: "deinit")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        commonInit()
        layoutView()
        userListUC.start()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false,
                                                     animated: animated)
    }
    
    func setup() {
        view.backgroundColor = .white
    }
    
    func layoutView() {
        let userListView = userListUC.view
        view.addSubview(userListView)
        userListView.translatesAutoresizingMaskIntoConstraints = false
        userListView.leftAnchor
            .constraint(equalTo: view.leftAnchor)
            .isActive = true
        userListView.rightAnchor
            .constraint(equalTo: view.rightAnchor)
            .isActive = true
        userListView.topAnchor
            .constraint(equalTo: view.topAnchor)
            .isActive = true
        userListView.bottomAnchor
            .constraint(equalTo: view.bottomAnchor)
            .isActive = true
    }
    
    func commonInit() {
        userListUC.dataSource = self
        userListUC.baseDataSource = self
    }
}

extension UserListUIManager: UserListUIControllerDataSource {
    func userListUIControllerShouldGetNavItem() -> UINavigationItem? {
        return navigationItem
    }
}

extension UserListUIManager: BaseControllerDataSource {
    func controllerShouldGetVC() -> UIViewController {
        return self
    }
}
