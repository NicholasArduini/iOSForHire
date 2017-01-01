//
//  UserRating.swift
//  For Hire
//
//  Created by Nicholas Arduini on 2016-11-26.
//  Copyright © 2016 Nicholas Arduini. All rights reserved.
//

import Foundation
import SwiftyJSON

struct UserRating {
    var priceRating : JSON
    var reliabilityRating : JSON
    var qualityRating : JSON
    
    init(jsonString: JSON){
        priceRating = jsonString["priceRating"]
        reliabilityRating = jsonString["reliabilityRating"]
        qualityRating = jsonString["qualityRating"]
    }
}
