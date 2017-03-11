//
//  PopViewController.swift
//  Fiestagram
//
//  Created by Steven Hurtado on 3/10/17.
//  Copyright © 2017 Steven Hurtado. All rights reserved.
//

import UIKit
import Parse

class PopViewController: UIViewController
{
    @IBOutlet weak var logOutBtn: UIButton!

    @IBOutlet weak var cancelBtn: UIButton!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func cancelPressed(_ sender: Any)
    {
        self.view.alpha = 1
        
        UIView.animate(withDuration: 0.3, animations: {
            self.view.alpha = 0
        }) { (completion: Bool) in
            
            let parent = self.parent as! ProfileViewController
            
            parent.moreBtn.isEnabled = true
            
            self.removeFromParentViewController()
        }
    }
    
    @IBAction func logOut(_ sender: Any)
    {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: Util.logOutNotification), object: nil)
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
