//
//  ToDo.swift
//  Todoey
//
//  Created by David E Bratton on 11/2/18.
//  Copyright © 2018 David Bratton. All rights reserved.
//

import Foundation
import RealmSwift

class ToDo: Object {
    @objc dynamic var title:String = ""
    @objc dynamic var done:Bool = false
    @objc dynamic var dateCreated: Date?
    // Inverse relationship to one
    var parentCategory = LinkingObjects(fromType: Category.self, property: "todos")
}
