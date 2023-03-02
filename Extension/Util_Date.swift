//
//  Util_Date.swift
//  CodeAble
//
//  Created by sangdon kim on 2022/07/06.
//  Copyright © 2022 Switchwon. All rights reserved.
//
import UIKit

extension Date {
    /// 밀리세컨드 반환
    var millisecondsSince1970: Int64 {
        return Int64((self.timeIntervalSince1970 * 1000.0).rounded())
    }
    
    /// 오늘 여부
    var isToday: Bool { get { return self.convertYearMonthDayString() == Date().convertYearMonthDayString() } }
    
    /// 달력 주간수
    var nWeekCountCalendar: Int { get {
        var nRow: Int = 1
        for date in self.arrMonthAllDay {
            if date.convertWeekDayNumberString() == "7" {
                if date.addDay().convertMonthString() == date.convertMonthString() {
                    nRow = nRow + 1
                }
            }
        }
        
      return nRow
    } }
    
    /// 해당월 모든 일자
    var arrMonthAllDay: [Date] { get {
        var arrDate: [Date] = []
        let dateStart: Date = self.startOfMonth()
        let dateEnd: Date = self.endOfMonth()
        if let nDateStart = Int(dateStart.convertDayString()), let nDateEnd = Int(dateEnd.convertDayString()) {
            let nDayCount: Int = nDateEnd - nDateStart + 1
            for nIndex in 0..<nDayCount {
                arrDate.append(dateStart.editDate(day: nIndex + 1))
            }
        }
        
        return arrDate
    } }
    
    var nWeekRow: Int { get {
        guard let nStartWeekday = Int(self.startOfMonth().convertWeekDayNumberString()) else { return 1 }
        let nDay: Int = self.convertDayInt() + ( nStartWeekday - 1 )
        if nDay % 7 == 0 { return nDay / 7 }
        else { return (nDay / 7) + 1 }
    } }
    
    /// 데이터 포멧에 맞는 문자열 반환
    func convertString ( strDateFormmat : String ) -> String {
        let fmHMDate = DateFormatter.init()
        fmHMDate.locale = Locale(identifier: "locale_str".localized())
        fmHMDate.dateFormat = strDateFormmat
        return fmHMDate.string(from: self)
    }
    
    /// Date -> String 변환 ( yyyy-MM-dd HH:mm:ss )
    func convertString () -> String                    { return self.convertString(strDateFormmat: "yyyy.MM.dd HH:mm") }
    /// Date -> String 변환 ( yyyy.MM.dd )
    func convertYearMonthDayString (strDivide: String = "-") -> String     {
        return self.convertString(strDateFormmat: "yyyy\(strDivide)MM\(strDivide)dd")
    }
    /// Date -> String 변환 ( yyyy년 MM월 dd일 )
    func convertYearMonthDay() -> String     {
        return self.convertString(strDateFormmat: "yyyy-MM-dd")
    }
    
    /// Date -> String 변환 ( yyyy )
    func convertYearString () -> String                { return self.convertString(strDateFormmat: "yyyy") }
    /// Date -> Int 변환 ( yyyy )
    func convertYearInt () -> Int                {
        if let nYear = Int(self.convertString(strDateFormmat: "yyyy")) {
            return nYear
        } else { return 0 }
    }
    func convertDoubleFigureYearString () -> String { return self.convertString(strDateFormmat: "yy") }
    /// Date -> String 변환 ( MM )
    func convertMonthString () -> String            { return self.convertString(strDateFormmat: "MM") }
    /// Date -> Int 변환 ( MM )
    func convertMonthInt () -> Int                {
        if let nMonth = Int(self.convertString(strDateFormmat: "MM")) {
            return nMonth
        } else { return 0 }
    }
    /// Date -> String 변환 ( yyyy.MM )
    func convertYearMonthString () -> String                { return self.convertString(strDateFormmat: "yyyy.MM") }
    /// Date -> String 변환 ( dd )
    func convertDayString () -> String                { return self.convertString(strDateFormmat: "dd") }
    /// Date -> String 변환 ( dd )
    func convertDayInt () -> Int                {
        if let nDay = Int(self.convertString(strDateFormmat: "dd")) {
            return nDay
        } else { return 0 }
    }
    /// Date -> String 변환 ( MM.dd )
    func convertMonthDayString () -> String            { return self.convertString(strDateFormmat: "MM.dd") }
    
    /// Date -> String 변환 ( HH:mm:ss )
    func convertHourMinuteSecondString() -> String  { return self.convertString(strDateFormmat: "HH:mm:ss") }
    /// Date -> String 변환 ( HH:mm )
    func convertHourMinuteString() -> String        { return self.convertString(strDateFormmat: "HH:mm") }
    /// Date -> String 변환 ( HH )
    func convertHourString () -> String                { return self.convertString(strDateFormmat: "HH") }
    /// Date -> Int 변환 ( HH )
    func convertHourInt () -> Int                   { let nConvert = Int(self.convertString(strDateFormmat: "HH"));        if let nConvert = nConvert { return nConvert } else { return 0 } }
    /// Date -> String 변환 ( mm )
    func convertMinuteString () -> String            { return self.convertString(strDateFormmat: "mm") }
    /// Date -> String 변환 ( ss )
    func convertSecondString () -> String            { return self.convertString(strDateFormmat: "ss") }
    
    /// Date -> String 변환 ( e )
    func convertWeekDayNumberString () -> String    { return self.convertString(strDateFormmat: "e") } /// "1": 일요일 ~ "7": 토요일
    /// Date -> String 변환 ( EEEE )
    func convertWeekDayString () -> String            { return self.convertString(strDateFormmat: "EEEE") }
    
