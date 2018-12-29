//
//  ViewController.swift
//  TinderClone
//
//  Created by Kate Roberts on 06/09/2018.
//  Copyright © 2018 Kate Roberts. All rights reserved.
//

///this is the branch

import UIKit
import CoreData

class ViewController: UIViewController{

    @IBAction func resetButton(_ sender: Any) {
        preloadData()
    }
    //@IBAction func buttonRHSpressed(_ sender: Any) {
//      //  performSegue.withIdentifier("goToMotivation")
//        //transitionToRibbonsStoryboard()//    }//MARK: Define my variables to work with the database
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var food: [NSManagedObject] = []
    var foodArray: [Food]!
    let datafilepath = FileManager.default.urls(for: .documentDirectory,
                                                in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    //MARK: My local variables for my code
    var currentlyPicturedFood: Food!
    var currentlyPicturedFoodIndex = Int()
    var unratedFood: [Food]!

    override func viewDidLoad() {
        super.viewDidLoad()
        print(datafilepath)
        preloadData()
        loadItems()
        unratedFood = foodArray.filter{$0.rating == 0}
        if unratedFood.count == 0
        {
            transitionToRibbonsStoryboard()
           // noUnratedFood()
//                let alert = UIAlertController(title: "You've rated all the food!", message: "Would you like to reload the blank database?", preferredStyle: .actionSheet)
//                let action = UIAlertAction(title: "Reload", style: .default){ (action) in self.preloadData(); print("I'm in the closure") }
//                alert.addAction(action)

            
            //        let secondFrame = CGRect(x: 120, y: 130, width: 250, height: 250)
            //        let secondView = UIView(frame: secondFrame)
            //        secondView.backgroundColor = UIColor.green
            //        view.addSubview(secondView)
            
             //   view.addSubview(alert.view)
                //secondView.addSubview(alert.view)
               // present(alert, animated: true, completion: nil)
               // self.show(alert, sender: alert)
        }
        else
        {
            currentlyPicturedFoodIndex = Int(arc4random_uniform(UInt32(unratedFood.count - 1)))
            currentlyPicturedFood = unratedFood[currentlyPicturedFoodIndex]
            foodImage.image = UIImage(named: currentlyPicturedFood.image_file_name!)
        }
        
        /// define swipe directions
        
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeLeft.direction = .left
        self.view.addGestureRecognizer(swipeLeft)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeRight.direction = .right
        self.view.addGestureRecognizer(swipeRight)
        
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeUp.direction = .up
        self.view.addGestureRecognizer(swipeUp)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeDown.direction = .down
        self.view.addGestureRecognizer(swipeDown)
        
    }
    
    @IBAction func reloadData(_ sender: Any) {
        preloadData()
    }
    //MARK: Actions and outlets

    @IBOutlet weak var foodImage: UIImageView!
    
    @IBOutlet weak var swipeDirectionLabel: UILabel!
    
    func updatePicture(){
        saveItems()
        //        ///future self, please add some code to handle the case where there are no unrated foods/ to allow for previously rated foods to be presented.
        /// filter food array so you're only seeing unrated ones
        unratedFood = unratedFood.filter{$0 != currentlyPicturedFood}
        
       
        if unratedFood.count == 0 {
            
            transitionToRibbonsStoryboard()
//            let alert =
//            UIAlertAction("You've rated all the foods!")
            noUnratedFood()
            return
            
        }
        if unratedFood.count > 1
        { /// load a picuture of a random one of these
        currentlyPicturedFoodIndex = Int(arc4random_uniform(UInt32(unratedFood.count - 1)))
        currentlyPicturedFood = unratedFood[currentlyPicturedFoodIndex]
        }
        else
        {
            currentlyPicturedFood = unratedFood[0]
        }
        foodImage.image = UIImage(named: currentlyPicturedFood.image_file_name!)
    }
    
    func loadItems(){
            let request : NSFetchRequest<Food> = Food.fetchRequest()
            do{
               try
               foodArray = context.fetch(request)
            }
            catch
            {
                print("Error fetching data \(error)")
            }
    }
    
    func saveItems(){
        do{ try context.save() }
        catch{
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            
        }
    }
    
    func preloadData () {
        // Retrieve data from the source file
        if let contentsOfURL = Bundle.main.url(forResource: "FoodData", withExtension: "csv") {
            
            // Remove all the menu items before preloading
            removeData()
            if let items = parseCSV(contentsOfURL: contentsOfURL as NSURL, encoding: String.Encoding.utf8) {
                // Preload the menu items
                if let managedObjectContext = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
                    for item in items {
                        let menuItem = NSEntityDescription.insertNewObject(forEntityName: "Food", into: managedObjectContext) as! Food
                        menuItem.image_file_name = item.image_file_name
                        menuItem.name = item.name
                        menuItem.rating = Int16(item.rating)
                        
                        //                        if managedObjectContext.save() != true {
                        //                            print("insert error: \(error!.localizedDescription)")
                        //                        }
                    }
                }
            }
        }
        loadItems()
        
        unratedFood = foodArray.filter{$0.rating == 0}
        currentlyPicturedFoodIndex = Int(arc4random_uniform(UInt32(unratedFood.count - 1)))
        currentlyPicturedFood = unratedFood[currentlyPicturedFoodIndex]
        foodImage.image = UIImage(named: currentlyPicturedFood.image_file_name!)
    }
    
