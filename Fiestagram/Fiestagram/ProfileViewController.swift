//
//  ProfileViewController.swift
//  Fiestagram
//
//  Created by Steven Hurtado on 3/10/17.
//  Copyright © 2017 Steven Hurtado. All rights reserved.
//

import UIKit
import Parse
import NVActivityIndicatorView

class ProfileViewController: UIViewController, UIPopoverPresentationControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    
    var posts : [PFObject]!
    var userPost: PFObject!
    
    var otherUserName = ""
    var selfProfile = true
    
    var recog = UITapGestureRecognizer()
    
    let actInd = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 200, height: 200), type: NVActivityIndicatorType.ballGridBeat, color: UIColor.myInstaRedViolet, padding: 0.0)

    
    @IBOutlet weak var moreBtn: UIBarButtonItem!

    @IBOutlet weak var avatarImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var taglineTextView: UITextView!
    @IBOutlet weak var uploadLabel: UILabel!
    var popViewContr : UIViewController? = nil
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.uploadLabel.isHidden = true
        self.taglineTextView.isUserInteractionEnabled = false
        self.taglineTextView.text = "I'm your bio! Go ahead and edit me!"

        self.taglineTextView.delegate = self
        self.taglineTextView.textContainer.lineFragmentPadding = 0
        self.taglineTextView.textContainerInset = UIEdgeInsets.zero
        
        self.recog = UITapGestureRecognizer(target: self, action: #selector(avatarUpload(_:)))
        
        self.avatarImageView.layer.cornerRadius = self.avatarImageView.frame.size.width / 2
        self.avatarImageView.clipsToBounds = true
        
        if(selfProfile)
        {
            self.avatarImageView.isUserInteractionEnabled = true
            self.avatarImageView.addGestureRecognizer(self.recog)
        }
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        self.actInd.frame = CGRect(x: 0, y: 0, width: self.view.frame.width/2, height: self.view.frame.width/2)
        
        self.actInd.center = self.view.center
        
        self.actInd.stopAnimating()
        
        self.collectionView.addSubview(actInd)
        
        getQuery()

        
    }
    
    func getQuery()
    {
        
        self.collectionView.bringSubview(toFront: self.actInd)
        self.actInd.startAnimating()
//
        print("Getting query")
        
        let query = PFQuery(className: "Post")
        
        if(selfProfile)
        {
            query.whereKey("username", equalTo: Util.currentUsername)
        }
        else
        {
            query.whereKey("username", equalTo: otherUserName)
        }
        
        query.limit = 20
        
        // fetch data asynchronously
        query.findObjectsInBackground { (posts: [PFObject]?, error: Error?) in
            if(posts != nil)
            {
                self.posts = posts!
                
                self.actInd.stopAnimating()
                
                print("Got posts")
                
                self.intializeProfile()
                
                self.collectionView.reloadData()
            }
            else
            {
                self.actInd.stopAnimating()
                print(error?.localizedDescription)
            }
            
        }
    }

    
    func intializeProfile()
    {
        if(selfProfile)
        {
            self.nameLabel.text = Util.currentUsername
            
            let user = PFUser.current()
            
            if(user?["bio"] != nil)
            {
                self.taglineTextView.isUserInteractionEnabled = true
                self.taglineTextView.text = user!["bio"] as? String
            }
            else
            {
                self.taglineTextView.isUserInteractionEnabled = true
                self.taglineTextView.text = "I'm your bio! Go ahead and edit me!"
            }
            
            if(user?["profile_image"] != nil)
            {
                let imageFile = user?["profile_image"] as! PFFile!
                
                imageFile?.getDataInBackground(block: { (data: Data?, error: Error?) in
                    if(error == nil)
                    {
                        print("GOT IMAGE")
                        let image = UIImage(data: data!)
                        self.avatarImageView.image = image
                        self.uploadLabel.isHidden = true
                    }
                    else
                    {
                        print(error?.localizedDescription)
                    }
                })
            }
            else
            {
                self.uploadLabel.isHidden = false
            }
            

        }
        else
        {
            self.nameLabel.text = self.otherUserName
            
            let author = userPost["author"] as! PFObject
            
            if(author["profile_image"] != nil)
            {
                let imageFile = author["profile_image"] as! PFFile
                imageFile.getDataInBackground(block: { (data: Data?, error: Error?) in
                    if(error != nil)
                    {
                        let image = UIImage(data: data!)
                        self.avatarImageView.image = image
                    }
                    else
                    {
                        print(error?.localizedDescription)
                    }
                })
            }
            else
            {
                self.uploadLabel.isHidden = false
            }
            
            if(author["bio"] != nil)
            {
                self.taglineTextView.isUserInteractionEnabled = false
                self.taglineTextView.text = author["bio"] as? String
            }
        }
        
        
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
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        if (self.posts != nil)
        {
            print("Collection Count: \(self.posts!.count)")
            return self.posts!.count
        }
        else
        {
            return 0
        }

    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "profTimeLineCell", for: indexPath) as! ProfCell
        
        let post = self.posts![(self.posts.count-1) - indexPath.row]
        
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
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        self.performSegue(withIdentifier: "imageDetailSegue", sender: indexPath)
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
    
    // MARK: - Upload Profile Picture
    
    func avatarUpload(_ sender: Any?)
    {
        print("In here boi")
        
        let vc = UIImagePickerController()
        vc.delegate = self
        vc.allowsEditing = true
        
        vc.sourceType = UIImagePickerControllerSourceType.photoLibrary
        
        self.present(vc, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : Any])
    {
        print("Image Picked (delegated)")
        
        // Get the image captured by the UIImagePickerController
        let editedImage = info[UIImagePickerControllerEditedImage] as! UIImage
        
        self.avatarImageView.image = editedImage
        
        let user = PFUser.current()
        
        user!["profile_image"] = Post.getPFFileFromImage(image: editedImage)
        
        self.uploadLabel.isHidden = true
        
        user?.saveInBackground(block: { (success: Bool, error: Error?) in
            if(!success)
            {
                print(error?.localizedDescription)
            }
        })
        
        dismiss(animated: true, completion: nil)
    }

    
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        // return UIModalPresentationStyle.FullScreen
        return .none
    }
    
    // MARK: - Text View
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool
    {
        if(text == "\n")
        {
            self.taglineTextView.isUserInteractionEnabled = true
            
            print("am I assigning?")
            
            let user = PFUser.current()
            
            user?["bio"] = self.taglineTextView.text
            
            user?.saveInBackground(block: { (success: Bool, error: Error?) in
                if(!success)
                {
                    print(error?.localizedDescription)
                }
            })
            
            self.view.endEditing(true)
            return false
        }
        else
        {
            return true
        }
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
        if(segue.identifier == "imageDetailSegue")
        {
            let vc = segue.destination as! ImageDetailViewController
            
            if(selfProfile)
            {
//                let user = PFUser.current()
             
                let indexPath = sender as! IndexPath
                let index = (self.posts.count-1) - indexPath.row
                
                let post = posts[index]
                vc.username = Util.currentUsername
                vc.caption = post["caption"] as? String
                vc.likesCount = post["likesCount"] as! Int
                vc.imageFile = post["media"] as! PFFile
                vc.date = post["_created_at"] as? Date
            }
            else
            {
                let indexPath = sender as! IndexPath
                let index = indexPath.row
                
                let post = posts[index]
                vc.username = self.otherUserName
                vc.caption = post["caption"] as? String
                vc.likesCount = post["likesCount"] as! Int
                vc.imageFile = post["media"] as! PFFile
                vc.date = post.createdAt
            }
            
        }
    }
}
