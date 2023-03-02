//
//  Util_UIButton.swift
//  CodeAble
//
//  Created by sangdon kim on 2022/07/06.
//  Copyright © 2022 Switchwon. All rights reserved.
//

import UIKit

extension UIButton {
    
    /// 버튼 타이틀 라벨 세팅
	func setTitleLabel ( text: String? = "", font: UIFont? = nil, color: UIColor? = nil, alignment: NSTextAlignment = .left, lineCount: Int = 0 ) {
        if let text = text { self.setTitle(text, for: .normal) }
        if let color = color { self.setTitleColor(color, for: .normal) }
		self.titleLabel?.setLabel(text: text, font: font, color: color, alignment: alignment, nLineCount: lineCount)
	}
    
    /// 버튼 이미지 세팅
    func setImage(strLocalImageName: String?) {
        guard let strLocalImageName = strLocalImageName else {
            self.setImage(nil, for: .normal)
            return
        }
        
        if let image = UIImage.init(named: strLocalImageName) {
            self.setImage(image, for: .normal)
        } else {
            self.setImage(nil, for: .normal)
        }
    }
    
    func setBackgroundColor(_ color: UIColor, for state: UIControl.State) {
        self.clipsToBounds = true
        let rect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()

        context?.setFillColor(color.cgColor)
        context?.fill(rect)

        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
         
         
        self.setBackgroundImage(image, for: state)
    }
    
}

extension UIControl {
	
	/// 타겟 추가
	///
	/// - Parameters:
	///   - controlEvents: 컨트롤 이벤트
	///   - action: 액션
	func addTarget (controlEvents: UIControl.Event = .touchUpInside, action: @escaping ()->()) {
		let sleeve = ClosureSleeve(action)
		addTarget(sleeve, action: #selector(ClosureSleeve.invoke), for: controlEvents)
		objc_setAssociatedObject(self, String(format: "[%d]", arc4random()), sleeve, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
	}
    
    class ClosureSleeve {
        let closure: ()->()
        
        init (_ closure: @escaping ()->()) {
            self.closure = closure
        }
        
        @objc func invoke () {
            closure()
        }
    }
}
