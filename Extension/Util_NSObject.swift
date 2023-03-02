//
//  Util_NSObject.swift
//  CodeAble
//
//  Created by sangdon kim on 2022/07/06.
//  Copyright © 2022 Switchwon. All rights reserved.
//

import UIKit

extension NSObject {
    /// 클래스명
    var className : String { get { return String(describing: type(of: self)) } }
    static var identifier:String {
        get {
            return String(describing: self)
        }
    }
}
