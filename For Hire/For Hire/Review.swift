//
//  Review.swift
//  For Hire
//
//  Created by Nicholas Arduini on 2016-11-22.
//  Copyright © 2016 Nicholas Arduini. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Review {
    var priceRating : JSON
    var reliabilityRating : JSON
    var qualityRating : JSON
    var reviewText : JSON
    var category : JSON
    var writtenForUser : JSON
    var writtenByUser : JSON
    
    init(jsonString: JSON){
        priceRating = jsonString["priceRating"]
        reliabilityRating = jsonString["reliabilityRating"]
        qualityRating = jsonString["qualityRating"]
        category = jsonString["category"]
        reviewText = jsonString["reviewText"]
        writtenForUser = jsonString["writtenForUser"]
        writtenByUser = jsonString["writtenByUser"]
    }
}
