//
//  Util.swift
//  switchwon
//
//  Created by sangdon kim on 2022/07/06.
//  Copyright © 2022 Switchwon. All rights reserved.
//

import UIKit
import Photos
import SafariServices
import SystemConfiguration
import AppTrackingTransparency
import AdSupport

class Util: NSObject {
    
    //============================================================
    // MARK: - Process Util
    //============================================================
    
    /// 딜레이 액션
    ///
    /// - Parameters:
    ///   - dDelay: 딜레이
    ///   - complete: 액션
    class func delayAction ( dDelay : Double, complete : @escaping () -> () ) {
        let dDelay = dDelay * Double(NSEC_PER_SEC)
        let time = DispatchTime.now() + Double(Int64(dDelay)) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: time) {
            complete()
        }
    }
    
    //============================================================
    // MARK: - UI Util
    //============================================================
    
    /// 토스트 메세지 출력
    ///
    /// - Parameters:
    ///   - msg: 토스트 메세지
    ///   - duration: 표시 시간
    class func showToastMessage(msg: String?, iconImageName:String? = nil, duration: Double = 2.0, position:CGFloat = 40) {
        if let strMsg = msg, strMsg.isExist == true {
            ToastCenter.default.cancelAll()
            
            let vToast = Toast.init(text: strMsg, iconImageName: iconImageName)
            vToast.view.font = FONT_NOTOSANS_KR_REGULAR(16)
            var notch:CGFloat = 0
            if IS_NOTCH {
                notch = 34
            }
            vToast.view.bottomOffsetPortrait = position + notch
            vToast.view.textInsets = UIEdgeInsets.init(top: 16, left: 20, bottom: 16, right: 20)
            vToast.duration = duration
            vToast.show()
            
            ILog("[TOAST] \(strMsg)")
        }
    }
    
    /// 팝업 Show 애니메이션
    /// - Parameters:
    ///   - vSuper: 슈퍼뷰
    ///   - vPopup: 팝업 슈퍼뷰
    ///   - vPopupContent: 팝업 컨텐츠 뷰
    ///   - tfPopup: 팝업 텍스트 필드
    class func showPopupAnimation(vSuper: UIView, vPopup: UIView, vPopupContent: UIView? = nil, tfPopup: UITextField? = nil, complete: (()->())? = nil ) {
        vSuper.addSubview(vPopup)
        vPopup.snp.makeConstraints{ (make) in
            make.edges.equalToSuperview()
        }
        
        vPopup.alpha = 0.0
        vPopupContent?.alpha = 0.0
        
        UIView.animate(withDuration: 0.3, animations: {
            vPopup.alpha = 1.0
        }, completion: { _ in
            UIView.animate(withDuration: 0.3, animations: {
                vPopupContent?.alpha = 1.0
            }, completion: { _ in
                tfPopup?.becomeFirstResponder()
            })
        })
        complete?()
    }
    
    class func showPopupAnimation(vPopup: UIView, vPopupContent: UIView? = nil, tfPopup: UITextField? = nil, complete: (()->())? = nil ) {
        GET_APPDELEGATE().window?.endEditing(true)
        GET_APPDELEGATE().window?.addSubview(vPopup)
        vPopup.snp.makeConstraints{ (make) in
            make.edges.equalToSuperview()
        }
        vPopup.alpha = 0.0
        vPopupContent?.alpha = 0.0
        
        UIView.animate(withDuration: 0.3, animations: {
            vPopup.alpha = 1.0
        }, completion: { _ in
            UIView.animate(withDuration: 0.3, animations: {
                vPopupContent?.alpha = 1.0
            }, completion: { _ in
                tfPopup?.becomeFirstResponder()
            })
        })
        complete?()
    }
    
    /// 팝업 Dismiss 애니메이션
    /// - Parameters:
    ///   - vPopup: 팝업 슈퍼 뷰
    ///   - vPopupContent: 팝업 컨텐츠 뷰
    ///   - tfPopup: 팝업 텍스트 필드
    class func dismisPopupWithAnimation(vPopup: UIView, vPopupContent: UIView? = nil, tfPopup: UITextField? = nil) {
        vPopup.alpha = 1.0
        UIView.animate(withDuration: 0.3, animations: {
            vPopup.alpha = 0.0
        }, completion: { _ in
            vPopup.removeFromSuperview()
        })
        
        tfPopup?.resignFirstResponder()
    }
    
    /// 다크모드 세팅
    /// - Parameter isDark: 다크모드 여부
    class func setDarkMode( isDark: Bool ) {
        if #available(iOS 13.0, *) {
            if let window = UIApplication.shared.keyWindow {
                UIView.transition (with: window, duration: 0.3, options: .transitionCrossDissolve, animations: {
                    UIApplication.shared.windows.forEach { window in
                        if isDark == true {
                            window.overrideUserInterfaceStyle = .dark
                        } else {
                            window.overrideUserInterfaceStyle = .light
                        }
                    }
                }, completion: nil)
            }
        }
    }
    
    //============================================================
    // MARK: - Data Util
    //============================================================
    
    /// 시스템 정보 로그
    class func showSystemInfoLog() {
        guard let dicMainBundle = Bundle.main.infoDictionary else {
            return
        }
        
        AGLog("========================================================================================", strLogName: "SYSTEM_INFO")
        if let CFBundleName = dicMainBundle["CFBundleName"] { AGLog("CFBundleName : \(CFBundleName)", strLogName: "SYSTEM_INFO") }
        if let CFBundleDisplayName = dicMainBundle["CFBundleDisplayName"] { AGLog("CFBundleDisplayName : \(CFBundleDisplayName)", strLogName: "SYSTEM_INFO") }
        if let CFBundleShortVersionString = dicMainBundle["CFBundleShortVersionString"] { AGLog("CFBundleShortVersionString : \(CFBundleShortVersionString)", strLogName: "SYSTEM_INFO") }
        if let CFBundleVersion = dicMainBundle["CFBundleVersion"] { AGLog("CFBundleVersion : \(CFBundleVersion)", strLogName: "SYSTEM_INFO") }
        if let CFBundleIdentifier = dicMainBundle["CFBundleIdentifier"] { AGLog("CFBundleIdentifier : \(CFBundleIdentifier)", strLogName: "SYSTEM_INFO") }
        AGLog("========================================================================================", strLogName: "SYSTEM_INFO")
    }
    
    //============================================================
    // MARK: - Util
    //============================================================
    
    
    /// 모든 폰트 이름 출력
    class func printAllFontName() {
        UIFont.familyNames.forEach({ familyName in
            let fontNames = UIFont.fontNames(forFamilyName: familyName)
            AGLog("\(familyName) : \(fontNames)", strLogName: "[FONT]")
        })
    }
    
    /// 네트워크 연결 상태 체크
    class func isConnectedToNetwork() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }) else {
            return false
        }
        
        var flags: SCNetworkReachabilityFlags = []
        
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return false
        }
        
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        return (isReachable && !needsConnection)
    }
    
    
    /// 패스워드 정합성 체크
    /// - Parameter str: 패스워드 문자열
    /// - Returns: 결과
    class func passwordValid(str:String) -> Bool{
        let reg = "^(?=.*[0-9])(?=.*[A-Za-z])(?=.*[+×÷=/_<>♡☆)(*&^%~#@!-':\";,?`￦\\|♤♧{}\\[\\]¥£€$◇■□●○•°※¤《》¡¿]).{7,}.$"
        let regex = try? NSRegularExpression(pattern: reg, options: [])
        
        if let _ = regex?.firstMatch(in: str, options: [], range: NSRange(location: 0, length: str.count)){
            return true
        } else {
            return false
        }
    }
    
    class func idValid(str:String) -> Bool{
        let reg = "^(?=.*[A-Za-z0-9]).{6,}$"
        let regex = try? NSRegularExpression(pattern: reg, options: [])
        
        if let _ = regex?.firstMatch(in: str, options: [], range: NSRange(location: 0, length: str.count)){
            return true
        } else {
            return false
        }
    }
    
    /// 핸드폰번호 정합성 체크
    /// - Parameter str: 핸드폰번호
    /// - Returns: 불린
    class func phoneValid(_ str:String) -> Bool{
        let number = str.replacingOccurrences(of: "-", with: "")
        let reg = "[0-9]{0,3}[0-9]{3,4}[0-9]{4}"
        let regex = try? NSRegularExpression(pattern: reg, options: [])
        
        if let _ = regex?.firstMatch(in: number, options: [], range: NSRange(location: 0, length: number.count)){
            return true
        } else {
            return false
        }
    }
    
    //============================================================
    // MARK: - Image Util
    //============================================================
    
    /// 이미지 추출
    /// - Parameter asset: asset
    /// - Returns: 이미지
    class func getUIImage(asset: PHAsset?) -> UIImage? {
        guard let asset = asset else { return nil }
        var img: UIImage?
        let manager = PHImageManager.default()
        let options = PHImageRequestOptions()
        options.version = .original
        options.isSynchronous = true
        manager.requestImageData(for: asset, options: options) { data, _, _, _ in
            if let data = data {
                img = UIImage(data: data)
            }
        }
        return img
    }
    
    /// 이미지 사이즈 반환
    /// - Parameter strURL: 이미지 URL
    /// - Returns: 이미지 사이즈
    class func getSizeOfImageAt(strURL: String) -> CGSize? {
        guard let url = URL.init(string: strURL) else {
            return nil
        }
        
        // with CGImageSource we avoid loading the whole image into memory
        guard let source = CGImageSourceCreateWithURL(url as CFURL, nil) else {
            return nil
        }
        
        let propertiesOptions = [kCGImageSourceShouldCache: false] as CFDictionary
        guard let properties = CGImageSourceCopyPropertiesAtIndex(source, 0, propertiesOptions) as? [CFString: Any] else {
            return nil
        }
        
        if let width = properties[kCGImagePropertyPixelWidth] as? CGFloat,
           let height = properties[kCGImagePropertyPixelHeight] as? CGFloat {
            return CGSize(width: width, height: height)
        } else {
            return nil
        }
    }
    
    /// 이미지 사이즈 반환 : 넓이 대비
    /// - Parameters:
    ///   - strURL: 이미지 URL
    ///   - cfWidth: 넓이
    /// - Returns: 이미지 사이즈
    class func getScreenHeightOfImageAt(strURL: String, cfWidth: CGFloat) -> CGFloat {
        guard let sizeOriginal: CGSize = Util.getSizeOfImageAt(strURL: strURL) else { return 0 }
        if sizeOriginal.width > 0 { return ( cfWidth * sizeOriginal.height ) / sizeOriginal.width }
        else { return 0 }
    }
    
    class func compareNewVersion(strNewVersion: String?) -> Bool {
        guard let strNewVersion = strNewVersion else {
            return false
        }
        
        let arrNewVersion = strNewVersion.split(separator: ".")
        
        var isNew: Bool = false
        if let arrVersion = APP_VERSION?.split(separator: "."), arrVersion.count == 3, arrNewVersion.count == 3 {
            if let nAppVersionFirst = Int(arrVersion[0]), let nAppVersionSecond = Int(arrVersion[1]), let nAppVersionThird = Int(arrVersion[2]),
               let nNewFirst = Int(arrNewVersion[0]), let nNewSecond = Int(arrNewVersion[1]), let nNewThird = Int(arrNewVersion[2]) {
                if nAppVersionFirst < nNewFirst { isNew = true }
                else if nAppVersionFirst == nNewFirst, nAppVersionSecond < nNewSecond { isNew = true }
                else if nAppVersionFirst == nNewFirst, nAppVersionSecond == nNewSecond, nAppVersionThird < nNewThird { isNew = true }
            }
        }

        return isNew
    }
    
    /// 이메일 유효성 검사
    ///
    /// - Parameter testStr: 이메일
    /// - Returns: 이메일 유효성 여부
    class func isValidEmail(strEmail: String?) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: strEmail)
    }
    
    /// 애플 이메일 가리시 사용 판단
    ///
    /// - Parameter testStr: 이메일
    /// - Returns: 이메일 유효성 여부
    class func isSecretEmail(strEmail: String?) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@privaterelay.appleid.com"
        
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: strEmail)
    }
    
    
    class func latestVersion() -> String? {
        guard let url = URL(string: "http://itunes.apple.com/lookup?id=\(APPLE_ID)"),
              let data = try? Data(contentsOf: url),
              let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any],
              let results = json["results"] as? [[String: Any]],
              let appStoreVersion = results[0]["version"] as? String else {
            return nil
        }
        return appStoreVersion
    }
    
    class func openAppStore(urlStr: String, comletion:@escaping ()->Void) {

        guard let url = URL(string: urlStr) else {
            DLog("유효하지 않은 URL")
            return
        }

        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
            comletion()
        } else {
            DLog("앱스토어 URL 오픈 실패")
        }
    }
    
    class func getCurrency(name:String) -> Currency {
        var currency:Currency = .USD
        switch name {
        case "KRW":
            currency = .KRW
        default:
            currency = .USD
        }
        return currency
    }
    
    class func requestTrakingPermission(completion:@escaping ()->Void) {
        if #available(iOS 14, *) {
            ATTrackingManager.requestTrackingAuthorization { status in
                switch status {
                case .authorized:
                    // Tracking authorization dialog was shown
                    // and we are authorized
                    DLog("requestPermission Authorized")

                    // Now that we are authorized we can get the IDFA
                    DLog(ASIdentifierManager.shared().advertisingIdentifier)
                    completion()
                case .denied:
                    // Tracking authorization dialog was
                    // shown and permission is denied
                    DLog("requestPermission Denied")
                    completion()
                case .notDetermined:
                    // Tracking authorization dialog has not been shown
                    DLog("requestPermission Not Determined")
                    
                    delayAction(dDelay: 0.5) {
                        requestTrakingPermission(completion: completion)
                    }
                case .restricted:
                    DLog("requestPermission Restricted")
                @unknown default:
                    print("Unknown")
                    DLog("requestPermission Unknown")
                    completion()
                }
            }
        }
    }
    
    class func requestNotification(completion:@escaping ()->Void) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.sound,.badge]) { didAllow, error in
            if didAllow {
                DLog("requestPermission requestNotification didAllow \(didAllow)")
            } else {
                DLog("requestPermission requestNotification didAllow \(didAllow)")
            }
            completion()
        }
    }
}
//============================================================
// MARK: - Gloabl Func
//============================================================

/// 메서드 반복
/// - Parameters:
///   - nCount: 반복 횟수
///   - action: 반복 메서드
func REPEAT_FUNC(nCount: Int, action: ()->() ) { if nCount > 0 { for _ in 0..<nCount { action() } } }



