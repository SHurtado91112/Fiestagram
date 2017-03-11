//
//  EditImageViewController.swift
//  Fiestagram
//
//  Created by Steven Hurtado on 3/10/17.
//  Copyright © 2017 Steven Hurtado. All rights reserved.
//

import UIKit

class EditImageViewController: UIViewController, UITextFieldDelegate
{

    @IBOutlet weak var captionTextField: UITextField!
    
    @IBOutlet weak var editImageView: UIImageView!
    
    var editPos = CGPoint()
    var capPos = CGPoint()
    
    @IBOutlet weak var filterLabel: UILabel!
    
    @IBOutlet weak var filterCollectionView: UICollectionView!
    
    var editImage : UIImage = UIImage()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.filterLabel.layer.addBorder(edge: .bottom
            , color: UIColor.myFiestaBackGray, thickness: 1)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardNotification(notification:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        
        editPos = editImageView.frame.origin
        capPos = captionTextField.frame.origin
        
        editImageView.image = editImage
        
    }

    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        UIView.animate(withDuration: 0.3)
        {
        
        }
    }
    
    // MARK: - Text Field
    
    func keyboardNotification(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let endFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            let duration:TimeInterval = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            let animationCurveRawNSN = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber
            let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIViewAnimationOptions.curveEaseInOut.rawValue
            let animationCurve:UIViewAnimationOptions = UIViewAnimationOptions(rawValue: animationCurveRaw)
            if (endFrame?.origin.y)! >= UIScreen.main.bounds.size.height {
                
            } else {
                
                UIView.animate(withDuration: 0.3, animations:
                    {
                        
                        var yPos = self.capPos.y - (endFrame?.size.height ?? 80)/4
                        
                        
                        self.captionTextField.frame.origin = CGPoint(x: 0, y: yPos)
                        
                        yPos = self.editPos.y - (endFrame?.size.height ?? 80)/4
                        
                        self.editImageView.frame.origin = CGPoint(x: 0, y: yPos)
                        
                        
                })
                
            }
            UIView.animate(withDuration: duration,
                           delay: TimeInterval(0),
                           options: animationCurve,
                           animations: { self.view.layoutIfNeeded() },
                           completion: nil)
        }
    }

    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        UIView.animate(withDuration: 0.3)
        {
            self.editImageView.frame.origin = self.editPos
            self.captionTextField.frame.origin = self.capPos
        }
        
        self.view.endEditing(true)
        self.resignFirstResponder()
        return true
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if(segue.identifier == "publishSegue")
        {
            let vc = segue.destination as! PublishViewController
            
            vc.publishImage = self.editImage
            vc.captionText = self.captionTextField.text!
        }
    }
}
