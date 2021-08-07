//
//  MainRenderUIController.swift
//  MeetingApaasTest
//
//  Created by ZYP on 2021/5/12.
//

import UIKit
import AgoraMeetingContext

protocol MainRenderUIControllerDelegate: NSObject {
    func mainRenderUIControllerShouldShowBoardManager()
}

class MainRenderUIController: BaseUIController {
    let view = MeetingView()
    let vm: MainRenderVM
    var data: MainRenderVM.UpdateInfo = .empty
    weak var delegate: MainRenderUIControllerDelegate?
    var rpPickerView = UIView()
    
    init(contextPool: AgoraMeetingContextPool,
         queue: DispatchQueue) {
        self.vm = MainRenderVM(renderContext: contextPool.renderContext,
                               usersContext: contextPool.usersContext,
                               mediaContext: contextPool.mediaContext,
                               boardContext: contextPool.boardContext,
                               screenContext: contextPool.screenContext,
                               queue: queue)
        super.init()
        setup()
        commonInit()
    }
    
    deinit {
        Log.info(text: "MainRenderUIController", tag: "deinit")
    }
    
    private func setup() {
        addSystemBroadcastPickerView()
        view.setMode(.videoFlow,
                     infosCunt: 0,
                     showRightButton: false)
        registerCell()
    }
    
    private func commonInit() {
        view.collectionViewVideo.delegate = self
        view.collectionViewVideo.dataSource = self
        view.collectionViewAudio.delegate = self
        view.collectionViewAudio.dataSource = self
        view.speakerView.delegate = self
        view.videoScrollView.collectionView.delegate = self
        view.videoScrollView.collectionView.dataSource = self
        view.speakerView.delegate = self
        vm.delegate = self
        vm.tipsDelegate = self
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(applicationWillTerminate),
                                               name: UIApplication.willTerminateNotification,
                                               object: nil)
    }
    
    @objc func applicationWillTerminate() {
        sendToScreenShareExitIfNeed()
    }
}

