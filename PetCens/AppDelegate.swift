//
//  AppDelegate.swift
//  PetCens
//
//  Created by Infraestructura on 14/10/16.
//  Copyright © 2016 Infraestructura. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UISplitViewControllerDelegate
{
    var window: UIWindow?
    
    func application(application: UIApplication, willFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool
    {
        let origen = NSBundle.mainBundle().pathForResource("PetCens", ofType: "sqlite")
        
        let destino = self.applicationDocumentsDirectory.URLByAppendingPathComponent("PetCens.sqlite")
        
        if !(NSFileManager.defaultManager().fileExistsAtPath(destino!.path!))
        {
            do
            {
                try NSFileManager.defaultManager().copyItemAtPath(origen!, toPath: destino!.path!)
                
            } catch {
                
                print("ERROR: AppDelegate.copyDBToDocuments()")
                
                //abort()
            }
        }
        
        return true
    }
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool
    {
        
        let splitViewController = self.window!.rootViewController as! UISplitViewController
        
        let navigationController = splitViewController.viewControllers[splitViewController.viewControllers.count-1] as! UINavigationController
        
        navigationController.topViewController!.navigationItem.leftBarButtonItem = splitViewController.displayModeButtonItem()
        
        splitViewController.delegate = self
        
        let masterNavigationController = splitViewController.viewControllers[0] as! UINavigationController
        
        let controller = masterNavigationController.topViewController as! MasterViewController
        
        controller.managedObjectContext = self.managedObjectContext
        
        return true
    }
    
    func applicationWillResignActive(application: UIApplication)
    {
        
    }
    
    func applicationDidEnterBackground(application: UIApplication)
    {

    }
    
    func applicationWillEnterForeground(application: UIApplication)
    {

    }
    
    func applicationDidBecomeActive(application: UIApplication)
    {
        
    }
    
    func applicationWillTerminate(application: UIApplication)
    {
        self.saveContext()
    }
    
    func splitViewController(splitViewController: UISplitViewController, collapseSecondaryViewController secondaryViewController:UIViewController, ontoPrimaryViewController primaryViewController:UIViewController) -> Bool
    {
        guard let secondaryAsNavController = secondaryViewController as? UINavigationController else { return false }
        
        guard let topAsDetailController = secondaryAsNavController.topViewController as? DetailViewController else { return false }
        
        if topAsDetailController.detailItem == nil
        {
            return true
        }
        
        return false
    }
    
    lazy var applicationDocumentsDirectory: NSURL =
        {

        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
            
        return urls[urls.count - 1]
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel =
    {
        let modelURL = NSBundle.mainBundle().URLForResource("PetCens", withExtension: "momd")!
        
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("PetCens.sqlite")
        
        var failureReason = "There was an error creating or loading the application's saved data."
        
        do {
            
            try coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil)
            
        } catch {
            
            var dict = [String: AnyObject]()
            
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            
            dict[NSLocalizedFailureReasonErrorKey] = failureReason
            
            dict[NSUnderlyingErrorKey] = error as NSError
            
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            
            abort()
        }
        
        return coordinator
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {

        let coordinator = self.persistentStoreCoordinator
        
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        
        managedObjectContext.persistentStoreCoordinator = coordinator
        
        return managedObjectContext
    }()
    
    func saveContext ()
    {
        if managedObjectContext.hasChanges
        {
            do {
                
                try managedObjectContext.save()
                
            } catch {
                
                let nserror = error as NSError
                
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                
                abort()
            }
        }
    }
}

