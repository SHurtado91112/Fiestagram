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
import SAConfettiView

class TimeLineViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{

    var posts : [PFObject]?
    
    @IBOutlet weak var tableView: UITableView!
    
    let actInd = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 200, height: 200), type: NVActivityIndicatorType.ballRotateChase, color: UIColor.myInstaRedViolet, padding: 0.0)
    
    var confettiView = SAConfettiView()
    
    override func viewDidAppear(_ animated: Bool)
    {
        self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "LietoMe", size: 32)!]
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.confettiView = SAConfettiView(frame: self.view.bounds)
        
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
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: Util.userDidUpdateImage), object: nil, queue: OperationQueue.main) { (Notification) in
            
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
        
        let post = self.posts![((self.posts?.count)!-1) - indexPath.section]
        
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
            cell.likeBtn.addTarget(self, action: #selector(likeClicked(_:)), for: .touchUpInside)
            cell.likeBtn.indexPath = indexPath
            cell.likeBtn.liked = false
        }
        
        if(post["screen_name"] != nil)
        {
            cell.userLabel.text = post["screen_name"] as? String
            cell.recog.indexPath = indexPath
            cell.recog.addTarget(self, action: #selector(labelClicked(_:)))
        }
        
        return cell

    }
    
    func labelClicked(_ sender: Any)
    {
        let recog = sender as! CustomTapRecognizer
    
        let indexPath = recog.indexPath
        
        print("Tapped Label")
        
        self.performSegue(withIdentifier: "profileSegue", sender: indexPath)
    }
    
    func likeClicked(_ sender: Any)
    {
        let button = sender as! LikeButton
        
        let cell = tableView.cellForRow(at: (button.indexPath)) as! TimeLineCell
        
        let post = self.posts![((self.posts?.count)!-1) - button.indexPath.section]
        
        var currentLikes = post["likesCount"] as? Int
        
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
        post["likesCount"] = currentLikes!
        
        post.saveInBackground()
        
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
        
        let indece = ((self.posts?.count)!-1) - section
        
        let post = self.posts![indece]
        
        let author = post["author"] as! PFUser
        
        print(author.objectId!)
        let query = PFUser.query()
        query?.limit = 20
        query?.whereKey("username", equalTo: post["username"])
        
        query?.getFirstObjectInBackground { queryUser, error in
            
            print("in query")
            print(query!)
            if error == nil
            {
                print(queryUser!)
//                var userVariable = newUser.objectId as String
                print(queryUser!["profile_image"])
                if(queryUser!["profile_image"] != nil)
                {
                    let profileImage = queryUser!["profile_image"] as! PFFile
                    
                    profileImage.getDataInBackground(block: { (data: Data?, error: Error?) in
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

            }
            else{
                print(error?.localizedDescription)
                header.avatarImageView.image = UIImage(named: "Gender Neutral User-50")
            }
        }
        
        let username = self.posts?[((self.posts?.count)!-1) - section]["screen_name"] as? String
        
        if(username != nil)
        {
            header.nameLabel.text = username
            header.recog.addTarget(self, action: #selector(labelClicked(_:)))
            header.recog.indexPath = IndexPath(row: 0, section: section)
        }
        
        let date = posts?[((self.posts?.count)!-1) - section].createdAt
        
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
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if(segue.identifier == "profileSegue")
        {
            let vc = segue.destination as! ProfileViewController
            
            let indexPath = sender as! IndexPath
            
            let post = posts?[((self.posts?.count)!-1) - indexPath.section]
            
            vc.selfProfile = false
            vc.otherScreenName = (post?["screen_name"] as? String)!
            vc.otherUserName = (post?["username"] as? String)!
            vc.userPost = post
        }
    }

}
