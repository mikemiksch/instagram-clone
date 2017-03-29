//
//  GalleryCell.swift
//  instagram-clone
//
//  Created by Mike Miksch on 3/29/17.
//  Copyright © 2017 Mike Miksch. All rights reserved.
//

import UIKit

class GalleryCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    
    var post : Post! {
        didSet  {
            self.imageView.image = post.image
            self.dateLabel.text = post.date
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.dateLabel.text = nil
        self.imageView.image = nil 
    }
    
}
