//
//  Util.swift
//  Fiestagram
//
//  Created by Steven Hurtado on 3/9/17.
//  Copyright © 2017 Steven Hurtado. All rights reserved.
//

import Foundation
import UIKit
import Parse

class Util: NSObject
{
    static var loggedIn = false
    static var currentUsername = ""
    
    static let logOutNotification = "UserDidLogOut"
    static let postImageNotification = "UserDidPostImage"
    static let userDidUpdateImage = "UserDidUpdateImage"
    
    class func invokeAlertMethod(_ strTitle: NSString, strBody: NSString, delegate: AnyObject?)
    {
        let rootVC = UIApplication.shared.keyWindow?.rootViewController
        
        let alert = UIAlertController(title: strTitle as String, message: strBody as String, preferredStyle: .alert)
        let action1 = UIAlertAction(title: "Okay", style: .default, handler: { (action) in
            rootVC?.dismiss(animated: true, completion: nil)
        })
        
        alert.addAction(action1)
        
        rootVC?.present(alert, animated: true, completion: nil)
    }
}

class Post: NSObject
{
    /**
     * Other methods
     */
    
    /**
     Method to add a user post to Parse (uploading image file)
     
     - parameter image: Image that the user wants upload to parse
     - parameter caption: Caption text input by the user
     - parameter completion: Block to be executed after save operation is complete
     */
    class func postUserImage(image: UIImage?, withCaption caption: String?, withCompletion completion: PFBooleanResultBlock?)
    {
        // Create Parse object PFObject
        let post = PFObject(className: "Post")
        
        // Add relevant fields to the object
        post["media"] = getPFFileFromImage(image: image) // PFFile column type
        post["author"] = PFUser.current()// Pointer column type that points to PFUser
        post["username"] = PFUser.current()?.username
        post["screen_name"] = Util.currentUsername
        post["profile_image"] = PFUser.current()?["profile_image"]
        post["caption"] = caption
        post["likesCount"] = 0
        post["commentsCount"] = 0
        
        // Save object (following function will save the object in Parse asynchronously)
        post.saveInBackground(block: completion)
    }
    
    /**
     Method to convert UIImage to PFFile
     
     - parameter image: Image that the user wants to upload to parse
     
     - returns: PFFile for the the data in the image
     */
    class func getPFFileFromImage(image: UIImage?) -> PFFile?
    {
        // check if image is not nil
        if let image = image
        {
            // get image data and check if that is not nil
            if let imageData = UIImagePNGRepresentation(image)
            {
                return PFFile(name: "image.png", data: imageData)
            }
        }
        return nil
    }
}

extension CALayer {
    
    func addBorder(edge: UIRectEdge, color: UIColor, thickness: CGFloat) {
        
        let border = CALayer()
        
        switch edge {
        case UIRectEdge.top:
            border.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: thickness)
            break
        case UIRectEdge.bottom:
            border.frame = CGRect(x: 0, y: self.frame.height - thickness, width: self.frame.width, height: thickness)
            break
        case UIRectEdge.left:
            border.frame = CGRect(x: 0, y: 0, width: thickness, height: self.frame.height)
            break
        case UIRectEdge.right:
            border.frame = CGRect(x: self.frame.width - thickness, y: 0, width: thickness, height: self.frame.height)
            break
        default:
            break
        }
        
        border.backgroundColor = color.cgColor;
        
        self.addSublayer(border)
    }
    
}

extension UIColor
{
    //fiestagram colors
    static var myFiestaBackGray: UIColor
    {
        //5f5f5f
        return UIColor(red: 95.0/255.0, green: 95.0/255.0, blue: 95.0/255.0, alpha: 1)
    }
    
    static var myFiestaDeepPurple: UIColor
    {
        //390D2B
        return UIColor(red: 57.0/255.0, green: 13.0/255.0, blue: 43.0/255.0, alpha: 1)
    }
    
    static var myInstaPurpleViolet: UIColor
    {
        //8a3ab9
        return UIColor(red: 138.0/255.0, green: 58.0/255.0, blue: 185.0/255.0, alpha: 1)
    }
    
    static var myInstaRedViolet: UIColor
    {
        //BC2A8D
        return UIColor(red: 188.0/255.0, green: 42.0/255.0, blue: 141.0/255.0, alpha: 1)
    }
    
    static var myInstaMaroon: UIColor
    {
        //cd486b
        return UIColor(red: 205.0/255.0, green: 72.0/255.0, blue: 107.0/255.0, alpha: 1)
    }
    
    static var myInstaYellow: UIColor
    {
        //fccc63
        return UIColor(red: 252.0/255.0, green: 204.0/255.0, blue: 99.0/255.0, alpha: 1)
    }
    
    //langua colors
    static var myMugiwaraYellow: UIColor
    {
        //E1CE7A
        return UIColor(red: 250.0/255.0, green: 123.0/255.0, blue: 84.0/255.0, alpha: 1)
    }
    
    static var myOuterSpaceBlack: UIColor
    {
        //424B54
        return UIColor(red: 250.0/255.0, green: 123.0/255.0, blue: 84.0/255.0, alpha: 1)
    }
    
    static var myIsabellineWhite: UIColor
    {
        //F6E8EA
        return UIColor(red: 250.0/255.0, green: 123.0/255.0, blue: 84.0/255.0, alpha: 1)
    }
    
    static var myCarminePink: UIColor
    {
        //EF626C
        return UIColor(red: 250.0/255.0, green: 123.0/255.0, blue: 84.0/255.0, alpha: 1)
    }
    
    //sg colors
    static var myCreamOrange: UIColor
    {
        //FA7B54
        return UIColor(red: 250.0/255.0, green: 123.0/255.0, blue: 84.0/255.0, alpha: 1)
    }
    
    static var myDullBlue: UIColor
    {
        //5B7FA4
        return UIColor(red: 91.0/255.0, green: 127.0/255.0, blue: 164.0/255.0, alpha: 1)
    }
    
    static var groupTableViewCell: UIColor
    {
        //EBEBF1
        return UIColor(red: 235.0/255.0, green: 235.0/255.0, blue: 241.0/255.0, alpha: 1)
    }
    
    
    //other colors
    static var myOffWhite: UIColor
    {
        //FAFAFA
        return UIColor(red: 250.0/255.0, green: 250.0/255.0, blue: 250.0/255.0, alpha: 1)
    }
    
    static var mySalmonRed: UIColor
    {
        //F55D3E
        return UIColor(red: 245.0/255.0, green: 93.0/255.0, blue: 62.0/255.0, alpha: 1)
    }
    
    static var myRoseMadder: UIColor
    {
        //D72638
        return UIColor(red: 215.0/255.0, green: 38.0/255.0, blue: 56.0/255.0, alpha: 1)
    }
    
    static var myOnyxGray: UIColor
    {
        //878E88
        return UIColor(red: 135.0/255.0, green: 142.0/255.0, blue: 136.0/255.0, alpha: 1)
    }
    
    static var myTimberWolf: UIColor
    {
        //DAD6D6
        return UIColor(red: 218.0/255.0, green: 214.0/255.0, blue: 214.0/255.0, alpha: 1)
    }
    
    
    static var myMatteGold: UIColor
    {
        //F7CB15
        return UIColor(red: 247.0/255.0, green: 203.0/255.0, blue: 21.0/255.0, alpha: 1)
    }
    
    static var twitterBlue: UIColor
    {
        //00aced
        return UIColor(red: 0.0/255.0, green: 172.0/255.0, blue: 237.0/255.0, alpha: 1)
    }
}
