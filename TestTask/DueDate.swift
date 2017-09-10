//
//  DueDate.swift
//  TestTask
//
//  Created by ParaBellum on 9/9/17.
//  Copyright © 2017 ParaBellum. All rights reserved.
//

import Foundation
import RealmSwift
class DueDate:Object{
    dynamic var dateString: String = "" // DD MM, YYYY

    let records = List<Record>()
    dynamic var date = Date()

    override class func primaryKey() -> String {
        return "dateString"
    }
}
