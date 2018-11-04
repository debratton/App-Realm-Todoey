//
//  AppDelegate.swift
//  Todoey
//
//  Created by David E Bratton on 10/30/18.
//  Copyright © 2018 David Bratton. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        //print(Realm.Configuration.defaultConfiguration.fileURL)
        
        // CREATE and ADD NEW REALM DB FOR TESTING
//        let data = Data()
//        data.name = "Anna Bratton"
//        data.age = 47
        
//        do {
//            let realm = try Realm()
//            try realm.write {
//                realm.add(data)
//            }
//        } catch {
//            print(error.localizedDescription)
//        }
        
        do {
            _ = try Realm()

        } catch {
            print(error.localizedDescription)
        }
        return true
    }

}

