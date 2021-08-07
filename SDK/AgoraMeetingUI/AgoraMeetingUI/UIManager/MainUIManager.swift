//
//  MainUIManager.swift
//  MeetingApaasTest
//
//  Created by ZYP on 2021/5/12.
//

import UIKit
import AgoraMeetingContext

typealias MainVC = MainUIManager
public class MainUIManager: UIViewController {
    weak var routerDelegate: UIManagerRouterProtocol?
    var topUIController: MainTopUIController!
    var bottomUIController: MainBottomUIController!
    var renderUIController: MainRenderUIController!
    var notifyUIController: MainNotifyUIController!
    var contextPool: AgoraMeetingContextPool!
    
    public init(contextPool: AgoraMeetingContextPool,
                queue: DispatchQueue) {
        super.init(nibName: nil,
                   bundle: nil)
        self.contextPool = contextPool
        topUIController = MainTopUIController(contextPool: contextPool)
        bottomUIController = MainBottomUIController(contextPool: contextPool)
        renderUIController = MainRenderUIController(contextPool: contextPool,
                                                    queue: queue)
        notifyUIController = MainNotifyUIController(contextPool: contextPool,
                                                    messageView: renderUIController.view.messageView,
                                                    queue: queue)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        Log.info(text: "MainUIManager",
                 tag: "deinit")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        layoutView()
        view.showLoading()
        commonInit()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true,
                                                     animated: animated)
        navigationItem.backButtonTitle = ""
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        renderUIController.view
            .speakerView
            .updateScaleVideoViewContentSize()
    }
    
    func setup() {
        view.backgroundColor = .white
    }
    
    func layoutView() {
        view.addSubview(topUIController.view)
        view.addSubview(bottomUIController.view)
        view.addSubview(renderUIController.view)
        
        topUIController.view.translatesAutoresizingMaskIntoConstraints = false
        bottomUIController.view.translatesAutoresizingMaskIntoConstraints = false
        renderUIController.view.translatesAutoresizingMaskIntoConstraints = false
        
        topUIController.view
            .topAnchor
            .constraint(equalTo: view.topAnchor)
            .isActive = true
        topUIController.view
            .leftAnchor
            .constraint(equalTo: view.leftAnchor)
            .isActive = true
        topUIController.view
            .rightAnchor
            .constraint(equalTo: view.rightAnchor)
            .isActive = true
        topUIController.view
            .heightAnchor
            .constraint(equalToConstant: 44 + UIScreen.statusBarHeight())
            .isActive = true
        
        bottomUIController.view
            .bottomAnchor
            .constraint(equalTo: view.bottomAnchor)
            .isActive = true
        bottomUIController.view
            .leftAnchor
            .constraint(equalTo: view.leftAnchor)
            .isActive = true
        bottomUIController.view
            .rightAnchor
            .constraint(equalTo: view.rightAnchor)
            .isActive = true
        bottomUIController.view
            .heightAnchor
            .constraint(equalToConstant: 55 + UIScreen.bottomSafeAreaHeight())
            .isActive = true
        
        renderUIController.view
            .leftAnchor
            .constraint(equalTo: view.leftAnchor)
            .isActive = true
        renderUIController.view
            .rightAnchor
            .constraint(equalTo: view.rightAnchor)
            .isActive = true
        renderUIController.view
            .topAnchor
            .constraint(equalTo: topUIController.view.bottomAnchor)
            .isActive = true
        renderUIController.view
            .bottomAnchor
            .constraint(equalTo: bottomUIController.view.topAnchor)
            .isActive = true
        
    }
    
    func commonInit() {
        topUIController.delegate = self
        topUIController.baseDataSource = self
        bottomUIController.delegate = self
        bottomUIController.baseDataSource = self
        renderUIController.baseDataSource = self
        renderUIController.delegate = self
        notifyUIController.baseDataSource = self
        notifyUIController.delegate = self
    }
    
    func setMessageRedDotHandle(needUpdate: Bool) {
        bottomUIController.setMessageRedDotHandle(needUpdate: needUpdate)
    }
    
    var notiScheduler: NotiEventScheduler {
        return notifyUIController.notiScheduler
    }
}

extension MainUIManager: MainTopUIControllerDelegate,
                         MainBottomUIControllerDelegate,
                         MainRenderUIControllerDelegate,
                         MainNotifyUIControllerDelegate {
    
    /// MARK -- MainBottomUIControllerDelegate
    
    func mainBottomUIControllerDidTapSetting() {
        routerDelegate?.pushSettingManagerFrom(self)
    }
    
    func mainBottomUIControllerDidTapUsers() {
        routerDelegate?.pushUsersManagerFrom(self)
    }
    
    func mainBottomUIControllerDidTapMessage() {
        routerDelegate?.pushMessageManagerFrom(self)
    }
    
    func mainBottomUIControllerDidTapStartScreen() {
        renderUIController.showOpenScreenAlert()
    }
    
    func mainBottomUIControllerDidTapEndScreen() {
        renderUIController.showCloseScreenAlert()
    }
    
    /// MARK -- MainRenderUIControllerDelegate
    
    func mainRenderUIControllerShouldShowBoardManager() {
        routerDelegate?.pushBoardManagerFrom(self)
    }
    
    /// MARK -- MainNotifyUIControllerDelegate
    
    func mainNotifyUIControllerDidTapGoSetButton() {
        routerDelegate?.pushSettingManagerFrom(self)
    }
    
    /// MARK -- MainTopUIControllerDelegate
    
    func mainTopUIControllerShouldShowCloseScreenAlert() {
        renderUIController.showCloseScreenAlert()
    }
    
    func mainTopUIControllerShouldCloseBoardAlert() {
        renderUIController.showEndBoardAlert()
    }
    
    func mainTopUIControllerDidExitRoom() {
        dismiss(animated: true, completion: { [weak self] in
            self?.topUIController.leaveRoom()
        })
    }
    
    func mainTopUIControllerDidJoinRoom(state: RoomJoinState) {
        if state == .joinFail {
            view.show(toast: "加入失败")
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) { [weak self] in
                self?.dismiss(animated: true, completion: nil)
            }
        }
        
        if state == .joinSuccess {
            view.dismissLoading()
        }
    }
}

extension MainUIManager: BaseControllerDataSource {
    func controllerShouldGetVC() -> UIViewController {
        return self
    }
}

