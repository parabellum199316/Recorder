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
    convenience init(name:String, dateAdded:Date){
        self.init()
        self.name = name
        self.dateAdded = dateAdded
    }
    
    //Properties
    
    dynamic var name = ""
    dynamic var urlString = ""
    dynamic var dateAdded = Date()
    
    
    var url:URL{
        return getURLFromString(self.urlString)
    }

    
    //Meta
    override static func primaryKey() -> String?{
        return "name"
    }
    
    
    
    //Etc
}
