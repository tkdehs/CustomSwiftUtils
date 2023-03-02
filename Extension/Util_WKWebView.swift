//
//  Util_WKWebView.swift
//  HowMuchToday
//
//  Created by sangdon kim on 2022/07/06.
//  Copyright © 2022 Switchwon. All rights reserved.
//

import UIKit
import WebKit
import SnapKit

extension WKWebView {
    func setWebViewProgressive( cfProgress: CGFloat ) {
        for subview in self.subviews {
            if subview.tag == 7749 {
                subview.removeFromSuperview()
            }
        }
        
        let vProgressBar = UIView.init(cfX: 0, cfY: 0, cfWidth: self.width, cfHeight: 3)
        vProgressBar.tag = 7749
        vProgressBar.backgroundColor = COLOR_PimaryDark
        self.addSubview(vProgressBar)

        vProgressBar.snp.makeConstraints{ (make) in
            make.top.left.equalToSuperview()
            make.width.equalTo(self.width * cfProgress)
            make.height.equalTo(3)
        }
        
        if cfProgress == 1.0 {
            UIView.animate(withDuration: 0.33, animations: {
                vProgressBar.alpha = 0.0
            })
        }
    }
}

extension WKWebView {
    func load(_ strUrl:String){
        if let url = URL (string: strUrl) { // 웹뷰 로드 주소
            let request = URLRequest(url: url as URL)
            self.load(request)
        }
    }
}

