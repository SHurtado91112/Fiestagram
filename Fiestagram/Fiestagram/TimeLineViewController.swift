//
//  TimeLineViewController.swift
//  Fiestagram
//
//  Created by Steven Hurtado on 3/10/17.
//  Copyright © 2017 Steven Hurtado. All rights reserved.
//

import UIKit
import Parse
import NVActivityIndicatorView

class TimeLineViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{

    var posts : [PFObject]!
    
    @IBOutlet weak var tableView: UITableView!
    
    let actInd = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 200, height: 200), type: NVActivityIndicatorType.ballGridBeat, color: UIColor.myInstaRedViolet, padding: 0.0)
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.actInd.frame = CGRect(x: 0, y: 0, width: self.view.frame.width/2, height: self.view.frame.width/2)
        
        self.actInd.center = self.view.center
        
        self.actInd.stopAnimating()
        
        self.view.addSubview(actInd)
        
        getQuery()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.estimatedRowHeight = 120
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: Util.postImageNotification), object: nil, queue: OperationQueue.main) { (Notification) in
            
            self.getQuery()
        }
    }

    func getQuery()
    {
        
        self.view.bringSubview(toFront: self.actInd)
        self.actInd.startAnimating()
        
        print("Getting query")
        // construct query
        let query = PFQuery(className: "Post")
        
        query.limit = 20
        
        // fetch data asynchronously
        query.findObjectsInBackground { (posts: [PFObject]?, error: Error?) in
            if(posts != nil)
            {
                self.posts = posts!
                
                self.actInd.stopAnimating()
                
                print("Got posts")
                
                self.tableView.reloadData()
            }
            else
            {
                self.actInd.stopAnimating()
                print(error?.localizedDescription)
            }
            
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        print("Getting count")
        if (self.posts != nil)
        {
            print("Count: \(self.posts!.count)")
            return self.posts!.count
        }
        else
        {
            return 0
        }
        
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
        
        let post = self.posts![(self.posts.count-1) - indexPath.section]
        
        print(post)
        
        if(post["media"] != nil)
        {
            let imageFile = post["media"] as! PFFile
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
        
        if(post["caption"] != nil)
        {
            cell.captionLabel.text = post["caption"] as? String
        }
        
        if(post["likesCount"] != nil)
        {
            let likes = post["likesCount"]
            cell.likesCountLabel.text = "\(likes!) likes"
        }
        
        if(post["username"] != nil)
        {
            cell.userLabel.text = post["username"] as? String
        }
        
        
        
        return cell

    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let header = tableView.dequeueReusableCell(withIdentifier: "header") as! HeaderCell
        
//        let author = posts[section]["author"] as? PFUser
//        let profileImage = author?["profile_image"] as? PFFile
//        
//        if(profileImage != nil)
//        {
//            profileImage?.getDataInBackground(block: { (data: Data?, error: Error?) in
//                if(error != nil)
//                {
//                    let image = UIImage(data: data!)
//                    header.avatarImageView.image = image
//                }
//            })
//        }
        
        let username = self.posts?[(self.posts.count-1) - section]["username"] as? String
        
        if(username != nil)
        {
            header.nameLabel.text = username
        }
        
        let date = posts?[(self.posts.count-1) - section].createdAt
        
        if(date != nil)
        {
            header.timeLabel.text  = getFormat(date: date!)
        }
        
        
        return header
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
