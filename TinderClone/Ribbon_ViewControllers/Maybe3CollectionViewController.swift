import UIKit
import CoreData
import MobileCoreServices

import MobileCoreServices

let maybe3ReuseIdentifier = "maybe3Cell"
var foodsTriedThisWeek: [(String?, IndexPath, String)]!

class Maybe3CollectionViewController: UICollectionViewController, CommunicationChannel {
    
    weak var delegate: CommunicationChannel?
    
    
     @IBOutlet var maybe3CollectionView: UICollectionView!
    
    
 
   // weak var delegate: CommunicationChannel?
    var whereDidTheSegueComeFrom = ""
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var food: [NSManagedObject] = []
    var foodArray: [Food]!
    let datafilepath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")

    override func viewDidLoad() {
        super.viewDidLoad()
        //self.view.backgroundColor = UIColor.blue
        //        loadItems()
        //        foodArray = foodArray.filter{ $0.rating == 2 }
     //   self.view.backgroundColor = UIColor(patternImage: UIImage(named:"Maybe.png")!)
        //MARK: Layout hack
        
        maybe3CollectionView.dragDelegate = self
        maybe3CollectionView.dropDelegate = self
        maybe3CollectionView.dragInteractionEnabled = true
        
        self.view.frame.size = CGSize(width: 250, height: 700)
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        // let width = UIScreen.main.bounds.width
        
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 10)
        layout.itemSize = CGSize(width: 100, height: 100)
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        layout.scrollDirection = .horizontal
        
        collectionView!.collectionViewLayout = layout
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadItems()
        foodArray = foodArray.filter{ $0.rating == 2}
        
        var temp = [Food]()
        if foodArray != nil
        {
            if foodArray.count > 1
            {
        for i in 0...(foodArray.count-1)
        {
            if i % 2 == 0
            {
                temp = temp + [foodArray[i]]
                // print( temp.flatMap{$0.name} )
            }
        }
        
        foodArray = temp
        reloadInputViews()
            }
        }
    }
            
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using [segue destinationViewController].
     // Pass the selected object to the new view controller.
     }
     */
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return foodArray.count
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "maybeCell", for: indexPath) as! MaybeCollectionViewCell
        
        // let cellContentsIndex = 2*indexPath.section + 1 + indexPath.row
        let cellContentsIndex =  indexPath.row
        if cellContentsIndex < foodArray.count
        {
            let plate = foodArray[cellContentsIndex]
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
        // cell.foodName?.text = plate.name
        return cell
    }
    //
    //    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    //        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: maybe2ReuseIdentifier, for: indexPath)
    //
    //        // Configure the cell
    //
    //        return cell
    //    }
    
    // MARK: UICollectionViewDelegate
    
    /*
     // Uncomment this method to specify if the specified item should be highlighted during tracking
     override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
     return true
     }
     */
    
    /*
     // Uncomment this method to specify if the specified item should be selected
     override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
     return true
     }
     */
    
    /*
     // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
     override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
     return false
     }
     
     override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
     return false
     }
     
     override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
     
     }
     */
    
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
    
    func updateSourceCellWithASmiley(sourceIndexPath: IndexPath, sourceViewController: String) {
        
//        print("hello from amber 3")
//
//        if sourceIndexPath == IndexPath( item: 99, section: 99) {
//            whereDidTheSegueComeFrom = sourceViewController
//            return
//        }
//
//        if foodsTriedThisWeek[0].2 == "fromTopMaybeRibbon"
//        {
//            let triedFoodImage = foodArray.filter{ $0.name == foodsTriedThisWeek![0].0 }[0].image_file_name
//            var rating = 2
//            if sourceViewController == "sentFromGreenRibbon" { rating = 1}
//            if sourceViewController == "sentFromRedRibbon" { rating = 3}
//
//            /// here I create a new entry in the database for the tried food, with an updated rating
//            if let managedObjectContext = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
//                let menuItem = NSEntityDescription.insertNewObject(forEntityName: "Food", into: managedObjectContext) as! Food
//                menuItem.image_file_name = triedFoodImage
//                menuItem.name = foodsTriedThisWeek![0].0
//                menuItem.rating = Int16(rating)
//                foodArray.append(menuItem)
//            }
        
            /// here I update the picture with 'tick' image - but i leave the other data untouched, because I want to be able to restore it if this tick was placed in error.
            //foodArray[foodsTriedThisWeek[0].1.row].image_file_name = "tick.png"
                //collectionView( maybe2CollectionView, cellForItemAt: foodsTriedThisWeek[0].1).delete(self)
          //  self.collectionView.deleteItems(at: [foodsTriedThisWeek[0].1])
            //  self.collectionView.reloadItems(at: [foodsTriedThisWeek[0].1])
            //  collectionView(collectionView, cellForItemAt:
            //maybe3CollectionView.cellForItem(at: foodsTriedThisWeek[0].1)?.delete(self)
            //reloadInputViews()
            //let cell = self.maybe2CollectionView.cellForItem(at: foodsTriedThisWeek[0].1) as! Maybe2CollectionViewCell
        
            //cell.displayContent(image: "tick.png", title: "")
            //cell.layer.borderWidth = 0.0
        
            foodArray.remove(at: foodsTriedThisWeek[0].1.row)
            foodArray = foodArray.filter{ $0.rating == 2 }
            //self.reloadInputViews()
            self.collectionView!.reloadData()
            self.collectionView!.numberOfItems(inSection: 0)
            // self.collectionView.deleteItems(at: [foodsTriedThisWeek[0].1])
            //self.collectionView(collectionView, cellForItemAt: foodsTriedThisWeek[0].1).
            // let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "maybeCell", for: foodsTriedThisWeek[0].1) as! MaybeCollectionViewCell
        
            // cell.foodImage = nil
            // cell.layer.borderWidth = 0.0
            // cell.reloadInputViews()
       // }
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


extension Maybe3CollectionViewController: UICollectionViewDragDelegate{
    
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem]
    {
        
        if indexPath.row >= self.foodArray.count
        {return []  }
        
        
        let item = self.foodArray[indexPath.row].image_file_name
        
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
        let itemProvider = NSItemProvider(object: item! as NSItemProviderWriting)
        
        let dragItem = UIDragItem(itemProvider: itemProvider)
        dragItem.localObject = item
        foodsTriedThisWeek = [( self.foodArray[indexPath.row].image_file_name ?? "no idea", indexPath, "fromTopMaybeRibbon")] + (foodsTriedThisWeek ?? [])
        //print("Food Tried This week \(foodsTriedThisWeek!)")
        return [dragItem]
        
    }
}

