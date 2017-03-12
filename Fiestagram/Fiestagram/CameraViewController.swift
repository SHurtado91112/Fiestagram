//
//  CameraViewController.swift
//  Fiestagram
//
//  Created by Steven Hurtado on 3/10/17.
//  Copyright © 2017 Steven Hurtado. All rights reserved.
//

import UIKit

class CameraViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    @IBOutlet weak var fromLabel: UILabel!
    
    @IBOutlet weak var galleryBtn: UIButton!
    
    @IBOutlet weak var cameraBtn: UIButton!

    let vc = UIImagePickerController()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    
        vc.delegate = self
        vc.allowsEditing = true
        
        self.fromLabel.layer.addBorder(edge: .bottom, color: UIColor.myFiestaBackGray, thickness: 1)
        
//        let vc = UIImagePickerController()
//        vc.delegate = self
//        vc.allowsEditing = true
//        vc.sourceType = UIImagePickerControllerSourceType.camera
//        
//        self.present(vc, animated: true, completion: nil)
    }

    
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : Any])
    {
        print("Image Picked (delegated)")
        
        // Get the image captured by the UIImagePickerController
        let editedImage = info[UIImagePickerControllerEditedImage] as! UIImage
        
        // Dismiss UIImagePickerController to go back to your original view controller
        dismiss(animated: true, completion: nil)
        
        self.performSegue(withIdentifier: "imageDetailSegue", sender: editedImage)
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func galleryPressed(_ sender: Any)
    {
        vc.sourceType = UIImagePickerControllerSourceType.photoLibrary

        self.present(vc, animated: true, completion: nil)
    }
    
    func resize(image: UIImage, newSize: CGSize) -> UIImage
    {
        let resizeImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        resizeImageView.contentMode = UIViewContentMode.scaleAspectFit
        resizeImageView.image = image
        
        UIGraphicsBeginImageContext(resizeImageView.frame.size)
        resizeImageView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if(segue.identifier == "imageDetailSegue")
        {
            let segueImage = sender as! UIImage
            
            let vc = segue.destination as! EditImageViewController
            
            vc.editImage = segueImage
            vc.originalImage = segueImage
        }
    }

}
