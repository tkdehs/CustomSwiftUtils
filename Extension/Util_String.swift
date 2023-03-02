//
//  Util_String.swift
//  CodeAble
//
//  Created by sangdon kim on 2022/07/06.
//  Copyright © 2022 Switchwon. All rights reserved.
//

import UIKit

extension String {
    /// 문자열 존재 여부
    var isExist : Bool { return !self.isEmpty }
    /// 문자열 길이
    var length: Int { get { return self.count } }
    /// 문자열 길이 ( UTF16 인코딩 길이 )
    var utf16Length: Int { get { return self.utf16.count } }
    
    /// Int Value
    var intValue : Int { get { return (self as NSString).integerValue } }
    /// CGFloat Value
    var floatValue : CGFloat { get { return CGFloat.init((self as NSString).floatValue) } }
    /// URL Value
    var urlValue: URL? { get { return URL(string: self) } }
    /// Bool Value
    var boolValue: Bool { get { return ["True","TRUE","true","t","YES","yes","Y","y","1"].contains(self) } }
    /// double Value
    var doubleValue : Double { get { return Double(self.replacingOccurrences(of: ",", with: "")) ?? 0.0 } }
    /// decimal Value
    var decimalValue : NSDecimalNumber { get { return NSDecimalNumber(string: self.replacingOccurrences(of: ",", with: "")) } }
    //============================================================
    // MARK: - Data Setting
    //============================================================
    
    func substring(from: Int, to: Int) -> String {
        guard from < count, to >= 0, to - from >= 0 else {
            return ""
        }
        
        // Index 값 획득
        let startIndex = index(self.startIndex, offsetBy: from)
        let endIndex = index(self.startIndex, offsetBy: to + 1) // '+1'이 있는 이유: endIndex는 문자열의 마지막 그 다음을 가리키기 때문
        
        // 파싱
        return String(self[startIndex ..< endIndex])
    }
    
    /// decimal 포메팅
    func decimalFroamt(max:Int = 2, min:Int = 2, roundMode:NumberFormatter.RoundingMode = .halfUp) -> String? {
        let str = self.replacingOccurrences(of: ",", with: "")
        if let doubleValue = Double(str) {
            return doubleValue.decimalFroamt(max:max,min: min,roundMode: roundMode)
        } else {
            return nil
        }
    }
    /// URL 인코딩
    func encodeUrl( characterSet : CharacterSet = CharacterSet.urlQueryAllowed ) -> String {
        if let strEncodeURL = self.addingPercentEncoding( withAllowedCharacters: characterSet) { return strEncodeURL }
        else {
            DLog("URL 인코딩 Fail")
            return ""
        }
    }
    
    /// URL 디코딩
    func decodeUrl() -> String {
        if let strDecodeURL = self.removingPercentEncoding { return strDecodeURL }
        else {
            DLog("URL 디코딩 Fail")
            return ""
        }
    }
    
    /// Base 64 인코딩
    func encodeBase64() -> String? {
        guard let data = self.data(using: String.Encoding.utf8) else {
            return nil
        }
        return data.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
    }
    
    /// Base 64 디코딩
    func decodeBase64() -> String? {
        guard let data = Data(base64Encoded: self, options: NSData.Base64DecodingOptions(rawValue: 0)) else {
            return nil
        }
        return String(data: data, encoding: String.Encoding.utf8)
    }
    
    /// 정규식 체크
    func checkString(strRegex:String = "[a-zA-Z0-9가-힣ㄱ-ㅎㅏ-ㅣ\\s]") -> Bool {
        let regex = try! NSRegularExpression(pattern: strRegex, options: [])
        let list = regex.matches(in:self, options: [], range:NSRange.init(location: 0, length:self.count))
        if list.count != self.count { return false }
        else { return true }
    }
    
