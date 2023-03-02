//
//  Util_UIView.swift
//  CodeAble
//
//  Created by sangdon kim on 2022/07/06.
//  Copyright © 2022 Switchwon. All rights reserved.
//

import UIKit
import SnapKit

extension UIView {
    
    /// 사이드 라인 타입
    enum SideLineType {
        case unknown            /// 타입 불명
        case all                /// 사이드 라인 All
        case top                /// 사이드 라인 Top
        case left               /// 사이드 라인 Left
        case right              /// 사이드 라인 Right
        case bottom             /// 사이드 라인 Bottom
        case topLeft            /// 사이드 라인 Top + Left
        case topRight           /// 사이드 라인 Top + Right
        case topBottom          /// 사이드 라인 Top + Bottom
        case leftRight          /// 사이드 라인 Left + Right
        case bottomLeft         /// 사이드 라인 Bottom + Left
        case bottomRight        /// 사이드 라인 Bottom + Right
        case topLeftRight       /// 사이드 라인 Top + Left + Right
        case topBottomLeft      /// 사이드 라인 Top + Bottom + Left
        case topBottomRight     /// 사이드 라인 Top + Bottom + Right
        case bottomLeftRight    /// 사이드 라인 Bottom + Left + Right
    }
    
    /// 라운드 코너 타입
    enum CornerType {
        case all                /// 모든 코너
        case up                 /// 상단 코너
        case down               /// 하단 코너
        case left               /// 좌측 코너
        case right              /// 우측 코너
        case upLeft             /// 좌측 상단 코너
        case upRight            /// 우측 상단 코너
        case downLeft           /// 좌측 하단 코너
        case downRight          /// 우측 하단 코너
        case upLeftAndDown      /// 좌측 상단 + 하단 코너
        case upRightAndDown     /// 우측 상단 + 하단 코너
        case downLeftAndUp      /// 좌측 하단 + 상단 코너
        case downRightAndUp     /// 우측 하단 + 상단 코너
        case upLeftAndDownRight /// 좌측 상단 + 우측 하단 코너
        case upRightAndDownLeft /// 우측 상단 + 좌측 하단 코너
    }
    
    var x : CGFloat                              { get { return self.frame.origin.x } }
    var y : CGFloat                              { get { return self.frame.origin.y } }
    func setX(value: CGFloat)                    { self.frame = CGRect.init(x: value, y: self.y, width: self.width, height: self.height) }
    func setY(value: CGFloat)                    { self.frame = CGRect.init(x: self.x, y: value, width: self.width, height: self.height) }
    func setXY(x: CGFloat, y: CGFloat)           { self.frame = CGRect.init(x: x, y: y, width: self.width, height: self.height) }
    
    var size: CGSize                             { get { return self.frame.size } }
    var width: CGFloat                           { get { return self.frame.size.width } }
    var height: CGFloat                          { get { return self.frame.size.height } }
    func setsize(value: CGSize)                  { self.frame = CGRect.init(x: self.x, y: self.y, width: value.width, height: value.height) }
	func setWidth(value: CGFloat) 	             { self.frame = CGRect.init(x: self.x, y: self.y, width: value, height: self.height) }
    func setHeight(value: CGFloat)	             { self.frame = CGRect.init(x: self.x, y: self.y, width: self.width, height: value) }
    func appendWidth(value: CGFloat)             { self.frame = CGRect.init(x: self.x, y: self.y, width: self.width + value, height: self.height) }
    func appendHeight(value: CGFloat)            { self.frame = CGRect.init(x: self.x, y: self.y, width: self.width, height: self.height + value) }
	
    var topY: CGFloat                            { get { return self.y }}
    var leftX: CGFloat                           { get { return self.x }}
    var rightX: CGFloat                          { get { return self.x + self.width }}
    var bottomY: CGFloat                         { get { return self.y + self.height }}
    func setTop(value: CGFloat)                  { self.frame = CGRect.init(x: self.x, y: value, width: self.width, height: self.height) }
    func setLeft(value: CGFloat)                 { self.frame = CGRect.init(x: value, y: self.y, width: self.width, height: self.height) }
    func setRight(value: CGFloat)                { self.frame = CGRect.init(x: value - self.width, y: self.y, width: self.width, height: self.height) }
    func setBottom(value: CGFloat)               { self.frame = CGRect.init(x: self.x, y: value - self.height, width: self.width, height: self.height) }
    
    func setFrame(x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat) { self.frame = CGRect.init(x: x, y: y, width: width, height: height) }
    
    /// 노출 여부 ( Reverse isHidden )
    var isShow: Bool                             { get { return self.isHidden.reverse } set { self.isHidden = newValue.reverse } }
    
    var globalPoint :CGPoint? {
        return self.superview?.convert(self.frame.origin, to: nil)
    }
    
