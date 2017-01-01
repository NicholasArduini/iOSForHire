//
//  AdInfoTableViewCell.swift
//  For Hire
//
//  Created by Nicholas Arduini on 2016-11-25.
//  Copyright © 2016 Nicholas Arduini. All rights reserved.
//

import UIKit

class AdInfoTableViewCell: UITableViewCell {

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
}
