//
//  Record.swift
//  TestTask
//
//  Created by ParaBellum on 9/9/17.
//  Copyright © 2017 ParaBellum. All rights reserved.


import Foundation
import RealmSwift
func getURLFromString(_ string:String) -> URL{
    return URL(string: string)!
}
class Record: Object{
    //Init
    convenience init(name:String,urlString: String, dateAdded:Date,durationString:String){
        self.init()
        self.name = name
        self.urlString = urlString
        self.dateAdded = dateAdded
        self.durationString = durationString
    }
    
    //Properties
    dynamic var name = ""
    dynamic var urlString = ""
    dynamic var dateAdded:Date!
    dynamic var durationString = ""
    
    
    var url:URL{
        return getURLFromString(self.urlString)
    }

    
    //Meta
    override static func primaryKey() -> String?{
        return "name"
    }
    
}
