//
//  Util_Int.swift
//  CodeAble
//
//  Created by sangdon kim on 2022/07/06.
//  Copyright © 2022 Switchwon. All rights reserved.
//

import UIKit

extension Int {
    
    /// 홀수 여부
    var isOdd: Bool { get {
        if self % 2 == 0    { return false }
        else                { return true }
    } }
    
    /// Convert to Bool
    /// - Returns: Bool Value
    func convertBool() -> Bool {
        if self == 1 { return true }
        else         { return false }
    }
    
    /// 가격에 세자리마다 comma(,) 추가
    var strAddComma : String { get {
            let numPrice : NSNumber = NSNumber.init(value: self)
            let strPrice : NSString = NumberFormatter.localizedString(from: numPrice, number: NumberFormatter.Style.decimal) as NSString
            return strPrice as String
        } }
    
    /// 시/ 분/ 초
    var toHMS: (Int, Int, Int) { get {
        return (self / 3600, (self % 3600) / 60, (self % 3600) % 60)
    } }
    
    func requiredCount(count:Int) -> String {
        let amt = pow(10, count - 1)
        let result = NSDecimalNumber(decimal: amt)
        if Int(truncating: result) > self {
            var resultStr = ""
            (1...(count - 1)).forEach { _ in
                resultStr = resultStr + "0"
            }
            return "\(resultStr)\(self)"
        } else {
            return "\(self)"
        }
    }
    
}
