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

    fileprivate var longPressGesture: UILongPressGestureRecognizer!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var food: [NSManagedObject] = []
    var foodArray: [Food]!
    let datafilepath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    @IBOutlet var noCollectionView : UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //collectionView?.addInteraction( UIDragInteraction )
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Register cell classes
        //self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: yesReuseIdentifier)
        loadItems()
        foodArray = foodArray.filter{ $0.rating == 3 }
        //noCollectionView.dragDelegate = self
       // noCollectionView.dropDelegate = self
       // noCollectionView.dragInteractionEnabled = true
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        
        let dragItem = UIDragItem(itemProvider: itemProvider)
        dragItem.localObject =  sampledFood
        return [dragItem]
    }
    
    //    func dataSourceForCollectionView(_ collectionView: UICollectionView) -> YesCollectionViewController
    //    {
    //     //   if( collectionView == yesCollectionView
    //   //     {
    //            return YesCollectionViewController
    //   //     }
    //
    //    }
    //func dataSourceForCollectionView()
    
    
    ///func previewForLifting
    
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
    
    //    func collectionView(_:itemsForBeginning:at:)
    //    {
    //        return
    //    }
    
    
    
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
//extension YesCollectionViewController: UICollectionViewDropDelegate{
//    func  collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
//        if collectionView.hasActiveDrag{
//            if session.items.count > 1 {
//                return UICollectionViewDropProposal(operation: .cancel)
//            }
//            else{
//                return UICollectionViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
//            }
//        }
//        else{
//            return UICollectionViewDropProposal(operation: .copy, intent: .insertAtDestinationIndexPath)
//        }
//    }
//
//    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
//        // let dataSource = dataSourceF
//        let destinationIndexPath: IndexPath
//
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
//            //            guard let myObject = item.dragItem.localObject
//            //                else{
//            //                    return
//            //            }
//            if let pet = item.dragItem.localObject as? Food{
//                print("Hello drsgged item. I've been expecting you!")
//                //foodArray.move
//                foodArray.insert(pet, at: destinationIndexPath.section)
//                // yesCollectionView.insertItems(at: <#T##[IndexPath]#>)
//                yesCollectionView.insertItems(at: [destinationIndexPath])
//                reloadInputViews()
//            }
            //            if let sourceIndexPath = item.sourceIndexPath{
            //                print("same app, same collection view")
            //
            //               // let newPic = item.description.
            //
            //             yesCollectionView.moveItem(at: sourceIndexPath, to:  destinationIndexPath)
            //            //yesCollectionView.dequeueReusableCell(withReuseIdentifier: "yesCell", for: destinationIndexPath)
            //
            //
            //               // let plate = foodArray[cellContentsIndex]
            //               // cell.displayContent(image: plate.image_file_name!, title: plate.name!)
            //             ///   self.collectionView.numberOfItems(inSection: 0)
            //               // yesCollectionView.deleteItems(at: [sourceIndexPath])
            //               // yesCollectionView.insertItems(at: [destinationIndexPath])
            //            /// it's not updating the new cell....
            //
            //            /// set the new cell image etc as the dragged cell stats.
            //
            //                /// in future I'd like it to remember where I dragged - but that is enough for now...
            //              //  DispatchQueue.main.async {
            //        //            collectionView.performBatchUpdates(self.collectionView.insertItems(at: [destinationIndexPath]),completion: collectionView.deleteItems(at: [sourceIndexPath]))
            //               // collectionView.deleteItems(at: [sourceIndexPath])
            //              //  let dummy = IndexPath(row: 0, section: 0)
            //              //  let sectionToUpdate = dummy.section
            //              //  collectionView.numberOfItems(inSection: sectionToUpdate).
            //                 //   collectionView.insertItems(at: [dummy])
            //              //  }
            //            }
            //            else{
            //                print("Different app")
            //            }
            
            
            
            //            let itemProvider = item.dragItem.itemProvider
            //            itemProvider.loadObject(ofClass: NSString.self){ string, error in
            //
            //
            //            }
  //      }
        
        //        coordinator.session.loadObjects(ofClass: NSString.self){ items in
        //            let stringItems = items as! [String]
        //
        //            var indexPaths = [IndexPath]()
        //
        //            for (index,item) in stringItems.enumerated(){
        //                let indexPath = IndexPath(row: destinationIndexPath.row + index, section: destinationIndexPath.section)
        //                self.foodArray.insert(foodArr item, at: indexPath.row)
        //            }
        //
        //        }
        
        //        for item in coordinator.items {
        //
        //            if (false){}
        
        //            else {
        //                print("different app")
        //                let itemProvider = item.dragItem.itemProvider
        //               string , error in
        //                    if let string = string as? String{
        //                        var selectedFood = Food()
        //                        selectedFood.name = string
        //                    }
        //
        //                }
        //     }
        
        
  //  }
//}


//func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem]
//{
//    let item = self.items[indexPath.row]
//    let itemProvider = NSItemProvider(object: item as NSString)
//    let dragItem = UIDragItem(itemProvider: itemProvider)
//    dragItem.localObject = item
//    return [dragItem]
//}
