//
//  AppDelegate.swift
//  SnackBlend Kiosk
//
//  Created by Eric Meadows on 3/1/17.
//  Copyright © 2017 Calmlee. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    // Unit Testing
//    var unitTesting = true
//    var arduinoTesting = true
    var unitTesting = false
    var arduinoTesting = false
    
    var window: UIWindow?
    let defaults = UserDefaults.standard
    var paymentViewController = PaymentViewController()
    var lightningSerialCable = LightningSerialCable()
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        if let rootViewController = self.topViewControllerWithRootViewController(rootViewController: window?.rootViewController) {
            if (rootViewController.responds(to: Selector(("canRotate")))) {
                // Unlock landscape view orientations for this view controller
                return .allButUpsideDown;
            }
        }
        return .portrait;
    }
    
    private func topViewControllerWithRootViewController(rootViewController: UIViewController!) -> UIViewController? {
        if (rootViewController == nil) { return nil }
        if (rootViewController.isKind(of: (UITabBarController).self)) {
            return topViewControllerWithRootViewController(rootViewController: (rootViewController as! UITabBarController).selectedViewController)
        } else if (rootViewController.isKind(of:(UINavigationController).self)) {
            return topViewControllerWithRootViewController(rootViewController: (rootViewController as! UINavigationController).visibleViewController)
        } else if (rootViewController.presentedViewController != nil) {
            return topViewControllerWithRootViewController(rootViewController: rootViewController.presentedViewController)
        }
        return rootViewController
    }
    


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        createLogs()
        uploadLogs()
        
        lightningSerialCable.enableComms()
        
        NSSetUncaughtExceptionHandler { (exception) in
            NSLog("<EXCEPTION> = NSUnsetUncaughtExceptionHandler")
        }
        
        signal(SIGABRT) { (_) in
            NSLog("<EXCEPTION> = SIGABRT")
        }
        signal(SIGILL) { (_) in
            NSLog("<EXCEPTION> = SIGILL")
        }
        
        signal(SIGSEGV) { (_) in
            NSLog("<EXCEPTION> = SIGSEGV")
        }
        signal(SIGFPE) { (_) in
            NSLog("<EXCEPTION> = SIGFPE")
        }
        signal(SIGBUS) { (_) in
            NSLog("<EXCEPTION> = SIGBUS")
        }
        
        signal(SIGPIPE) { (_) in
            NSLog("<EXCEPTION> = SIGPIPE")
        }
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        print("aWT reached")
    }


}

