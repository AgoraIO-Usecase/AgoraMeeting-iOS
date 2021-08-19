//
//  MainRenderUIController+Handle.swift
//  AgoraMeetingUI
//
//  Created by ZYP on 2021/6/9.
//

import Foundation
import DifferenceKit
import AgoraMeetingContext

extension MainRenderUIController {
    func update(info: MainRenderVM.UpdateInfo) {
        let hasChangeMode = info.mode != data.mode
        let mode = info.mode
        
        switch mode {
        case .videoFlow:
            let count = info.videoCellInfos.count
            let showRightButton = info.showRightButton
            let collectionView = view.collectionViewVideo
            view.setMode(mode,
                         infosCunt: count,
                         showRightButton: showRightButton)
            if hasChangeMode {
                data = info
                view.videoScrollView.collectionView.reloadData()
                collectionView.reloadData()
                return
            }
            let changeset = StagedChangeset(source: data.videoCellInfos,
                                            target: info.videoCellInfos)
            let old = data.videoCellInfos
            data = info
            data.videoCellInfos = old
            collectionView.reloadWithOutAnimations(using: changeset,
                                                   interrupt: nil,
                                                   setData: { [weak self](dataNew) in
                                                    self?.data.videoCellInfos = dataNew
                                                   }, completeOneStep: { [weak self] in
                                                    self?.view.updatePage()
                                                   })
            return
        case .audioFlow :
            data.audioCellInfos = info.audioCellInfos
            let count = info.audioCellInfos.count
            let showRightButton = info.showRightButton
            view.setMode(mode,
                         infosCunt: count,
                         showRightButton: showRightButton)
            view.updatePage()
            return
        case .speaker:
            let count = info.videoCellMiniInfos.count
            let showRightButton = info.showRightButton
            let speakerInfo = info.speakerInfo!
            let selectedInfo = info.selectedInfo!
            let collectionView = view.videoScrollView.collectionView
            view.setMode(mode,
                         infosCunt: count,
                         showRightButton: showRightButton)
            if hasChangeMode {
                data = info
                view.collectionViewVideo.reloadData()
                collectionView.reloadData()
            }
            else {
                let changeset = StagedChangeset(source: data.videoCellMiniInfos,
                                                target: info.videoCellMiniInfos)
                let old = data.videoCellMiniInfos
                data = info
                data.videoCellMiniInfos = old
                collectionView.reloadWithOutAnimations(using: changeset) { [weak self](dataNew) in
                    self?.data.videoCellMiniInfos = dataNew
                }
            }
            
            updateSpeakerView(info: selectedInfo,
                              model: speakerInfo)
            
            return
        @unknown default:
            fatalError()
        }
    }
    
    func updateSpeakerView(info: RenderInfo,
                           model: SpeakerModel) {
        switch info.type {
        case .media:
            let videoView = view.speakerView.getVideoView()
            view.speakerView.setModel(model)
            vm.subscriptVideo(streamId: info.streamId,
                              view: videoView,
                              isHighStream: true)
            break
        case .screenSharing:
            view.speakerView.setModel(model)
            if !model.isLocalUser {
                let videoView = view.speakerView.getVideoView()
                vm.subscriptVideo(streamId: info.streamId,
                                  view: videoView,
                                  isHighStream: true)
            }
            break
        case .board:
            view.speakerView.setModel(model)
            let boardView = view.speakerView.getBoardView()
            boardView.isUserInteractionEnabled = false
            vm.renderBoardView(view: boardView,
                               canWrite: false)
            break
        }
    }
}
