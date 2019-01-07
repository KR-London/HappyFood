//
//  TargetCollectionViewController.swift
//  TinderClone
//
//  Created by Kate Roberts on 04/01/2019.
//  Copyright © 2019 Kate Roberts. All rights reserved.
//

import UIKit
import CoreData

private let reuseIdentifier = "targetCell"

var ticks = [String]()

class TargetCollectionViewController: UICollectionViewController, CommunicationChannel {

    weak var delegate: CommunicationChannel?
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var triedFood: [NSManagedObject] = []
    var triedFoodArray: [TriedFood]!
   // let datafilepath = FileManager.default.urls(for: .documentDirectory,
                                               // in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    /// these variables help me to delete cells
    var longPressGesture = UILongPressGestureRecognizer()
    var isAnimate: Bool! = true
    var longPressedEnabled = false
    @IBAction func removeBtnClick(_ sender: UIButton) {
        if foodsTriedThisWeek != nil
        {
            let hitPoint = sender.convert(CGPoint.zero, to: self.collectionView)
            let hitIndex = self.collectionView.indexPathForItem(at: hitPoint)
        
            /// remove the tried food and refresh the collection view
            let indexOfThisFood = 2*(hitIndex?.section)! + (hitIndex?.row)!
        
            if indexOfThisFood < foodsTriedThisWeek.count
            {
                foodsTriedThisWeek.remove(at: indexOfThisFood)
                self.collectionView.reloadData()
            }
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //adding longpress gesture over UICollectionView
        longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.longTap(_:)))
        self.view.addGestureRecognizer(longPressGesture)

        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
       // self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier) as! TargetCollectionViewCell

        // Do any additional setup after loading the view.
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        // let width = UIScreen.main.bounds.width
        
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: 100, height: 100)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
       // layout.collectionView?.contentSize.height = 200
        
        collectionView!.collectionViewLayout = layout
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
        return 3
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 2
    }

    //// code in to read from "foods tried this week" and give picture overalaid with a tick for those
    
    /// actually - just tick for MVP
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! TargetCollectionViewCell
        
       // cell.foodImage.image = UIImage(named: "tick.png")
        
        cell.removeBtnClick.isHidden = true
        
        if foodsTriedThisWeek != nil
        {
            if 2*indexPath.section + indexPath.row  < foodsTriedThisWeek.count
            {
                cell.foodImage.image = UIImage(named: "Tick.jpeg")
                if longPressedEnabled   {
                    cell.startAnimate()
                }else{
                    cell.stopAnimate()
                }
            }
            else
            {
                cell.foodImage.image = nil
            }
        }
        // Configure the cell
        
        /// this tells it to wobble if I've long pressed!
//        if longPressedEnabled   {
//            cell.startAnimate()
//        }else{
//            cell.stopAnimate()
//        }
    
        return cell
    }

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
    
    
    /// add an extra element & load a tick
    
    func updateSourceCellWithASmiley(sourceIndexPath: IndexPath, sourceViewController: String) {
        self.collectionView.reloadData()
    }

    
    func loadItems(){
        let request : NSFetchRequest<TriedFood> = TriedFood.fetchRequest()
        do{
            try     triedFood = context.fetch(request)
        }
        catch
        {
            print("Error fetching data \(error)")
        }
        
//        for i in 0 ... triedFood.count
//        {
//            let newFood = ( "test", IndexPath(item: 99, section: 99), "fromFileLoadingInTargetRibbon")
//          //  foodsTriedThisWeek.append(newFood)
//        }
    }
    
    @objc func longTap(_ gesture: UIGestureRecognizer){
        print("Long tap detected")
        switch(gesture.state) {
        case .began:
                print(".began")
                guard let selectedIndexPath = self.collectionView.indexPathForItem(at: gesture.location(in: self.collectionView))
                    else { return }
                self.collectionView.beginInteractiveMovementForItem(at: selectedIndexPath)
            break
//            guard let selectedIndexPath = imgcollection.indexPathForItem(at: gesture.location(in: imgcollection)) else {
//                return
//            }
//            imgcollection.beginInteractiveMovementForItem(at: selectedIndexPath)
        case .changed:
               print(".changed")
               self.collectionView.updateInteractiveMovementTargetPosition(gesture.location(in: gesture.view!))
            break
//            imgcollection.updateInteractiveMovementTargetPosition(gesture.location(in: gesture.view!))
        case .ended:
               print(".ended")
               self.collectionView.endInteractiveMovement()
               //           // doneBtn.isHidden = false
               longPressedEnabled = !longPressedEnabled
               self.collectionView.reloadData()
            break
            
        default:
            self.collectionView.cancelInteractiveMovement()
            break
            
        }
    }
    
 

}
