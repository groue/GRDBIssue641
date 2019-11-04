//
//  AppDelegate.swift
//  GRDBIssue641
//
//  Created by Gwendal Roué on 04/11/2019.
//  Copyright © 2019 Gwendal Roué. All rights reserved.
//

import UIKit
import GRDB

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let sharedContainerUrl = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.your.group.id")!
        let databaseURL = sharedContainerUrl.appendingPathComponent("db.sqlite", isDirectory: false)
//        let databaseURL = try! FileManager.default
//            .url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
//            .appendingPathComponent("db.sqlite")
        var config = Configuration()
        config.prepareDatabase = { db in
            try db.usePassphrase("secret")
        }
        let dbQueue = try! DatabaseQueue(path: databaseURL.path, configuration: config)
        var migrator = DatabaseMigrator()
        migrator.registerMigration("v1") { db in
            try db.create(table: "player") { t in
                t.autoIncrementedPrimaryKey("id")
                t.column("name", .text)
            }
        }
        try! migrator.migrate(dbQueue)
        try! dbQueue.write { db in
            _ = try Row.fetchAll(db, sql: "SELECT * FROM player")
        }

        // Override point for customization after application launch.
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

