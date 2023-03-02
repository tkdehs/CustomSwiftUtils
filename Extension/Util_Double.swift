//
//  Util_Double.swift
//  switchwon
//
//  Created by PNX on 2022/07/16.
//

import UIKit

extension Double {
    func decimalFroamt(max:Int = 2, min:Int = 2, roundMode:NumberFormatter.RoundingMode = .halfUp) -> String{
        
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = max
        formatter.minimumFractionDigits = min
        formatter.numberStyle = .decimal
        formatter.roundingMode = roundMode
        formatter.usesGroupingSeparator = true
        if let result = formatter.string(for: self) {
            return result
        } else {
            return ""
        }
    }
    
    func decimalFroamt(currency:Currency) -> String{
        self.decimalFroamt(max: currency.data.dotCount, min: currency.data.dotCount, roundMode: currency.data.rundMode)
    }
    
    /// 소수점 999 현상 떄문에 쓰는 대시멀
    var decimal : NSDecimalNumber {
        get {
            return NSDecimalNumber(value: self)
        }
    }
    
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
