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
    
    weak var communicationChannelGreen: CommunicationChannel?
    weak var communicationChannelTarget: CommunicationChannel?
    weak var communicationChannelAmber3: CommunicationChannel?
    weak var communicationChannelAmber2: CommunicationChannel?
    weak var communicationChannelRed: CommunicationChannel?
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var food: [NSManagedObject] = []
    var foodArray: [Food]!
    let datafilepath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    @IBAction func pinch(_ sender: UIPinchGestureRecognizer) {
        self.performSegue(withIdentifier: "goToCamera", sender: self)
    }
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet weak var greenView: UIView!
    
    @IBOutlet weak var stackView: UIStackView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
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
          self.view.addSubview(stackView)
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
            
            case ("fromTargetRibbon", "droppingIntoGreen"):
                 communicationChannelTarget?.updateSourceCellWithASmiley(sourceIndexPath: sourceIndexPath, sourceViewController: sourceViewController)
                break
            case ("fromTargetRibbon", "droppingIntoTopMaybe"):
                break
            case ("fromTargetRibbon", "droppingIntoBottomMaybe"): break
            case ("fromTargetRibbon", "droppingIntoRed"):
                 communicationChannelTarget?.updateSourceCellWithASmiley(sourceIndexPath: sourceIndexPath, sourceViewController: sourceViewController)
                break
            
            case ("fromTopMaybeRibbon", "droppingIntoGreen"): communicationChannelAmber3?.updateSourceCellWithASmiley(sourceIndexPath: sourceIndexPath, sourceViewController: sourceViewController)
                 communicationChannelTarget?.updateSourceCellWithASmiley(sourceIndexPath: sourceIndexPath, sourceViewController: sourceViewController)
                break
            case ("fromTopMaybeRibbon", "droppingIntoTarget"):
                communicationChannelAmber3?.updateSourceCellWithASmiley(sourceIndexPath: sourceIndexPath, sourceViewController: sourceViewController)
                foodsTriedThisWeek = Array(foodsTriedThisWeek.dropFirst())
                print(foodsTriedThisWeek)
                break
            case ("fromTopMaybeRibbon", "droppingIntoBottomMaybe"):
                communicationChannelAmber3?.updateSourceCellWithASmiley(sourceIndexPath: sourceIndexPath, sourceViewController: sourceViewController)
                 foodsTriedThisWeek = Array(foodsTriedThisWeek.dropFirst())
                print("fromTopMaybe droppingIntoIntoBottomMaybe \(String(describing: foodsTriedThisWeek))")
                break
            case ("fromTopMaybeRibbon", "droppingIntoRed"):
                communicationChannelAmber3?.updateSourceCellWithASmiley(sourceIndexPath: sourceIndexPath, sourceViewController: sourceViewController)
                 communicationChannelTarget?.updateSourceCellWithASmiley(sourceIndexPath: sourceIndexPath, sourceViewController: sourceViewController)
                break
            
            case ("fromBottomMaybeRibbon", "droppingIntoGreen"):
                    communicationChannelAmber2?.updateSourceCellWithASmiley(sourceIndexPath: sourceIndexPath, sourceViewController: sourceViewController)
                    communicationChannelTarget?.updateSourceCellWithASmiley(sourceIndexPath: sourceIndexPath, sourceViewController: sourceViewController)
                    break
            case ("fromBottomMaybeRibbon", "droppingIntoTarget"):
                    communicationChannelAmber2?.updateSourceCellWithASmiley(sourceIndexPath: sourceIndexPath, sourceViewController: sourceViewController)
                    foodsTriedThisWeek = Array(foodsTriedThisWeek.dropFirst())
                    break
            case ("fromBottomMaybeRibbon", "droppingIntoTopMaybe"):
                    communicationChannelAmber2?.updateSourceCellWithASmiley(sourceIndexPath: sourceIndexPath, sourceViewController: sourceViewController)
                    break
            case ("fromBottomMaybeRibbon", "droppingIntoRed"):
                    communicationChannelAmber2?.updateSourceCellWithASmiley(sourceIndexPath: sourceIndexPath, sourceViewController: sourceViewController)
                    communicationChannelTarget?.updateSourceCellWithASmiley(sourceIndexPath: sourceIndexPath, sourceViewController: sourceViewController)
                    break
            
            case ("fromRedRibbon", "droppingIntoGreen"):
                    communicationChannelRed?.updateSourceCellWithASmiley(sourceIndexPath: sourceIndexPath, sourceViewController: sourceViewController)
                    
                     communicationChannelTarget?.updateSourceCellWithASmiley(sourceIndexPath: sourceIndexPath, sourceViewController: sourceViewController)
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



