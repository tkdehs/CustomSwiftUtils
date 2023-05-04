//
//  Util_Decimal.swift
//  switchwon
//
//  Created by PNX on 2023/03/03.
//

import Foundation

extension Decimal {
    var convertDouble:Double { get { Double(truncating: self as NSNumber) } }
    var convertNSNumber:NSNumber{ get { NSDecimalNumber(decimal: self) } }
    
    func decimalFormat(max:Int = 2, min:Int = 2, roundMode:NumberFormatter.RoundingMode = .halfUp) -> String{
        
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
    
    func round(count:Int = 0, roundMode:NumberFormatter.RoundingMode = .halfUp) -> Decimal{
        
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = count
        formatter.minimumFractionDigits = count
        formatter.roundingMode = roundMode
        
        if let str = formatter.string(for: self) {
            let trimmedString = str.trimmingCharacters(in: .whitespacesAndNewlines)
            return Decimal(string: trimmedString) ?? 0
        } else {
            return 0
        }
    }
}