extension Maybe3CollectionViewController: UICollectionViewDropDelegate{
    
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
                delegate?.updateSourceCellWithASmiley(sourceIndexPath: IndexPath.init(item: 0, section: 0), sourceViewController: "droppingIntoTopMaybe")
                var draggedFood: Food
                let request : NSFetchRequest<Food> = Food.fetchRequest()
                do
                {
                    let foodArrayFull = try context.fetch(request)
                    draggedFood = foodArrayFull.filter{$0.image_file_name == pet}.first!
                    draggedFood.rating = 2
                    foodArray.insert(draggedFood, at: destinationIndexPath.row )
                }
                catch
                {
                    print("Error fetching data \(error)")
                }
                DispatchQueue.main.async {
                    self.maybe3CollectionView.insertItems(at: [destinationIndexPath])
                }
            }
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    //    func updateSourceCellWithASmiley(sourceIndexPath: IndexPath, sourceViewController: String) {
    //        print("Message Received from \(sourceViewController)")
    //
    //        if sourceViewController == "deletetick"
    //        {
    //            //            // get the stats on this tick
    //            //            let indexPathOfThisTick = foodsTriedThisWeek[0].1
    //            //            var imageFileNameForTheFoodBehindThisTick = String()
    //            //
    //            //            let request : NSFetchRequest<Food> = Food.fetchRequest()
    //            //            do
    //            //            {
    //            //                var foodArrayFull = try context.fetch(request)
    //            //
    //            //                //// look up the image file name in the underlying database
    //            //                let updatedVersionOfThisFood = foodArrayFull.filter{$0.name == foodsTriedThisWeek[0].0 }.filter{$0.image_file_name != "tick.png" }.first!
    //            //                imageFileNameForTheFoodBehindThisTick = updatedVersionOfThisFood.image_file_name!
    //            //
    //            //                /// remove the previously updated to avoid duplication
    //            //                foodArrayFull = Array(foodArrayFull.drop{$0 == updatedVersionOfThisFood})
    //            //
    //            //                /// change the database entry to have the tick entry restored back to previous state
    //            //                foodArrayFull.filter{$0.name == foodsTriedThisWeek[0].0 }.first!.image_file_name = imageFileNameForTheFoodBehindThisTick
    //            //
    //            //                /// If this works correctly, I won;t have any duplicate entries now
    //            //
    //            //            }
    //            //            catch
    //            //            {
    //            //                print("Error fetching data \(error)")
    //            //            }
    //            //
    //            //            /// change the tick into the correct picture
    //            //
    //            //            let cell = self.maybeCollectionView.cellForItem(at: foodsTriedThisWeek[0].1) as! MaybeCollectionViewCell
    //            //            cell.displayContent(image: "imageFileNameForTheFoodBehindThisTick", title: "foodsTriedThisWeek[0].0")
    //            //            cell.layer.borderWidth = 5.0
    //            //
    //            //            /// delete the alterantive entry from food array full. how do i do this without crashing....?
    //            //
    //            //            /// clean up foods tried this week
    //            //            foodsTriedThisWeek = Array(foodsTriedThisWeek.dropFirst())
    //        }
    //        else{
    //            let triedFoodImage = foodArray.filter{ $0.name == foodsTriedThisWeek[0].0 }[0].image_file_name
    //            var rating = 2
    //            if sourceViewController == "sentFromGreenRibbon" { rating = 1}
    //            if sourceViewController == "sentFromRedRibbon" { rating = 2}
    //
    //            /// here I create a new entry in the database for the tried food, with an updated rating
    //            if let managedObjectContext = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
    //                let menuItem = NSEntityDescription.insertNewObject(forEntityName: "Food", into: managedObjectContext) as! Food
    //                menuItem.image_file_name = triedFoodImage
    //                menuItem.name = foodsTriedThisWeek[0].0
    //                menuItem.rating = Int16(rating)
    //                foodArray.append(menuItem)
    //            }
    //
    //            /// here I update the picture with 'tick' image - but i leave the other data untouched, because I want to be able to restore it if this tick was placed in error.
    //            foodArray[2*foodsTriedThisWeek[0].1.section + foodsTriedThisWeek[0].1.row].image_file_name = "tick.png"
    //
    //            let cell = self.maybeCollectionView.cellForItem(at: foodsTriedThisWeek[0].1) as! MaybeCollectionViewCell
    //
    //            cell.displayContent(image: "tick.png", title: "")
    //            cell.layer.borderWidth = 0.0
    //        }
    //    }
}


