//
//  ImageDetailViewController.swift
//  Fiestagram
//
//  Created by Steven Hurtado on 3/11/17.
//  Copyright © 2017 Steven Hurtado. All rights reserved.
//

import UIKit
import Parse
import SAConfettiView

class ImageDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    
    var imageFile : PFFile!
    var username : String?
    var likesCount : Int = 0
    var caption : String?
    var date : Date?
    var profileImage : PFFile!
    
    var post : PFObject!
    
    var confettiView = SAConfettiView()
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        self.confettiView = SAConfettiView(frame: self.view.bounds)
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.estimatedRowHeight = 120
        self.tableView.rowHeight = UITableViewAutomaticDimension

        // Do any additional setup after loading the view.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let cell = tableView.cellForRow(at: indexPath)
        
        cell?.selectionStyle = .none
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "instaCell", for: indexPath) as! TimeLineCell
        
        if(self.imageFile != nil)
        {
            imageFile.getDataInBackground(block: { (data: Data?, error: Error?) in
                if(error != nil)
                {
                    print(error?.localizedDescription)
                }
                else
                {
                    let image = UIImage(data: data!)
                    cell.instaImageView.image = image
                }
            })
        }
        
        if(self.caption != nil)
        {
            cell.captionLabel.text = self.caption
        }
        
        cell.likesCountLabel.text = "\(self.likesCount) likes"
        cell.likeBtn.addTarget(self, action: #selector(likeClicked(_:)), for: .touchUpInside)
        cell.likeBtn.indexPath = indexPath
        cell.likeBtn.liked = false
        
        if(self.username != nil)
        {
            cell.userLabel.text = self.username
        }
        
        
        return cell
        
    }
    
    func likeClicked(_ sender: Any)
    {
        let button = sender as! LikeButton
        
        let cell = tableView.cellForRow(at: (button.indexPath)) as! TimeLineCell
        
        var currentLikes = self.post["likesCount"] as? Int
        
        self.confettiView.alpha = 1
        if(!(button.liked))
        {
            self.view.addSubview(confettiView)
            self.confettiView.startConfetti()
            cell.likeBtn.tintColor = UIColor.red
            cell.likeBtn.setImage(UIImage(named: "Like Filled-50"), for: .normal)
            cell.likeBtn.liked = true
            
            (currentLikes!) += 1
        }
        else
        {
            cell.likeBtn.tintColor = UIColor.myFiestaBackGray
            cell.likeBtn.setImage(UIImage(named: "Like-50"), for: .normal)
            cell.likeBtn.liked = false
            
            (currentLikes!) -= 1
        }
        
        cell.likesCountLabel.text = "\(currentLikes!) likes"
        self.post["likesCount"] = currentLikes!
        
        self.post.saveInBackground()
        
        UIView.animate(withDuration: 1.7, animations: {
            self.confettiView.alpha = 0
        }) { (completion: Bool) in
            self.confettiView.stopConfetti()
            self.confettiView.removeFromSuperview()
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let header = tableView.dequeueReusableCell(withIdentifier: "header") as! HeaderCell
        
        if(profileImage != nil)
        {
            profileImage?.getDataInBackground(block: { (data: Data?, error: Error?) in
                if(error == nil)
                {
                    let image = UIImage(data: data!)
                    header.avatarImageView.image = image
                }
                else
                {
                    header.avatarImageView.image = UIImage(named: "Gender Neutral User-50")
                }
            })
        }
        else
        {
            header.avatarImageView.image = UIImage(named: "Gender Neutral User-50")
        }
        
        if(self.username != nil)
        {
            header.nameLabel.text = self.username
        }
        
        if(self.date != nil)
        {
            header.timeLabel.text  = getFormat(date: self.date!)
        }
        
        
        return header
    }


    func getDifference(date: Date) -> Int {
        
        let difference = Int(Date().timeIntervalSince(date))
        return difference
    }
    
    func getFormat(date: Date) -> String
    {
        let seconds = self.getDifference(date: date)
        
        let hours = seconds/3600
        
        if(hours >= 24)
        {
            let newDateFormat = DateFormatter()
            newDateFormat.dateFormat = "MMM d, yyyy"
            
            return newDateFormat.string(from: date)
        }
        else
        {
            if(hours >= 1)
            {
                return "\(hours)h"
            }
            else
            {
                let mins = seconds/60
                
                if(mins >= 1)
                {
                    return "\(mins)m"
                }
                else
                {
                    return "\(seconds)s"
                }
            }
            
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
