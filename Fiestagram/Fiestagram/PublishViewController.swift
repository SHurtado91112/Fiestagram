//
//  PublishViewController.swift
//  Fiestagram
//
//  Created by Steven Hurtado on 3/10/17.
//  Copyright © 2017 Steven Hurtado. All rights reserved.
//

import UIKit
import Parse
import NVActivityIndicatorView

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
        
        let actInd = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 200, height: 200), type: NVActivityIndicatorType.ballGridBeat, color: UIColor.myInstaRedViolet, padding: 0.0)
        
        
        actInd.frame = CGRect(x: 0, y: 0, width: self.view.frame.width/2, height: self.view.frame.width/2)
            
        actInd.center = self.view.center
        
        self.view.addSubview(actInd)
        
        self.view.bringSubview(toFront: actInd)
        
        actInd.startAnimating()
        
        if(self.publishImageView.image != nil && self.captionLabel.text != "")
        {
            
            Post.postUserImage(image: publishImageView.image!, withCaption: self.captionLabel.text!, withCompletion: { (success: Bool, error: Error?) in
                if(error != nil)
                {
                    print(error?.localizedDescription)
                
                    actInd.stopAnimating()
                }
                else
                {
                    print("Posted Image!")
                    
                    actInd.stopAnimating()
                    
                    _ = self.navigationController?.popToRootViewController(animated: true)
                    
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "tabBarStart")
                    
                    self.view.window?.rootViewController = vc
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: Util.postImageNotification), object: nil)
                }
            })
        }
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
