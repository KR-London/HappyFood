//
//  MaybeCollectionViewController.swift
//  TinderClone
//
//  Created by Kate Roberts on 24/09/2018.
//  Copyright © 2018 Kate Roberts. All rights reserved.
//

import UIKit
import CoreData
import MobileCoreServices

let reuseIdentifier = "maybeCell"

@IBDesignable
class MaybeCollectionViewController: UICollectionViewController, CommunicationChannel {

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var food: [NSManagedObject] = []
    var foodArray: [Food]!
    let datafilepath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    var foodsTriedThisWeek: [(String, IndexPath)]!
    
    @IBOutlet var maybeCollectionView : UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        loadItems()
//        foodArray = foodArray.filter{ $0.rating == 2 }
        maybeCollectionView.dragDelegate = self
        maybeCollectionView.dropDelegate = self
        maybeCollectionView.dragInteractionEnabled = true
        
        
        //MARK: Layout hack
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
       // let width = UIScreen.main.bounds.width
        layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 20, right: 10)
        layout.itemSize = CGSize(width: 100, height: 100)
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        layout.scrollDirection = .horizontal
        collectionView!.collectionViewLayout = layout
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadItems()
        foodArray = foodArray.filter{ $0.rating == 2 }
        reloadInputViews()
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return (foodArray.count+1)/2
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "maybeCell", for: indexPath) as! MaybeCollectionViewCell
        
        let cellContentsIndex = 2*indexPath.section + 1 + indexPath.row
        if cellContentsIndex <= foodArray.count
        {
            let plate = foodArray[cellContentsIndex-1]
            cell.displayContent(image: plate.image_file_name!, title: plate.name!)
            if plate.image_file_name == "tick.png"
            {
                cell.layer.borderWidth = 0.0
                cell.displayContent(image: "tick.png", title: "")
            }
            else
            {
                cell.displayContent(image: plate.image_file_name!, title: plate.name!)
            }
        }
        else
        {
            cell.layer.borderWidth = 0.0
        }
       // cell.foodName?.text = "Sec " + indexPath.section.description + "/Item " + indexPath.item.description
         //cell.foodName?.text = plate.name
        return cell
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
    
    /// MARK: Drag and drop helper functions
    
    func dragItems(for indexPath: IndexPath) -> [UIDragItem]{
        let sampledFood = foodArray[indexPath.section]
        let itemProvider = NSItemProvider()
        itemProvider.registerDataRepresentation(forTypeIdentifier: kUTTypePlainText as String, visibility: .all){completion in
            let data = sampledFood.name?.data(using: .utf8)
            completion(data, nil)
            return nil
        }
        
        let dragItem = UIDragItem(itemProvider: itemProvider)
        dragItem.localObject =  sampledFood
        return [dragItem]
    }
}

extension MaybeCollectionViewController: UICollectionViewDragDelegate{
    
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem]
    {
    
        if 2*indexPath.section + indexPath.row >= self.foodArray.count
        {return []  }
        
        let item = self.foodArray[2*indexPath.section + indexPath.row].image_file_name
        
//            /// if I'm dragging a tick, I'm going to interpret that as the user not wanting the tick
//        if item == "tick.png"
//        {
//            // get the stats on this tick
//            let indexPathOfThisTick = foodsTriedThisWeek[0].1
//            var imageFileNameForTheFoodBehindThisTick = String()
//
//            let request : NSFetchRequest<Food> = Food.fetchRequest()
//            do
//            {
//                var foodArrayFull = try context.fetch(request)
//
//                //// look up the image file name in the underlying database
//                let updatedVersionOfThisFood = foodArrayFull.filter{$0.name == foodsTriedThisWeek[0].0 }.filter{$0.image_file_name != "tick.png" }.first!
//                imageFileNameForTheFoodBehindThisTick = updatedVersionOfThisFood.image_file_name!
//
//                /// remove the previously updated to avoid duplication
//                updatedVersionOfThisFood.rating = 4
//              //foodArrayFull = Array(foodArrayFull.drop{$0 == updatedVersionOfThisFood})
//               // context.delete(re)
//
//                /// change the database entry to have the tick entry restored back to previous state
//                foodArrayFull.filter{$0.name == foodsTriedThisWeek[0].0 }.first!.image_file_name = imageFileNameForTheFoodBehindThisTick
//
//                /// update the cell
//                let cell = self.maybeCollectionView.cellForItem(at: foodsTriedThisWeek[0].1) as! MaybeCollectionViewCell
//                cell.displayContent(image: imageFileNameForTheFoodBehindThisTick, title: "foodsTriedThisWeek[0].0")
//                cell.layer.borderWidth = 5.0
//
//
//                /// If this works correctly, I won;t have any duplicate entries now
//
//
//
//
//
//            }
//            catch
//            {
//                print("Error fetching data \(error)")
//            }
//
//            /// change the tick into the correct picture
//
//
//
//            /// delete the alterantive entry from food array full. how do i do this without crashing....?
//
//            /// clean up foods tried this week
//           foodsTriedThisWeek = Array(foodsTriedThisWeek.dropFirst())
//
//            return []
//        }
        
       // let item = self.foodArray[2*indexPath.section + indexPath.row].image_file_name
        let itemProvider = NSItemProvider(object: item! as! String as NSItemProviderWriting)
        
        let dragItem = UIDragItem(itemProvider: itemProvider)
        dragItem.localObject = item
        foodsTriedThisWeek = [( self.foodArray[2*indexPath.section + indexPath.row].name ?? "no idea", indexPath)]
        print(foodsTriedThisWeek)
        return [dragItem]
        
    }
}

