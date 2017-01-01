//
//  User.swift
//  For Hire
//
//  Created by Nicholas Arduini on 2016-11-16.
//  Copyright © 2016 Nicholas Arduini. All rights reserved.
//

import Foundation
import SwiftyJSON

struct User {
    var email : JSON
    var userToken : JSON
    var phoneNumber : JSON
    var accountName : JSON
    var description : JSON
    var categories = JSON([String].self)
    var address : JSON
    var region : JSON
    var rating : JSON
    var accountType : JSON
    var priceRating : JSON
    var reliabilityRating : JSON
    var qualityRating : JSON
    var numReviews : JSON

    init(jsonString: JSON){
        email = jsonString["emailAddress"]
        userToken = jsonString["userToken"]
        phoneNumber = jsonString["phoneNumber"]
        accountName = jsonString["accountName"]
        description = jsonString["description"]
        categories = jsonString["categories"]
        address = jsonString["address"]
        region = jsonString["region"]
        rating = jsonString["rating"]
        accountType = jsonString["accountType"]
        priceRating = jsonString["priceRating"]
        reliabilityRating = jsonString["reliabilityRating"]
        qualityRating = jsonString["qualityRating"]
        numReviews = jsonString["numReviews"]
    }
}
