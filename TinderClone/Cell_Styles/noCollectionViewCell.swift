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
        foodImage.image = UIImage(named: image)
      //  foodName.text = title
       // print("No ribbon should display \(title)")
    }
    
    func setup(){
        self.layer.borderWidth = 0.0
        self.layer.borderColor = UIColor.red.cgColor
        self.layer.cornerRadius = 5.0
    }
    
}