extension MaybeCollectionViewController: UICollectionViewDropDelegate{
    
    public func canHandle(_ session: UIDropSession) -> Bool {
        return session.canLoadObjects(ofClass: NSString.self)
    }

    
    func  collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        if collectionView.hasActiveDrag{
            if session.items.count > 1 {
                return UICollectionViewDropProposal(operation: .cancel)
            }
            else{
                return UICollectionViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
            }
        }
        else{
            return UICollectionViewDropProposal(operation: .copy, intent: .insertAtDestinationIndexPath)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        
        
        

       let destinationIndexPath: IndexPath
        if let indexPath = coordinator.destinationIndexPath{
            destinationIndexPath = indexPath
        }
        else{
            let section = collectionView.numberOfSections - 1
            let row = collectionView.numberOfItems(inSection: section)
            destinationIndexPath = IndexPath(row: row, section: section)
        }
        
        for item in coordinator.items{
            if let pet = item.dragItem.localObject as? String{
               // print("Hello drsgged item. I've been expecting you!")
                var draggedFood: Food
                let request : NSFetchRequest<Food> = Food.fetchRequest()
                do
                {
                    let foodArrayFull = try context.fetch(request)
                    draggedFood = foodArrayFull.filter{$0.image_file_name == pet}.first!
                    foodArray.insert(draggedFood, at: 2*destinationIndexPath.section + destinationIndexPath.row )
                    foodArray.remove(at: 2*(item.sourceIndexPath?.section)! + item.sourceIndexPath!.row)
                }
                catch
                {
                    print("Error fetching data \(error)")
                }
                DispatchQueue.main.async {
                    self.maybeCollectionView.insertItems(at: [destinationIndexPath])
                }
            }
            
    }
}
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func updateSourceCellWithASmiley(sourceIndexPath: IndexPath, sourceViewController: String) {
        print("Message Received from \(sourceViewController)")

        if sourceViewController == "deletetick"
        {
//            // get the stats on this tick
//            let indexPathOfThisTick = foodsTriedThisWeek[0].1
//            var imageFileNameForTheFoodBehindThisTick = String()
//
//            let request : NSFetchRequest<Food> = Food.fetchRequest()
//            do
//            {
//                var foodArrayFull = try context.fetch(request)
//
//                //// look up the image file name in the underlying database
//                let updatedVersionOfThisFood = foodArrayFull.filter{$0.name == foodsTriedThisWeek[0].0 }.filter{$0.image_file_name != "tick.png" }.first!
//                imageFileNameForTheFoodBehindThisTick = updatedVersionOfThisFood.image_file_name!
//
//                /// remove the previously updated to avoid duplication
//                foodArrayFull = Array(foodArrayFull.drop{$0 == updatedVersionOfThisFood})
//
//                /// change the database entry to have the tick entry restored back to previous state
//                foodArrayFull.filter{$0.name == foodsTriedThisWeek[0].0 }.first!.image_file_name = imageFileNameForTheFoodBehindThisTick
//
//                /// If this works correctly, I won;t have any duplicate entries now
//
//            }
//            catch
//            {
//                print("Error fetching data \(error)")
//            }
//
//            /// change the tick into the correct picture
//
//            let cell = self.maybeCollectionView.cellForItem(at: foodsTriedThisWeek[0].1) as! MaybeCollectionViewCell
//            cell.displayContent(image: "imageFileNameForTheFoodBehindThisTick", title: "foodsTriedThisWeek[0].0")
//            cell.layer.borderWidth = 5.0
//
//            /// delete the alterantive entry from food array full. how do i do this without crashing....?
//
//            /// clean up foods tried this week
//            foodsTriedThisWeek = Array(foodsTriedThisWeek.dropFirst())
        }
        else{
            let triedFoodImage = foodArray.filter{ $0.name == foodsTriedThisWeek[0].0 }[0].image_file_name
            var rating = 2
            if sourceViewController == "sentFromGreenRibbon" { rating = 1}
            if sourceViewController == "sentFromRedRibbon" { rating = 2}
        
            /// here I create a new entry in the database for the tried food, with an updated rating
            if let managedObjectContext = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
                let menuItem = NSEntityDescription.insertNewObject(forEntityName: "Food", into: managedObjectContext) as! Food
                menuItem.image_file_name = triedFoodImage
                menuItem.name = foodsTriedThisWeek[0].0
                menuItem.rating = Int16(rating)
                 foodArray.append(menuItem)
            }
        
            /// here I update the picture with 'tick' image - but i leave the other data untouched, because I want to be able to restore it if this tick was placed in error.
            foodArray[2*foodsTriedThisWeek[0].1.section + foodsTriedThisWeek[0].1.row].image_file_name = "tick.png"

            let cell = self.maybeCollectionView.cellForItem(at: foodsTriedThisWeek[0].1) as! MaybeCollectionViewCell

            cell.displayContent(image: "tick.png", title: "")
            cell.layer.borderWidth = 0.0
        }
    }
}


