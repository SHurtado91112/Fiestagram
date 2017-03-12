//
//  ProfCell.swift
//  Fiestagram
//
//  Created by Steven Hurtado on 3/11/17.
//  Copyright © 2017 Steven Hurtado. All rights reserved.
//

import UIKit

class ProfCell: UICollectionViewCell
{
    @IBOutlet weak var instaImageView: UIImageView!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        self.layer.shadowColor = UIColor.myFiestaBackGray.cgColor
        self.layer.shadowOpacity = 0.6
        self.layer.shadowOffset = CGSize(width: 0.0, height: 14.0)
        self.layer.shadowRadius = 10
        self.layer.shouldRasterize = true
    }
}
