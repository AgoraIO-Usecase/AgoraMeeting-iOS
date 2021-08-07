//
//  MainRenderEventScheduler+Info.swift
//  AgoraMeetingUI
//
//  Created by ZYP on 2021/6/11.
//

import Foundation
import DifferenceKit
import AgoraMeetingContext

extension MainRenderEventScheduler {
    class SortItem {
        let id: String
        var userOperation: UserOpration = .none
        private var operationTime: TimeInterval = 0.0
        
        init(id: String) {
            self.id = id
        }
        
        init(item: SortItem) {
            self.id = item.id
            self.userOperation = item.userOperation
            self.operationTime = item.operationTime
        }
        
        func setUserOpration(userOperation: UserOpration,
                             special: Special? = nil) {
            switch userOperation {
            case .none:/// when new add
                operationTime =  special?.value ?? Date().timeIntervalSince1970
                self.userOperation = userOperation
            case .down,
                 .up:
                operationTime = special?.value ?? Date().timeIntervalSince1970
                self.userOperation = userOperation
            }
        }
        
        var value: TimeInterval {
            switch userOperation {
            case .none:
                return -1 * operationTime
            case .up:
                return operationTime
            case .down:
                return -1 * operationTime
            }
        }
        
        enum UserOpration {
            case none
            case up
            case down
        }
        
        enum Special {
            case initForHost
            case initForMe
            
            var value: TimeInterval {
                switch self {
                case .initForHost:
                    return 1
                case .initForMe:
                    return 2
                }
            }
        }
    }
}

