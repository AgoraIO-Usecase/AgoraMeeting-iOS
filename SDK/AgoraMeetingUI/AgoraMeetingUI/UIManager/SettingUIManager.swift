//
//  SettingUIManager.swift
//  AgoraMeetingUI
//
//  Created by ZYP on 2021/6/17.
//

import Foundation
import AgoraMeetingContext

typealias SettingVC = SettingUIManager
class SettingUIManager: UIViewController {
    weak var routerDelegate: UIManagerRouterProtocol?
    var settingUC: SettingUIController!
    weak var contextPool: AgoraMeetingContextPool?
    
    init(contextPool: AgoraMeetingContextPool) {
        super.init(nibName: nil, bundle: nil)
        self.contextPool = contextPool
        settingUC = SettingUIController(contextPool: contextPool)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        Log.info(text: "SettingUIManager",
                 tag: "deinit")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        layoutView()
        settingUC.start()
        commonInit()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false,
                                                     animated: animated)
    }
    
    func setup() {
        title = MeetingUILocalizedString("set_t17", comment: "")
        view.backgroundColor = .white
        #if DEBUG
//        addDebugButton()
        #endif
    }
    
    func commonInit() {
        settingUC.baseDataSource = self
    }
    
    func layoutView() {
        let settingView = settingUC.view
        view.addSubview(settingView)
        settingView.translatesAutoresizingMaskIntoConstraints = false
        settingView.leftAnchor
            .constraint(equalTo: view.leftAnchor)
            .isActive = true
        settingView.rightAnchor
            .constraint(equalTo: view.rightAnchor)
            .isActive = true
        settingView.topAnchor
            .constraint(equalTo: view.topAnchor)
            .isActive = true
        settingView.bottomAnchor
            .constraint(equalTo: view.bottomAnchor)
            .isActive = true
    }
    
    func addDebugButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .bookmarks,
                                                            target: self,
                                                            action: #selector(debugAction))
    }
    
    @objc func debugAction() {
        let vc = DebugUIManager()
        vc.contextPool = contextPool
        navigationController?.pushViewController(vc,
                                                 animated: true)
    }
}

extension SettingUIManager: BaseControllerDataSource {
    func controllerShouldGetVC() -> UIViewController {
        return self
    }
}
