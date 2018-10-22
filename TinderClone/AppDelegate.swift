//
//  AppDelegate.swift
//  TinderClone
//
//  Created by Kate Roberts on 06/09/2018.
//  Copyright © 2018 Kate Roberts. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

   // let delegate = UIApplication.shared.delegate as! AppDelegate

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        //preloadData()
        return true
    }


    func applicationWillTerminate(_ application: UIApplication) {
        self.saveContext()
    }

    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TinderClone")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
//    func parseCSV(contentsOfURL: NSURL, encoding: String.Encoding) -> [(image_file_name: String, name: String, rating: Int)]?
//    {
//        /// load CSV function
//        let delimiter = ","
//        var items:[(image_file_name: String, name: String, rating: Int)]?
//        
//        let optContent = try? String(contentsOf: contentsOfURL as URL!)
//        guard let content = optContent
//            else
//        {
//            print("That didn't work!")
//            return items
//        }
//        
//        items = []
//        
//        let lines:[String] = content.components(separatedBy: NSCharacterSet.newlines)
//        
//        for line in lines{
//            var values:[String] = []
//            if line != ""
//            {
//                if line.range( of: "\"" ) != nil
//                {
//                    var textToScan: String = line
//                    var value:NSString?
//                    var textScanner:Scanner = Scanner(string: textToScan)
//                    while textScanner.string != ""
//                    {
//                        if (textScanner.string as NSString).substring(to: 1) == "\"" {
//                            textScanner.scanLocation += 1
//                            textScanner.scanUpTo("\"", into: &value)
//                            textScanner.scanLocation += 1
//                        } else {
//                            textScanner.scanUpTo(delimiter, into: &value)
//                        }
//                        
//                        // Store the value into the values array
//                        values.append(value as! String)
//                    }
//                    
//                    // Retrieve the unscanned remainder of the string
//                    if textScanner.scanLocation < textScanner.string.count {
//                        textToScan = (textScanner.string as NSString).substring(from: textScanner.scanLocation + 1)
//                    } else {
//                        textToScan = ""
//                    }
//                    textScanner = Scanner(string: textToScan)
//                }
//                else  {
//                    values = line.components(separatedBy: delimiter)
//                }
//                
//                ///image_file_name: String, name: String, rating: Int
//                // Put the values into the tuple and add it to the items array
//                let item = (image_file_name: values[0], name: values[1], rating: Int(values[2]) ?? 0 )
//                items?.append(item as! (image_file_name: String, name: String, rating: Int ))
//            }
//        }
//        //print(items)
//        return items
//    }
    
   
//    func preloadData () {
//        // Retrieve data from the source file
//        if let contentsOfURL = Bundle.main.url(forResource: "FoodData", withExtension: "csv") {
//            
//            // Remove all the menu items before preloading
//           removeData()
//            
//            var error:NSError?
//            if let items = parseCSV(contentsOfURL: contentsOfURL as NSURL, encoding: String.Encoding.utf8) {
//                // Preload the menu items
//                if let managedObjectContext = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
//                    for item in items {
//                        let menuItem = NSEntityDescription.insertNewObject(forEntityName: "Food", into: managedObjectContext) as! Food
//                        menuItem.image_file_name = item.image_file_name
//                        menuItem.name = item.name
//                        menuItem.rating = Int16(item.rating)
//                        
////                        if managedObjectContext.save() != true {
////                            print("insert error: \(error!.localizedDescription)")
////                        }
//                    }
//                }
//            }
//        }
//    }
//    
//    func removeData () {
//        // Remove the existing items
//        if let managedObjectContext = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext  {
//            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Food")
//            var menuItems: [Food]
//            
//            do
//            {
//                menuItems = try managedObjectContext.fetch(fetchRequest) as! [Food]
//            }
//            catch
//            {
//                print("Failed to retrieve record")
//                return
//            }
//            
//            for menuItem in menuItems
//            {
//                managedObjectContext.delete(menuItem)
//            }
//        }
//    }
    
    }


