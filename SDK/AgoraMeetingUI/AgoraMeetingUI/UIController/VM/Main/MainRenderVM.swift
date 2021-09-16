//
//  RenderVM.swift
//  AgoraMeetingUI
//
//  Created by ZYP on 2021/6/8.
//

import Foundation
import AgoraMeetingContext
import DifferenceKit
import Whiteboard

protocol RenderVMDelegate: NSObject {
    func renderVMDidUpdateInfo(vm: MainRenderVM,
                               info: MainRenderVM.UpdateInfo)
    func renderVMShouldShowSystemViewForScreenStart(vm: MainRenderVM)
}

class MainRenderVM: BaseVM {
    weak var delegate: RenderVMDelegate?
    let renderContext: RenderContext
    let usersContext: UsersContext
    let mediaContext: MediaContext
    let boardContext: BoardContext
    let screenContext: ScreenContext
    let queue: DispatchQueue
    var layout = RenderLayout.tile
    var selectedId = ""
    let eventScheduler = MainRenderEventScheduler()
    var subscribedAudios = [String]()
    
    init(renderContext: RenderContext,
         usersContext: UsersContext,
         mediaContext: MediaContext,
         boardContext: BoardContext,
         screenContext: ScreenContext,
         queue: DispatchQueue) {
        self.renderContext = renderContext
        self.usersContext = usersContext
        self.mediaContext = mediaContext
        self.boardContext = boardContext
        self.screenContext = screenContext
        self.queue = queue
        super.init()
        commonInit()
    }
    
    deinit {
        renderContext.unregisterEventHandler(self)
        unregisterNotiFormScreenShareExtension()
        Log.info(text: "MainRenderVM",
                 tag: "deinit")
    }
    
    func start() {
        let renderInfoList = renderContext.getRenderInfoList()
        if renderInfoList.count == 0 { return }
        eventScheduler.set(renders: renderInfoList)
    }
    
    private func setup() {}
    
    private func commonInit() {
        eventScheduler.delegate = self
        renderContext.registerEventHandler(self)
        screenContext.registerEventHandler(self)
        registerNotiFormScreenShareExtension()
        start()
    }
    
    func subscriptVideo(streamId: String,
                        view: UIView ,
                        isHighStream: Bool) {
        Log.info(text: "subscriptVideo \(streamId)", tag: "sub")
        let _ = mediaContext.subscriptVideo(streamId: streamId,
                                            view: view,
                                            renderMode: .fit,
                                            isHighStream: isHighStream)
    }
    
    func unSubscriptVideo(streamId: String) {
        Log.info(text: "unSubscriptVideo \(streamId)", tag: "sub")
        let _ = mediaContext.unSubscriptVideo(streamId: streamId)
    }
    
    func renderBoardView(view: UIView,
                         canWrite: Bool) {
        let error = boardContext.renderBoardView(view: view,
                                                 canWrite: canWrite)
        if let e = error {
            Log.info(text: "\(e.message)",
                     tag: "renderBoardView")
        }
    }
    
    func setTileTop(renderId: String,
                    isTop: Bool) {
        eventScheduler.setTop(renderId: renderId,
                              isTop: isTop)
    }
    
    func setLecturerMain(renderId: String) {
        switchToLecturer(renderId: renderId)
    }
    
    func switchToLecturer(renderId: String) {
        eventScheduler.setLayoutManual(layout: .lecturer,
                                       selectedId: renderId)
    }
    
    func switchToTile() {
        eventScheduler.setLayoutManual(layout: .tile)
    }
    
    func handleAudioSubscribe(infos: [RenderInfo]) {
        let activeStreamIds = infos.filter({ $0.type == .media && !$0.isMe && $0.hasAudio }).map({ $0.streamId })
        Log.info(text: "handleAudioSubscribe \(activeStreamIds)",
                 tag: "test")
        /// subscribe
        if let error = mediaContext.subscriptAudio(streamIds: activeStreamIds) {
            Log.error(error: error,
                      tag: "handleAudioSubscribe")
            return
        }
        subscribedAudios = activeStreamIds
    }
}
