//
//  HeaderCell.swift
//  Fiestagram
//
//  Created by Steven Hurtado on 3/11/17.
//  Copyright © 2017 Steven Hurtado. All rights reserved.
//

import UIKit

class HeaderCell: UITableViewCell
{

    let gradientLayer = CAGradientLayer()
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        
        avatarImageView.layer.cornerRadius = avatarImageView.frame.size.width / 2
        avatarImageView.clipsToBounds = true
        
        gradientLayer.frame = self.frame

        let color1 = UIColor.myTimberWolf.cgColor as CGColor

        let color4 = UIColor.myFiestaDeepPurple.cgColor as CGColor
        gradientLayer.colors = [color1, color4]
        
        gradientLayer.startPoint = CGPoint(x: 1, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0, y: 0)
        
        gradientLayer.locations = [0.0, 1.0]
    
        self.layer.insertSublayer(gradientLayer, at: 0)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
