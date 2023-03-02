//
//  Util_Log.swift
//  switchwon
//
//  Created by sangdon kim on 2022/07/06.
//  Copyright © 2022 Switchwon. All rights reserved.
//

import UIKit

//============================================================
// MARK: - Log System
//============================================================

/// AG log
public func AGLog<T>(_ object: T,
                     _ logStep: Int = 1,
                     strLogName: String = "",
                     fileName: String = #file,
                     line:Int = #line,
                     functionName:String = #function) {
    #if RELEASE
    return
    #endif
    if BundleInfo(strKey: "BUILD_SETTING") == "PRD" { return }
    
    guard let strFileName = fileName.split(separator: "/").last?.replacingOccurrences(of: ".swift", with: "") else {
        print("[ERROR]   File Name Error => Log System Fail : \(fileName)")
        return
    }
    
    var strLog = "\(strFileName)[\(line)] \(functionName)"
    strLog.arrangeLogSpace()
    strLog.appendTapSpace(nCount: logStep)
    
    if strLogName.isExist == true {
        var strLogTitle: String = "[\(strLogName)]"
        strLogTitle.arrangeLogSpace(nCountAlign: 10)
        
        if let strObject = (object as? String), strObject.components(separatedBy: "\n").count > 1 {
            let arrObjectLine = strObject.components(separatedBy: "\n")
            for strObjectLine in arrObjectLine {
                print("\(strLogTitle) \(strLog)\(strObjectLine)")
            }
        } else {
            print("\(strLogTitle) \(strLog)\(object)")
        }
        
    } else {
        print("[AG] \(strLog)\(object)")
    }
}

/// Information Log
public func ILog<T>(_ object:T, _ logStep:Int = 1, fileName:String = #file, line:Int = #line, functionName:String = #function) {
    AGLog(object,
          logStep,
          strLogName: "INFO",
          fileName:fileName,
          line:line,
          functionName:functionName)
}

/// Development Log
public func DLog<T>(_ object:T, _ logStep:Int = 1, fileName:String = #file, line:Int = #line, functionName:String = #function) {
    AGLog(object,
          logStep,
          strLogName: "DEBUG",
          fileName:fileName,
          line:line,
          functionName:functionName)
}

/// Warning Log
public func WLog<T>(_ object:T, _ logStep:Int = 1, fileName:String = #file, line:Int = #line, functionName:String = #function) {
    AGLog(object,
          logStep,
          strLogName: "WARNING",
          fileName:fileName,
          line:line,
          functionName:functionName)
}

/// Blank Log
public func BlankLog ( nCount : Int = 1 ) {
    for _ in 0..<nCount {
        print(" ")
    }
}
