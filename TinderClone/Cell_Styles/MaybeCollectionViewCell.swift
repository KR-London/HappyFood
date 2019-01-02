//
//  MaybeCollectionViewCell.swift
//  TinderClone
//
//  Created by Kate Roberts on 24/09/2018.
//  Copyright © 2018 Kate Roberts. All rights reserved.
//

import UIKit

@IBDesignable
class MaybeCollectionViewCell: UICollectionViewCell {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override init(frame: CGRect){
        super.init(frame: frame)
        setup()
    }
    
    @IBOutlet var foodImage: UIImageView!
    @IBOutlet var foodName: UILabel!
    
    public func displayContent(image: String, title: String)
    {
        foodImage.image = UIImage(named: image)
        //foodName.text = title
        //print("Maybe ribbon should display \(title)")
    }
    
    func setup(){
        self.layer.borderWidth = 5.0
        self.layer.borderColor = UIColor.yellow.cgColor
        self.layer.cornerRadius = 5.0
    }
    
}
