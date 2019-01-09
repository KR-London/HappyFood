//
//  CelebrationCollectionViewCell.swift
//  TinderClone
//
//  Created by Kate Roberts on 09/01/2019.
//  Copyright © 2019 Kate Roberts. All rights reserved.
//

import UIKit

class CelebrationCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var foodImage: UIImageView!
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override init(frame: CGRect){
        super.init(frame: frame)
        setup()
    }
    
    
    
    public func displayContent(image: String)
    {
        foodImage.image = maskImage(image: UIImage(named: image)!, mask: UIImage(named: "MASK.png")! )
    }
    
    func setup(){
        self.layer.borderWidth = 0.0
        self.layer.borderColor = UIColor.blue.cgColor
        //self.layer.cornerRadius = 40.0
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
