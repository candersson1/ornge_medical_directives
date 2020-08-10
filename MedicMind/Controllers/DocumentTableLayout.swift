//
//  DocumentTableLayout.swift
//  Ornge
//
//  Created by Charles Trickey on 2020-03-17.
//  Copyright © 2020 Charles Trickey. All rights reserved.
//

import UIKit

class DocumentTableLayout: UICollectionViewLayout {

    private let cellPadding: CGFloat = 0
    private var cache: [UICollectionViewLayoutAttributes] = []

    private var contentHeight: CGFloat = 0
    private var contentWidth: CGFloat {
        guard let collectionView = collectionView else {
            return 0
        }
        guard let sectionInfo = (collectionView as! IndexedCollectionView).sectionInfo else {
            return 0
        }
        return sectionInfo.sectionWidth
    }

    // 5
    override var collectionViewContentSize: CGSize {
      return CGSize(width: contentWidth, height: contentHeight)
    }
    
    override func prepare() {
        super.prepare()
        cache.removeAll()
        guard cache.isEmpty == true || cache.isEmpty == false,
            let collectionView = collectionView
        else {
            return
        }
        
        contentHeight = 0
        
        let indexedCollectionView = (collectionView as! IndexedCollectionView)
        let sectionInfo = indexedCollectionView.sectionInfo
        if(sectionInfo == nil) {
            return
        }
        var sizeMatrix : [[CGSize]]
                    
        var xOffset : CGFloat = 0
        var yOffset : CGFloat = 0
        
        if(indexedCollectionView.isSectionHeader) {
            sizeMatrix = [sectionInfo!.headerSizeMatrix]
        } else {
            sizeMatrix = sectionInfo!.cellSizeMatrix
        }
        
        for row in 0 ..< sizeMatrix.count {
            let rowHeight : CGFloat
            if(indexedCollectionView.isSectionHeader) {
                rowHeight = sectionInfo!.heightForSectionHeader()
            } else {
                rowHeight = sectionInfo!.heightForRow(index: row)
            }
            for cell in 0 ..< sizeMatrix[row].count {
                let contentWidth : CGFloat = sizeMatrix[row][cell].width
                
                let indexPath = IndexPath(item: cell, section: row)
                let frame = CGRect(x: xOffset, y: yOffset, width: contentWidth, height: rowHeight)
                let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)
          
                let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                attributes.frame = insetFrame
                cache.append(attributes)
                xOffset += contentWidth
            }
            
            yOffset += rowHeight
            xOffset = 0
        }
    }
    
    
    
    func rowHeightFromSizeMatrix(input : [CGSize]) -> CGFloat {
        var maxHeight : CGFloat = 0
        for size in input {
            if size.height > maxHeight {
                maxHeight = size.height
            }
        }
        return maxHeight
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
      var visibleLayoutAttributes: [UICollectionViewLayoutAttributes] = []
      
      // Loop through the cache and look for items in the rect
      for attributes in cache {
        if attributes.frame.intersects(rect) {
          visibleLayoutAttributes.append(attributes)
        }
      }
      return visibleLayoutAttributes
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
      return cache[indexPath.item]
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
}
