//
//  Filters.swift
//  instagram-clone
//
//  Created by Mike Miksch on 3/28/17.
//  Copyright © 2017 Mike Miksch. All rights reserved.
//

import UIKit

enum FilterName : String {
    case vintage = "CIPhotoEffectTransfer"
    case blackAndWhite = "CIPhotoEffectMono"
    case sepia = "CISepiaTone"
    case comic = "CIComicEffect"
    case blur = "CIMotionBlur"
    case posterize = "CIColorPosterize"
    case invert = "CIColorInvert"
    case fade = "CIPhotoEffectFade"    
}

enum FilterErrors : Error {
    case ciFilterError
    case eaglContextError
    case outputError
}

typealias FilterCompletion = (UIImage?) -> ()

class Filters {
    
    static let shared = Filters()
    
    static var originalImage : UIImage?
    
    static var history = [originalImage]
    
    var ciContext : CIContext
    
    private init() {
        let options = [kCIContextWorkingColorSpace : NSNull()]
        let eaglContext = EAGLContext(api: .openGLES2)!
        ciContext = CIContext(eaglContext: eaglContext, options: options)
    }
    
    class func filter(name: FilterName, image: UIImage, _ label: String?, completion: @escaping FilterCompletion) {
        OperationQueue().addOperation {
            
            guard let filter = CIFilter(name: name.rawValue) else { fatalError("Failed to create CIFilter") }
            
            let coreImage = CIImage(image: image)
            filter.setValue(coreImage, forKey: kCIInputImageKey)

            
            //Get final image using GPU
            
            guard let outputImage = filter.outputImage else { fatalError("Failed to get output image from filter") }
            
            if let cgImage = Filters.shared.ciContext.createCGImage(outputImage, from: outputImage.extent) {
                
                let finalImage = UIImage(cgImage: cgImage)
                OperationQueue.main.addOperation {
                    completion(finalImage)
                }
                
            } else {
                OperationQueue.main.addOperation {
                    completion(nil)
                }
            }
            
        }
    }
    
}
