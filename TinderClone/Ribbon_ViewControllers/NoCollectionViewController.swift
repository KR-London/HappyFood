//
//  NoCollectionViewController.swift
//  TinderClone
//
//  Created by Kate Roberts on 26/09/2018.
//  Copyright © 2018 Kate Roberts. All rights reserved.
//

import UIKit
import CoreData
import MobileCoreServices

private let noReuseIdentifier = "noCell"

@IBDesignable
class NoCollectionViewController: UICollectionViewController {
    
   weak var delegate: CommunicationChannel?

    
    fileprivate var longPressGesture: UILongPressGestureRecognizer!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var food: [NSManagedObject] = []
    var foodArray: [Food]!
    let datafilepath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    @IBOutlet var noCollectionView : UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.red
        //collectionView?.addInteraction( UIDragInteraction )

        
        // Register cell classes
        //self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: yesReuseIdentifier)
        loadItems()
        foodArray = foodArray.filter{ $0.rating == 3 }
      // delegate?.updateSourceCellWithASmiley(sourceIndexPath: IndexPath.init(item: 0, section: 0), sourceViewController: "sentFromRedRibbon")
        //print("Message sent from No ribbon")
        //noCollectionView.dragDelegate = self
        noCollectionView.dropDelegate = self
       // noCollectionView.dragInteractionEnabled = true
        // Do any additional setup after loading the view.
    }
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
        //return foodArray.count/2
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return foodArray.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        //self.collectionView!.register(MaybeCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "noCell", for: indexPath) as! noCollectionViewCell
     
        let cellContentsIndex = 2*indexPath.section + 1 + indexPath.row
        if cellContentsIndex <= foodArray.count
        {
            let plate = foodArray[cellContentsIndex - 1 ]
            cell.displayContent(image:
                plate.image_file_name!, title: plate.name!)
        }
        // cell.foodName?.text = "Sec " + indexPath.section.description + "/Item " + indexPath.item.description
        //cell.foodName?.text = plate.name
        return cell
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
       //  delegate?.updateSourceCellWithASmiley(sourceIndexPath: IndexPath.init(item: 0, section: 0), sourceViewController: "sentFromRedRibbon")
        let dragItem = UIDragItem(itemProvider: itemProvider)
        dragItem.localObject =  sampledFood
        return [dragItem]
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
    
    public func canHandle(_ session: UIDropSession) -> Bool {
        return session.canLoadObjects(ofClass: NSString.self)
    }
    
}
//extension YesCollectionViewController: UICollectionViewDragDelegate{
//
//    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem]
//    {
//        let item = self.foodArray[indexPath.row].name
//        let itemProvider = NSItemProvider(object: item! as NSString)
//        let dragItem = UIDragItem(itemProvider: itemProvider)
//        dragItem.localObject = item
//        return [dragItem]
//    }
//}
//
extension NoCollectionViewController: UICollectionViewDropDelegate{
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
                //print("Hello drsgged item. I've been expecting you!")
                if pet == "" {return}
                if pet == "tick.png"
                {
                    print("Oh no you don't!")
                    return
                }
                
                
                delegate?.updateSourceCellWithASmiley(sourceIndexPath: IndexPath.init(item: 0, section: 0), sourceViewController: "sentFromRedRibbon")
                var draggedFood: Food
                let request : NSFetchRequest<Food> = Food.fetchRequest()
                do
                {
                    let foodArrayFull = try context.fetch(request)
                    
                    //// this is a crash point potentially
                    /// that double filter makes no sense
                    let filteredFood = foodArrayFull.filter{$0.image_file_name == pet}.filter{$0.name != "tick" }
                    
                    if filteredFood.count < 1 { return }
                    
                    draggedFood = filteredFood.first!
                 
                    foodArray.insert(draggedFood, at:  destinationIndexPath.row )
                }
                catch
                {
                    print("Error fetching data \(error)")
                }
                
                DispatchQueue.main.async {
                    self.noCollectionView.insertItems(at: [destinationIndexPath])
                }
            }
            
        }
    }

//    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
//
//        let destinationIndexPath: IndexPath
//        if let indexPath = coordinator.destinationIndexPath{
//            destinationIndexPath = indexPath
//        }
//        else{
//            let section = collectionView.numberOfSections - 1
//            let row = collectionView.numberOfItems(inSection: section)
//            destinationIndexPath = IndexPath(row: row, section: section)
//        }
//
//        for item in coordinator.items{
//            if let pet = item.dragItem.localObject as? String{
//                print("Hello drsgged item. I've been expecting you!")
//                var draggedFood: Food
//                let request : NSFetchRequest<Food> = Food.fetchRequest()
//                do
//                {
//                    let foodArrayFull = try context.fetch(request)
//                    draggedFood = foodArrayFull.filter{$0.name == pet}.first!
//                    foodArray.insert(draggedFood, at:  destinationIndexPath.row )
//                }
//                catch
//                {
//                    print("Error fetching data \(error)")
//                }
//                DispatchQueue.main.async {
//                    self.noCollectionView.insertItems(at: [destinationIndexPath])
//                }
//            }
//                        if let sourceIndexPath = item.sourceIndexPath{
//                            print("same app, same collection view")
//                            noCollectionView.moveItem(at: sourceIndexPath, to:  destinationIndexPath)
//                        }
//                        else{
//                            print("Different app")
//                        }
//                        let itemProvider = item.dragItem.itemProvider
//                        itemProvider.loadObject(ofClass: NSString.self){ string, error in
//
//
//                        }
//        }
//}
}

//func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem]
//{
//    let item = self.items[indexPath.row]
//    let itemProvider = NSItemProvider(object: item as NSString)
//    let dragItem = UIDragItem(itemProvider: itemProvider)
//    dragItem.localObject = item
//    return [dragItem]
//}
