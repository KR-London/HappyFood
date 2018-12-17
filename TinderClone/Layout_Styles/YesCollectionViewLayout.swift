//
//  YesCollectionViewLayout.swift
//  TinderClone
//
//  Created by Kate Roberts on 01/10/2018.
//  Copyright © 2018 Kate Roberts. All rights reserved.
//

import UIKit

class YesCollectionViewLayout: UICollectionViewFlowLayout {
    
    ///Users/kate/Documents/TFood/TinderClone/YesCollectionViewCell.swift/ used for calculating each cells' CGRect on screen.
    /// CGRect will define the origin and size of the cell
    let CELL_HEIGHT = 150.0
    let CELL_WIDTH = 150.0
    
    
    // dictionary yo hold the UICollectionViewLayoutAttributes for each cell
    // layout attributes will define teh cell's size and position (x,y,z index).
    /// one of the heaview parts of the layout.
    // recommend holding it in a dictionary or data store for smooth performance
    
    var cellAttrsDictionary = Dictionary<NSIndexPath, UICollectionViewLayoutAttributes>()
    
    //define the size of the area the user can move around in within the collection view
    var contentSize = CGSize.zero
    
    // Used to determine if a data source update has occured.
    // Note: The data source would be responsible for updating
    // this value if an update was performed.
    var dataSourceDidUpdate = true
    
    func collectionViewContentSize() -> CGSize{
       // return CGSize(width: 2000,height: 2000)
        return self.contentSize
    }
    
    override func prepare() {
        if (collectionView?.numberOfItems(inSection: 0))! > 0 {
            /// cycle through each item of the section
            for item in 0...(collectionView?.numberOfItems(inSection: 0))!-1{
                /// build the collection attributes
                let cellIndex = NSIndexPath(item: item, section: 0)
                let xPos = Double(item)*CELL_WIDTH
                let yPos = CELL_HEIGHT
                
                var cellAttributes = UICollectionViewLayoutAttributes(forCellWith: cellIndex as IndexPath)
                cellAttributes.frame = CGRect(x: xPos, y:yPos, width: CELL_WIDTH, height: CELL_HEIGHT)
                cellAttributes.zIndex = 1
                
                //save
                cellAttrsDictionary[cellIndex] = cellAttributes
            }
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        /// create array to hold all the elements in our current view
        var attributesInRTect = [UICollectionViewLayoutAttributes]()
        
        /// check each element to see if they should be returned
        for cellAttributes in cellAttrsDictionary.values
        {
            if rect.intersects(cellAttributes.frame)
            {
                attributesInRTect.append(cellAttributes)
            }
        }
        
        return attributesInRTect
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cellAttrsDictionary[indexPath as NSIndexPath]!
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
}
