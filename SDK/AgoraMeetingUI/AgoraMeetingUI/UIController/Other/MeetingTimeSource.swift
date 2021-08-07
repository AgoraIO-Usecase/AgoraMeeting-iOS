//
//  TimeSource.swift
//  AgoraMeetingUI
//
//  Created by ZYP on 2021/6/11.
//

import Foundation
protocol MeetingTimeSourceDelegate: NSObject {
    func meetingTimeSourceTimeDidCome()
}

class MeetingTimeSource {
    weak var delegate: MeetingTimeSourceDelegate?
    private let internalTimer: DispatchSourceTimer
    private var isRunning = false
    
    init(interval: DispatchTimeInterval,
         repeats: Bool = false,
         leeway: DispatchTimeInterval = .seconds(0),
         queue: DispatchQueue = .init(label: "MeetingTimeSource.queue")) {
        internalTimer = DispatchSource.makeTimerSource(queue: queue)
        internalTimer.setEventHandler { [weak self] in
            if let strongSelf = self {
                strongSelf.delegate?.meetingTimeSourceTimeDidCome()
            }
        }
        
        if repeats {
            internalTimer.schedule(deadline: .now() + interval, repeating: interval, leeway: leeway)
        } else {
            internalTimer.schedule(deadline: .now() + interval, leeway: leeway)
        }
    }
    
    deinit {
        if !self.isRunning {
            internalTimer.resume()
        }
    }
    
    func start() {
        if !isRunning {
            internalTimer.resume()
            isRunning = true
        }
    }
    
    func suspend() {
        if isRunning {
            internalTimer.suspend()
            isRunning = false
        }
    }
}
