//
//  Category.swift
//  Todoey
//
//  Created by David E Bratton on 11/2/18.
//  Copyright © 2018 David Bratton. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name:String = ""
    // MAKE Relationship to ToDo's like we did in CoreData
    // To Many
    let todos = List<ToDo>()
}
