//
//  FilterCell.swift
//  instagram-clone
//
//  Created by Mike Miksch on 3/30/17.
//  Copyright © 2017 Mike Miksch. All rights reserved.
//

import UIKit

class FilterCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var filterLabel: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.imageView.image = nil
        self.filterLabel.text = nil
    }
}