    /// Date -> AM/PM/오전/오후 변환
    /// - Returns: 한글 여부
    func convertAMPM ( isHangul : Bool = true ) -> String {
        if let nVisitTspHour = Int(self.convertHourString()), nVisitTspHour < 12 {
            if isHangul == true        { return "오전" }
            else                    { return "AM" }
        } else {
            if isHangul == true        { return "오후" }
            else                    { return "PM" }
        }
    }
    
    /// Date -> 요일 반환
    /// - Returns: 영문 요일 값
    func convertEngWeekday(isKOR: Bool = false, isSimple: Bool = false) -> String {
        if isKOR == true {
            var strResult : String = " "
            switch self.convertWeekDayNumberString() {
                case "1": strResult = "일"
                case "2": strResult = "월"
                case "3": strResult = "화"
                case "4": strResult = "수"
                case "5": strResult = "목"
                case "6": strResult = "금"
                case "7": strResult = "토"
                default: strResult = ""
            }
            
            if isSimple == true {
                return strResult
            } else {
                strResult.append("요일")
                return strResult
            }
            
        } else {
            switch self.convertWeekDayNumberString() {
                case "1": return "Sun"
                case "2": return "Mon"
                case "3": return "Tue"
                case "4": return "Wed"
                case "5": return "Thu"
                case "6": return "Fri"
                case "7": return "Sat"
                default: return ""
            }
        }
    }
    
    /// Date -> AM/PM HH:MM
    /// - Returns: AM/PM/오전/오후 HH:MM
    func convertAMPMHHMM ( isKOR : Bool = true ) -> String {
        var strResult : String = ""
        strResult.append(self.convertAMPM( isHangul: isKOR ))
        if self.convertHourInt() > 12 {
            strResult.append(" \(self.convertHourInt()-12)시")
        } else {
            strResult.append(" \(self.convertHourInt())시")
        }
        
        strResult.append(" \(self.convertMinuteString())분")
        
        return strResult
    }
    func convertAMPMHHMMSS ( isKOR : Bool = true ) -> String {
        var strResult : String = ""
        strResult.append(self.convertAMPM( isHangul: isKOR ))
        if self.convertHourInt() > 12 {
            strResult.append(" \(self.convertHourInt()-12):")
        } else {
            strResult.append(" \(self.convertHourInt()):")
        }
        
        strResult.append("\(self.convertMinuteString()):\(self.convertSecondString())")
        
        return strResult
    }
    
    func diffTime(difDate:Date = Date(), isAbs:Bool = true) -> Int {
        let second = 86400.0 / 24 / 60 / 60
        let diffValue = (self.timeIntervalSinceReferenceDate - difDate.timeIntervalSinceReferenceDate) / second
        
        let result:Int
        if isAbs {
            result = abs(Int(diffValue))
        } else {
            result = Int(diffValue)
        }
        
        return result
    }
    
    /// Edit Date
    func editDate(year: Int? = nil, month: Int? = nil, day: Int? = nil, hour: Int? = nil, minute: Int? = nil, second: Int? = nil) -> Date {
        var components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: self)
        if let year = year { components.year = year }
        if let month = month { components.month = month }
        if let day = day { components.day = day }
        if let hour = hour { components.hour = hour }
        if let minute = minute { components.minute = minute }
        if let second = second { components.second = second }
        
        if let date = Calendar.current.date(from: components) {
            return date
        } else {
            return self
        }
    }
    
    /// Clear Date
    func clearDate(isHour: Bool = true, isMinute: Bool = true, isSecond: Bool = true) -> Date {
        var components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: self)
        if isHour == true { components.hour = 0 }
        if isMinute == true { components.minute = 0 }
        if isSecond == true { components.second = 0 }
        
        if let date = Calendar.current.date(from: components) {
            return date
        } else {
            return self
        }
    }
    
    func startOfMonth() -> Date {
        var components = Calendar.current.dateComponents([.year,.month], from: self)
        components.day = 1
        if let dateFirst = Calendar.current.date(from: components) {
            return dateFirst
        } else {
            return self
        }
    }
    
    func endOfMonth() -> Date {
        if let dateResult = Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: self.startOfMonth()) {
            return dateResult
        } else {
            return self
        }
    }
    
    func addMonth(month:Int = 1) -> Date {
        if let dateResult = Calendar.current.date(byAdding: DateComponents(month: month), to: self) {
            return dateResult
        } else {
            return self
        }
    }
    
    func reduceMonth() -> Date {
        if let dateResult = Calendar.current.date(byAdding: DateComponents(month: -1), to: self) {
            return dateResult
        } else {
            return self
        }
    }
    
    func addDay(day:Int = 1) -> Date {
        if let dateResult = Calendar.current.date(byAdding: DateComponents(day: day), to: self) {
            return dateResult
        } else {
            return self
        }
    }
    
    func reduceDay() -> Date {
        if let dateResult = Calendar.current.date(byAdding: DateComponents(day: -1), to: self) {
            return dateResult
        } else {
            return self
        }
    }
    
    func startOfYear() -> Date {
        var components = Calendar.current.dateComponents([.year], from: self)
        components.month = 1
        components.day = 1
        if let dateFirst = Calendar.current.date(from: components) {
            return dateFirst
        } else {
            return self
        }
    }
    
    func endOfYear() -> Date {
        if let dateResult = Calendar.current.date(byAdding: DateComponents(year: 1, day: -1), to: self.startOfYear()) {
            return dateResult
        } else {
            return self
        }
    }
}
