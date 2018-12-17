//
//  YesCollectionViewCell.swift
//  TinderClone
//
//  Created by Kate Roberts on 26/09/2018.
//  Copyright © 2018 Kate Roberts. All rights reserved.
//


import UIKit

@IBDesignable
class YesCollectionViewCell: UICollectionViewCell {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override init(frame: CGRect){
        super.init(frame: frame)
        setup()
    }
    
    @IBOutlet var foodImage: UIImageView!
    
    public func displayContent(image: String)
    {
        foodImage.image = UIImage(named: image)
    }
    
    func setup(){
        self.layer.borderWidth = 5.0
        self.layer.borderColor = UIColor.green.cgColor
        self.layer.cornerRadius = 5.0
    }
    
}
