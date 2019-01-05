//
//  TargetCollectionViewCell.swift
//  TinderClone
//
//  Created by Kate Roberts on 04/01/2019.
//  Copyright © 2019 Kate Roberts. All rights reserved.
//

import UIKit

class TargetCollectionViewCell: UICollectionViewCell {
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
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.green.cgColor
        self.layer.cornerRadius = 5.0
    }
    
}
