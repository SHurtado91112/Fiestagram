//
//  SplashViewController.swift
//  Fiestagram
//
//  Created by Steven Hurtado on 3/9/17.
//  Copyright © 2017 Steven Hurtado. All rights reserved.
//

import UIKit
import SAConfettiView

class SplashViewController: UIViewController
{
    
    @IBOutlet weak var fiestaLabel: UILabel!
    @IBOutlet weak var hatImageView: UIImageView!
    
    var startPos = CGPoint()
    
    var confettiView = SAConfettiView()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        self.fiestaLabel.alpha = 0
        
        startPos = hatImageView.frame.origin
        hatImageView.frame.origin.y -= self.view.frame.height
        
        startAnimation()
    }
    
    func startAnimation()
    {
        self.confettiView = SAConfettiView(frame: self.view.bounds)
        self.view.addSubview(confettiView)
        
        self.confettiView.startConfetti()
        
        UIView.animate(withDuration: 1.7, animations: {
            
            self.hatImageView.frame.origin = self.startPos
            
            self.fiestaLabel.alpha = 1
            
        }) { (end: Bool) in
            
            UIView.animate(withDuration: 1.7, animations:
                {
                  self.confettiView.stopConfetti()
            }, completion: { (end2: Bool) in
                if(!Util.loggedIn)
                {
                    self.performSegue(withIdentifier: "splashSegue", sender: self)
                }
                else
                {
                    self.performSegue(withIdentifier: "persistSegue", sender: self)
                }
            })
        }
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
