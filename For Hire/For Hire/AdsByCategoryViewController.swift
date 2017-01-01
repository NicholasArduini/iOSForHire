//
//  AdsByCategoryViewController.swift
//  For Hire
//
//  Created by Nicholas Arduini on 2016-09-23.
//  Copyright © 2016 Nicholas Arduini. All rights reserved.
//

import UIKit
import Foundation
import MapKit
import Alamofire
import SwiftyJSON

class AdsByCategoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(self.refresh), for: UIControlEvents.valueChanged)
        adsTableView.addSubview(refreshControl)
        
        getUsers()
        self.title = category
        locationLabel.text = location
        
        adsTableView.delegate = self
        adsTableView.dataSource = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var adTabSelection: UISegmentedControl!
    @IBOutlet weak var adsTableView: UITableView!
    @IBOutlet weak var loadingView: UIActivityIndicatorView!
    
    var refreshControl: UIRefreshControl!
    var category = ""
    var location = ""
    var users = [User]()
    
    let array = ["House needs painting", "Setting up new computer", "Need new door"]
    let detArray = ["Jo Gregory", "Frank Castle", "Tony Stark", "Jo Gregory", "Frank Castle", "Tony Stark"]
    let rating = ["5.0", "4.8", "4.5", "4.9", "4.7", "4.3"]
    
    let cellSpacingHeight = CGFloat(8)
    
    //change table view when selecting for hire or looking for ad
    @IBAction func adTabSelection(_ sender: AnyObject) {
        DispatchQueue.main.async{
            self.adsTableView.reloadData()
        }
    }
    
    func refresh(sender:AnyObject) {
        getUsers()
    }
    
    func getUsers(){
        let parameters: Parameters = [
            "region": location,
            "category": category
        ]
        if(!refreshControl.isRefreshing){
            currentlyLoadingData(bool: true, loadingView: loadingView)
        }
        
        Alamofire.request(Common.byRegionCategory, parameters: parameters).responseJSON { response in
            switch response.result {
            case .success(let jsonString):
                if((response.result.value) != nil) {
                    let json = JSON(jsonString)
                    if(json[Common.jsonMessage] == Common.serverNoAdsFound){
                        //self.alertUser(title: "No ads found", message: "")
                    } else {
                        let jsonArray:[JSON] = json.arrayValue
                        self.users.removeAll()
                        for u in jsonArray {
                            let user = User(jsonString: u)
                            self.users.append(user)
                        }
                        
                        DispatchQueue.main.async{
                            self.adsTableView.reloadData()
                        }
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
    
    // Set the spacing between sections
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return cellSpacingHeight
    }
    
    // Make the background color show through
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if(adTabSelection.selectedSegmentIndex == 0){
            return users.count
        } else {
            return array.count
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")! as! BrowseAdsViewCell
        cell.ratingControl.rating = 0
        if(adTabSelection.selectedSegmentIndex == 0){ //for hire ad
            cell.title?.text = users[indexPath.section].accountName.stringValue
            cell.subTitle?.text = users[indexPath.section].accountType.stringValue
            cell.phoneNumber = users[indexPath.section].phoneNumber.stringValue
            if(users[indexPath.section].numReviews.intValue > 0){
                cell.ratingControl.rating = (users[indexPath.section].rating.intValue) / (users[indexPath.section].numReviews.intValue * 3)
            }
            cell.numberOfReviewsLabel.text = "\(users[indexPath.section].numReviews.intValue) reviews"
            cell.rightTextLabel.isHidden = true
            cell.callButton.isHidden = false
            cell.callView.isHidden = false
        } else { //looking for ad
            cell.title?.text = array[indexPath.section]
            cell.subTitle?.text = detArray[indexPath.section]
            cell.ratingControl.rating = 0
            
            let priceAttribute = [NSFontAttributeName : UIFont.boldSystemFont(ofSize: 15)]
            let priceString = NSMutableAttributedString(string: "$240", attributes: priceAttribute)
            let plainTextAttribute = [NSFontAttributeName : UIFont.systemFont(ofSize: 8)]
            let bestBidText = NSMutableAttributedString(string: " best bid", attributes: plainTextAttribute)
            priceString.append(bestBidText)
            cell.rightTextLabel.attributedText = priceString
            cell.rightTextLabel.isHidden = false
            cell.callButton.isHidden = true
            cell.callView.isHidden = true
        }
        
        //shadow
        cell.backgroundColor = UIColor.white
        cell.layer.shadowOffset = CGSize(width: 0.0, height: 0.5)
        cell.layer.shadowColor = UIColor.lightGray.cgColor
        cell.layer.shadowRadius = 0.3
        cell.layer.shadowOpacity = 0.9
        cell.clipsToBounds = false
        let shadowFrame: CGRect = (cell.layer.bounds)
        let shadowPath: CGPath = UIBezierPath(rect: shadowFrame).cgPath
        cell.layer.shadowPath = shadowPath
        
        cell.adImage.layer.cornerRadius = 4
        cell.adImage.layer.masksToBounds = true
        cell.ratingControl.alignLeft = true
        cell.ratingControl.enabled = false
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(users.count > 0){
            self.performSegue(withIdentifier: "displaySelectedAd", sender: self)
        } else {
            alertUser(title: Common.error, message: Common.couldNotLoadUserInfo)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "displaySelectedAd"){
            let indexPaths = self.adsTableView!.indexPathsForSelectedRows!
            let indexPath = indexPaths[0] as IndexPath
            let vc = segue.destination as! DisplayAdViewController
            if(adTabSelection.selectedSegmentIndex == 0){ //for hire
                vc.currentUser = users[indexPath.section]
                vc.isForHireAd = true
                vc.adType = Common.forHireAdType
            } else { //looking for
                vc.adTitleText = array[indexPath.section]
                vc.isForHireAd = false
                vc.adType = Common.lookingForAdType
            }
            vc.location = location
        }
    }
}