    func regexCheck(_ char:Character) -> Bool {
//        contains(_ element: Character) -> Bool
        let checkString = String(char)
        let regex = try! NSRegularExpression(pattern: self, options: [])
        let list = regex.matches(in:checkString, options: [], range:NSRange.init(location: 0, length:checkString.count))
        if list.count != checkString.count { return false }
        else { return true }
        
    }
    
    ///  핸드폰번호 정규식
    /// - Returns: 정합성 결과
    func isValidPhone() -> Bool {
        let phoneRegEx = "^01([0|1|6|7|8|9]?)-?([0-9]{3,4})-?([0-9]{4})$"
        let pred = NSPredicate(format:"SELF MATCHES %@", phoneRegEx)
        return pred.evaluate(with: self)
    }
    
    mutating func removeCharacterSave(_ strRemoveText: String = "") {
        self = self.replacingOccurrences(of: strRemoveText, with: "")
    }
    
    func removeCharacter(_ strRemoveText: String = "") -> String {
        return self.replacingOccurrences(of: strRemoveText, with: "")
    }
    
    func removeSpecialChars() -> String {
        let okayChars : Set<Character> = Set("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ1234567890")
        return self.filter {okayChars.contains($0)}
    }
    
    /// 날짜를 커뮤니티에 표시될 형식으로 변환
    func getTimeIntervalText() -> String {
        var nInterval : TimeInterval = 0
        if let dateRegTsp = self.convertDate {
            nInterval = Date.timeIntervalSinceReferenceDate - dateRegTsp.timeIntervalSinceReferenceDate
        }
        
        if nInterval < 300            { return "방금 전" }
        else if nInterval < 3600      { return "\(Int(nInterval/60))분 전" }
        else if nInterval < 86400     { return "\(Int(nInterval/3600))시간 전" }
        else if nInterval < 604800    { return "\(Int(nInterval/86400))일 전" }
        else if let convertDate = self.convertDate { return convertDate.convertYearMonthDayString() }
        else { return "알수없음" }
    }
    
    mutating func appendByComma(_ str: String?, strComma: String = ",") {
        guard let str = str else { return }
        if self.isExist == true {
            self.append(strComma)
            self.append(str)
        } else {
            self.append(str)
        }
    }
    
    /// C String 변환
    /// - Returns: C String
    func convertCString() -> UnsafeMutablePointer<UInt8>? {
        var utf8 = Array(self.utf8)
        /// Adds Null Character
        utf8.append(0)
        let count = utf8.count
        let result = UnsafeMutableBufferPointer<UInt8>.allocate(capacity: count)
        _ = result.initialize(from: utf8)
        return result.baseAddress
    }
    
    /// 넘버 포멧팅
    /// - Parameter strFormat: X 포멧
    mutating func convertNumberFormat(strFormat: String = "XXX-XXXX-XXXX") {
        let strNumber: String = self.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        var strResult: String = ""
        var index: Index = strNumber.startIndex
        
        // iterate over the mask characters until the iterator of numbers ends
        for ch in strFormat where index < strNumber.endIndex {
            if ch == "X" {
                strResult.append(strNumber[index])
                index = strNumber.index(after: index)
                
            } else {
                strResult.append(ch)
            }
        }
        self = strResult
    }
    
