//
//  Maybe2CollectionViewCell.swift
//  TinderClone
//
//  Created by Kate Roberts on 02/01/2019.
//  Copyright © 2019 Kate Roberts. All rights reserved.
//

import UIKit

class Maybe2CollectionViewCell: UICollectionViewCell {
    
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
        self.layer.borderWidth = 0.0
        self.layer.borderColor = UIColor.yellow.cgColor
        self.layer.cornerRadius = 5.0
    }
    
}
