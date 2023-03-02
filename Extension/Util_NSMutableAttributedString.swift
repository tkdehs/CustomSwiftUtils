//
//  Util_ NSMutableAttributedString.swift
//  CodeAble
//
//  Created by Ahngunism on 2022/01/17.
//  Copyright © 2022 OKPOS. All rights reserved.
//

import UIKit

extension NSMutableAttributedString {
    
    var fontSize:CGFloat { return 14 }
    var boldFont:UIFont { return FONT_NOTOSANS_KR_BOLD(fontSize) }
    var normalFont:UIFont { return FONT_NOTOSANS_KR_REGULAR(fontSize)}
    
    func bold(_ value:String) -> NSMutableAttributedString {
        
        let attributes:[NSAttributedString.Key : Any] = [
            .font : boldFont
        ]
        
        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }
    
    func normal(_ value:String) -> NSMutableAttributedString {
        
        let attributes:[NSAttributedString.Key : Any] = [
            .font : normalFont,
        ]
        // 추가
        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }
    /// 일반 텍스트 추가
    /// - Parameters:
    ///   - strOri: 원문 텍스트
    ///   - size: 사이즈
    ///   - color: 컬러
    func appendNormalText(_ strOri: String, size: CGFloat = 14, color: UIColor? = nil) -> NSMutableAttributedString {
        var attributes:[NSAttributedString.Key : Any] = [ .font : FONT_NOTOSANS_KR_REGULAR(size) ]
        if let color = color { attributes[.foregroundColor] = color }
        self.append(NSAttributedString(string: strOri, attributes:attributes))
        return self
    }
    
    /// 볼드 텍스트 추가
    /// - Parameters:
    ///   - strOri: 원문 텍스트
    ///   - size: 사이즈
    ///   - color: 컬러
    func appendBoldText(_ strOri: String, size: CGFloat = 14, color: UIColor? = nil) -> NSMutableAttributedString {
        var attributes:[NSAttributedString.Key : Any] = [ .font : FONT_NOTOSANS_KR_BOLD(size) ]
        if let color = color { attributes[.foregroundColor] = color }
        self.append(NSAttributedString(string: strOri, attributes:attributes))
        return self
    }
    
    /// 하이라이트 텍스트 추가
    /// - Parameters:
    ///   - strOri: 원문 텍스트
    ///   - size: 사이즈
    func appendHighlightedText(_ strOri: String, size: CGFloat = 14) -> NSMutableAttributedString {
        let attributes:[NSAttributedString.Key : Any] = [
            .font : UIFont.systemFont(ofSize: size),
            .foregroundColor : UIColor.white,
            .backgroundColor : UIColor.orange
        ]
        
        self.append(NSAttributedString(string: strOri, attributes:attributes))
        return self
    }
    
    /// 밑줄 텍스트 추가
    /// - Parameters:
    ///   - strOri: 원문 텍스트
    ///   - size: 사이즈
    func appendUnderlinedText(_ strOri: String, size: CGFloat = 14) -> NSMutableAttributedString {
        let attributes:[NSAttributedString.Key : Any] = [
            .font :  UIFont.systemFont(ofSize: size),
            .underlineStyle : NSUnderlineStyle.single.rawValue
        ]
        
        self.append(NSAttributedString(string: strOri, attributes:attributes))
        return self
    }
    
}
