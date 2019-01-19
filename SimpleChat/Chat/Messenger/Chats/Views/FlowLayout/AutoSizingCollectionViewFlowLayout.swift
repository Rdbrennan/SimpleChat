//
//  AutoSizingCollectionViewFlowLayout.swift
//  Subly
//
//  Created by Robert Brennan on 9/20/18.
//  Copyright © 2018 TechYes. All rights reserved.
//

import UIKit

var isInsertingCellsToTop: Bool = false
var contentSizeWhenInsertingToTop: CGSize?

class AutoSizingCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    override func prepare() {
        super.prepare()
        
        if isInsertingCellsToTop == true {
            if let collectionView = collectionView, let oldContentSize = contentSizeWhenInsertingToTop {
                let newContentSize = collectionViewContentSize
                let contentOffsetY = collectionView.contentOffset.y + (newContentSize.height - oldContentSize.height)
                let newOffset = CGPoint(x: collectionView.contentOffset.x, y: contentOffsetY)
                collectionView.setContentOffset(newOffset, animated: false)
            }
            contentSizeWhenInsertingToTop = nil
            isInsertingCellsToTop = false
        }
    }
}