    func removeData () {
        // Remove the existing items
        if let managedObjectContext = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext  {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Food")
            var menuItems: [Food]
            
            do
            {
                menuItems = try managedObjectContext.fetch(fetchRequest) as! [Food]
            }
            catch
            {
                print("Failed to retrieve record")
                return
            }
            
            for menuItem in menuItems
            {
                managedObjectContext.delete(menuItem)
            }
        }
    }

    func parseCSV(contentsOfURL: NSURL, encoding: String.Encoding) -> [(image_file_name: String, name: String, rating: Int)]?
    {
        /// load CSV function
        let delimiter = ","
        var items:[(image_file_name: String, name: String, rating: Int)]?
        
        let optContent = try? String(contentsOf: contentsOfURL as URL)
        guard let content = optContent
            else
        {
            print("That didn't work!")
            return items
        }
        
        items = []
        
        let lines:[String] = content.components(separatedBy: NSCharacterSet.newlines)
        
        for line in lines{
            var values:[String] = []
            if line != ""
            {
                if line.range( of: "\"" ) != nil
                {
                    var textToScan: String = line
                    var value:NSString?
                    var textScanner:Scanner = Scanner(string: textToScan)
                    while textScanner.string != ""
                    {
                        if (textScanner.string as NSString).substring(to: 1) == "\"" {
                            textScanner.scanLocation += 1
                            textScanner.scanUpTo("\"", into: &value)
                            textScanner.scanLocation += 1
                        } else {
                            textScanner.scanUpTo(delimiter, into: &value)
                        }
                        
                        // Store the value into the values array
                        values.append(value! as String)
                    }
                    
                    // Retrieve the unscanned remainder of the string
                    if textScanner.scanLocation < textScanner.string.count {
                        textToScan = (textScanner.string as NSString).substring(from: textScanner.scanLocation + 1)
                    } else {
                        textToScan = ""
                    }
                    textScanner = Scanner(string: textToScan)
                }
                else  {
                    values = line.components(separatedBy: delimiter)
                }
                
                ///image_file_name: String, name: String, rating: Int
                // Put the values into the tuple and add it to the items array
                let item = (image_file_name: values[0], name: values[1], rating: Int(values[2]) ?? 0 )
                items?.append(item )
            }
        }
        //print(items)
        return items
    }
    
    func noUnratedFood()
    {
       
//        let alert = UIAlertController(title: "You've rated all the food!", message: "Would you like to reload the blank database?", preferredStyle: .actionSheet)
//        alert.addAction(UIAlertAction(title: "Reload", style: .default, handler: nil))
//
////        let secondFrame = CGRect(x: 120, y: 130, width: 250, height: 250)
////        let secondView = UIView(frame: secondFrame)
////        secondView.backgroundColor = UIColor.green
////        view.addSubview(secondView)
//
//        self.view.addSubview(alert.view)
//        //secondView.addSubview(alert.view)
//        self.present(alert, animated: true, completion: nil)

    }
    
    @objc func handleGesture(gesture: UISwipeGestureRecognizer) -> Void {
        if gesture.direction == UISwipeGestureRecognizer.Direction.right {
            //print("Swipe Right")
            
            foodArray[foodArray.index(of: currentlyPicturedFood)!].rating = 2
            updatePicture()
            /// This was the segue code
//            let mainStoryBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
//
//            guard let destinationVC = mainStoryBoard.instantiateViewController(withIdentifier: "trafficLightStoryboard") as? CustomViewController
//                else
//            {
//                print("Couldn't find view controller")
//                return
//            }
//
//            navigationController?.pushViewController(destinationVC, animated: true)
 
        }
        else if gesture.direction == UISwipeGestureRecognizer.Direction.left {
            //print("Swipe Left")
  
            foodArray[foodArray.index(of: currentlyPicturedFood)!].rating = 2
            updatePicture()
        }
        else if gesture.direction == UISwipeGestureRecognizer.Direction.up {
           // print("Swipe Up")
 
            
            foodArray[foodArray.index(of: currentlyPicturedFood)!].rating = 1
            updatePicture()
        }
        else if gesture.direction == UISwipeGestureRecognizer.Direction.down {
           // print("Swipe Down")
            
            foodArray[foodArray.index(of: currentlyPicturedFood)!].rating = 3
            updatePicture()
            //self.storyboard
            
  
      
            
            //onButtonTapped()
           // performSegue(withIdentifier: goToData, sender: self)
        }
    }

    func transitionToRibbonsStoryboard(){
        let mainStoryBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        guard let destinationVC = mainStoryBoard.instantiateViewController(withIdentifier: "tellMeMotivation") as? MotivationViewController
            else
        {
            print("Couldn't find view controller")
            return
        }
        
        navigationController?.pushViewController(destinationVC, animated: true)
    }
    
}




