//
//  PublishViewController.swift
//  Fiestagram
//
//  Created by Steven Hurtado on 3/10/17.
//  Copyright © 2017 Steven Hurtado. All rights reserved.
//

import UIKit
import Parse

class PublishViewController: UIViewController
{

    @IBOutlet weak var looksGoodLabel: UILabel!
    
    @IBOutlet weak var publishBtn: UIButton!
    
    @IBOutlet weak var captionLabel: UILabel!
    
    @IBOutlet weak var publishImageView: UIImageView!
    
    var publishImage = UIImage()
    var captionText = ""
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.publishImageView.image = publishImage
        self.captionLabel.text = captionText
        
        looksGoodLabel.layer.addBorder(edge: .bottom, color: UIColor.myFiestaBackGray, thickness: 1)
    }

    @IBAction func publishPressed(_ sender: Any)
    {
        
        if(self.publishImageView.image != nil && self.captionLabel.text != "")
        {
            
            Post.postUserImage(image: publishImageView.image!, withCaption: self.captionLabel.text!, withCompletion: { (success: Bool, error: Error?) in
                if(error != nil)
                {
                    print(error?.localizedDescription)
                    
//                    MBProgressHUD.hide(self.view, animated: true)
                }
                else
                {
                    print("Posted Image!")
//                    MBProgressHUD.hideHUDForView(self.view, animated: true)
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: Util.postImageNotification), object: nil)
                }
            })
        }
        
        _ = self.navigationController?.popToRootViewController(animated: true)
    }
    
    func displayAlert(_ title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction((UIAlertAction(title: "Okay", style: .default, handler: { (action) in
            
        })))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
