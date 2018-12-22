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
        loadItems()
        foodArray = foodArray.filter{ $0.rating == 2 }
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
            if plate.name == "tick"
            {
                cell.layer.borderWidth = 0.0
                cell.displayContent(image: "tick.png", title: "")
            }
            else
            {
                cell.displayContent(image: plate.image_file_name!, title: plate.name!)
            }
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
        let item = self.foodArray[2*indexPath.section + indexPath.row].name
        let itemProvider = NSItemProvider(object: item! as String as NSItemProviderWriting)
        
        let dragItem = UIDragItem(itemProvider: itemProvider)
        dragItem.localObject = item
        foodsTriedThisWeek = [( item ?? "no idea", indexPath)]
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
                    draggedFood = foodArrayFull.filter{$0.name == pet}.first!
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

        print(foodArray[2*foodsTriedThisWeek[0].1.section + foodsTriedThisWeek[0].1.row])

        let triedFoodImage = foodArray.filter{ $0.name == foodsTriedThisWeek[0].0 }[0].image_file_name
        var rating = 2
        if sourceViewController == "sentFromGreenRibbon" { rating = 1}
        if sourceViewController == "sentFromRedRibbon" { rating = 2}
        
        if let managedObjectContext = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
                let menuItem = NSEntityDescription.insertNewObject(forEntityName: "Food", into: managedObjectContext) as! Food
                menuItem.image_file_name = triedFoodImage
                menuItem.name = foodsTriedThisWeek[0].0
                menuItem.rating = Int16(rating)
                 foodArray.append(menuItem)
        }
       
        
       // foodArray.append(triedFood)
        foodArray[2*foodsTriedThisWeek[0].1.section + foodsTriedThisWeek[0].1.row].name = "tick"
        foodArray[2*foodsTriedThisWeek[0].1.section + foodsTriedThisWeek[0].1.row].image_file_name = "tick.png"
        //foodArray = foodArray.
        //foodArray = foodArray.insert(<#T##newElement: Food##Food#>, at: 2*foodsTriedThisWeek[0].1.section + foodsTriedThisWeek[0].1.row)
        let cell = self.maybeCollectionView.cellForItem(at: foodsTriedThisWeek[0].1) as! MaybeCollectionViewCell
       // self.maybeCollectionView.insertItems(at: [foodsTriedThisWeek[0].1])
        cell.displayContent(image: "tick.png", title: "")
        cell.layer.borderWidth = 0.0
        print("Hello")
    }
}


