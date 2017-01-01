//
//  ReviewsViewController.swift
//  For Hire
//
//  Created by Nicholas Arduini on 2016-10-24.
//  Copyright © 2016 Nicholas Arduini. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

protocol UpdateUserFromReviewDelegate: class {
    func userDoesNeedUpdating()
}

class ReviewsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, ReviewHasBeenWrittenDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.title = "Reviews"
        
        getRating()
        getReviews()
        loadingView.hidesWhenStopped = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var writeReviewButton: UIButton!
    @IBOutlet weak var reviewsTableView: UITableView!
    @IBOutlet weak var loadingView: UIActivityIndicatorView!
    @IBOutlet weak var priceRatingLabel: UILabel!
    @IBOutlet weak var reliabilityRatingLabel: UILabel!
    @IBOutlet weak var qualityRatingLabel: UILabel!
    
    var reviews = [Review]()
    var currentUser: User!
    
    weak var delegate: UpdateUserFromReviewDelegate? = nil
    
    @IBAction func writeReviewButton(_ sender: Any) {
        self.performSegue(withIdentifier: "toWriteAReview", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "toWriteAReview"){
            let nav = segue.destination as! UINavigationController
            let vc = nav.topViewController as! WriteReviewTableViewController
            vc.writtenForUser = currentUser.email.stringValue
            vc.delegate = self
        }
    }
    
    func userDidWriteReview(){
        getRating()
        getReviews()
        delegate?.userDoesNeedUpdating()
    }
    
    func getRating(){
        if(currentUser == nil){
            return
        }
        
        let parameters: Parameters = [
            "userToken": currentUser.userToken.stringValue
        ]
        
        currentlyLoadingData(bool: true, loadingView: loadingView)
        
        Alamofire.request(Common.validateUser, parameters: parameters).responseJSON { response in
            switch response.result {
            case .success(let jsonString):
                if((response.result.value) != nil) {
                    let json = JSON(jsonString)
                    if(json[Common.jsonMessage] == Common.serverNotValidUser){
                        self.alertUser(title: Common.notValidUser, message: "")
                    } else {
                        self.currentUser = User(jsonString: json)
                        
                        if(self.currentUser.numReviews.doubleValue > 0){
                            self.priceRatingLabel.text = "\(Double(self.currentUser.priceRating.doubleValue / self.currentUser.numReviews.doubleValue).roundTo(places: 1))"
                            self.reliabilityRatingLabel.text = "\(Double(self.currentUser.reliabilityRating.doubleValue / self.currentUser.numReviews.doubleValue).roundTo(places: 1))"
                            self.qualityRatingLabel.text = "\(Double(self.currentUser.qualityRating.doubleValue / self.currentUser.numReviews.doubleValue).roundTo(places: 1))"
                        }
                        self.dismissKeyboard()
                    }
                }
            case .failure(let error):
                self.alertUser(title: Common.error, message: Common.couldNotConnectToServer)
                print(error)
            }
            self.currentlyLoadingData(bool: false, loadingView: self.loadingView)
        }
        
    }
    
    func getReviews(){
        if(currentUser == nil){
            return
        }
        
        let parameters: Parameters = [
            "writtenForUser": currentUser.email.stringValue
        ]
        
        currentlyLoadingData(bool: true, loadingView: loadingView)
        
        Alamofire.request(Common.getReviews, parameters: parameters).responseJSON { response in
            switch response.result {
            case .success(let jsonString):
                if((response.result.value) != nil) {
                    let json = JSON(jsonString)
                    if(json[Common.jsonMessage] == Common.serverNotValidUser){
                        //self.alertUser(title: "Not Valid User", message: "Cannot get reviews for this user")
                    } else {
                        self.reviews.removeAll()
                        let jsonArray:[JSON] = json.arrayValue
                        for r in jsonArray {
                            let review = Review(jsonString: r)
                            self.reviews.append(review)
                        }
                        
                        DispatchQueue.main.async{
                            self.reviewsTableView.reloadData()
                        }
                    }
                }
            case .failure(let error):
                self.alertUser(title: Common.error, message: Common.couldNotConnectToServer)
                print(error)
            }
            self.currentlyLoadingData(bool: false, loadingView: self.loadingView)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviews.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")! as! ReviewViewCell
        cell.priceRating.text = reviews[indexPath.row].priceRating.stringValue
        cell.reliabiltyRating.text = reviews[indexPath.row].reliabilityRating.stringValue
        cell.quailtyRating.text = reviews[indexPath.row].qualityRating.stringValue
        cell.writtenReview.text = reviews[indexPath.row].reviewText.stringValue
        cell.subtitleLabel.text = "by \(reviews[indexPath.row].writtenByUser.stringValue) in \(reviews[indexPath.row].category.stringValue)"
        
        return cell
    }
    
}
