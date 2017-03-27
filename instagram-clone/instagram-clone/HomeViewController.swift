//
//  HomeViewController.swift
//  instagram-clone
//
//  Created by Mike Miksch on 3/27/17.
//  Copyright © 2017 Mike Miksch. All rights reserved.
//

import UIKit
import MobileCoreServices

class HomeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    let imagePicker = UIImagePickerController()
    var newPicture : Bool?
    
    @IBOutlet weak var imageView: UIImageView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera
            imagePicker.mediaTypes = [kUTTypeImage as String]
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
            newPicture = true
        }
    }
    
    func presentImagePickerWith(sourceType: UIImagePickerControllerSourceType) {
        self.imagePicker.delegate = self
        self.imagePicker.sourceType = sourceType
        self.present(self.imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let chosenImage = info[UIImagePickerControllerEditedImage] as! UIImage
        imageView.image = chosenImage
        dismiss(animated: true, completion: nil)
    }

    @IBAction func imageTapped(_ sender: Any) {
        print("User Tapped Image!")
        self.presentActionSheet()
    }
    
    func presentActionSheet() {
        let actionSheetController = UIAlertController(title: "Source", message: "Please select Source Type", preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { (action) in
            self.presentImagePickerWith(sourceType: .camera)
        }
        
        let photoAction = UIAlertAction(title: "Photo Library", style: .default) { (action) in
            self.presentImagePickerWith(sourceType: .photoLibrary)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        
        actionSheetController.addAction(cameraAction)
        actionSheetController.addAction(photoAction)
        actionSheetController.addAction(cancelAction)
        
        self.present(actionSheetController, animated: true, completion: nil)
    }
    
}
