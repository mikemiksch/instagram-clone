//
//  CloudKit.swift
//  instagram-clone
//
//  Created by Mike Miksch on 3/27/17.
//  Copyright © 2017 Mike Miksch. All rights reserved.
//

import Foundation
import CloudKit

class CloudKit {
    
    static let shared = CloudKit()
    
    let container = CKContainer.default()
    
    var privateDatabase : CKDatabase {
        return container.privateCloudDatabase
    }
    
}
