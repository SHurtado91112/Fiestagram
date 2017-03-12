//
//  SignInViewController.swift
//  Fiestagram
//
//  Created by Steven Hurtado on 3/9/17.
//  Copyright © 2017 Steven Hurtado. All rights reserved.
//

import UIKit
import Parse

class SignInViewController: UIViewController, UITextFieldDelegate
{
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    @IBOutlet weak var signInBtn: UIButton!
    
    @IBOutlet weak var signUpBtn: UIButton!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        self.signInBtn.layer.cornerRadius = 10
        self.signUpBtn.layer.cornerRadius = 10
    }

    @IBAction func signInPressed(_ sender: Any)
    {
        PFUser.logInWithUsername(inBackground: self.usernameTextField.text!, password: self.passwordTextField.text!) { (user: PFUser?, error: Error?) in
            if(user != nil)
            {
                self.setCurrentUsername()
                
                let alert = UIAlertController(title: "Success!", message: "You have signed in.", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction((UIAlertAction(title: "Okay", style: .default, handler: { (action) in
                    self.performSegue(withIdentifier: "loginSegue", sender: self)
                })))
                
                self.present(alert, animated: true, completion: nil)
            }
            else
            {
                let errorString : String = (error?.localizedDescription)!
                
                self.displayAlert("Error", message: errorString)
            }
        }

        
    }
    
    func setCurrentUsername()
    {
        let text = self.usernameTextField.text!
        
        if let range: Range<String.Index> = text.range(of: "@")
        {
            let range2: Range<String.Index> = Range(uncheckedBounds: (lower: text.startIndex, upper: range.lowerBound))
            
            Util.currentUsername = text.substring(with: range2)
            
            print("Current User: \(Util.currentUsername)")
        }
        else
        {
            Util.currentUsername = text
        }
        
        
        
    }
    
    @IBAction func signUpPressed(_ sender: Any)
    {
        let newUser = PFUser()
        
        newUser.username = usernameTextField.text!
        
        setCurrentUsername()
        
        newUser["screen_name"] = Util.currentUsername
        newUser["bio"] = "I'm your bio! Go ahead and edit me!"
        newUser["profile_image"] = Post.getPFFileFromImage(image: UIImage(named: "Gender Neutral User-50"))
        
        newUser.password = passwordTextField.text!
        
        newUser.signUpInBackground { (success: Bool, error: Error?) in
            if(success)
            {
                let alert = UIAlertController(title: "Success!", message: "You now have an account.", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction((UIAlertAction(title: "Okay", style: .default, handler: { (action) in
                    self.performSegue(withIdentifier: "loginSegue", sender: self)
                })))
                
                self.present(alert, animated: true, completion: nil)
            }
            else
            {
                let errorString : String = (error?.localizedDescription)!
                
                self.displayAlert("Error", message: errorString)
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        switch(textField.tag)
        {
            case 0:
                self.passwordTextField.becomeFirstResponder()
            break
            default:
                self.view.endEditing(true)
                resignFirstResponder()
            break
        }
        
        return true
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
