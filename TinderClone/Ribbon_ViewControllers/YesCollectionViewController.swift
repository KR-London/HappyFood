//
//  YesCollectionViewController.swift
//  TinderClone
//
//  Created by Kate Roberts on 26/09/2018.
//  Copyright © 2018 Kate Roberts. All rights reserved.
//

import UIKit
import CoreData
import MobileCoreServices

private let yesReuseIdentifier = "yesCell"
 // var pets  =   ["Corner.png", "Cheese.png", "Blueberries.png"]
//var pets  =   ["1.png","Tomato.png", "Tasty.png", "Satsuma.png", "Jam.png", "Cream Cheese.png","Corner.png", "Cheese.png", "Blueberries.png"]

@IBDesignable
class YesCollectionViewController: UICollectionViewController {

    weak var delegate: CommunicationChannel?
    fileprivate var longPressGesture: UILongPressGestureRecognizer!

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var food: [NSManagedObject] = []
    var foodArray: [Food]!
    let datafilepath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    @IBOutlet var yesCollectionView : UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
     //   delegate?.updateSourceCellWithASmiley(sourceIndexPath: IndexPath.init(item: 0, section: 0), sourceViewController: "sentFromGreenRibbon")
        loadItems()
        
       // self.view.backgroundColor = UIColor.green
        foodArray = foodArray.filter{ $0.rating == 1 }
        yesCollectionView.dragDelegate = self
        yesCollectionView.dropDelegate = self
        yesCollectionView.dragInteractionEnabled = false
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return foodArray.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        //self.collectionView!.register(MaybeCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "yesCell", for: indexPath) as! YesCollectionViewCell
        
        let cellContentsIndex = indexPath.row
        if cellContentsIndex <= foodArray.count
        {
            let plate = foodArray[cellContentsIndex]
            cell.displayContent(image: plate.image_file_name!)
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

extension YesCollectionViewController: UICollectionViewDragDelegate{
    
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem]
    {
        let item = self.foodArray[indexPath.row].name
        let itemProvider = NSItemProvider(object: item! as String as NSItemProviderWriting)
        
        //// add alternative with the encoding - or in fact replace this whoe lot with the encoding version.
        
        let dragItem = UIDragItem(itemProvider: itemProvider)
        dragItem.localObject = item
        return [dragItem]
    }
}

extension YesCollectionViewController: UICollectionViewDropDelegate{
    
    func  collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        
//        delegate?.updateSourceCellWithASmiley(sourceIndexPath: IndexPath.init(item: 0, section: 0), sourceViewController: "sentFromGreenRibbon")
        
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
                if pet == "" {return}
                if pet == "tick.png"
                {
                    //delegate?.updateSourceCellWithASmiley(sourceIndexPath: IndexPath.init(item: 0, section: 0), sourceViewController: "deletetick")
                    print("Oh no you don't!")
                    return
                }
                //print("Hello drsgged item. I've been expecting you!")
                delegate?.updateSourceCellWithASmiley(sourceIndexPath: IndexPath.init(item: 0, section: 0), sourceViewController: "sentFromGreenRibbon")
                var draggedFood: Food
                let request : NSFetchRequest<Food> = Food.fetchRequest()
                do
                {
                    let foodArrayFull = try context.fetch(request)
                    draggedFood = foodArrayFull.filter{$0.image_file_name == pet}.filter{$0.image_file_name != "tick.png" }.first!
                        foodArray.insert(draggedFood, at:  destinationIndexPath.row )
                }
                catch
                {
                    print("Error fetching data \(error)")
                }
                
                DispatchQueue.main.async {
                    self.yesCollectionView.insertItems(at: [destinationIndexPath])
                }
            }
            
        }
}
}
