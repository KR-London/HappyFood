//
//  TargetCollectionViewCell.swift
//  TinderClone
//
//  Created by Kate Roberts on 04/01/2019.
//  Copyright © 2019 Kate Roberts. All rights reserved.
//

import UIKit

class TargetCollectionViewCell: UICollectionViewCell {
    
    var isAnimate = false
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override init(frame: CGRect){
        super.init(frame: frame)
        setup()
    }
    
    @IBOutlet var foodImage: UIImageView!
    
    @IBOutlet weak var removeBtnClick: UIButton!
    
    @IBOutlet weak var tickImage: UIImageView!
    
    
    
    public func displayContent(image: String)
    {
        foodImage.image = maskImage(image: UIImage(named: image)!, mask: UIImage(named: "MASK.png")! )
        //foodImage.image = UIImage(named: image)
    }
    
    func setup(){
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.cornerRadius = 40.0
        if removeBtnClick != nil
        {
            removeBtnClick.isHidden = true
        }
        
        
//        if tickImage != nil
//        {
//            tickImage.isHidden = true
//        }
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
    
    func startAnimate() {
        let shakeAnimation = CABasicAnimation(keyPath: "transform.rotation")
        shakeAnimation.duration = 0.05
        shakeAnimation.repeatCount = 4
        shakeAnimation.autoreverses = true
        shakeAnimation.duration = 0.2
        shakeAnimation.repeatCount = 99999
        
        let startAngle: Float = (-2) * 3.14159/180
        let stopAngle = -startAngle
        
        shakeAnimation.fromValue = NSNumber(value: startAngle as Float)
        shakeAnimation.toValue = NSNumber(value: 3 * stopAngle as Float)
        shakeAnimation.autoreverses = true
        shakeAnimation.timeOffset = 290 * drand48()
        
        let layer: CALayer = self.layer
        layer.add(shakeAnimation, forKey:"animate")
        self.removeBtnClick.isHidden = false 
        isAnimate = true
    }
    
    func stopAnimate() {
        let layer: CALayer = self.layer
        layer.removeAnimation(forKey: "animate")
        self.removeBtnClick.isHidden = true
        isAnimate = false
    }
    
}
