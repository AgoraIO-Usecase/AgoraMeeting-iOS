//
//  MainRenderEventScheduler+Handle.swift
//  AgoraMeetingUI
//
//  Created by ZYP on 2021/6/11.
//

import Foundation
import AgoraMeetingContext
import DifferenceKit

extension MainRenderEventScheduler {
    func createUpdate(layout: RenderLayout,
                      renderInfoList: [RenderInfo]) -> MainRenderVM.UpdateInfo? {
        switch layout {
        case .audio:
            let audioCellInfos = renderInfoList.map({ (render) -> AudioCellInfo in
                let id = render.id
                let name = render.userInfo.userName
                let headImageName = String.headImageName(userName: name.md5())
                let audioEnable = render.hasAudio
                let userId = render.userInfo.userId
                return AudioCellInfo(id: id,
                                     headImageName: headImageName,
                                     name: name,
                                     audioEnable: audioEnable,
                                     userId: userId)
            })
            let info = UpdateInfo(videoCellInfos: [],
                                  audioCellInfos: audioCellInfos,
                                  videoCellMiniInfos: [],
                                  mode: .audioFlow,
                                  speakerInfo: nil,
                                  showRightButton: false,
                                  selectedInfo: nil)
            return info
        case .tile:
            let sortCached = sortItems
            var videoCellInfos = [VideoCellInfo]()
            for render in renderInfoList {
                let id = render.id
                let isHost = render.userInfo.userRole == .host
                let name = render.userInfo.userName
                let headImageName = String.headImageName(userName: name.md5())
                let userId = render.userInfo.userId
                let enableAudio = render.hasAudio
                let userOperation = sortCached[id]?.userOperation
                let isUp = (userOperation == nil) ? false : userOperation! == .up
                let showMeunButton = render.options.count > 0
                let showHeadImage = !render.hasVideo
                let streamId = render.streamId
                let sheetInfos = render.options.toSheetInfos
                let isMe = render.isMe
                let info = VideoCellInfo(id: id,
                                         isHost: isHost,
                                         enableAudio: enableAudio,
                                         name: name,
                                         isUp: isUp,
                                         showMeunButton: showMeunButton,
                                         headImageName: headImageName,
                                         showHeadImage: showHeadImage,
                                         isMe: isMe,
                                         streamId: streamId,
                                         sheetInfos: sheetInfos,
                                         userId: userId)
                videoCellInfos.append(info)
            }
            let info = UpdateInfo(videoCellInfos: videoCellInfos,
                                  audioCellInfos: [],
                                  videoCellMiniInfos: [],
                                  mode: .videoFlow,
                                  speakerInfo: nil,
                                  showRightButton: false,
                                  selectedInfo: nil)
            return info
        case .lecturer:
            guard let selectedInfo = renderInfoList.filter({ $0.id == selectedId }).first else {
                return nil
            }
            let hasShareType = renderInfoList.contains(where: { $0.type != .media })
            let videoCellMiniInfos = renderInfoList.map { (render) -> VideoCellMiniInfo in
                let id = render.id
                let isHost = render.userInfo.userRole == .host
                let name = render.userInfo.userName
                let headImageName = String.headImageName(userName: name.md5())
                let userId = render.userInfo.userId
                let enableAudio = render.hasAudio
                let showHeadImage = !render.hasVideo
                let hasDisplayInMainScreen = selectedId == id
                let type = render.type.cellMiniInfoType
                let isMe = render.isMe
                let streamId = render.streamId
                let board = VideoCellMiniInfo.boardInfo(id: "", token: "")
                return VideoCellMiniInfo(id: id,
                                         isHost: isHost,
                                         enableAudio: enableAudio,
                                         name: name,
                                         headImageName: headImageName,
                                         showHeadImage: showHeadImage,
                                         hasDisplayInMainScreen: hasDisplayInMainScreen,
                                         type: type,
                                         isMe: isMe,
                                         streamId: streamId,
                                         userId: userId,
                                         board: board)
            }.filter({ $0.id != selectedId })
            
            let speakerInfo = SpeakerModel()
            speakerInfo.hasAudio = selectedInfo.hasAudio
            speakerInfo.isHost = selectedInfo.userInfo.userRole == .host
            speakerInfo.isLocalUser = selectedInfo.isMe
            speakerInfo.name = selectedInfo.userInfo.userName
            speakerInfo.type = selectedInfo.type.speakType
            
            let info = UpdateInfo(videoCellInfos: [],
                                  audioCellInfos: [],
                                  videoCellMiniInfos: videoCellMiniInfos,
                                  mode: .speaker,
                                  speakerInfo: speakerInfo,
                                  showRightButton: !hasShareType,
                                  selectedInfo: selectedInfo)
            return info
        }
    }
    
    func handleSort(newRenders: [RenderInfo]) {
        let current = sortItems
        let isFirst = current.count == 0
        var temp = [String : SortItem]()
        
        if isFirst { /** first **/
            for render in newRenders {
                let isMe = render.isMe
                let isHost = render.userInfo.userRole == .host
                let userOperation: SortItem.UserOpration = (isHost || isMe) ? .up : .none
                var special: SortItem.Special? = nil
                if userOperation == .up {
                    special = isHost ? .initForHost : .initForMe
                }
                let sortItem = SortItem(id: render.id)
                sortItem.setUserOpration(userOperation: userOperation,
                                         special: special)
                temp[render.id] = sortItem
            }
            sortItems = temp
            return
        }
        
        /** not first **/
        for render in newRenders {
            if let oldItem = current[render.id] {
                let sortItem = SortItem(item: oldItem)
                temp[render.id] = sortItem
                continue
            }
            let sortItem = SortItem(id: render.id)
            sortItem.setUserOpration(userOperation: .none)
            temp[render.id] = sortItem
        }
        sortItems = temp
    }
    
    func sort(_ lsh: RenderInfo,
              _ rsh: RenderInfo) -> Bool {
        return (sortItems[lsh.id]?.value ?? 0) > (sortItems[rsh.id]?.value ?? 0)
    }
}
