//
//  Common.swift
//  For Hire
//
//  Created by Nicholas Arduini on 2016-10-30.
//  Copyright © 2016 Nicholas Arduini. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON

class Common {
    
    static let categories = ["Electrical", "Painting", "Landscaping", "Electronics", "Windows & Doors", "HVAC", "Pools"]
    static let categoriesImages = [UIImage(named: "Electrician"), UIImage(named: "Painting"), UIImage(named: "Landscaping"), UIImage(named: "Electronics"),
                  UIImage(named: "Windows & Doors"), UIImage(named: "HVAC"), UIImage(named: "Pools")]
    
    //ad types
    static let forHireAdType = "ForHire"
    static let lookingForAdType = "LookingFor"
    static let profileAdType = "Profile"
    
    //defaults keys
    static let userLoggedInKey = "userLoggedInKey"
    static let currentUserToken = "currentUserToken"
    static let currentUserName = "currentUserName"
    
    //urls
    static let ip = "192.168.1.21"
    //static let ip = "172.17.40.252"
    static let serverAddress = "http:\(ip):8080/ForHire/"
    static let createUser = "\(serverAddress)authentication/create"
    static let loginUser = "\(serverAddress)authentication/login"
    static let validateUser = "\(serverAddress)authentication/validate"
    static let byRegionCategory = "\(serverAddress)clientRequest/byRegionCategory"
    static let updateCategories = "\(serverAddress)clientRequest/updateCategories"
    static let updateClient = "\(serverAddress)clientRequest/updateClient"
    static let updatePassword = "\(serverAddress)clientRequest/updatePassword"
    static let deleteClient = "\(serverAddress)clientRequest/deleteAccount"
    static let postReview = "\(serverAddress)reviews/postReview"
    static let getReviews = "\(serverAddress)reviews/getReviews"
    
    //server keys
    static let serverNotValidUser = "not valid user" as JSON
    static let serverEmailAlreadyUsed = "email already used" as JSON
    static let serverNoAdsFound = "no ads found" as JSON
    static let serverReviewAlreadyExists = "review already exists" as JSON
    
    //alerts
    static let jsonMessage = "message"
    static let error = "Error"
    static let warning = "Warning"
    static let success = "Success"
    static let noConnection = "No Connection"
    static let couldNotConnectToServer = "Could not connect to server"
    static let notValidUser = "Not Valid User"
    static let emailPasswordDoNotMatch = "Email and password do not match"
    static let invalidEmail = "Invalid Email"
    static let emailHasAlreadyBeenUsed = "This email address has already been used"
    static let missingInfo = "Missing info"
    static let fillInAllFields = "Please fill in all required fields"
    static let couldNotLoadUserInfo = "Could not load user info"
    static let couldNotWriteReview = "Can not write review for this user"
    static let reviewAlreadySent = "Review already sent"
    static let youHaveAlreadySentAReview = "You have already written a reivew"
    static let couldNotUpdateUser = "Could not update user"
    static let passwordHasBeenChanged = "Password has been changed"
    static let couldNotFindCurrentLocation = "Could not find your location"
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func alertUser(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
        alert.addAction(action)
        alert.view.tintColor = UIColor.black
        self.present(alert, animated: true, completion: nil)
    }
    
    func setupLoadingView( loadingView: inout UIActivityIndicatorView){
        loadingView = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        loadingView.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        loadingView.center = self.view.center
        loadingView.backgroundColor = UIColor.clear
        loadingView.hidesWhenStopped = true
        self.view.addSubview(loadingView)
    }
    
    func currentlyLoadingData(bool: Bool, loadingView: UIActivityIndicatorView){
        if(bool){ // make screen unresponsive
            loadingView.startAnimating()
            self.view.isUserInteractionEnabled = false
            loadingView.isHidden = false
        } else { // make screen responsive
            loadingView.stopAnimating()
            self.view.isUserInteractionEnabled = true
            loadingView.isHidden = true
        }
    }
}

extension Double {
    /// Rounds the double to decimal places value
    func roundTo(places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
