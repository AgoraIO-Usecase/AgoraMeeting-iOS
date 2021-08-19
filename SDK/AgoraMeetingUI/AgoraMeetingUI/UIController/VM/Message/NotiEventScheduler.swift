//
//  NotiEventScheduler.swift
//  AgoraMeetingUI
//
//  Created by ZYP on 2021/6/22.
//

import Foundation
import AgoraMeetingContext

protocol NotiSchedulerEventHandle: NSObject {
    func onNotiInfosChange(infos: [NotiEventScheduler.Info])
}

protocol NotiEventSchedulerDelegate: NSObject {
    func notiEventSchedulerShouldGoToSetUIManager()
    func notiEventSchedulerDidGetRecordFiles(recordFiles: [RecordFile])
}

class NotiEventScheduler: NSObject {
    private let obs = NSMapTable<AnyObject, AnyObject>.weakToWeakObjects()
    private var infos = [Info]()
    private var successQueue = [MessageId]()
    private let queue = DispatchQueue(label: "NotiEventScheduler.queue")
    private let timer: MeetingTimeSource
    private var includeCalculatedTimeType = false
    private let messageContext: MessagesContext
    weak var delegate: NotiEventSchedulerDelegate?
    
    init(messageContext: MessagesContext) {
        self.timer = MeetingTimeSource(interval: .seconds(1),
                                       repeats: true,
                                       queue: queue)
        self.messageContext = messageContext
        super.init()
        commonInit()
    }
    
    deinit {
        Log.info(text: "NotiEventScheduler",
                 tag: "deinit")
    }
    
    private func commonInit() {
        timer.delegate = self
        timer.start()
    }
    
    func registerEventHandler(_ observer: NotiSchedulerEventHandle) {
        obs.setObject(observer, forKey: observer)
    }
    
    func unregisterEventHandler(_ observer: NotiSchedulerEventHandle) {
        obs.removeObject(forKey: observer)
    }
    
    func setNotis(notis: [NotifyMessage]) {
        queue.async { [weak self] in
            self?.setNotisInternal(notis: notis)
        }
    }
    
    func setNotisInternal(notis: [NotifyMessage]) {
        let count = notis.count
        let infoCount = infos.count
        if count > infoCount {
            let adds = notis[infoCount...count-1].map({ $0 })
            addNotis(notis: adds)
        }
    }
    
    fileprivate func getObs() -> [NotiSchedulerEventHandle] {
        guard let enumerator = obs.objectEnumerator() else {
            return []
        }
        let obArray = enumerator.compactMap({ $0 as? NotiSchedulerEventHandle })
        return obArray
    }
    
    func addNotis(notis: [NotifyMessage]) {
        let temp = configShowTime(messages: notis)
        infos.append(contentsOf: temp)
    }
    
    func dealNotifyMessageEvent(messageId: MessageId,
                                success: @escaping VoidBlock,
                                fail: @escaping FailBlock) {
        let info = infos[messageId]
        
        if info.type == .recordClose, let payload = info.payload as? NotifyMessage.PayloadRecord {
            requestGetRecordFile(recordId: payload.recordId)
            return
        }
        
        if info.type == .sysPermissionCamDenied
            || info.type == .sysPermissionMicDenied {
            showSystemSetting()
            return
        }
        
        if info.type == .notifyInOutClosed ||
           info.type == .notifyInOutOverMaxLimit {
            invokeShouldGoToSetUIManager()
            return
        }
        
        messageContext.dealNotifyMessageEvent(messageId: messageId,
                                              success: { [weak self] in
                                                self?.successQueue.append(messageId)
                                                success()
                                              },
                                              fail: fail)
    }
    
    private func updateExtern() {
        let needCalculatedTime = infos.contains(where: { $0.type.isCalculatedTimeType && $0.count > 0 })
        if !needCalculatedTime { includeCalculatedTimeType = false  }
        if needCalculatedTime { calculatedTime() }
        if successQueue.count > 0 { configResult() }
        invokeOnNotiInfosChange(infos: infos)
    }
    
    private func calculatedTime() {
        let count = infos.count
        for i in 0..<count {
            infos[i].updateForCount()
        }
    }
    
    private func configResult() {
        for i in successQueue {
            infos[i].updateForSuccess()
        }
        successQueue.removeAll()
    }
    
    private func configShowTime(messages: [NotifyMessage]) -> [Info] {
        var lastTime = infos.last?.timestamp ?? 0
        var temp = [Info]()
        for msg in messages {
            let showTime = msg.timestamp - lastTime > 60
            let info = Info(noti: msg,
                            showTime: showTime)
            temp.append(info)
            lastTime = msg.timestamp
        }
        return temp
    }
    
    private func showSystemSetting() {
        guard let url = URL(string: UIApplication.openSettingsURLString) else {
            return
        }
        
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
    private func requestGetRecordFile(recordId: String) {
        invokeShouldGoToRecordReplayPage(recordFiles: [])
    }
}

extension NotiEventScheduler {
    func invokeOnNotiInfosChange(infos: [NotiEventScheduler.Info]) {
        let obs = self.getObs()
        queue.async {
            for ob in obs {
                ob.onNotiInfosChange(infos: infos)
            }
        }
    }
    
    func invokeShouldGoToSetUIManager() {
        if Thread.isMainThread {
            delegate?.notiEventSchedulerShouldGoToSetUIManager()
            return
        }
        
        DispatchQueue.main.sync { [weak self]() in
            self?.delegate?.notiEventSchedulerShouldGoToSetUIManager()
        }
    }
    
    func invokeShouldGoToRecordReplayPage(recordFiles: [RecordFile]) {
        if Thread.isMainThread {
            delegate?.notiEventSchedulerDidGetRecordFiles(recordFiles: recordFiles)
            return
        }
        
        DispatchQueue.main.sync { [weak self]() in
            self?.delegate?.notiEventSchedulerDidGetRecordFiles(recordFiles: recordFiles)
        }
    }
}

extension NotifyMessageType {
    var isCalculatedTimeType: Bool {
        return self == .userApproveApplyCam || self == .userApproveApplyMic
    }
}

extension NotiEventScheduler: MeetingTimeSourceDelegate {
    func meetingTimeSourceTimeDidCome() {
        updateExtern()
    }
}
