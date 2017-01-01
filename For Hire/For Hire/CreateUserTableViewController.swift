//
//  CreateUserTableViewController.swift
//  For Hire
//
//  Created by Nicholas Arduini on 2016-11-07.
//  Copyright © 2016 Nicholas Arduini. All rights reserved.
//

import UIKit
import MapKit
import Alamofire
import SwiftyJSON

class CreateUserTableViewController: UITableViewController, SelectedCategoriesDelegate, CLLocationManagerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()
        findLocation()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        
        setupLoadingView(loadingView: &loadingView)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var forHireCategoriesLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var findLocationButton: UIButton!
    @IBOutlet weak var accountType: UISegmentedControl!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    var loadingView = UIActivityIndicatorView()
    var forHireCategories = [String]()
    let locationManager = CLLocationManager()
    var locationString = ""
    
    @IBAction func exitVCButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func createAccountButton(_ sender: Any) {
        
        if(allUserInfoEntered()){
            if(validEmailPassword()){
                let parameters: Parameters = [
                    "userid": emailTextField.text!,
                    "password": passwordTextField.text!,
                    "phoneNumber": phoneNumberTextField.text!,
                    "accountName": nameTextField.text!,
                    "description": descriptionTextView.text!,
                    "categories": JSON(forHireCategories),
                    "address": addressTextField.text!,
                    "region": locationString,
                    "accountType" : accountType.titleForSegment(at: accountType.selectedSegmentIndex)!
                ]
                
                currentlyLoadingData(bool: true, loadingView: loadingView)
                
                Alamofire.request(Common.createUser, method: .post, parameters: parameters).responseJSON { response in
                    switch response.result {
                    case .success(let jsonString):
                        if((response.result.value) != nil) {
                            let json = JSON(jsonString)
                            if(json[Common.jsonMessage] == Common.serverEmailAlreadyUsed){
                                self.alertUser(title: Common.invalidEmail, message: Common.emailHasAlreadyBeenUsed)
                            } else {
                                let user = User(jsonString: json)
                                self.dismissKeyboard()
                                let defaults = UserDefaults.standard
                                defaults.set(true, forKey: Common.userLoggedInKey)
                                defaults.setValue(user.userToken.description, forKey: Common.currentUserToken)
                                defaults.setValue(user.accountName.description, forKey: Common.currentUserName)
                                defaults.synchronize()
                                
                                self.performSegue(withIdentifier: "userCreated", sender: self)
                            }
                        }
                    case .failure(let error):
                        print(error)
                        self.alertUser(title: Common.error, message: Common.couldNotConnectToServer)
                    }
                    self.currentlyLoadingData(bool: false, loadingView: self.loadingView)
                }
            }
        } else {
            alertUser(title: Common.missingInfo, message: Common.fillInAllFields)
        }
    }
    
    @IBAction func findLocationButton(_ sender: Any) {
        findLocation()
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
                    self.locationLabel.text = self.locationString
                }
                self.locationManager.stopUpdatingLocation()
                self.currentlyLoadingData(bool: false, loadingView: self.loadingView)
            })
        }
    }
    
    func userDidEnterCategories(categories: [String]) {
        self.forHireCategories = categories
        forHireCategoriesLabel.text = stringFromArray(array: categories)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toChooseCategories" {
            let vc = segue.destination as! ChooseAllCategoriesTableViewController
            vc.selectedDelegate = self
            vc.selectedCategories = forHireCategories
        }
    }
    
    func stringFromArray(array: [String]) ->String{
        var s = ""
        for a in array {
            s += a + ", "
        }
        if(s.characters.count > 3){
            let range = s.index(s.endIndex, offsetBy: -2)..<s.endIndex
            s.removeSubrange(range)
        } else {
            s = "None"
        }
        
        return s
        
    }
    
    func allUserInfoEntered() ->Bool{
        var bool = true
        
        if(!validEmail()){
            emailTextField.layer.addSublayer(makeTextFieldUnderline(textField: emailTextField))
            emailTextField.layer.masksToBounds = true
            bool = false
        }
        
        if(!validPassword()){
            passwordTextField.layer.addSublayer(makeTextFieldUnderline(textField: passwordTextField))
            passwordTextField.layer.masksToBounds = true
            bool = false
        }
        
        if(!((nameTextField.text?.characters.count)! >= 1)){
            nameTextField.layer.addSublayer(makeTextFieldUnderline(textField: nameTextField))
            nameTextField.layer.masksToBounds = true
            bool = false
        }
        
        if(!((phoneNumberTextField.text?.characters.count)! >= 10)){
            phoneNumberTextField.layer.addSublayer(makeTextFieldUnderline(textField: phoneNumberTextField))
            phoneNumberTextField.layer.masksToBounds = true
            bool = false
        }
        
        if(!((descriptionTextView?.text.characters.count)! >= 1)){
            descriptionTextView.layer.addSublayer(makeTextFieldUnderline(textView: descriptionTextView))
            descriptionTextView.layer.masksToBounds = true
            bool = false
        }
        
        if(!((addressTextField.text?.characters.count)! >= 1)){
            addressTextField.layer.addSublayer(makeTextFieldUnderline(textField: addressTextField))
            addressTextField.layer.masksToBounds = true
            bool = false
        }
        
        if(!(locationString.characters.count >= 1)){
            findLocationButton.tintColor = UIColor.red
            bool = false
        }
        
        return bool
        
    }
    
    func validEmail() -> Bool{
        return ((emailTextField.text?.contains("@"))! && (emailTextField.text?.characters.count)! > 7)
    }
    
    func validPassword() ->Bool{
        return ((passwordTextField.text?.characters.count)! >= 6)
    }
    
    func validEmailPassword() ->Bool{
        if(!validEmail() && !validPassword()){
            alertUser(title: "Invalid Email and Password", message: "The provided email address is not valid and a password must contain at least 6 characters")
            emailTextField.layer.addSublayer(makeTextFieldUnderline(textField: emailTextField))
            emailTextField.layer.masksToBounds = true
            passwordTextField.layer.addSublayer(makeTextFieldUnderline(textField: passwordTextField))
            passwordTextField.layer.masksToBounds = true
            return false
        } else if(!validEmail()){
            alertUser(title: "Invalid Email", message: "The email address provided is not valid")
            emailTextField.layer.addSublayer(makeTextFieldUnderline(textField: emailTextField))
            emailTextField.layer.masksToBounds = true
            return false
        } else if(!validPassword()){
            alertUser(title: "Invalid Password", message: "The password provided must contain at least 6 characters")
            passwordTextField.layer.addSublayer(makeTextFieldUnderline(textField: passwordTextField))
            passwordTextField.layer.masksToBounds = true
            return false
        }
        
        return true
    }
    
    func makeTextFieldUnderline(textField: UITextField) -> CALayer {
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = UIColor.red.cgColor
        border.frame = CGRect(x: 0, y: textField.frame.size.height - width, width:  textField.frame.size.width, height: textField.frame.size.height)
        
        border.borderWidth = width
        textField.layer.addSublayer(border)
        textField.layer.masksToBounds = true
        return border
    }
    
    func makeTextFieldUnderline(textView: UITextView) -> CALayer {
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = UIColor.red.cgColor
        border.frame = CGRect(x: 0, y: textView.frame.size.height - width, width:  textView.frame.size.width, height: textView.frame.size.height)
        
        border.borderWidth = width
        textView.layer.addSublayer(border)
        textView.layer.masksToBounds = true
        return border
    }
    
}
