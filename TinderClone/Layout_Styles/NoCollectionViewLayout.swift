//
//  YesCollectionViewLayout.swift
//  TinderClone
//
//  Created by Kate Roberts on 01/10/2018.
//  Copyright © 2018 Kate Roberts. All rights reserved.
//

import UIKit

class NoCollectionViewLayout: UICollectionViewLayout {
    
    
    ///Users/kate/Documents/TFood/TinderClone/YesCollectionViewCell.swift/ used for calculating each cells' CGRect on screen.
    /// CGRect will define the origin and size of the cell
    let CELL_HEIGHT = 100.0
    let CELL_WIDTH = 100.0
    let CELL_SPACING = 25.0
    
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
        return self.contentSize
    }
    
    override func prepare() {
        /// I don't have headers, so I jump straight to 'else' on the credera tutorial
        if !dataSourceDidUpdate
        {
            // Determine current content offsets.
            let xOffset = collectionView!.contentOffset.x
            //let yOffset = collectionView!.contentOffset.y
            
            let indexPath = NSIndexPath(item:0,section:0)
            // update y position to follow user. I don't understand this comment
            if let attrs = cellAttrsDictionary[indexPath] {
                var frame = attrs.frame
                frame.origin.x = xOffset
                attrs.frame = frame
            }
            return
        }
        // Acknowledge data source change, and disable for next time.
        dataSourceDidUpdate = false
        // cycle through every section of the data source
        guard let numberOfItemsToDisplay = collectionView?.numberOfItems(inSection: 0) else{ return}
        
        /// I'm assumping that the collection view will only exist with 1 or more items...? Is this correct...?
        for item in 0...numberOfItemsToDisplay-1
        {
            /// build the UICollectionViewAttributes for the cell
            let cellIndex = NSIndexPath(item:item,section:1)
            let xPos = Double(item)*(CELL_WIDTH + CELL_SPACING) + CELL_SPACING
            let yPos = CELL_HEIGHT - 90.0
            
            let  cellAttributes = UICollectionViewLayoutAttributes(forCellWith: cellIndex as IndexPath)
            cellAttributes.frame = CGRect(x:xPos, y:yPos, width: CELL_WIDTH, height: CELL_HEIGHT)
            cellAttributes.zIndex = 1
            
            //save attributes
            cellAttrsDictionary[cellIndex] = cellAttributes
            
        }
        
        //update content size
        
        self.contentSize = CGSize(width:160, height:160)
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
