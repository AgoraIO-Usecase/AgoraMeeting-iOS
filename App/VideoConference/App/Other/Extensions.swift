//
//  extensions.swift
//  VideoConference
//
//  Created by ZYP on 2021/5/26.
//  Copyright © 2021 agora. All rights reserved.
//

import UIKit
import CommonCrypto

extension String {
    func md5() -> String {
        let utf8 = cString(using: .utf8)
        var digest = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
        CC_MD5(utf8, CC_LONG(utf8!.count - 1), &digest)
        return digest.reduce("") { $0 + String(format:"%02X", $1) }.lowercased()
    }
}

extension UIColor {
    convenience public init(hex: UInt) {
        let r = CGFloat((hex & 0x00FF_0000) >> 16) / 255.0
        let g = CGFloat((hex & 0x0000_FF00) >> 8) / 255.0
        let b = CGFloat((hex & 0x0000_00FF) >> 0) / 255.0
        self.init(red: r, green: g, blue: b, alpha: 1)
    }
}