    mutating func convertStrFormat() {
        let strArr = Array(self) // 문자열 한글자씩 확인을 위해 배열에 담는다
        let pattern = "^[가-힣ㄱ-ㅎㅏ-ㅣa-zA-Z0-9_]$"
        // 문자열 길이가 한개 이상인 경우만 패턴 검사 수행
        var resultString = ""
        if strArr.count > 0 {
            if let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive) {
                var index = 0
                while index < strArr.count { // string 문자 하나 마다 개별 정규식 체크
                    let checkString = regex.matches(in: String(strArr[index]), options: [], range: NSRange(location: 0, length: 1))
                    if checkString.count == 0 {
                        index += 1 // 정규식 패턴 외의 문자가 포함된 경우
                    }
                    else { // 정규식 포함 패턴의 문자
                        resultString += String(strArr[index]) // 리턴 문자열에 추가
                        index += 1
                    }
                }
            }
            self = resultString
        }
    }
    
    /// 전화번호 넘버 포멧팅
    mutating func convertPhoneNumberFormat() {
        if(self.length < 13){
            self.convertNumberFormat(strFormat: "XXX-XXX-XXXX")
        }else{
            self.convertNumberFormat(strFormat: "XXX-XXXX-XXXX")
        }
    }
    
    /// 전화번호 넘버 포멧팅
    mutating func convertLocalPhoneNumberFormat() {
        let strNumber: String = self.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        if strNumber.length >= 11 {
            self.convertNumberFormat(strFormat: "XXX-XXXX-XXXX")
        } else if strNumber.length == 10 {
            self.convertNumberFormat(strFormat: "XX-XXXX-XXXX")
        } else {
            self.convertNumberFormat(strFormat: "XX-XXX-XXXX")
        }
    }
    
    /// 전화번호 넘버 포멧팅
    mutating func convertCompanyNumberFormat() {
        self.convertNumberFormat(strFormat: "XXX-XX-XXXXX")
    }
    
    mutating func convertCorpNumberFormat() {
        self.convertNumberFormat(strFormat: "XXXXXX-XXXXXXX")
    }
    
    //============================================================
    // MARK: - String Subscript
    //============================================================
    
    subscript (i: Int) -> Character {
        if self.length > i {
            return self[self.index(self.startIndex, offsetBy: i)]
        } else {
            return Character.init("")
        }
    }
    
    subscript (i: Int) -> String {
        if self.length > i {
            return String(self[i] as Character)
        } else {
            return ""
        }
    }
    
    subscript (r: Range<Int>) -> String {
        var range : Range<Int> = r
        if self.length < range.lowerBound             { return "" }
        if self.length < range.upperBound {
            range = range.lowerBound..<self.length
        }
        if range.lowerBound == range.upperBound         { return ""}
        
        return String(self[self.index(self.startIndex, offsetBy: range.lowerBound)..<self.index(self.startIndex, offsetBy: range.upperBound)])
    }
    
    mutating func appendSafely(_ appendValue: String?) {
        if let appendValue = appendValue {
            self.append(contentsOf: appendValue)
        }
    }
    
    mutating func appendSafely(_ appendValue: Int?) {
        if let appendValue = appendValue {
            self.append(contentsOf: "\(appendValue)")
        }
    }
    
    //============================================================
    // MARK: - Convert Data Type
    //============================================================
    
    func convertJsonStringToDictionary() -> [String: AnyObject]? {
        if let data = data(using: String.Encoding.utf8) {
            do { return try JSONSerialization.jsonObject(with: data, options: []) as? [String:AnyObject] }
            catch let error as NSError { print(error) } }
        return nil
    }
    
    func onlyNumber() -> String {
        return self.filter("0123456789".contains)
    }
    
    /// Date 변환
    var convertDate : Date? {
        get {
            var strDate: String = self
            if self.length == 29 { strDate = self[0..<23] }
            let formatter: DateFormatter = DateFormatter()
            formatter.timeZone = TimeZone.init(abbreviation: "KST")
            if strDate.length == 24        { formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'" }
            else if strDate.length == 23    { formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS" }
            else if strDate.length == 21    { formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.S" }
            else if strDate.length == 19    { formatter.dateFormat = "yyyy-MM-dd HH:mm:ss" }
            else if strDate.length == 16    { formatter.dateFormat = "yyyy-MM-dd HH:mm" }
            else if strDate.length == 14    { formatter.dateFormat = "yyyyMMddHHmmss" }
            else if strDate.length == 10    { formatter.dateFormat = "yyyy-MM-dd" }
            else if strDate.length == 8    { formatter.dateFormat = "yyyyMMdd" }
            else if strDate.length == 6    { formatter.dateFormat = "HHmmss" }
            else                        { return nil }
            
            if let dateResult: Date = formatter.date(from: strDate) {
                return dateResult
            } else {
                return nil
            }
        }
    }
    
    /// Date T 변환
    var convertTDate : Date {
        get {
            var strDate: String = self
            if self.length == 29 { strDate = self[0..<23] }
            let formatter: DateFormatter = DateFormatter()
            formatter.timeZone = TimeZone.init(abbreviation: "KST")
            if strDate.length == 24        { formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'" }
            else if strDate.length == 23    { formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS" }
            else if strDate.length == 21    { formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.S" }
            else if strDate.length == 19    { formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss" }
            else if strDate.length == 16    { formatter.dateFormat = "yyyy-MM-dd'T'HH:mm" }
            else if strDate.length == 14    { formatter.dateFormat = "yyyyMMddHHmmss" }
            else if strDate.length == 10    { formatter.dateFormat = "yyyy-MM-dd" }
            else if strDate.length == 8    { formatter.dateFormat = "yyyyMMdd" }
            else if strDate.length == 6    { formatter.dateFormat = "HHmmss" }
            else                        { return Date() }
            
            if let dateResult: Date = formatter.date(from: strDate) {
                return dateResult
            } else {
                return Date()
            }
        }
    }
    
    func convertDate(format:String) -> Date {
        var strDate: String = self
        let formatter: DateFormatter = DateFormatter()
        formatter.timeZone = TimeZone.init(abbreviation: "KST")
        formatter.dateFormat = format
        
        if let dateResult: Date = formatter.date(from: strDate) {
            return dateResult
        } else {
            return Date()
        }
    }
    
    func diffDay(difDate:String) -> Int {
        let day = 86400.0
        let diffValue = ((self.convertDate?.timeIntervalSinceReferenceDate ?? 0) - (difDate.convertDate?.timeIntervalSinceReferenceDate ?? 0)) / day
        let abs = abs(Int(diffValue))
        DLog(abs)
        return abs
    }
    
    func diffDay(difDate:Date = Date(), isAbs:Bool = true) -> Int {
        let day = 86400.0
        let diffValue = ((self.convertDate?.timeIntervalSinceReferenceDate ?? 0) - difDate.timeIntervalSinceReferenceDate) / day
        
        let result:Int
        if isAbs {
            result = abs(Int(diffValue))
        } else {
            result = Int(diffValue)
        }
        DLog(result)
        return result
    }
    
    
    //============================================================
    // MARK: - UI Setting
    //============================================================
    
    /// 라벨 높이 계산
    func height(constraintedWidth width: CGFloat, font: UIFont, lineBreakMode : NSLineBreakMode = .byTruncatingTail, nLineCount : Int = 0) -> CGFloat {
        let label =  UILabel(frame: CGRect(x: 0, y: 0, width: width, height: .greatestFiniteMagnitude))
        label.font = font
        label.numberOfLines = nLineCount
        label.text = self
        label.lineBreakMode = lineBreakMode
        label.sizeToFit()
        
        return label.frame.height
    }
    /// 라벨 싸이즈
    func size(font: UIFont, lineBreakMode : NSLineBreakMode = .byTruncatingTail, nLineCount : Int = 0) -> CGSize {
        let label =  UILabel()
        label.font = font
        label.numberOfLines = nLineCount
        label.text = self
        label.lineBreakMode = lineBreakMode
        label.sizeToFit()
        
        return label.frame.size
    }
    
    //============================================================
    // MARK: - Log String
    //============================================================

    /// 로그 정렬
    mutating func arrangeLogSpace( nCountAlign : Int = 65 ) {
        let nSpace : Int = nCountAlign - self.countLogStringWidth()
        if nSpace <= 0 { return }
        for _ in 0..<nSpace {
            self = self.appending(" ")
        }
    }

    mutating func appendTapSpace(nCount : Int ) {
        for _ in 1...nCount {
            self = self.appending("\t\t")
        }
    }

    /// 로그 문자 넓이 계산
    func countLogStringWidth() -> Int {
        var nCount : Int = 0
        
        for nIndex in 0..<self.length {
            let str : String = self[nIndex]
            if str.checkString(strRegex: "[가-힣ㄱ-ㅎㅏ-ㅣ]") == true {
                nCount = nCount + 2
            } else {
                nCount = nCount + 1
            }
        }
        
        return nCount
    }

    
    /// 다국어 문자열 불러오기
    /// - Parameter comment: 코멘트
    /// - Returns: 다국어 처리된 문자
    func localized(comment: String = "") -> String {
        return NSLocalizedString(self, comment: comment)
    }
    
    
    /// 다국어 문자열 불러오기
    /// - Parameters:
    ///   - argument: 변수 값
    ///   - comment: 코멘트
    /// - Returns: 다국어 처리된 문자
    func localized(with argument: CVarArg = [], comment: String = "") -> String {
        return String(format: self.localized(comment: comment), argument)
    }
    
    func localized(_ argument: CVarArg...) -> String {
        return String(format: self.localized(comment: ""), argument)
    }
    
    /// 언더라인 텍스트
    var underLined: NSAttributedString {
        NSMutableAttributedString(string: self, attributes: [.underlineStyle: NSUnderlineStyle.single.rawValue])
    }
    
    func attrBold(fontSize:CGFloat, fontColor:UIColor, strBold:String) -> NSAttributedString {
        let attrs = [
            NSAttributedString.Key.font: FONT_NOTOSANS_KR_BOLD(fontSize),
            NSAttributedString.Key.foregroundColor: fontColor
        ]
        let nonBoldAttribute = [
            NSAttributedString.Key.font: FONT_NOTOSANS_KR_REGULAR(fontSize),
        ]
        let attrStr = NSMutableAttributedString(string: self, attributes: nonBoldAttribute)
        if let range = self.range(of: strBold) {
            let nsRange = NSRange(range, in: self)
            
            attrStr.setAttributes(attrs, range: nsRange)
        }
        return attrStr
    }
    
    func attrColor(font:UIFont, fontColor:UIColor, strBold:String) -> NSAttributedString {
        let attrs = [
            NSAttributedString.Key.font: font,
            NSAttributedString.Key.foregroundColor: fontColor
        ]
        let nonBoldAttribute = [
            NSAttributedString.Key.font: font,
        ]
        let attrStr = NSMutableAttributedString(string: self, attributes: nonBoldAttribute)
        if let range = self.range(of: strBold) {
            let nsRange = NSRange(range, in: self)
            
            attrStr.setAttributes(attrs, range: nsRange)
        }
        return attrStr
    }
    
    func htmlToAttributedString(font:UIFont = FONT_NOTOSANS_KR_REGULAR(14), align:String = "center") -> NSAttributedString? {
        do {
            let newHTML = String(format:"<span style=\"font-size: \(font.pointSize); font-family: \(font.fontName); text-align: \(align); display: block;\">%@</span>", self)
            guard let data = newHTML.data(using: .utf8) else { return nil }
            
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return nil
        }
    }
    var htmlToString: String {
        return htmlToAttributedString()?.string ?? ""
    }
    
    func masked(repeating:String.Element = "*", backStart:Int, count:Int) -> String {
        let startIndex = (self.count - backStart - count)
        let endIndex = (self.count - backStart)
        return String(self.enumerated().map { (index, element) in
            if index >= startIndex && index < endIndex{
                return repeating
            } else {
                return element
            }
        })
    }
    
    func trim() -> String {
        return self.trimmingCharacters(in: .whitespaces)
    }
}

extension String.Encoding {
    /// EUC_KR Encoding
    static let eucKrDecode = String.Encoding(rawValue: CFStringConvertEncodingToNSStringEncoding(0x0422))
}
