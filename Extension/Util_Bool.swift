//
//  Util_Bool.swift
//  CodeAble
//
//  Created by sangdon kim on 2022/07/06.
//  Copyright © 2022 Switchwon. All rights reserved.
//

extension Bool {
	/// Bool 값의 반대값
	var reverse : Bool { get { return !self } }
    
    var toInt : Int { get { return self ? 1 : 0 } }
    
    /// Bool 값의 반대값 세팅
    mutating func reversed() {
        self = self.reverse
    }
}
;
