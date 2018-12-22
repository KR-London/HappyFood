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
    
    @IBOutlet var maybeCollectionView : UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //collectionView?.dataSource = self
        //collectionView?.delegate = self
        //self.collectionView!.register(MaybeCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        loadItems()
        foodArray = foodArray.filter{ $0.rating == 2 }
        maybeCollectionView.dragDelegate = self
        maybeCollectionView.dropDelegate = self
        maybeCollectionView.dragInteractionEnabled = true
        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        //self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

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
        return (foodArray.count+1)/2
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        //return 8
        return 2
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        //self.collectionView!.register(MaybeCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "maybeCell", for: indexPath) as! MaybeCollectionViewCell
        
        let cellContentsIndex = 2*indexPath.section + 1 + indexPath.row
        if cellContentsIndex <= foodArray.count
        {
            let plate = foodArray[cellContentsIndex-1]
            cell.displayContent(image: plate.image_file_name!, title: plate.name!)
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
        
        //// add alternative with the encoding - or in fact replace this whoe lot with the encoding version.
      //po  foodArray.remove(at: 2*indexPath.section + indexPath.row)
        let dragItem = UIDragItem(itemProvider: itemProvider)
        dragItem.localObject = item
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
        // let dataSource = dataSourceF
       let destinationIndexPath: IndexPath
//        for item in coordinator.items
//        {
        if let indexPath = coordinator.destinationIndexPath{
            destinationIndexPath = indexPath
        }
        else{
            let section = collectionView.numberOfSections - 1
            let row = collectionView.numberOfItems(inSection: section)
            destinationIndexPath = IndexPath(row: row, section: section)
        }
        
        for item in coordinator.items{
            //            guard let myObject = item.dragItem.localObject
            //                else{
            //                    return
            //            }
            if let pet = item.dragItem.localObject as? String{
                print("Hello drsgged item. I've been expecting you!")
                var draggedFood: Food
                let request : NSFetchRequest<Food> = Food.fetchRequest()
                do
                {
                    let foodArrayFull = try context.fetch(request)
                    draggedFood = foodArrayFull.filter{$0.name == pet}.first!
                    //print(draggedFood)
                    foodArray.insert(draggedFood, at: 2*destinationIndexPath.section + destinationIndexPath.row )
                    foodArray.remove(at: 2*(item.sourceIndexPath?.section)! + item.sourceIndexPath!.row)
                }
                catch
                {
                    print("Error fetching data \(error)")
                }
               
                //foodArray.move
               // foodArray.insert(pet, at: destinationIndexPath.section)
                // yesCollectionView.insertItems(at: <#T##[IndexPath]#>)
                DispatchQueue.main.async {
                  //  self.maybeCollectionView.moveItem(at: item.sourceIndexPath!, to: destinationIndexPath)
                    self.maybeCollectionView.insertItems(at: [destinationIndexPath])
                    //self.maybeCollectionView.deleteItems(at: [item.sourceIndexPath!])
                    //reloadInputViews()
                }
            }
            
    }
}
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func updateSourceCellWithASmiley(sourceIndexPath: IndexPath, sourceViewController: String) {
        print("Message Received!")
    }
}


