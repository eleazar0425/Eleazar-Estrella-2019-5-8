//
//  CollectionView+noElementsBackground.swift
//  Pelina Beer App
//
//  Created by Eleazar Estrella GB on 5/10/19.
//  Copyright © 2019 Eleazar Estrella. All rights reserved.
//

import Foundation
import UIKit

extension UICollectionView {
    func showNoElementsBackground(message: String){
        let noDataLabel: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        noDataLabel.text = message
        noDataLabel.textColor = UIColor.black
        noDataLabel.textAlignment = NSTextAlignment.center
        self.backgroundView = noDataLabel
    }
    
    func showNoElementsBackground(){
        self.showNoElementsBackground(message: "No elements")
    }
    
    func removeNoElementsBackground(){
        self.backgroundView = nil
    }
}
