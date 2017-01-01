//
//  PersonalInfoTableViewController.swift
//  For Hire
//
//  Created by Nicholas Arduini on 2016-11-23.
//  Copyright © 2016 Nicholas Arduini. All rights reserved.
//

import UIKit
import MapKit
import Alamofire
import SwiftyJSON

protocol UpdatedPersonalInfoUserDelegate: class {
    func userDidUpDatePersonalInfo()
}

class PersonalInfoTableViewController: UITableViewController, CLLocationManagerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()
        
        findLocation()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        
        setupLoadingView(loadingView: &loadingView)
        
        if(currentUser != nil){
            accountNameTextField.text = currentUser.accountName.stringValue
            regionTextField.text = currentUser.region.stringValue
            phoneNumberTextField.text = currentUser.phoneNumber.stringValue
            addressTextField.text = currentUser.address.stringValue
            descriptionTextView.text = currentUser.description.stringValue
        }
        
        if(currentUser.accountType.stringValue == "Independent"){
            accountTypeSegControl.selectedSegmentIndex = 0
        } else {
            accountTypeSegControl.selectedSegmentIndex = 1
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var accountNameTextField: UITextField!
    @IBOutlet weak var regionTextField: UILabel!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var accountTypeSegControl: UISegmentedControl!
    @IBOutlet weak var findRegionButton: UIButton!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    weak var delegate: UpdatedPersonalInfoUserDelegate? = nil
    
    var loadingView = UIActivityIndicatorView()
    var currentUser: User!
    let locationManager = CLLocationManager()
    var locationString = ""
    
    @IBAction func findRegionButton(_ sender: Any) {
        findLocation()
    }
    
    @IBAction func saveButton(_ sender: Any) {
        
        if(currentUser == nil){
            return
        }
        
        let parameters: Parameters = [
            "userToken": currentUser.userToken.stringValue,
            "phoneNumber": phoneNumberTextField.text!,
            "accountName": accountNameTextField.text!,
            "description": descriptionTextView.text,
            "address": addressTextField.text!,
            "region": regionTextField.text!,
            "accountType" : accountTypeSegControl.titleForSegment(at: accountTypeSegControl.selectedSegmentIndex)!
        ]
        
        currentlyLoadingData(bool: true, loadingView: loadingView)
        
        Alamofire.request(Common.updateClient, method: .post, parameters: parameters).responseJSON { response in
            switch response.result {
            case .success(let jsonString):
                if((response.result.value) != nil) {
                    let json = JSON(jsonString)
                    if(json[Common.jsonMessage] == Common.serverNotValidUser){
                        self.alertUser(title: Common.error, message: Common.couldNotUpdateUser)
                    } else {
                        self.dismissKeyboard()
                        self.delegate?.userDidUpDatePersonalInfo()
                        let _  = self.navigationController?.popViewController(animated: true)
                    }
                }
            case .failure(let error):
                print(error)
                self.alertUser(title: Common.error, message: Common.couldNotConnectToServer)
            }
            self.currentlyLoadingData(bool: false, loadingView: self.loadingView)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        findLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location Manager failed with the following error: \(error)")
        alertUser(title: Common.warning, message: Common.couldNotFindCurrentLocation)
    }
    
    func findLocation(){
        currentlyLoadingData(bool: true, loadingView: loadingView)
        locationManager.startUpdatingLocation()
        
        let geoCoder = CLGeocoder()
        let currentLocation = locationManager.location?.coordinate
        
        if(currentLocation != nil){
            let location = CLLocation(latitude: (currentLocation?.latitude)!, longitude: (currentLocation?.longitude)!)
            
            geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
                var placeMark: CLPlacemark!
                placeMark = placemarks?[0]
                
                if(placeMark != nil){
                    self.locationString = "\(placeMark.locality!), \(placeMark.administrativeArea!)"
                    self.regionTextField.text = self.locationString
                }
                self.locationManager.stopUpdatingLocation()
                self.currentlyLoadingData(bool: false, loadingView: self.loadingView)
            })
        }
    }
}




