//
//  MeetingServerApi.swift
//  VideoConference
//
//  Created by ZYP on 2021/7/14.
//  Copyright © 2021 agora. All rights reserved.
//

import Foundation


class MeetingServerApi {
    typealias SuccessBlockVoid = () -> ()
    static var host = ""
    
    struct HttpResp<DATA: Decodable>: Decodable {
        let code: Int
        let msg: String
        let data: DATA
    }
    
    struct HttpDataUpdate: Decodable {
        /// 是否强制更新 0 不更新 1推荐更新 2强制更新
        let forcedUpgrade: Int?
        
        enum Upgrade: Int, Decodable {
            case noNeed = 0
            case shouldUpgrade = 1
            case mustUpgrade = 2
        }
        
        var upGradeType: Upgrade? {
            return (forcedUpgrade != nil) ? Upgrade(rawValue: forcedUpgrade!) : nil
        }
    }
    
    static func checkUpdate(appVersion: String,
                            shouldUpdate: @escaping SuccessBlockVoid) {
        
        if MeetingServerApi.host.count == 0 {
            fatalError("host should be not empty, please set it")
        }
        
        let url = URL(string: MeetingServerApi.host + "/scenario/meeting/v2/appVersion?osType=1&terminalType=1&appVersion=\(appVersion)")!
        var request = URLRequest(url: url)
        request.addValue("Authorization",
                         forHTTPHeaderField: "Basic OGJmMzUzMzM1MjA2NDg1NThhZDFiNzM2Y2ZhNWQyZjE6NzQ1NDIxYzgxYWJiNGFjOWExZmM3YzdlNTBlOTE5OTk=")
        print(url.absoluteString)
        let task = URLSession.shared.dataTask(with: request) { (data, resp, error) in
            if error != nil { return }
            let decoder = JSONDecoder()
            do {
                let resp = try decoder.decode(HttpResp<HttpDataUpdate>.self,
                                              from: data!)
                guard let type = resp.data.upGradeType else {
                    return
                }
                
                if type != .noNeed {
                    DispatchQueue.main.async {
                        shouldUpdate()
                    }
                }
            }
            catch let e {
                print(e)
            }
        }
        task.resume()
    }
    
}
