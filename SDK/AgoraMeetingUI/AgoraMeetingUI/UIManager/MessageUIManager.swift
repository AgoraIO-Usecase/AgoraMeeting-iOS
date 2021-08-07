//
//  MessageUIManager.swift
//  AgoraMeetingCore
//
//  Created by ZYP on 2021/6/21.
//

import Foundation
import AgoraMeetingContext

protocol MessageUIManagerDelegate: NSObject {
    func messageUIManagerDidAppear()
    func messageUIManagerDidDisappear()
}

class MessageUIManager: UIViewController {
    let messageUC: MessageUIController
    weak var delegate: MessageUIManagerDelegate?
    
    init(contextPool: AgoraMeetingContextPool,
         notiScheduler: NotiEventScheduler,
         queue: DispatchQueue) {
        messageUC = MessageUIController(contextPool: contextPool,
                                        notiScheduler: notiScheduler,
                                        queue: queue)
        super.init(nibName: nil,
                   bundle: nil)
        setup()
        layoutView()
        commonInit()
    }
    
    deinit {
        delegate?.messageUIManagerDidDisappear()
        Log.info(text: "MessageUIManager",
                 tag: "deinit")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        messageUC.start()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false,
                                                     animated: animated)
        navigationItem.backButtonTitle = ""
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        delegate?.messageUIManagerDidAppear()
        navigationItem.backBarButtonItem?.title = ""
    }
    
    func setup() {
        title = MeetingUILocalizedString("msg_t4", comment: "")
        view.backgroundColor = .white
    }
    
    func layoutView() {
        let messageView = messageUC.view
        view.addSubview(messageView)
        messageView.translatesAutoresizingMaskIntoConstraints = false
        messageView.leftAnchor
            .constraint(equalTo: view.leftAnchor)
            .isActive = true
        messageView.rightAnchor
            .constraint(equalTo: view.rightAnchor)
            .isActive = true
        messageView.bottomAnchor
            .constraint(equalTo: view.bottomAnchor)
            .isActive = true
        messageView.topAnchor
            .constraint(equalTo: view.topAnchor)
            .isActive = true
    }
    
    func commonInit() {
        messageUC.baseDataSource = self
    }
}

extension MessageUIManager: BaseControllerDataSource {
    func controllerShouldGetVC() -> UIViewController {
        return self
    }
}
