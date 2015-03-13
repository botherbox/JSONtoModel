//
//  ViewController.swift
//  JSONtoModel
//
//  Created by BotherBox on 15/3/8.
//  Copyright (c) 2015年 sz. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let start = NSDate()
        
        loadNewsData()
        
        let delta = NSDate().timeIntervalSinceDate(start)
        println(delta)
        
    }
    
    func loadNewsData() {
        
        var total = NSMutableArray()
        EasyNetwork().requestJSONWithURL("http://c.3g.163.com/nc/article/headline/T1348647853363/0-140.html", method: HTTPMethod.GET, params: nil) { (data, error) -> Void in
            
            let newsData = data as! NSDictionary
            let keyString = newsData.keyEnumerator().nextObject() as! String
            
            let dataList = newsData[keyString] as! NSArray
            
            for _ in 0...100 {
                
            }
            
            let newsList = JSONtoModel.arrayToObject(dataList, cls: NewsModel.self)
            
            println("\(newsList.count)")
            
            
//            NSString *dataKeyString = [[responseObject keyEnumerator] nextObject];
//            
//            NSArray *newsData = responseObject[dataKeyString];
            
        }
        
    }
    
    func demo() {
        
        let jsonData = loadJSON() as! NSDictionary
        var result = [SubDemoModel]()
        
        let start = NSDate()
        
        for _ in 0...10000 {
            
            let obj = JSONtoModel.dictionaryToObject(jsonData, cls: SubDemoModel.self) as! SubDemoModel
            result.append(obj)
        }
        
        let delta = NSDate().timeIntervalSinceDate(start)
        
        println("\(result.count)")
        println("\(result.last)")
        println("\(delta)")
        
        let demo = result.last!
        println("\(demo.name)")
        println("\(demo.age)")
        println("\(demo.boolVar)")
        println("\(demo.floatVar)")
        println("\(demo.doubleVar)")
        println("\(demo.num)")
        println("\(demo.info)")
        println("\(demo.infoArr)")
        println("\(demo.nsArr)")
        println("\(demo.other)")
    }
    
    func loadJSON() -> AnyObject? {
        let jsonFile = NSBundle.mainBundle().pathForResource("demo.json", ofType: nil)
        
        println("\(jsonFile)")
        
        let jsonData = NSData(contentsOfFile: jsonFile!)
        
        var error: NSError?
        let re: AnyObject? = NSJSONSerialization.JSONObjectWithData(jsonData!, options: NSJSONReadingOptions.allZeros, error: &error)
        
        println(error)
        
        return re
    }
    
}

