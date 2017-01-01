//
//  BrowseAdsViewCell.swift
//  For Hire
//
//  Created by Nicholas Arduini on 2016-10-20.
//  Copyright © 2016 Nicholas Arduini. All rights reserved.
//

import Foundation
import UIKit

class BrowseAdsViewCell: UITableViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var subTitle: UILabel!
    @IBOutlet weak var adImage: UIImageView!
    @IBOutlet weak var numberOfReviewsLabel: UILabel!
    
    @IBOutlet weak var rightTextLabel: UILabel!
    @IBOutlet weak var ratingControl: RatingControl!
    @IBOutlet weak var callButton: UIButton!
    @IBOutlet weak var callView: UIView!
    
    var phoneNumber = ""
    
    @IBAction func callButton(_ sender: AnyObject) {
        let url:NSURL = NSURL(string: "tel://\(phoneNumber)")!
        
        if (UIApplication.shared.canOpenURL(url as URL)) {
            UIApplication.shared.openURL(url as URL)
        }
    }
}
