//
//  EditAccountDetailsTableViewController.swift
//  For Hire
//
//  Created by Nicholas Arduini on 2016-11-10.
//  Copyright © 2016 Nicholas Arduini. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class EditAccountDetailsTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLoadingView(loadingView: &loadingView)
        
        self.hideKeyboardWhenTappedAround()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var currentPasswordTextField: UITextField!
    @IBOutlet weak var newPasswordTextField: UITextField!
    
    var loadingView = UIActivityIndicatorView()
    var userToken = ""
    var userEmail = ""
    
    @IBAction func changePasswordButton(_ sender: Any) {
        if((newPasswordTextField.text?.characters.count)! >= 6){
            let parameters: Parameters = [
                "userID": userEmail,
                "password" : currentPasswordTextField.text!,
                "newPassword" : newPasswordTextField.text!
            ]
            
            currentlyLoadingData(bool: true, loadingView: loadingView)
            
            Alamofire.request(Common.updatePassword, method: .post, parameters: parameters).responseJSON { response in
                switch response.result {
                case .success(let jsonString):
                    if((response.result.value) != nil) {
                        let json = JSON(jsonString)
                        if(json[Common.jsonMessage] == Common.serverNotValidUser){
                            self.alertUser(title: Common.error, message: Common.couldNotUpdateUser)
                        } else {
                            self.dismissKeyboard()
                            self.currentPasswordTextField.text = ""
                            self.newPasswordTextField.text = ""
                            
                            self.alertUser(title: Common.success, message: Common.passwordHasBeenChanged)
                            self.performSegue(withIdentifier: "loggedOutToLogin", sender: self)
                        }
                    }
                case .failure(let error):
                    print(error)
                    self.alertUser(title: Common.error, message: Common.couldNotConnectToServer)
                }
                
                self.currentlyLoadingData(bool: false, loadingView: self.loadingView)
            }
        } else {
            alertUser(title: "Invalid New Password", message: "The new password provided must contain at least 6 characters")
        }
    }
    
    @IBAction func logoutButton(_ sender: Any) {
        let defaults = UserDefaults.standard
        defaults.set(false, forKey: Common.userLoggedInKey)
        defaults.setValue("", forKey: Common.currentUserToken)
        defaults.setValue("", forKey: Common.currentUserName)
        defaults.synchronize()
        self.performSegue(withIdentifier: "loggedOutToLogin", sender: self)
    }
    
    @IBAction func deleteAccountButton(_ sender: Any) {
        confirmDeleteAlert()
    }
    
    func deleteAccount(){
        let parameters: Parameters = [
            "userToken": userToken
        ]
        
        currentlyLoadingData(bool: true, loadingView: loadingView)
        
        Alamofire.request(Common.deleteClient, parameters: parameters).responseJSON { response in
            switch response.result {
            case .success(let jsonString):
                if((response.result.value) != nil) {
                    let json = JSON(jsonString)
                    if(json[Common.jsonMessage] == Common.serverNotValidUser){
                        self.alertUser(title: Common.error, message: Common.couldNotUpdateUser)
                    } else {
                        self.dismissKeyboard()
                        let defaults = UserDefaults.standard
                        defaults.set(false, forKey: Common.userLoggedInKey)
                        defaults.setValue("", forKey: Common.currentUserToken)
                        defaults.synchronize()
                        self.performSegue(withIdentifier: "loggedOutToLogin", sender: self)
                    }
                }
            case .failure(let error):
                print(error)
                self.alertUser(title: Common.error, message: Common.couldNotConnectToServer)
            }
            
            self.currentlyLoadingData(bool: false, loadingView: self.loadingView)
        }
    }
    
    func confirmDeleteAlert(){
        let deleteAlert = UIAlertController(title: "Warning", message: "Please confirm you want to delete your account", preferredStyle: UIAlertControllerStyle.alert)
        
        deleteAlert.addAction(UIAlertAction(title: "Confrirm", style: .default, handler: { (action: UIAlertAction!) in
            self.deleteAccount()
        }))
        
        deleteAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        deleteAlert.view.tintColor = UIColor.black
        
        present(deleteAlert, animated: true, completion: nil)
    }
    
    
}
