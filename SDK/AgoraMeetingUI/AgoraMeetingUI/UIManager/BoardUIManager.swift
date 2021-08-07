//
//  BoardUIManager.swift
//  MeetingUI
//
//  Created by ZYP on 2021/5/19.
//

import UIKit
import AgoraMeetingContext

typealias BoardVC = BoardUIManager
class BoardUIManager: UIViewController {
    private var boardUIController: BoardUIController!
    
    init(contextPool: AgoraMeetingContextPool) {
        super.init(nibName: nil,
                   bundle: nil)
        self.boardUIController = BoardUIController(boardContext: contextPool.boardContext)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        Log.info(text: "BoardUIManager",
                 tag: "deinit")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        conmonInit()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    func setup() {
        title = MeetingUILocalizedString("wb_t3", comment: "")
        boardUIController.view.frame = view.bounds
        view.addSubview(boardUIController.view)
    }
    
    func conmonInit() {
        boardUIController.baseDataSource = self
        boardUIController.renderView()
    }
}

extension BoardUIManager: BaseControllerDataSource {
    func controllerShouldGetVC() -> UIViewController {
        return self
    }
}
