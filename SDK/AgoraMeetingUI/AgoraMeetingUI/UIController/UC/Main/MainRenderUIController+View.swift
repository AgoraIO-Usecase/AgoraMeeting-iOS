//
//  MainRenderUIController+View.swift
//  AgoraMeetingUI
//
//  Created by ZYP on 2021/6/9.
//

import UIKit

extension MainRenderUIController {
    func registerCell() {
        let whiteBoardCellClass = WhiteBoardCell.self
        let audioNib = UINib(nibName: audioCellIdf,
                             bundle: .meetingUI())
        
        view.collectionViewVideo.register(whiteBoardCellClass,
                                          forCellWithReuseIdentifier: whiteBoardCellIdf)
        view.videoScrollView.collectionView.register(whiteBoardCellClass,
                                                     forCellWithReuseIdentifier: whiteBoardCellIdf)
        
        view.collectionViewVideo.register(VideoCellRemote.self, forCellWithReuseIdentifier: videoCellIdfRemote)
        view.collectionViewVideo.register(VideoCellLocal.self, forCellWithReuseIdentifier: videoCellIdfLocal)
        
        
        view.collectionViewAudio.register(audioNib,
                                          forCellWithReuseIdentifier: audioCellIdf)
        view.videoScrollView.collectionView.register(VideoCellMiniLocal.self,
                                                     forCellWithReuseIdentifier: videoMiniIdfLocal)
        view.videoScrollView.collectionView.register(VideoCellMiniRemote.self,
                                                     forCellWithReuseIdentifier: videoMiniIdfRemote)
    }
}

extension MainRenderUIController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    fileprivate var whiteBoardCellIdf: String { "WhiteBoardCell" }
    fileprivate var videoCellIdfRemote: String { "VideoCellRemote" }
    fileprivate var videoCellIdfLocal: String { "VideoCellLocal" }
    fileprivate var audioCellIdf: String { "AudioCell" }
    fileprivate var videoMiniIdfLocal: String { "VideoCellMiniLocal" }
    fileprivate var videoMiniIdfRemote: String { "VideoCellMiniRemote" }

    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        if collectionView == view.videoScrollView.collectionView { return data.videoCellMiniInfos.count }
        if collectionView == view.collectionViewVideo { return data.videoCellInfos.count }
        return data.audioCellInfos.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == view.videoScrollView.collectionView { /** 底部列表 **/
            let info = data.videoCellMiniInfos[indexPath.row]
            switch info.type {
            case .video:
                let idf = info.isMe ? videoMiniIdfLocal : videoMiniIdfRemote
                let cell = collectionView
                    .dequeueReusableCell(withReuseIdentifier: idf,
                                         for: indexPath) as! VideoCellMini
                cell.config(info: info)
                return cell
            case .screen:
                let cell = collectionView
                    .dequeueReusableCell(withReuseIdentifier: videoMiniIdfRemote,
                                         for: indexPath) as! VideoCellMini
                cell.config(info: info)
                return cell
            case .board:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: whiteBoardCellIdf,
                                                              for: indexPath) as! WhiteBoardCell
                return cell
            }
        }
        
        if collectionView == view.collectionViewAudio { /** 语音平铺 **/
            let info = data.audioCellInfos[indexPath.row]
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: audioCellIdf,
                                                          for: indexPath) as! AudioCell
            cell.setImageName(info.headImageName,
                              name: info.name,
                              audioEnable: info.audioEnable)
            return cell
        }
        else { /** 视频平铺 **/
            let info = data.videoCellInfos[indexPath.row]
            let idf = info.isMe ? videoCellIdfLocal : videoCellIdfRemote
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: idf,
                                                          for: indexPath) as! VideoCell
            cell.config(info: info)
            cell.delegate = self
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        willDisplay cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        
        if view.collectionViewVideo == collectionView,
           let `cell` = cell as? VideoCell,
           let info = cell.info,
           info.hasVideo { /** 视频平铺 **/
            vm.subscriptVideo(streamId: info.streamId,
                              view: cell.videoView,
                              isHighStream: true)
            return
        }
        
        if view.videoScrollView.collectionView == collectionView,
           let `cell` = cell as? VideoCellMini,
           let info = cell.infoMini { /** 底部列表 **/
            switch info.type {
            case .video:
                if info.hasVideo {
                    vm.subscriptVideo(streamId: info.streamId,
                                      view: cell.videoView,
                                      isHighStream: false)
                }
                break
            case .screen:
                if !info.isMe {
                    vm.subscriptVideo(streamId: info.streamId,
                                      view: cell.videoView,
                                      isHighStream: false)
                }
                break
            default:
                break
            }
            return
        }
        
        if let cell = cell as? WhiteBoardCell {
            vm.renderBoardView(view: cell.boardView,
                               canWrite: false)
            return
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        didEndDisplaying cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        
        let userInteraction = (collectionView.isDragging || collectionView.isDecelerating || collectionView.isTracking)
        
        guard userInteraction else {
            return
        }
        
        if collectionView.indexPathsForVisibleItems.contains(indexPath) {
            return
        }
        
        if view.collectionViewVideo == collectionView,
           let `cell` = cell as? VideoCell,
           let info = cell.info { /** 视频平铺 **/
            vm.unSubscriptVideo(streamId: info.streamId)
            return
        }
        
        if let `cell` = cell as? VideoCellMini, let info = cell.infoMini { /** 底部列表 **/
            vm.unSubscriptVideo(streamId: info.streamId)
            return
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        if collectionView == view.collectionViewVideo,
           let cell = collectionView.cellForItem(at: indexPath) as? VideoCell,
           let renderId = cell.info?.differenceIdentifier {
            if !cell.info!.showHeadImage {
                vm.switchToLecturer(renderId: renderId)
            }
            return
        }
        
        if collectionView == view.videoScrollView.collectionView {
            if let cell = collectionView.cellForItem(at: indexPath) as? VideoCellMini,
               let renderId = cell.infoMini?.differenceIdentifier,
               !cell.infoMini!.showHeadImage { /// media or screenShare
                vm.setLecturerMain(renderId: renderId)
                return
            }
            
            if ((collectionView.cellForItem(at: indexPath) as? WhiteBoardCell) != nil) { /// board
                let info = data.videoCellMiniInfos[indexPath.row]
                vm.setLecturerMain(renderId: info.id)
            }
        }
    }
}

extension MainRenderUIController: UIScrollViewDelegate {
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [unowned self] in
            self.view.updatePage()
        }
    }
    
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [unowned self] in
            self.view.updatePage()
        }
    }
}