    var globalFrame :CGRect? {
        return self.superview?.convert(self.frame, to: nil)
    }
	
    convenience init( cfX: CGFloat, cfY: CGFloat, cfWidth: CGFloat, cfHeight: CGFloat ) {
        let rect = CGRect.init(x: cfX, y: cfY, width: cfWidth, height: cfHeight)
        self.init(frame: rect)
    }
    
    convenience init( vBound: UIView ) {
        self.init(frame: vBound.bounds)
    }
	
	/// 서브뷰 클리어
	func removeAllSubview () {
        for vSub in self.subviews {
            /// Tag = 9981 : 불변 유지 태그
            if vSub.tag != 9981 {
                vSub.removeFromSuperview()
            }
        }
	}
    
    func remove8864View() {
        for vSub in self.subviews {
            /// Tag = 9981 : 불변 유지 태그
            if vSub.tag == 8864 {
                vSub.removeFromSuperview()
            }
        }
    }
	
	/// 보더라인 생성
	///
	/// - Parameters:
	///   - target: 타켓 뷰
	///   - colorHexString: 보더라인 컬러
	func makeBorderLine ( color: UIColor? = nil, cfBorderWidth: CGFloat = 1.0, cfRadius: CGFloat? = nil ) {
		self.layer.borderWidth = cfBorderWidth
		if let color = color {
			self.layer.borderColor = color.cgColor
		}
        
        if let cfRadius = cfRadius {
            self.layer.cornerRadius = cfRadius
        }
	}
    
    func makeBorderLine(color : UIColor = .gray, cfBorderWidth : CGFloat? = nil, cfCornerRadius : CGFloat? = nil, someSide : SideLineType = SideLineType.all ) {
        /// 기존 보더 라인 제거
        for subview:UIView in self.subviews {
            if subview.tag == 7749 { subview.removeFromSuperview() }
        }
        if let cfBorderWidth = cfBorderWidth {
            self.layer.borderWidth = cfBorderWidth
        }
        if let cfCornerRadius = cfCornerRadius {
            self.layer.cornerRadius = cfCornerRadius
        }
        
        /// 보더 라인 초기화
        let vBorderTop       = UIView()
        let vBorderLeft      = UIView()
        let vBorderRight     = UIView()
        let vBorderBottom    = UIView()
        
        vBorderTop.backgroundColor     = color;
        vBorderLeft.backgroundColor    = color;
        vBorderRight.backgroundColor   = color;
        vBorderBottom.backgroundColor  = color;
        
        vBorderTop.tag        = 7749
        vBorderLeft.tag       = 7749
        vBorderRight.tag      = 7749
        vBorderBottom.tag     = 7749
        
        self.addSubview(vBorderTop)
        self.addSubview(vBorderLeft)
        self.addSubview(vBorderRight)
        self.addSubview(vBorderBottom)
        
        vBorderTop.isHidden       = true
        vBorderLeft.isHidden      = true
        vBorderRight.isHidden     = true
        vBorderBottom.isHidden    = true
        
        if let cfBorderWidth = cfBorderWidth {
            vBorderTop.snp.makeConstraints { (make) in
                make.top.left.right.equalTo(self)
                make.height.equalTo(cfBorderWidth)
            }
            vBorderLeft.snp.makeConstraints { (make) in
                make.top.bottom.left.equalTo(self)
                make.width.equalTo(cfBorderWidth)
            }
            vBorderRight.snp.makeConstraints { (make) in
                make.top.bottom.right.equalTo(self)
                make.width.equalTo(cfBorderWidth)
            }
            vBorderBottom.snp.makeConstraints { (make) in
                make.bottom.left.right.equalTo(self)
                make.height.equalTo(cfBorderWidth)
            }
            
            switch (someSide) {
            case .unknown:    break         // 타입 불명
            case .all:                     // 모든 사이드 라인
                vBorderTop.isHidden        = false
                vBorderLeft.isHidden       = false
                vBorderRight.isHidden      = false
                vBorderBottom.isHidden     = false
            case .top:                     // 사이드 라인 Top
                vBorderTop.isHidden        = false
            case .left:                    // 사이드 라인 Left
                vBorderLeft.isHidden       = false
            case .right:                   // 사이드 라인 Right
                vBorderRight.isHidden      = false
            case .bottom:                  // 사이드 라인 Bottom
                vBorderBottom.isHidden     = false
            case .topLeft:                 // 사이드 라인 Top + Left
                vBorderTop.isHidden        = false
                vBorderLeft.isHidden       = false
            case .topRight:                // 사이드 라인 Top + Right
                vBorderTop.isHidden        = false
                vBorderRight.isHidden      = false
            case .leftRight:               // 사이드 라인 Left + Right
                vBorderLeft.isHidden       = false
                vBorderRight.isHidden      = false
            case .topBottom:               // 사이드 라인 Top + Bottom
                vBorderTop.isHidden        = false
                vBorderBottom.isHidden     = false
            case .bottomLeft:              // 사이드 라인 Bottom + Left
                vBorderBottom.isHidden     = false
                vBorderLeft.isHidden       = false
            case .bottomRight:             // 사이드 라인 Bottom + Right
                vBorderBottom.isHidden     = false
                vBorderRight.isHidden      = false
            case .topLeftRight:            // 사이드 라인 Top + Left + Right
                vBorderTop.isHidden        = false
                vBorderLeft.isHidden       = false
                vBorderRight.isHidden      = false
            case .topBottomLeft:           // 사이드 라인 Top + Bottom + Left
                vBorderTop.isHidden        = false
                vBorderBottom.isHidden     = false
                vBorderLeft.isHidden       = false
            case .topBottomRight:          // 사이드 라인 Top + Bottom + Right
                vBorderTop.isHidden        = false
                vBorderBottom.isHidden     = false
                vBorderRight.isHidden      = false
            case .bottomLeftRight:         // 사이드 라인 Bottom + Left + Right
                vBorderBottom.isHidden     = false
                vBorderLeft.isHidden       = false
                vBorderRight.isHidden      = false
            }
        }
    }
    
