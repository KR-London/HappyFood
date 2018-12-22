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

class CustomViewController: UIViewController, CommunicationChannel {
    
    weak var communicationChannel: CommunicationChannel?

    override func viewDidLoad() {
        super.viewDidLoad()
        ///self.view.backgroundColor = UIColor.init(patternImage:#imageLiteral(resourceName: "stripes.png") )
        
      //  var backgroundStripes = UIImage(named: "stripes.png")
        //backgroundStripes = backgroundStripes?.resizeImage(targetSize: CGSize(width: self.view!.frame.width, height: self.view!.frame.height))
      //  self.view.sa
     //   backgroundColor = UIColor.init(patternImage:backgroundStripes! )
        
        let imageName = "stripes.png"
        let image = UIImage(named: imageName)
        let imageView = UIImageView(image: image!)
        imageView.frame = CGRect(x: 0, y: -30, width: self.view.frame.width , height: 1.2*self.view.frame.height)
        view.addSubview(imageView)
        view.sendSubviewToBack(imageView)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EmbedAmber" {
            let  dvc = segue.destination as! MaybeCollectionViewController
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
