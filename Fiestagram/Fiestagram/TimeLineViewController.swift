//
//  TimeLineViewController.swift
//  Fiestagram
//
//  Created by Steven Hurtado on 3/10/17.
//  Copyright © 2017 Steven Hurtado. All rights reserved.
//

import UIKit
import Parse

class TimeLineViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{

    var posts : [PFObject]!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        getQuery()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.estimatedRowHeight = 120
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: Util.postImageNotification), object: nil, queue: OperationQueue.main) { (Notification) in
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "tabBarStart") as! UITabBarController
            self.view.window?.rootViewController = vc
            
            self.getQuery()
        }
    }

    func getQuery()
    {
        
        print("Getting query")
        // construct query
        let query = PFQuery(className: "Post")
        
        query.limit = 20
        
        // fetch data asynchronously
        query.findObjectsInBackground { (posts: [PFObject]?, error: Error?) in
            if(posts != nil)
            {
                self.posts = posts!
                
                print("Got posts")
                
                self.tableView.reloadData()
            }
            else
            {
                print(error?.localizedDescription)
            }
            
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let cell = tableView.cellForRow(at: indexPath)
        
        cell?.selectionStyle = .none
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "instaCell", for: indexPath) as! TimeLineCell
        
        let post = self.posts![(self.posts.count-1) - indexPath.row]
        
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
        
        if(post["timestamp"] != nil)
        {
            let time = post["timestamp"] as? String
//            cell.timeLabel.text = getFormat(time)
        }
        
        return cell

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
