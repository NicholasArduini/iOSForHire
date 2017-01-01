//
//  DisplayAdViewController.swift
//  For Hire
//
//  Created by Nicholas Arduini on 2016-10-20.
//  Copyright © 2016 Nicholas Arduini. All rights reserved.
//

import UIKit
import MapKit
import SwiftyJSON
import Alamofire

class DisplayAdViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate, UpdatedPersonalInfoUserDelegate, UpdatedCategoriesDelegate, UpdateUserFromReviewDelegate{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        fillAdContent()
        findLocation()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        
        adPicture.layer.cornerRadius = 6
        adPicture.layer.masksToBounds = true
        
        loadingView.isHidden = true
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(self.refresh), for: UIControlEvents.valueChanged)
        scrollView.addSubview(refreshControl)
        
        if(self.forHireCategories.count == 0){
            self.noCategoriesLabel.isHidden = false
        } else {
            self.noCategoriesLabel.isHidden = true
        }
        
        if(adType == Common.forHireAdType){
            //
        } else if(adType == Common.lookingForAdType){
            self.navigationItem.setRightBarButton(UIBarButtonItem(title: "Place Bid", style: .done, target: self, action: #selector(self.bringUpBidDialogBox)), animated: true)
        } else {
            self.title = "My Profile"
            findLoggedInUser()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var adPicture: UIImageView!
    @IBOutlet weak var adSubtitle: UILabel!
    @IBOutlet weak var adTitle: UILabel!
    @IBOutlet weak var categoriesCollection: UICollectionView!
    @IBOutlet weak var noCategoriesLabel: UILabel!
    @IBOutlet weak var adInfoTableView: UITableView!
    @IBOutlet weak var loadingView: UIActivityIndicatorView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var refreshControl: UIRefreshControl!
    let locationManager = CLLocationManager()
    var location = ""
    var isForHireAd = true
    var selectedCategories = [String]()
    var currentUser: User!
    var forHireCategories = [JSON]()
    var jobImages = Common.categoriesImages
    var adType = Common.profileAdType
    
    //for demo looking for ads
    var adTitleText = ""
    let adInfoLookingFor = ["4.6 rating", "All bids", "Region / Address", "Description"]
    
    func refresh(sender:AnyObject) {
        if(adType == Common.profileAdType){
            findLoggedInUser()
        } else {
            updateAdByUser()
        }
    }
    
    @IBAction func placeBidButton(_ sender: AnyObject) {
        bringUpBidDialogBox()
    }
    
    @IBAction func callButton(_ sender: AnyObject) {
        let url:NSURL = NSURL(string: "tel://9052650693")!
        
        if (UIApplication.shared.canOpenURL(url as URL)) {
            UIApplication.shared.openURL(url as URL)
        }
    }
    
    func bringUpBidDialogBox(){
        let alert = UIAlertController(title: "Place your bid", message: "", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Submit", style: UIAlertActionStyle.default, handler: nil))
        alert.view.tintColor = UIColor.red
        
        alert.addTextField(configurationHandler: {(textField: UITextField!) in
            textField.placeholder = ""
            textField.keyboardType = UIKeyboardType.numberPad
        })
        self.present(alert, animated: true, completion: nil)
    }
    
    func userDidUpDatePersonalInfo(){
        findLoggedInUser()
    }
    
    func userDidUpdateCategories(){
        findLoggedInUser()
    }
    
    func userDoesNeedUpdating(){
        updateAdByUser()
    }
    
    func fillAdContent(){
        if(currentUser != nil){
            adTitle.text = currentUser.accountName.stringValue
            adSubtitle.text = currentUser.accountType.stringValue
            forHireCategories = currentUser!.categories.arrayValue
            selectedCategories = currentUser.categories.arrayObject as! [String]
        }
    }
    
    func updateAdByUser() {
        
        let parameters: Parameters = [
            "userToken": currentUser.userToken
        ]
        
        if(!refreshControl.isRefreshing){
            currentlyLoadingData(bool: true, loadingView: loadingView)
        }
        
        Alamofire.request(Common.validateUser, parameters: parameters).responseJSON { response in
            switch response.result {
            case .success(let jsonString):
                if((response.result.value) != nil) {
                    let json = JSON(jsonString)
                    if(json[Common.jsonMessage] == Common.serverNotValidUser){
                        self.alertUser(title: Common.notValidUser, message: "")
                    } else {
                        self.currentUser = User(jsonString: json)
                        self.adInfoTableView.reloadData()
                        self.dismissKeyboard()
                    }
                }
            case .failure(let error):
                self.alertUser(title: Common.error, message: Common.couldNotConnectToServer)
                print(error)
            }
            if(!self.refreshControl.isRefreshing){
                self.currentlyLoadingData(bool: false, loadingView: self.loadingView)
            }
            self.refreshControl.endRefreshing()
        }
    }
    
    func findLoggedInUser() {
        let defaults = UserDefaults.standard
        
        if let currentUserToken = defaults.string(forKey: Common.currentUserToken) {
            
            let parameters: Parameters = [
                "userToken": currentUserToken
            ]
            
            if(!refreshControl.isRefreshing){
                currentlyLoadingData(bool: true, loadingView: loadingView)
            }
            
            Alamofire.request(Common.validateUser, parameters: parameters).responseJSON { response in
                switch response.result {
                case .success(let jsonString):
                    if((response.result.value) != nil) {
                        let json = JSON(jsonString)
                        if(json[Common.jsonMessage] == Common.serverNotValidUser){
                            self.alertUser(title: Common.notValidUser, message: "")
                        } else {
                            self.currentUser = User(jsonString: json)
                            self.fillAdContent()
                            self.adInfoTableView.reloadData()
                            self.categoriesCollection.reloadData()
                            if(self.forHireCategories.count == 0){
                                self.noCategoriesLabel.isHidden = false
                            } else {
                                self.noCategoriesLabel.isHidden = true
                            }
                            self.dismissKeyboard()
                        }
                    }
                case .failure(let error):
                    self.alertUser(title: Common.error, message: Common.couldNotConnectToServer)
                    print(error)
                }
                if(!self.refreshControl.isRefreshing){
                    self.currentlyLoadingData(bool: false, loadingView: self.loadingView)
                }
                self.refreshControl.endRefreshing()
            }
        }
    }
    
    func stringFromArray(array: [String]) ->String{
        var s = ""
        var i = 0
        for a in array {
            if(i > 2){
                s += "...  "
                break
            }
            s += a + ", "
            i += 1
        }
        if(s.characters.count > 3){
            let range = s.index(s.endIndex, offsetBy: -2)..<s.endIndex
            s.removeSubrange(range)
        } else {
            s = "None"
        }
        
        return s
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
                    self.location = "\(placeMark.locality!), \(placeMark.administrativeArea!)"
                }
                self.locationManager.stopUpdatingLocation()
                self.currentlyLoadingData(bool: false, loadingView: self.loadingView)
            })
        }
    }
    
    //for hire other categories available
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return forHireCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! AdCollectionViewCell
        
        cell.imageView.image = self.jobImages[indexPath.row]
        cell.imageView.layer.cornerRadius = 6
        cell.imageView.layer.masksToBounds = true
        cell.imageLabel.text = self.forHireCategories[indexPath.row].stringValue
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "showAdsFromDisplay", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "viewReviewsFromAd"){
            let vc = segue.destination as! ReviewsViewController
            vc.currentUser = currentUser
            vc.delegate = self
        } else if(segue.identifier == "showDescriptionFromAd"){
            let vc = segue.destination as! ShowExtraContentViewController
            vc.showTableView = false
            vc.textInput = currentUser.description.stringValue
            vc.titleText = currentUser.accountName.stringValue
        } else if(segue.identifier == "showBidsFromAd"){
            let vc = segue.destination as! ShowExtraContentViewController
            vc.showTableView = true
            vc.titleText = adTitleText
        } else if(segue.identifier == "showPersonalInfo"){
            let vc = segue.destination as! PersonalInfoTableViewController
            vc.delegate = self
            vc.currentUser = currentUser
        }else if(segue.identifier == "showAccountInfo"){
            let vc = segue.destination as! EditAccountDetailsTableViewController
            vc.userToken = currentUser.userToken.stringValue
            vc.userEmail = currentUser.email.stringValue
        } else if(segue.identifier == "showAdsFromDisplay"){
            if(location == ""){
                alertUser(title: Common.noConnection, message: Common.couldNotFindCurrentLocation)
            } else {
                let indexPaths = self.categoriesCollection!.indexPathsForSelectedItems!
                let indexPath = indexPaths[0] as IndexPath
                let vc = segue.destination as! AdsByCategoryViewController
                vc.category = self.forHireCategories[indexPath.row].stringValue
                vc.location = location
            }
        } else if(segue.identifier == "toChooseAllCategories"){
            let vc = segue.destination as! ChooseAllCategoriesTableViewController
            vc.selectedCategories = selectedCategories
            vc.userToken = currentUser.userToken.stringValue
            vc.showSave = true
            vc.updatedDelegate = self
        }
    }
    
    func formatPhoneNumber(phoneNumber: String) ->String{
        if(phoneNumber.characters.count >= 10){
            let startIndex = phoneNumber.index(phoneNumber.startIndex, offsetBy: 3)
            let middleStartIndex = phoneNumber.index(phoneNumber.startIndex, offsetBy: 3)
            let middleEndIndex = phoneNumber.index(phoneNumber.endIndex, offsetBy: -4)
            let range = middleStartIndex..<middleEndIndex
            
            return "(\(phoneNumber.substring(to: startIndex))) \(phoneNumber.substring(with: range)) \(phoneNumber.substring(from: middleEndIndex))"
        } else {
            return phoneNumber
        }
    }
    
    //looking for past bids
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(adType == Common.forHireAdType){
            return 4
        } else if(adType == Common.lookingForAdType){
            return adInfoLookingFor.count
        } else {
            return 4
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "cell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! AdInfoTableViewCell
        
        if(adType == Common.forHireAdType){
            if(indexPath.row == 0){
                if(currentUser.numReviews.intValue > 0){
                    cell.title?.text = "\(Double(currentUser.rating.doubleValue / (currentUser.numReviews.doubleValue * 3)).roundTo(places: 1)) rating"
                    cell.subTitle?.text = "based on \(currentUser.numReviews.intValue) reviews"
                } else {
                    cell.title?.text = "0.0 rating"
                    cell.subTitle?.text = "No reviews"
                }
                cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
            } else if(indexPath.row == 1){
                cell.title?.text = "Phone #"
                cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
                cell.subTitle?.text = formatPhoneNumber(phoneNumber: currentUser.phoneNumber.stringValue)
            } else if(indexPath.row == 2){
                cell.title?.text = "Address / Location"
                cell.subTitle?.text = currentUser.address.stringValue
            } else {
                cell.title?.text = "Description"
                cell.subTitle?.text = currentUser.description.stringValue
                cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
            }
        } else if(adType == Common.lookingForAdType) { //demo data
            if(indexPath.row == 0){
                cell.title?.text = adInfoLookingFor[indexPath.row]
                cell.subTitle?.text = "based on 36 reviews"
                cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
            } else if(indexPath.row == 1){
                cell.title?.text = adInfoLookingFor[indexPath.row]
                cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
                cell.subTitle?.text = "$240 by dan the man"
            } else if(indexPath.row == 2){
                cell.title?.text = adInfoLookingFor[indexPath.row]
                cell.subTitle?.text = "44 Foxtrail cres, Woodbridge ON, L4L 9H8"
            } else {
                cell.title?.text = adInfoLookingFor[indexPath.row]
                cell.subTitle?.text = "This is an ad description"
                cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
            }
        } else {
            if(indexPath.row == 0){
                cell.title?.text = "Personal Info"
                cell.subTitle?.text = "Edit details shown in ads"
                cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
            } else if(indexPath.row == 1){
                cell.title?.text = "Account Details"
                cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
                cell.subTitle?.text = "Edit account"
            } else if(indexPath.row == 2){
                cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
                cell.title?.text = "Available For Hire In"
                cell.subTitle?.text = stringFromArray(array: selectedCategories)
            } else {
                cell.title?.text = "Looking For Ads"
                cell.subTitle?.text = "View Ads"
                cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(currentUser != nil){
            if(adType == Common.forHireAdType){
                if(indexPath.row == 0){
                    self.performSegue(withIdentifier: "viewReviewsFromAd", sender: self)
                } else if(indexPath.row == 1){
                    let url:NSURL = NSURL(string: "tel://\(currentUser.phoneNumber.stringValue)")!
                    
                    if (UIApplication.shared.canOpenURL(url as URL)) {
                        UIApplication.shared.openURL(url as URL)
                    }
                } else if(indexPath.row == 3){
                    self.performSegue(withIdentifier: "showDescriptionFromAd", sender: self)
                }
            } else if(adType == Common.lookingForAdType){
                if(indexPath.row == 0){
                    self.performSegue(withIdentifier: "viewReviewsFromAd", sender: self)
                } else if(indexPath.row == 1){
                    self.performSegue(withIdentifier: "showBidsFromAd", sender: self)
                } else if(indexPath.row == 3){
                    self.performSegue(withIdentifier: "showDescriptionFromAd", sender: self)
                }
            } else {
                if(indexPath.row == 0){
                    self.performSegue(withIdentifier: "showPersonalInfo", sender: self)
                } else if(indexPath.row == 1){
                    self.performSegue(withIdentifier: "showAccountInfo", sender: self)
                } else if(indexPath.row == 2){
                    self.performSegue(withIdentifier: "toChooseAllCategories", sender: self)
                } else if(indexPath.row == 3){
                    //looking for ads
                }
            }
        }
        
    }
}
