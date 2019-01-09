//
//  noCollectionViewCell.swift
//  TinderClone
//
//  Created by Kate Roberts on 26/09/2018.
//  Copyright © 2018 Kate Roberts. All rights reserved.
//

import UIKit


class noCollectionViewCell: UICollectionViewCell {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override init(frame: CGRect){
        super.init(frame: frame)
        setup()
    }
    
    
    
    @IBOutlet var foodImage: UIImageView!
   // @IBOutlet var foodName: UILabel!
    
    public func displayContent(image: String, title: String)
    {
//        if foodImage.image != nil
//        {
            foodImage.image = maskImage(image: UIImage(named: image)!, mask: UIImage(named: "MASK.png")! )
        //}
        //foodImage.image = UIImage(named: image)
      //  foodName.text = title
       // print("No ribbon should display \(title)")
    }
    
    func setup(){
        self.layer.borderWidth = 0.0
        self.layer.borderColor = UIColor.red.cgColor
        self.layer.cornerRadius = 5.0
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
