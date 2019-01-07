//
//  CustomViewController.swift
//  TinderClone
//
//  Created by Kate Roberts on 18/09/2018.
//  Copyright © 2018 Kate Roberts. All rights reserved.
//

import UIKit
import CoreData
import MobileCoreServices

protocol CommunicationChannel : class {
    func updateSourceCellWithASmiley( sourceIndexPath: IndexPath, sourceViewController: String )
}
var isPerformingSegue = false

@IBDesignable
class CustomViewController: UIViewController, CommunicationChannel {
    
    //// this is what I use to co-ordinate my VCs
    weak var communicationChannelGreen: CommunicationChannel?
    weak var communicationChannelTarget: CommunicationChannel?
    weak var communicationChannelAmber3: CommunicationChannel?
    weak var communicationChannelAmber2: CommunicationChannel?
    weak var communicationChannelRed: CommunicationChannel?
    
//    let path = NSHomeDirectory()+"/Documents/Storage.plist"
//    var dictionary : NSMutableDictionary!
//    let fileManager = FileManager.defaultManager()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var food: [NSManagedObject] = []
    var foodArray: [Food]!
    var triedFood: [TriedFood]!
    
    let datafilepath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    @IBAction func pinch(_ sender: UIPinchGestureRecognizer) {
        self.performSegue(withIdentifier: "goToCamera", sender: self)
    }
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet weak var greenView: UIView!
    
    @IBOutlet weak var stackView: UIStackView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if foodsTriedThisWeek == nil
        {
            loadItems()
        }
        
       // let pinchRecogniser = UIPinchGestureRecognizer(target: self, action: "pinched:" )
       // self.view.addGestureRecognizer(pinchRecogniser)
  //  }
    
  //  func pinched(recogniser: UIPinchGestureRecognizer) {
     //   if recogniser.scale <= 0.2 && !isPerformingSegue {
          //  self.performSegue(withIdentifier: "goToCamera", sender: self)
        //    isPerformingSegue = true
      //  }
        //self.addChild(greenView)
       // scrollView.contentSize = CGSize(width: 375, height: 800)
        ///self.view.backgroundColor = UIColor.init(patternImage:#imageLiteral(resourceName: "stripes.png") )
       // self.view.addSubview(stackView)
      //  var backgroundStripes = UIImage(named: "stripes.png")
        //backgroundStripes = backgroundStripes?.resizeImage(targetSize: CGSize(width: self.view!.frame.width, height: self.view!.frame.height))
      //  self.view.sa
        let maybe = UIImage(named: "Maybe.png")
        self.view.backgroundColor = UIColor.init(patternImage: maybe! )
        
       
        