    /// 사이드 풀 라운드 처리
    func makeRoundSideFull() {
        self.layer.cornerRadius = self.height / 2
    }
    
    /// 라운드 처리
    ///
    /// - Parameter cfRadius: 라운드 값
    func makeRound ( cfRadius : CGFloat = 8.0, cornerType: CornerType = .all ) {
        if cornerType == .all {
            self.layer.cornerRadius = cfRadius
            return
        }
        
        /// 베지어 패스 및 레이어 구성
        var rectCorner: UIRectCorner = UIRectCorner()
        
        switch cornerType {
        case .all: break
        case .up:
            rectCorner = [.topLeft, .topRight]
        case .down:
            rectCorner = [.bottomLeft, .bottomRight]
        case .left:
            rectCorner = [.topLeft, .bottomLeft]
        case .right:
            rectCorner = [.topRight, .bottomRight]
        case .upLeft:
            rectCorner = [.topLeft]
        case .upRight:
            rectCorner = [.topRight]
        case .downLeft:
            rectCorner = [.bottomLeft]
        case .downRight:
            rectCorner = [.bottomRight]
        case .upLeftAndDown:
            rectCorner = [.topLeft, .bottomLeft, .bottomRight]
        case .upRightAndDown:
            rectCorner = [.topRight, .bottomLeft, .bottomRight]
        case .downLeftAndUp:
            rectCorner = [.topLeft, .topRight, .bottomLeft]
        case .downRightAndUp:
            rectCorner = [.topLeft, .topRight, .bottomRight]
        case .upLeftAndDownRight:
            rectCorner = [.topLeft, .bottomRight]
        case .upRightAndDownLeft:
            rectCorner = [.topRight, .bottomLeft]
        }
        
        let maskPath: UIBezierPath = UIBezierPath.init(roundedRect: self.bounds, byRoundingCorners: rectCorner, cornerRadii: CGSize.init(width: cfRadius, height: cfRadius))
        let maskLayer: CAShapeLayer = CAShapeLayer.init()
        maskLayer.path = maskPath.cgPath
        self.layer.mask = maskLayer
    }
    
    /// 그림자 생성
    func makeShadow(color : UIColor = UIColor.black, opacity : Float = 0.1, radius : CGFloat = 16, offsetX : CGFloat = 0, offsetY : CGFloat = 0 ) {
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = opacity
        self.layer.shadowRadius = radius
        self.layer.shadowOffset.width = offsetX
        self.layer.shadowOffset.height = offsetY
    }
    
    /// 백그라운드 랜덤 세팅
    func setBackgroundRandom () {
        self.backgroundColor = COLOR_RANDOM
    }

    /// 부분 모서리 라운드처리
    func roundCorners(cfRadius : CGFloat = 20.0) {
        if #available(iOS 11.0, *) {
            self.layer.cornerRadius = cfRadius
            self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            self.clipsToBounds = true
        } else {
            let roundCornerPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: [.topRight, .topLeft], cornerRadii: CGSize(width: cfRadius, height: cfRadius))

            let maskLayer = CAShapeLayer()
            maskLayer.path = roundCornerPath.cgPath
            self.layer.mask = maskLayer
        }
    }
    
    func loadFromNib(xib:AnyClass) -> UIView {
        let identifier = String(describing: xib)
        let view: UIView = Bundle(for: xib).loadNibNamed(identifier, owner: self, options: nil)!.first as! UIView
        return view
    }
}
