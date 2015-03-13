//
//  DemoModel.swift
//  JSONtoModel
//
//  Created by BotherBox on 15/3/8.
//  Copyright (c) 2015年 sz. All rights reserved.
//

import Foundation

// 如果使用KVC 则模型中的基本数据类型 不能使用可选类型 
// 比如： var age: Int?(错误) var age: Int = 0(正确)
class DemoModel: NSObject, JSONtoModelProtocol {
    var name: String?
    
    var age: Int = 0
//    var age: Int? // 错误 无法使用KVC
    var boolVar: Bool = true
    var floatVar: Float = 0
    var doubleVar: Double = 0
    var num: NSNumber?
    var info: Info?
    var infoArr: [Info]?
    var nsArr: NSArray? // Info类型
    var other: [[Info]]?
    
    static func customClassMapping() -> [String : String]? {
        return ["info": "\(Info.self)", "infoArr": "\(Info.self)", "other": "\(Info.self)"]
    }
    
}

class Info: NSObject {
    var name: String?
}

// 子类
class SubDemoModel: DemoModel {
    var subDemoVar: String?
}
