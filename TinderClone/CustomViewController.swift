//
//  CustomViewController.swift
//  TinderClone
//
//  Created by Kate Roberts on 18/09/2018.
//  Copyright © 2018 Kate Roberts. All rights reserved.
//

import UIKit

protocol CommunicationChannel : class {
    func updateSourceCellWithASmiley( sourceIndexPath: IndexPath, sourceViewController: String )
}

@IBDesignable
class CustomViewController: UIViewController, CommunicationChannel {
    
    weak var communicationChannel: CommunicationChannel?
    
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet weak var greenView: UIView!
    
    @IBOutlet weak var stackView: UIStackView!
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.addChild(greenView)
       // scrollView.contentSize = CGSize(width: 375, height: 800)
        ///self.view.backgroundColor = UIColor.init(patternImage:#imageLiteral(resourceName: "stripes.png") )
       // self.view.addSubview(stackView)
      //  var backgroundStripes = UIImage(named: "stripes.png")
        //backgroundStripes = backgroundStripes?.resizeImage(targetSize: CGSize(width: self.view!.frame.width, height: self.view!.frame.height))
      //  self.view.sa
     //   backgroundColor = UIColor.init(patternImage:backgroundStripes! )
        
       
        
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
            communicationChannel = dvc
        } else if segue.identifier == "EmbedGreen" {
            let dvc = segue.destination as! YesCollectionViewController
            dvc.delegate = self
        } else if segue.identifier == "EmbedRed" {
            let  dvc = segue.destination as! NoCollectionViewController
            dvc.delegate = self
            //print(dvc.delegate!)
            //communicationChannel = dvc
        }
        else if segue.identifier == "EmbedAmber2"{
            let  dvc = segue.destination as! Maybe2CollectionViewController
          //  dvc.delegate = self
           // dvc.updateSourceCellWithASmiley(sourceIndexPath: IndexPath( item: 99, section: 99) , sourceViewController: "Maybe2")
        }
        else if segue.identifier == "EmbedTarget"{
        //     let targetViewController = segue.destinationViewController as! TargetCollectionViewController
           // let  dvc = segue.destination as! TargetCollectionViewController
            //  dvc.delegate = self
            // dvc.updateSourceCellWithASmiley(sourceIndexPath: IndexPath( item: 99, section: 99) , sourceViewController: "Maybe2")
        }
       //  imageView.sendSubviewToBack(view)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
     func updateSourceCellWithASmiley( sourceIndexPath: IndexPath, sourceViewController: String )
     {
        
        communicationChannel?.updateSourceCellWithASmiley(sourceIndexPath: sourceIndexPath, sourceViewController: sourceViewController)
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



