//
//  JSONtoModel.swift
//  JSONtoModel
//
//  Created by BotherBox on 15/3/8.
//  Copyright (c) 2015年 sz. All rights reserved.
//

import Foundation

@objc protocol JSONtoModelProtocol {
    
    // 属性名和属性类型映射字典
    static func customClassMapping() -> [String: String]?

}

class JSONtoModel {
    
    class func dictionaryToObject(dict: NSDictionary, cls: AnyClass) -> AnyObject? {
        // 实例化模型对象
        let instance: AnyObject = cls.alloc()
        // 获取属性列表
        let propertyList = self.fullModelInfo(cls)
        
//        println("\(propertyList)")
        for (pName, pType) in propertyList {
            // 获取属性值
            // 如果有值 再KVC 否则会报错
            if let value: AnyObject? = dict[pName] {
//                println("\(value!) -- \(pName) -- \(pType)")
                
                // -------------------------
                // JSON反序列化的时候，如果是 null， 则返回的字典中用NSNull()代替
                // 如果JSON里返回的是<null> 则用 value === NSNull() 来过滤
//                if value === NSNull() {
//                    println("\(pName)")
//                }
                // -------------------------
                
                // 如果JSON字典中的值 是 nil 或 <null> 直接跳出
                if value == nil || value === NSNull() {
                    continue
                }
                
                // 如果是基本数据类型
                if pType.isEmpty {
//                    println("\(value) -- \(pName) -- \(pType)")
                    instance.setValue(value, forKey: pName)
                    continue
                }
                
                // 自定义类型 －－－－－－－－－－－－－－－－－－－－
                let type = "\(value!.classForCoder)"
//                println("\(value) ------ \(type)")
                // 如果是字典
                if type == "NSDictionary" {
                    if let subObj: AnyObject? = dictionaryToObject(value as! NSDictionary, cls: NSClassFromString(pType)) {
                        instance.setValue(subObj, forKey: pName)
                    }
                    continue
                }
                
                if type == "NSArray" {// 如果是数组
                    let objArr = arrayToObject(value as! NSArray, cls: NSClassFromString(pType))
                    instance.setValue(objArr, forKey: pName)
                    continue
                }
            }
        }
        return instance
    }
    
    /// 转换数组为实例
    class func arrayToObject(arr: NSArray, cls: AnyClass) -> [AnyObject] {

        var instanceArr = [AnyObject]()
        
        var type: String?
        for value in arr {
            type = "\(value.classForCoder)"
            if type == "NSDictionary" {
                if let subObj: AnyObject = dictionaryToObject(value as! NSDictionary, cls: cls) {
                    instanceArr.append(subObj)
                }
                continue
            }
            
            if type == "NSArray" {
                let objArr: [AnyObject] = arrayToObject(value as! NSArray, cls: cls)
                instanceArr.append(objArr)
                continue
            }
        }
        return instanceArr
    }
    
    /// 属性缓存
    static var cacheList = [String: [String: String]]()
    /// 获取类的完整属性列表
    class func fullModelInfo(var currentCls: AnyClass) -> [String: String] {
        
        // 如果缓存有
        if let properties = cacheList["\(currentCls)"] {
            return properties
        }
        
        // 属性列表
        var pList = [String: String]()
        while let superCls: AnyClass = currentCls.superclass() {
        
            let clsProperties = modelInfo(currentCls)
            for (k, v) in clsProperties {
                pList.updateValue(v, forKey: k)
            }
            
            currentCls = superCls
        }
        
        cacheList["\(currentCls)"] = pList
        
        return pList
    }
    
    /// 获取属性类型
    class func modelInfo(cls: AnyClass) -> [String: String] {
        
        // 如果缓存有
        if let properties = cacheList["\(cls)"] {
            return properties
        }
        
        var count: UInt32 = 0
        let iVarList = class_copyIvarList(cls, &count)
        
        var customTypes: [String: String]?
        
        //
        if cls.respondsToSelector("customClassMapping") {
//            println("有属性是自定义类型")
            customTypes = cls.customClassMapping()
        }
        
//        println("有\(count)个属性")
//        println("\(_stdlib_getDemangledTypeName(iVarList))")
        
        // 保存属性名称
        var classVars = [String: String]()
        for i in 0..<count {
//            println("\(iVarList[Int(i)])")
            
            let cName = ivar_getName(iVarList[Int(i)])
            let name = String.fromCString(cName)!
            classVars[name] = customTypes?[name] ?? ""
            
        }
        
        free(iVarList)
        cacheList["\(cls)"] = classVars
        
        return classVars
    }
    
    /**
        通过class_copyIvarList()函数来获取 类里面的属性
        结论：
            1. 在swift里 class_copyIvarList() 可以获取属性的名称
            2. 但是无法获取属性的类型
    */
    class func getIVarList(cls: AnyClass) -> [String: String] {
        var vCount: UInt32 = 0
        var vList = class_copyIvarList(cls, &vCount)
        
        for i in 0..<vCount {
            let ivar = vList[Int(i)]
            
            let cName = ivar_getName(ivar)
            let name = String.fromCString(cName)
            
            let cType = ivar_getTypeEncoding(ivar)
            let type = String.fromCString(cType)
            
            println("\(name) -- \(type)")
        }
        
        return [String: String]()
    }
    
    /**
        通过class_copyPropertyList() 函数 获取类里的属性
        结论：
            1. class_copyPropertyList()可以获取非基本数据类型的属性
            2. 无法获取基本类型未初始化的属性 比如：var intVar: Int? 
            3. 如果改成 var intVar: Int = 0 就可以获取到
            4. 通过 properry_getAttributes可以获取属性的类型，但是无可操作性
    */
    class func getPropertyList(cls: AnyClass) -> [String: String] {
        
        var pCount: UInt32 = 0
        var pList = class_copyPropertyList(cls, &pCount)
        
        println("有\(pCount)个属性")
        
        var pNameList = [String: String]()
        for i in 0..<pCount {
            
            let property = pList[Int(i)]
            
            let cName = property_getName(property)
            let name = String.fromCString(cName)
            
            let cType = property_getAttributes(property)
            let type = String.fromCString(cType)
            
            println("\(name) is \(type)")
        }
        
        free(pList)
        return  pNameList
        
    }
    
}