      //  let mix = UIImage(named: "mix")
       // let scribblesImageView = UIImageView(image: mix!)
      //  scribblesImageView.frame = CGRect(x: 0, y:-40, width: self.view.frame.width, height: 1.15*self.view.frame.height)
      //  view.addSubview(scribblesImageView)
        //view.sendSubviewToBack(scribblesImageView)
        
//        let imageName = "stripes.png"
//        let image = UIImage(named: imageName)
//        let imageView = UIImageView(image: image!)
//        imageView.frame = CGRect(x: 0, y: -30, width: self.view.frame.width , height: 1.2*self.view.frame.height)
//        view.addSubview(imageView)
//        view.sendSubviewToBack(imageView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(true)
           // self.scrollView.sizeThatFits(CGSize(width: 200, height: 1000) )
            //self.view.addSubview(stackView)
            scrollView.contentSize = stackView.bounds.size
            scrollView.addSubview(stackView)
        
//        scrollView = UIScrollView(frame: view.bounds)
//        scrollView.backgroundColor = UIColor.blackColor()
//        scrollView.contentSize = imageView.bounds.size
//        scrollView.autoresizingMask = UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleHeight
//
//        scrollView.addSubview(imageView)
//        view.addSubview(scrollView)

    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EmbedAmber3" {
            let  dvc = segue.destination as! Maybe3CollectionViewController
            communicationChannelAmber3 = dvc
            dvc.delegate = self
        } else if segue.identifier == "EmbedGreen" {
            let dvc = segue.destination as! YesCollectionViewController
            dvc.delegate = self
            communicationChannelGreen = dvc
        } else if segue.identifier == "EmbedRed" {
            let  dvc = segue.destination as! NoCollectionViewController
            dvc.delegate = self
            communicationChannelRed = dvc
        }
        else if segue.identifier == "EmbedAmber2"{
            let  dvc = segue.destination as! Maybe2CollectionViewController
             dvc.delegate = self
            communicationChannelAmber2 = dvc
        }
        else if segue.identifier == "EmbedTarget"{
            let targetViewController = segue.destination as! TargetCollectionViewController
            targetViewController.delegate = self
            communicationChannelTarget = targetViewController
          
           // let  dvc = segue.destination as! TargetCollectionViewController
            //  dvc.delegate = self
            // dvc.updateSourceCellWithASmiley(sourceIndexPath: IndexPath( item: 99, section: 99) , sourceViewController: "Maybe2")
        }
       //  imageView.sendSubviewToBack(view)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
     func updateSourceCellWithASmiley( sourceIndexPath: IndexPath, sourceViewController: String )
     {
        
        let sourceSink = (from: foodsTriedThisWeek[0].2, to: sourceViewController)
        
        switch sourceSink
        {
            case ("fromGreenRibbon", "droppingIntoGreen"):
            communicationChannelGreen?.updateSourceCellWithASmiley(sourceIndexPath: sourceIndexPath, sourceViewController: sourceViewController)
            foodsTriedThisWeek = Array(foodsTriedThisWeek.dropFirst())
            break
            case ("fromGreenRibbon", "droppingIntoTarget"):
                communicationChannelGreen?.updateSourceCellWithASmiley(sourceIndexPath: sourceIndexPath, sourceViewController: sourceViewController)
                foodsTriedThisWeek = Array(foodsTriedThisWeek.dropFirst())
                break
            case ("fromGreenRibbon", "droppingIntoTopMaybe"):
                communicationChannelGreen?.updateSourceCellWithASmiley(sourceIndexPath: sourceIndexPath, sourceViewController: sourceViewController)
                foodsTriedThisWeek = Array(foodsTriedThisWeek.dropFirst())
                break
            case ("fromGreenRibbon", "droppingIntoBottomMaybe"):
                communicationChannelGreen?.updateSourceCellWithASmiley(sourceIndexPath: sourceIndexPath, sourceViewController: sourceViewController)
                foodsTriedThisWeek = Array(foodsTriedThisWeek.dropFirst())
                break
            case ("fromGreenRibbon", "droppingIntoRed"):
                communicationChannelGreen?.updateSourceCellWithASmiley(sourceIndexPath: sourceIndexPath, sourceViewController: sourceViewController)
                foodsTriedThisWeek = Array(foodsTriedThisWeek.dropFirst())
                break
            
            case ( "fromTargetRibbon", "droppingIntoTarget"):
            communicationChannelTarget?.updateSourceCellWithASmiley(sourceIndexPath: sourceIndexPath, sourceViewController: sourceViewController)
            doesThisGetATick(sourceIndexPath: sourceIndexPath, from: sourceSink.from, to: sourceSink.to)
            break
            case ("fromTargetRibbon", "droppingIntoGreen"):
                 communicationChannelTarget?.updateSourceCellWithASmiley(sourceIndexPath: sourceIndexPath, sourceViewController: sourceViewController)
                 doesThisGetATick(sourceIndexPath: sourceIndexPath, from: sourceSink.from, to: sourceSink.to)
                break
            case ("fromTargetRibbon", "droppingIntoTopMaybe"):
                  foodsTriedThisWeek = Array(foodsTriedThisWeek.dropFirst())
                    break
            case ("fromTargetRibbon", "droppingIntoBottomMaybe"):
                  foodsTriedThisWeek = Array(foodsTriedThisWeek.dropFirst())
                    break
            case ("fromTargetRibbon", "droppingIntoRed"):
                 //communicationChannelTarget?.updateSourceCellWithASmiley(sourceIndexPath: sourceIndexPath, sourceViewController: sourceViewController)
                 doesThisGetATick(sourceIndexPath: sourceIndexPath, from: sourceSink.from, to: sourceSink.to)
                break
            
        case ("fromTopMaybeRibbon", "droppingIntoTopMaybe"): communicationChannelAmber3?.updateSourceCellWithASmiley(sourceIndexPath: sourceIndexPath, sourceViewController: sourceViewController)
        //communicationChannelTarget?.updateSourceCellWithASmiley(sourceIndexPath: sourceIndexPath, sourceViewController: sourceViewController)
        //doesThisGetATick(sourceIndexPath: sourceIndexPath, from: sourceSink.from, to: sourceSink.to)
            foodsTriedThisWeek = Array(foodsTriedThisWeek.dropFirst())
            break
            case ("fromTopMaybeRibbon", "droppingIntoGreen"): communicationChannelAmber3?.updateSourceCellWithASmiley(sourceIndexPath: sourceIndexPath, sourceViewController: sourceViewController)
                 //communicationChannelTarget?.updateSourceCellWithASmiley(sourceIndexPath: sourceIndexPath, sourceViewController: sourceViewController)
                 doesThisGetATick(sourceIndexPath: sourceIndexPath, from: sourceSink.from, to: sourceSink.to)
                break
            case ("fromTopMaybeRibbon", "droppingIntoTarget"):
                communicationChannelAmber3?.updateSourceCellWithASmiley(sourceIndexPath: sourceIndexPath, sourceViewController: sourceViewController)
                foodsTriedThisWeek = Array(foodsTriedThisWeek.dropFirst())
                break
            case ("fromTopMaybeRibbon", "droppingIntoBottomMaybe"):
                communicationChannelAmber3?.updateSourceCellWithASmiley(sourceIndexPath: sourceIndexPath, sourceViewController: sourceViewController)
                 foodsTriedThisWeek = Array(foodsTriedThisWeek.dropFirst())
                break
            case ("fromTopMaybeRibbon", "droppingIntoRed"):
                communicationChannelAmber3?.updateSourceCellWithASmiley(sourceIndexPath: sourceIndexPath, sourceViewController: sourceViewController)
                 //communicationChannelTarget?.updateSourceCellWithASmiley(sourceIndexPath: sourceIndexPath, sourceViewController: sourceViewController)
                 doesThisGetATick(sourceIndexPath: sourceIndexPath, from: sourceSink.from, to: sourceSink.to)
                break
            
            case ("fromBottomMaybeRibbon", "droppingIntoBottomMaybe"):
            communicationChannelAmber2?.updateSourceCellWithASmiley(sourceIndexPath: sourceIndexPath, sourceViewController: sourceViewController)
            //communicationChannelTarget?.updateSourceCellWithASmiley(sourceIndexPath: sourceIndexPath, sourceViewController: sourceViewController)
            doesThisGetATick(sourceIndexPath: sourceIndexPath, from: sourceSink.from, to: sourceSink.to)
            break
            case ("fromBottomMaybeRibbon", "droppingIntoGreen"):
                    communicationChannelAmber2?.updateSourceCellWithASmiley(sourceIndexPath: sourceIndexPath, sourceViewController: sourceViewController)
                    //communicationChannelTarget?.updateSourceCellWithASmiley(sourceIndexPath: sourceIndexPath, sourceViewController: sourceViewController)
                     doesThisGetATick(sourceIndexPath: sourceIndexPath, from: sourceSink.from, to: sourceSink.to)
                    break
            case ("fromBottomMaybeRibbon", "droppingIntoTarget"):
                    communicationChannelAmber2?.updateSourceCellWithASmiley(sourceIndexPath: sourceIndexPath, sourceViewController: sourceViewController)
                    foodsTriedThisWeek = Array(foodsTriedThisWeek.dropFirst())
                    break
            case ("fromBottomMaybeRibbon", "droppingIntoTopMaybe"):
                    communicationChannelAmber2?.updateSourceCellWithASmiley(sourceIndexPath: sourceIndexPath, sourceViewController: sourceViewController)
                    foodsTriedThisWeek = Array(foodsTriedThisWeek.dropFirst())
                    break
            case ("fromBottomMaybeRibbon", "droppingIntoRed"):
                    communicationChannelAmber2?.updateSourceCellWithASmiley(sourceIndexPath: sourceIndexPath, sourceViewController: sourceViewController)
                    //communicationChannelTarget?.updateSourceCellWithASmiley(sourceIndexPath: sourceIndexPath, sourceViewController: sourceViewController)
                     doesThisGetATick(sourceIndexPath: sourceIndexPath, from: sourceSink.from, to: sourceSink.to)
                    break
            
            case ("fromRedRibbon", "droppingIntoRed"):
            communicationChannelRed?.updateSourceCellWithASmiley(sourceIndexPath: sourceIndexPath, sourceViewController: sourceViewController)
            //doesThisGetATick(sourceIndexPath: sourceIndexPath, from: sourceSink.from, to: sourceSink.to)
            // communicationChannelTarget?.updateSourceCellWithASmiley(sourceIndexPath: sourceIndexPath, sourceViewController: sourceViewController)
             foodsTriedThisWeek = Array(foodsTriedThisWeek.dropFirst())
            break
            case ("fromRedRibbon", "droppingIntoGreen"):
                    communicationChannelRed?.updateSourceCellWithASmiley(sourceIndexPath: sourceIndexPath, sourceViewController: sourceViewController)
                    doesThisGetATick(sourceIndexPath: sourceIndexPath, from: sourceSink.from, to: sourceSink.to)
                    // communicationChannelTarget?.updateSourceCellWithASmiley(sourceIndexPath: sourceIndexPath, sourceViewController: sourceViewController)
                   // foodsTriedThisWeek = Array(foodsTriedThisWeek.dropFirst())
                    break
            case ("fromRedRibbon", "droppingIntoTarget"):
                    communicationChannelRed?.updateSourceCellWithASmiley(sourceIndexPath: sourceIndexPath, sourceViewController: sourceViewController)
                    foodsTriedThisWeek = Array(foodsTriedThisWeek.dropFirst())
                    break
            case ("fromRedRibbon", "droppingIntoTopMaybe"):
                    //communicationChannelTarget?.updateSourceCellWithASmiley(sourceIndexPath: sourceIndexPath, sourceViewController: sourceViewController)
                    communicationChannelRed?.updateSourceCellWithASmiley(sourceIndexPath: sourceIndexPath, sourceViewController: sourceViewController)
                    foodsTriedThisWeek = Array(foodsTriedThisWeek.dropFirst())
                    break
            case ("fromRedRibbon", "droppingIntoBottomMaybe"):
                    communicationChannelRed?.updateSourceCellWithASmiley(sourceIndexPath: sourceIndexPath, sourceViewController: sourceViewController)
                    foodsTriedThisWeek = Array(foodsTriedThisWeek.dropFirst())
                    break
            
            default: return
        }
        
        
//        if sourceSink.from == "fromTopMaybeRibbon"
//        {
//            communicationChannelAmber3?.updateSourceCellWithASmiley(sourceIndexPath: sourceIndexPath, sourceViewController: sourceViewController)
//        }
//        if sourceSink.from == "fromBottomMaybeRibbon"
//        {
//            communicationChannelAmber2?.updateSourceCellWithASmiley(sourceIndexPath: sourceIndexPath, sourceViewController: sourceViewController)
//        }
        
        
   //     communicationChannelTarget?.updateSourceCellWithASmiley(sourceIndexPath: sourceIndexPath, sourceViewController: sourceViewController)
    }
    
    func doesThisGetATick(sourceIndexPath: IndexPath, from: String, to: String)
    {
       var unique = [Int]()
        /// check for uniqueness
        for i in 0 ... foodsTriedThisWeek.count-1
        {
            if i > 0
            {
                if foodsTriedThisWeek[0].0 == foodsTriedThisWeek[i].0
                {
                   // foodsTriedThisWeek = Array(foodsTriedThisWeek.dropFirst())
                   // return
                    unique = [i] + unique            }
            }
        }
        
        if unique.count > 0
        {
            for i in 0 ... unique.count - 1
            {
                foodsTriedThisWeek.remove(at: unique[i])
            }
            return
        }
        
        /// if it is unique, then give the use a smiley!
        communicationChannelTarget?.updateSourceCellWithASmiley(sourceIndexPath: sourceIndexPath, sourceViewController: to)
        
        /// and save down to coreData
        if let managedObjectContext = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
                let newFood = NSEntityDescription.insertNewObject(forEntityName: "TriedFood", into: managedObjectContext) as! TriedFood
            
                newFood.nameOfTriedFood = foodsTriedThisWeek[0].0
                newFood.dateTried = nil
        }
    }
    
    func maskImage(image:UIImage, mask:(UIImage))->UIImage{
        
        let imageReference = image.cgImage
        let maskReference = mask.cgImage
        
        let imageMask = CGImage(maskWidth: maskReference!.width,
                                height: maskReference!.height,
                                bitsPerComponent: maskReference!.bitsPerComponent,
                                bitsPerPixel: maskReference!.bitsPerPixel,
                                bytesPerRow: maskReference!.bytesPerRow,
                                provider: maskReference!.dataProvider!, decode: nil, shouldInterpolate: true)
        
        let maskedReference = imageReference!.masking(imageMask!)
        
        let maskedImage = UIImage(cgImage:maskedReference!)
        
        return maskedImage
    }
    
    
    func loadItems(){
        let request : NSFetchRequest<TriedFood> = TriedFood.fetchRequest()
        do{
            try
                triedFood = context.fetch(request)
        }
        catch
        {
            print("Error fetching data \(error)")
        }
        
        if triedFood != nil && triedFood.count > 0 
        {
           
            for i in 0 ... triedFood.count-1
            {
                if foodsTriedThisWeek == nil
                {
                    foodsTriedThisWeek = [( triedFood[i].nameOfTriedFood , IndexPath( item: 99, section: 99), "loadedFromFile")]
                }
                foodsTriedThisWeek.append(( triedFood[i].nameOfTriedFood , IndexPath( item: 99, section: 99), "loadedFromFile"))
            }
            
            var unique = [Int]()
            /// check for uniqueness
            for i in 0 ... foodsTriedThisWeek.count-1
            {
                if i > 0
                {
                    if foodsTriedThisWeek[0].0 == foodsTriedThisWeek[i].0
                    {
                        // foodsTriedThisWeek = Array(foodsTriedThisWeek.dropFirst())
                        // return
                        unique = [i] + unique            }
                }
            }
            
            if unique.count > 0
            {
                for i in 0 ... unique.count - 1
                {
                    foodsTriedThisWeek.remove(at: unique[i])
                }
                return
            }
        }
        

    }
}
extension UIImage {
    func resizeImage(targetSize: CGSize) -> UIImage {
        let size = self.size
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        let newSize = widthRatio > heightRatio ?  CGSize(width: size.width * heightRatio, height: size.height * heightRatio) : CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        self.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    

}



