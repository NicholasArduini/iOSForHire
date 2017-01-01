//
//  WriteReviewTableViewController.swift
//  For Hire
//
//  Created by Nicholas Arduini on 2016-10-23.
//  Copyright © 2016 Nicholas Arduini. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

protocol ReviewHasBeenWrittenDelegate: class {
    func userDidWriteReview()
}

class WriteReviewTableViewController: UITableViewController, SelectedCategoryDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        self.hideKeyboardWhenTappedAround()
        
        setupLoadingView(loadingView: &loadingView)
        
        let defaults = UserDefaults.standard
        writtenByUser = defaults.string(forKey: Common.currentUserName)!
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var priceRatingControl: RatingControl!
    @IBOutlet weak var reliabilityRatingControl: RatingControl!
    @IBOutlet weak var qualityRatingControl: RatingControl!
    @IBOutlet weak var writtenReview: UITextView!
    
    var loadingView = UIActivityIndicatorView()
    var category = ""
    var writtenForUser = ""
    var writtenByUser = ""
    
    weak var delegate: ReviewHasBeenWrittenDelegate? = nil
    
    @IBAction func cancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func submitButton(_ sender: AnyObject) {
        
        if(checkAllFieldsEntered()){
            
            let parameters: Parameters = [
                "priceRating": String(priceRatingControl.rating),
                "reliabilityRating": String(reliabilityRatingControl.rating),
                "qualityRating": String(qualityRatingControl.rating),
                "reviewText": writtenReview.text,
                "category": category,
                "writtenByUser": writtenByUser,
                "writtenForUser": writtenForUser
            ]
            
            currentlyLoadingData(bool: true, loadingView: loadingView)
            
            Alamofire.request(Common.postReview, method: .post, parameters: parameters).responseJSON { response in
                switch response.result {
                case .success(let jsonString):
                    if((response.result.value) != nil) {
                        let json = JSON(jsonString)
                        if(json[Common.jsonMessage] == Common.serverNotValidUser){
                            self.alertUser(title: Common.notValidUser, message: Common.couldNotWriteReview)
                        } else if(json[Common.jsonMessage] == Common.serverReviewAlreadyExists){
                            self.alertUser(title: Common.reviewAlreadySent, message: Common.youHaveAlreadySentAReview)
                        }else {
                            self.delegate?.userDidWriteReview()
                            self.dismiss(animated: true, completion: nil)
                        }
                    }
                case .failure(let error):
                    self.alertUser(title: Common.error, message: Common.couldNotConnectToServer)
                    print(error)
                }
                
               self.currentlyLoadingData(bool: false, loadingView: self.loadingView)
            }
        } else {
            alertUser(title: "Cannot submit", message: "Please make sure all fields have been completed")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toChooseCategory" {
            let vc = segue.destination as! ChooseCategoriesTableViewController
            vc.delegate = self
        }
    }
    
    func checkAllFieldsEntered() ->Bool{
        var bool = true
        
        if(priceRatingControl.rating <= 0){
            bool = false
        }
        
        if(reliabilityRatingControl.rating <= 0){
            bool = false
        }
        
        if(qualityRatingControl.rating <= 0){
            bool = false
        }
        
        if(writtenReview.text.characters.count <= 0){
            bool = false
        }
        
        if(category == ""){
            bool = false
        }
        
        return bool
        
    }
    
    func userDidEnterCategory(category: String) {
        self.category = category
        categoryLabel.text = category
    }
}
