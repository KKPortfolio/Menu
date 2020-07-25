//
//  AutoResizeFlowLayout.swift
//  Menu
//
//  Created by Kurt Kim on 2020-06-28.
//  Copyright © 2020 Kurt Kim. All rights reserved.
//

import UIKit

class AutoResizeFlowLayout: UICollectionViewFlowLayout {
    
    override func prepare() {
        super.prepare()
        if self.collectionView != nil {
            var newItemSize = self.itemSize
            let itemsPerRow: Int = 1
            let totalSpacing: CGFloat = 0.0
            var newWidth = (self.collectionView!.bounds.size.width - self.sectionInset.left - self.sectionInset.right - totalSpacing)
            newWidth /= CGFloat(itemsPerRow)
            newItemSize.width = max(newItemSize.width, newWidth)
            if self.itemSize.height > 0 {
                let aspectRatio: CGFloat = self.itemSize.width / self.itemSize.height
                newItemSize.height = newItemSize.width / aspectRatio
            }
            self.itemSize = newItemSize
        }
    }
}
