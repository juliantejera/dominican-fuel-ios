//
//  AppDelegate.swift
//  DominicanFuel
//
//  Created by Julian Tejera on 3/18/15.
//  Copyright (c) 2015 Julian Tejera. All rights reserved.
//

import UIKit
import CoreData
import Fabric
import Crashlytics

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, ManagedDocumentCoordinatorDelegate {

    var window: UIWindow?
    var document: UIManagedDocument?
    
    func setupAppirater() {
        Appirater.setAppId("986018933")
        Appirater.setDaysUntilPrompt(5)
        Appirater.setUsesUntilPrompt(5)
        Appirater.setSignificantEventsUntilPrompt(-1)
        Appirater.setTimeBeforeReminding(2)
        Appirater.setDebug(false)
        Appirater.appLaunched(true)
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        Fabric.with([Crashlytics.self])
        setupAppirater()
        
        let coordinator = ManagedDocumentCoordinator()
        coordinator.delegate = self
        coordinator.setupDocument("DominicanFuel")
        return true
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        Appirater.appEnteredForeground(true)
    }

    // MARK: Remote Notifications
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        var token = deviceToken.description.trimmingCharacters(in: CharacterSet(charactersIn: "<>"))
        token = token.replacingOccurrences(of: " ", with: "")        
        print("Device Token: \(token)")
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        application.applicationIconBadgeNumber = 0
        if (application.applicationState == UIApplicationState.inactive) {
            // Instantiate VC from notification
        }
        
    }
    
    // MARK: - Managed Document Coordinator Delegate
    
    func managedDocumentCoordinator(_ coordinator: ManagedDocumentCoordinator, didOpenDocument document: UIManagedDocument) {
        self.document = document
        if let tabBarController = self.window?.rootViewController as? UITabBarController {
            if let fuelsTableViewController = tabBarController.viewControllers?.first?.contentViewController as? FuelsTableViewController {
                fuelsTableViewController.document = document
            }
            
            if let splitViewController = tabBarController.viewControllers?[1] as? UISplitViewController {
                
                if let filterPickerController = splitViewController.viewControllers.first?.contentViewController as? FilterPickerTableViewController {
                    filterPickerController.document = document
                }
                
                if let chartViewController = splitViewController.viewControllers.last?.contentViewController as? ChartViewController {
                    chartViewController.document = document
                }

            }
        }
        
        let seeder = CoreDataSeeder(document: document)
        seeder.seed()
    }
    
    func managedDocumentCoordinator(_ coordinator: ManagedDocumentCoordinator, didFailWithError error: NSError) {
        // Handle error
        print("Error: \(error)")
    }
    
}

