//
//  Util_UITextField.swift
//  CodeAble
//
//  Created by sangdon kim on 2022/07/06.
//  Copyright © 2022 Switchwon. All rights reserved.
//

import UIKit

private var arrMaxLength : [UITextField: Int] = [:]

extension UITextField : UITextFieldDelegate {
	/// NonNull 텍스트 값
	var safeText : String { get {
		if let strText = self.text {
			return strText
		}
		return ""
		} }
	
	/// 텍스트 값 유무 여부
	var isExistText : Bool { get {
		if let strText = self.text, strText.length > 0 {
			return true
		}
		return false
		} }
    
    /// 텍스트 값 Empty 여부
    var isEmptyText : Bool { get {
        return self.isExistText.reverse
        } }
	
	/// 텍스트 길이
	var nLength : Int { get {
		if let strText = self.text {
			return strText.length
		}
		return 0
		} }
    
    /// double
    var doubleValue : Double { get {
        if let strText = self.text {
            return strText.doubleValue
        }
        return 0.0
        } }
    
    /// 최대 텍스트 길이
    @IBInspectable var nMaxLength : Int {
        get {
            if let nMaxLength = arrMaxLength[self] { return nMaxLength }
            return Int.max
        }
        set {
            arrMaxLength[self] = newValue
            self.addTarget(controlEvents: .editingChanged, action: {
                if let strText = self.text {
                    if strText.length > self.nMaxLength {
                        self.text = strText[0..<self.nMaxLength]
                    }
                }
            })
        }
    }
    
    /// 최대 텍스트 길이
    var isMaxLength: Bool { get { return self.nLength == self.nMaxLength } }
    
    /// 전화번호 필드 세팅
    func setPhoneNumberTextField() {
        /// 최대길이 수정
        self.nMaxLength = 13
        
        self.addTarget(controlEvents: .editingChanged, action: {
            guard var strText = self.text else { return }
			strText.convertPhoneNumberFormat()
			self.text = strText
        })
    }
    /// 전화번호 필드 세팅 이후 콜백
    func setPhoneNumberTextField(callback:@escaping (String)->Void) {
        /// 최대길이 수정
        self.nMaxLength = 13
        
        self.addTarget(controlEvents: .editingChanged, action: {
            guard var strText = self.text else { return }
            strText.convertPhoneNumberFormat()
            self.text = strText
            callback(strText)
        })
    }
	
    /// 키보드 완료 버튼 추가
    func addKeyboardCompleteButton (strTitle: String = "close".localized()) {
        let tbKeyboard = UIToolbar.init(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: 38))
        let barFlexible = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: self, action: #selector(resignFirstResponder))
        let barBtnDone = UIBarButtonItem.init(title: strTitle, style: UIBarButtonItem.Style.plain, target: self, action: #selector(resignFirstResponder))
        let attributes:[NSAttributedString.Key : Any] = [ .font : FONT_NOTOSANS_KR_REGULAR(16) ]
        barBtnDone.setTitleTextAttributes(attributes, for: .normal)
        tbKeyboard.items = [barFlexible,barBtnDone]
        self.inputAccessoryView = tbKeyboard
    }
    
    /// 데이터 클리어
    func clear() {
        self.text = nil
    }
}

/// 커스텀 인셋 텍스트필드
@IBDesignable class InsetUITextField : UITextField {
	@IBInspectable var cfTopMargin : CGFloat = 0
	@IBInspectable var cfLeftMargin : CGFloat = 0
	@IBInspectable var cfRightMargin : CGFloat = 0
	@IBInspectable var cfBottomMargin : CGFloat = 0
	
	/// 텍스트필드 인셋 마진 세팅
	///
	/// - Parameters:
	///   - cfTopMargin: 상단 마진
	///   - cfLeftMargin: 좌측 마진
	///   - cfRightMargin: 우측 마진
	///   - cfBottomMargin: 하단 마진
	func setInset ( cfTopMargin : CGFloat, cfLeftMargin : CGFloat, cfRightMargin : CGFloat , cfBottomMargin : CGFloat ) {
		self.cfTopMargin = cfTopMargin
		self.cfLeftMargin = cfLeftMargin
		self.cfRightMargin = cfRightMargin
		self.cfBottomMargin = cfBottomMargin
	}
	
	override func textRect(forBounds bounds: CGRect) -> CGRect {
		return bounds.inset(by: UIEdgeInsets.init(top: cfTopMargin, left: cfLeftMargin, bottom: cfBottomMargin, right: cfRightMargin))
	}
	
	override func editingRect(forBounds bounds: CGRect) -> CGRect {
		return textRect(forBounds:bounds)
	}
	override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
		return bounds.inset(by: UIEdgeInsets.init(top: cfTopMargin, left: cfLeftMargin, bottom: cfBottomMargin, right: cfRightMargin))
	}
}
