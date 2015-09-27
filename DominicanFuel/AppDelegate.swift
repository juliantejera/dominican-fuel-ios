//
//  AppDelegate.swift
//  DominicanFuel
//
//  Created by Julian Tejera on 3/18/15.
//  Copyright (c) 2015 Julian Tejera. All rights reserved.
//

import UIKit
import CoreData

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
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        application.registerUserNotificationSettings(UIUserNotificationSettings(forTypes: [.Sound, .Badge, .Alert], categories: nil))
        application.registerForRemoteNotifications()
        
        
        if let _ = launchOptions?[UIApplicationLaunchOptionsRemoteNotificationKey] as? [NSObject: AnyObject] {
            application.applicationIconBadgeNumber = 0
            
        }
        
        setupAppirater()
        
        let coordinator = DominicanFuelManagedDocumentCoordinator()
        coordinator.delegate = self
        coordinator.setupDocument()
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
        Appirater.appEnteredForeground(true)
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    // MARK: Remote Notifications
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        var token = deviceToken.description.stringByTrimmingCharactersInSet(NSCharacterSet(charactersInString: "<>"))
        token = token.stringByReplacingOccurrencesOfString(" ", withString: "")
        
        let mobileDevice = MobileDevice(pushNotificationToken: token)
        MobileDeviceRepository().create(mobileDevice, callback: { (response) -> Void in
            // NO ACTION
        })
        
        print("Device Token: \(token)")
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        application.applicationIconBadgeNumber = 0
        if (application.applicationState == UIApplicationState.Inactive) {
            // Instantiate VC from notification
        }
        
    }
    
    // MARK: - Managed Document Coordinator Delegate
    
    func managedDocumentCoordinator(coordinator: ManagedDocumentCoordinator, didOpenDocument document: UIManagedDocument) {
        self.document = document
        if let tabBarController = self.window?.rootViewController as? UITabBarController {
            if let fuelsTableViewController = tabBarController.viewControllers?.first?.contentViewController as? FuelsTableViewController {
                fuelsTableViewController.document = document
            }
            
            if let splitViewController = tabBarController.viewControllers?[1] as? UISplitViewController {
                
                if let timestampViewController = splitViewController.viewControllers.first?.contentViewController as? ChartTimespanTableViewController {
                    timestampViewController.document = document
                }
                
                if let chartViewController = splitViewController.viewControllers.last?.contentViewController as? ChartViewController {
                    chartViewController.document = document
                }

            }
        }
        
        let seeder = CoreDataSeeder(document: document)
        seeder.seed()
    }
    
    func managedDocumentCoordinator(coordinator: ManagedDocumentCoordinator, didFailWithError error: NSError) {
        // Handle error
        print("Error: \(error)")
    }
    
}

