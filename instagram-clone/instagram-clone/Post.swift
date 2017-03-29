//
//  Post.swift
//  instagram-clone
//
//  Created by Mike Miksch on 3/28/17.
//  Copyright © 2017 Mike Miksch. All rights reserved.
//

import UIKit
import CloudKit

class Post  {
    let image : UIImage
    let date : String
    init(image: UIImage) {
        self.image = image
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        self.date = dateFormatter.string(from: currentDate)
    }
}

enum PostError : Error {
    case writingImageToData
    case writingDataToDisk
}

extension Post {
    class func recordFor(post: Post) throws -> CKRecord? {
        guard let data = UIImageJPEGRepresentation(post.image, 0.7) else { throw PostError.writingImageToData }
        
        do {
            try data.write(to: post.image.path)
            
            let asset = CKAsset(fileURL: post.image.path)
            
            let record = CKRecord(recordType: "Post")
            record.setValue(asset, forKey: "image")
            record.setValue(asset, forKey: "date")
            
            return record
            
        } catch {
            throw PostError.writingDataToDisk
        }
    }
}
