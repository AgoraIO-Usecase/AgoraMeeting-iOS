//
//  MainRenderEventScheduler.swift
//  AgoraMeetingUI
//
//  Created by ZYP on 2021/6/11.
//

import Foundation
import AgoraMeetingContext
import DifferenceKit

protocol EventSchedulerDelegate: NSObject {
    func eventSchedulerDidUpdate(updateInfo: MainRenderVM.UpdateInfo)
}

class MainRenderEventScheduler: NSObject {
    typealias UpdateInfo = MainRenderVM.UpdateInfo
    typealias AudioCellInfo = MainRenderVM.AudioCellInfo
    typealias VideoCellInfo = MainRenderVM.VideoCellInfo
    typealias VideoCellMiniInfo = MainRenderVM.VideoCellMiniInfo
    
    weak var delegate: EventSchedulerDelegate?
    let queue: DispatchQueue
    var layout: RenderLayout = .tile
    var renders = [RenderInfo]()
    let timer: MeetingTimeSource
    var last: MainRenderVM.UpdateInfo?
    let timeOutForNoVideoInTileMode = 8
    var stayTileTime = 0
    var selectedId: String?
    var sortItems = [String : SortItem]()
    var shouldAutoCheck = false
    
    init(queue: DispatchQueue = .init(label: "MainRenderEventScheduler.queue")) {
        self.queue = queue
        self.timer = MeetingTimeSource(interval: .seconds(1),
                                       repeats: true,
                                       queue: queue)
        super.init()
        timer.delegate = self
        timer.start()
    }
    
    deinit {
        Log.info(text: "MainRenderEventScheduler",
                 tag: "deinit")
    }
    
    func setLayoutManual(layout: RenderLayout,
                         selectedId: String? = nil) {
        queue.async { [unowned self] in
            self.selectedId = selectedId
            self.setLayoutManualInternal(layout: layout)
        }
    }
    
    func setTop(renderId: String,
                isTop: Bool) {
        queue.async { [unowned self] in
            sortItems[renderId]?.setUserOpration(userOperation: isTop ? .up : .down)
            makeExtern()
        }
    }
    
    func set(renders: [RenderInfo]) {
        queue.async { [unowned self] in
            guard renders.count > 0 else { return } 
            self.handleSort(newRenders: renders)
            self.renders = renders
            self.timer.start()
            self.shouldAutoCheck = true
        }
    }
    
    private func makeExtern() {
        let temp = renders.sorted(by: sort(_:_:))
        guard let info = createUpdate(layout: layout,
                                      renderInfoList: temp) else {
            return
        }
        if info != last {
            Log.info(text: "\(layout)", tag: "layout")
            last = info
            delegate?.eventSchedulerDidUpdate(updateInfo: info)
        }
    }
    
    private func setLayoutManualInternal(layout: RenderLayout) {
        let current = self.layout
        if current == .audio || layout == .audio {
            return
        }
        
        if current == .lecturer, layout == .lecturer {
            stayTileTime = 0
            self.layout = layout
            makeExtern()
            return
        }
        
        if current == .tile, layout == .lecturer { /** from tile to lecturer **/
            stayTileTime = 0
            self.layout = layout
            makeExtern()
            return
        }
        
        if current == .lecturer, layout == .tile { /** from lecturer to tile **/
            stayTileTime = 0
            self.layout = layout
            makeExtern()
            return
        }
    }
    
    private func autoCheckLayout() {
        let current = self.layout
        if let shareRender = renders.filter({ $0.type != .media }).first { /** has share **/
            switch current {
            case .lecturer:
                if selectedId != shareRender.id {
                    stayTileTime = 0
                    self.layout = .lecturer
                    selectedId = shareRender.id
                }
                return
            case .audio:
                stayTileTime = 0
                self.layout = .lecturer
                selectedId = shareRender.id
                return
            case .tile:
                stayTileTime = 0
                self.layout = .lecturer
                selectedId = shareRender.id
                return
            }
        }
        
        /** no share, no video **/
        let hasVideo = renders.contains(where: { $0.hasVideo })
        if hasVideo {
            stayTileTime = 0
        }
        
        if !hasVideo, stayTileTime >= timeOutForNoVideoInTileMode { /** to audio **/
            stayTileTime = 0
            self.layout = .audio
            selectedId = nil
            return
        }
        if !hasVideo, current == .lecturer { /** to tile **/
            stayTileTime = 0
            self.layout = .tile
            selectedId = nil
            return
        }
        if hasVideo, current == .audio { /** to tile **/
            stayTileTime = 0
            self.layout = .tile
            selectedId = nil
            return
        }
        
        if current == .lecturer,
           let render = renders.filter({ $0.id == selectedId }).first { /** can find, but no video **/
            if !render.hasVideo,
               let id = renders.filter({ $0.hasVideo }).first?.id {
                stayTileTime = 0
                selectedId = id
                return
            }
        }
        
        if current == .lecturer,
           renders.filter({ $0.id == selectedId }).first == nil { /** can not find, not share **/
            
            if hasVideo {
                stayTileTime = 0
                selectedId = nil
                layout = .tile
                return
            }
            
            if !hasVideo {
                stayTileTime = 0
                selectedId = nil
                layout = .audio
            }
        }
    }
}

extension MainRenderEventScheduler: MeetingTimeSourceDelegate {
    func meetingTimeSourceTimeDidCome() {
        let hasVideo = renders.contains(where: { $0.hasVideo })
        if layout == .tile, !hasVideo {
            stayTileTime += 1
            autoCheckLayout()
            makeExtern()
        }
        
        if shouldAutoCheck {
            shouldAutoCheck = false
            autoCheckLayout()
        }
        makeExtern()
    }
}
