//
//  NewsModel.swift
//  JSONtoModel
//
//  Created by BotherBox on 15/3/12.
//  Copyright (c) 2015年 sz. All rights reserved.
//

import Foundation

class NewsModel: NSObject {
   
    /** 主标题 */
    var title: String?
    /** 新闻摘要 */
    var digest: String?
    /** 回帖数 */
    var replyCount: NSNumber?
    /** 主图 */
    var imgsrc: String?
    /** 配图 */
    var imgextra: NSArray?
    /** 是否是ads_cell */
    var imgType: NSNumber?
    
    var tname: String?
    var ptime: String?
    var photosetID: String?
    var hasHead: NSNumber?
    var hasImg: NSNumber?
    var lmodify: String?
    var template: String?
    var skipType: String?
    var alias: String?
    var docid: String?
    var hasCover: Bool = false
    var hasAD: NSNumber?
    var priority: NSNumber?
    var cid: String?
    var hasIcon: Bool = false
    var ename: String?
    var skipID: String?
    var order: NSNumber?;
    
    var url_3w: String?
    var timeConsuming: String?
    var subtitle: String?
    var adTitle: String?
    var url: String?
    var source: String?
    
    
    var TAG: String?
    var TAGS: String?
    
    var specialID: String?
    
    var editor: NSArray?;
    
}
