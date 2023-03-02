//
//  Util_CGFloat.swift
//  CodeAble
//
//  Created by sangdon kim on 2022/07/06.
//  Copyright © 2022 Switchwon. All rights reserved.
//
import UIKit

extension CGFloat {
    
    /// 값 증가
    /// - Parameter cfValue: 증가값
    mutating func append( _ cfValue : CGFloat ) {
        self = self + cfValue
    }
    
    /// 값 증가
    /// - Parameter cfValue: 증가값
    mutating func append( _ arrValue : CGFloat... ) {
        for value in arrValue {
            self = self + value
        }
    }
}
