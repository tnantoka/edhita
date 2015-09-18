//
//  AppDelegate.swift
//  Edhita
//
//  Created by Tatsuya Tobioka on 10/7/14.
//  Copyright (c) 2014 tnantoka. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UISplitViewControllerDelegate, EDHFinderDelegate {

    var window: UIWindow?

    var splitController: UISplitViewController!
    var editorController: EditorViewController!

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)

        self.setAppearance()
        self.initExample()
        
        self.editorController = EditorViewController()
        let _ = editorController.view // Force load view
        let editorNavController = UINavigationController(rootViewController: self.editorController)

        EDHFinder.sharedFinder().toolbarHidden = false
        EDHFinder.sharedFinder().finderDelegate = self
        let masterNavController = EDHFinder.sharedFinder().listNavigationControllerWithDelegate(editorController)
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            if let listController = masterNavController.topViewController as? UITableViewController {
                listController.clearsSelectionOnViewWillAppear = false
                listController.preferredContentSize = CGSize(width: 320.0, height: 600.0)
            }
        }
        
        self.splitController = UISplitViewController()
        self.splitController.viewControllers = [masterNavController, editorNavController]
        self.splitController.delegate = self
        
        editorController.navigationItem.leftBarButtonItem = self.splitController.displayModeButtonItem()
        editorController.navigationItem.leftItemsSupplementBackButton = true
        
        self.window?.rootViewController = self.splitController
        self.window?.makeKeyAndVisible()
        
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
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    // MARK: - UISplitViewControllerDelegate

    func splitViewController(splitViewController: UISplitViewController, collapseSecondaryViewController secondaryViewController:UIViewController, ontoPrimaryViewController primaryViewController:UIViewController) -> Bool {
        if let secondaryAsNavController = secondaryViewController as? UINavigationController {
            if let topAsDetailController = secondaryAsNavController.topViewController as? EditorViewController {
                if topAsDetailController.finderItem == nil {
                    // Return true to indicate that we have handled the collapse by doing nothing; the secondary controller will be discarded.
                    return true
                }
            }
        }
        return false
    }

    // MARK: - EDHFinderDelegate
    
    func listViewControllerWithPath(path: String!, delegate: EDHFinderListViewControllerDelegate!) -> EDHFinderListViewController! {
        return FinderListViewController(path: path, delegate: delegate)
    }
    
    // MARK: - Utilities
    
    func setAppearance() {
        // 118, 122, 133
        // #767a85
        UINavigationBar.appearance().barTintColor = UIColor.coolGrayColor()
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        UINavigationBar.appearance().titleTextAttributes = [ NSForegroundColorAttributeName: UINavigationBar.appearance().tintColor ]
        
        UIToolbar.appearance().barTintColor = UINavigationBar.appearance().barTintColor
        UIToolbar.appearance().tintColor = UINavigationBar.appearance().tintColor
    }

    func initExample() {
        //EDHUtility.setIsFirstLaunch(true)
        if EDHUtility.isFirstLaunch() {
            let fromPath = NSBundle.mainBundle().pathForResource("bootstrap", ofType: nil)
            let toPath = (EDHFinder.sharedFinder().rootPath as NSString).stringByAppendingPathComponent("example")
            FCFileManager.copyItemAtPath(fromPath, toPath: toPath)
            EDHUtility.setIsFirstLaunch(false)
        }
    }

}

