//
//  TimeLineCell.swift
//  Fiestagram
//
//  Created by Steven Hurtado on 3/10/17.
//  Copyright © 2017 Steven Hurtado. All rights reserved.
//

import UIKit

class CustomTapRecognizer: UITapGestureRecognizer
{
    var indexPath : IndexPath = IndexPath()
}

class TimeLineCell: UITableViewCell
{
    
    @IBOutlet weak var instaImageView: UIImageView!
    @IBOutlet weak var likesCountLabel: UILabel!
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var captionLabel: UILabel!
    
    @IBOutlet weak var likeBtn: LikeButton!
    
    let recog = CustomTapRecognizer()
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        
        self.userLabel.addGestureRecognizer(recog)
        self.userLabel.isUserInteractionEnabled = true
        
        self.layer.shadowColor = UIColor.myFiestaBackGray.cgColor
        self.layer.shadowOpacity = 0.6
        self.layer.shadowOffset = CGSize(width: 0.0, height: 14.0)
        self.layer.shadowRadius = 10
        self.layer.shouldRasterize = true
    }

    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

class LikeButton : UIButton
{
    var indexPath : IndexPath = IndexPath()
    var liked = false
}
