//
//  ReviewViewCell.swift
//  For Hire
//
//  Created by Nicholas Arduini on 2016-10-24.
//  Copyright © 2016 Nicholas Arduini. All rights reserved.
//

import UIKit

class ReviewViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBOutlet weak var priceRating: UILabel!
    @IBOutlet weak var reliabiltyRating: UILabel!
    @IBOutlet weak var quailtyRating: UILabel!
    @IBOutlet weak var writtenReview: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    

}
