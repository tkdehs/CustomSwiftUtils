//
//  Util_UIImageView.swift
//  CodeAble
//
//  Created by sangdon kim on 2022/07/06.
//  Copyright © 2022 Switchwon. All rights reserved.
//

import UIKit
import SDWebImage // pod 'SDWebImage', '= 5.12.2'

extension UIImageView {
    
    /// 이미지 세팅
    /// - Parameters:
    ///   - strURL: 이미지 URL
    ///   - url: 이미지 URL
    func setImage(strURL: String? = nil, cfWidth: CGFloat? = nil, cfHeight: CGFloat? = nil ) {
        guard var strURL = strURL else {
            WLog("Set image fail : URL is missing")
            return
        }
        
        if let cfWidth = cfWidth, let cfHeight = cfHeight {
            strURL.append("?w=\(cfWidth)&h=\(cfHeight)")
        }
        
        guard let urlImage = URL.init(string: strURL) else {
            WLog("Set image fail : URL is missing")
            return
        }
        
        self.sd_setImage(with: urlImage,
                         placeholderImage: nil,
                         options: [.continueInBackground, .lowPriority, .retryFailed, .allowInvalidSSLCertificates],
                         completed: { (image, error, cacheType, url) in
                            if (cacheType == .disk || cacheType == .none) {
                                UIView.animate(withDuration: 0.5, animations: {
                                    UIView.setAnimationCurve(.linear)
                                })
                            }
        })
    }
    
    func setImage(strURL: String? = nil, defaultImg:UIImage? = nil ) {
        guard let strURL = strURL else {
            WLog("Set image fail : URL is missing")
            return
        }
        
        guard let urlImage = URL.init(string: strURL) else {
            WLog("Set image fail : URL is missing")
            return
        }
        
        self.sd_setImage(with: urlImage,
                         placeholderImage: defaultImg,
                         options: [.continueInBackground, .lowPriority, .retryFailed, .allowInvalidSSLCertificates],
                         completed: { (image, error, cacheType, url) in
                            if (cacheType == .disk || cacheType == .none) {
                                UIView.animate(withDuration: 0.5, animations: {
                                    UIView.setAnimationCurve(.linear)
                                })
                            }
        })
    }
    
    /// 로컬 이미지 세팅
    /// - Parameter strFileName: File name
    func setLocalImage(_ strFileName: String?, isDesinable: Bool = false, tintColor: UIColor? = nil) {
        guard let strFileName = strFileName else {
            WLog("Set local image fail : Image file name missing")
            self.image = nil
            return
        }
        
        if let imgLocal = UIImage.init(named: strFileName) {
            self.image = imgLocal
        } else if let asset : NSDataAsset = NSDataAsset.init(name: strFileName) {
            self.image = UIImage.sd_image(with: asset.data)
        } else {
            WLog("Set local image fail : Image file missing")
            self.image = nil
        }
        
        if let image = self.image, let tintColor = tintColor {
            self.image = image.withRenderingMode(.alwaysTemplate)
            self.tintColor = tintColor
        }
    }

}
