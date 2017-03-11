//
//  ProfileViewController.swift
//  Fiestagram
//
//  Created by Steven Hurtado on 3/10/17.
//  Copyright © 2017 Steven Hurtado. All rights reserved.
//

import UIKit
import Parse

class ProfileViewController: UIViewController, UIPopoverPresentationControllerDelegate {
    
    @IBOutlet weak var moreBtn: UIBarButtonItem!

    var popViewContr : UIViewController? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func moreBtnPressed(_ sender: Any)
    {
        self.moreBtn.isEnabled = false
        
        popViewContr = storyboard?.instantiateViewController(withIdentifier: "PopOverController") as! PopViewController
        
        popViewContr?.view.alpha = 0
        
        self.addChildViewController(popViewContr!)
        
        popViewContr?.view.frame = self.view.frame
        
        self.view.addSubview((popViewContr?.view)!)
        
        popViewContr?.didMove(toParentViewController: self)
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: Util.logOutNotification), object: nil, queue: OperationQueue.main) { (Notification) in
            
            self.logOutNotified()
        }
        
        
        UIView.animate(withDuration: 0.3)
        {
            self.popViewContr?.view.alpha = 1
        }

    }
    
    func logOutNotified()
    {
        PFUser.logOutInBackground
            { (error: Error?) in
                Util.loggedIn = false
                
                UIView.animate(withDuration: 0.3, animations: {
                    self.popViewContr?.view.alpha = 0
                }) { (completion: Bool) in
                    
                    self.popViewContr?.removeFromParentViewController()
                    
                    Util.currentUsername = ""
                    
                    self.moreBtn.isEnabled = true
                    
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    
                    let vc = storyboard.instantiateInitialViewController()
                    
                    self.view.window?.rootViewController = vc
                }
        }
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        // return UIModalPresentationStyle.FullScreen
        return .none
    }
    
    override func didReceiveMemoryWarning() {
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
