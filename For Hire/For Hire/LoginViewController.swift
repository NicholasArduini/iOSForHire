//
//  LoginViewController.swift
//  For Hire
//
//  Created by Nicholas Arduini on 2016-11-07.
//  Copyright © 2016 Nicholas Arduini. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class LoginViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()
        loadingView.isHidden = true
        
        emailTextField.layer.addSublayer(makeTextFieldUnderline(textField: emailTextField))
        emailTextField.layer.masksToBounds = true
        passwordTextField.layer.addSublayer(makeTextFieldUnderline(textField: passwordTextField))
        passwordTextField.layer.masksToBounds = true
        
        UIApplication.shared.statusBarStyle = .lightContent
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loadingView: UIActivityIndicatorView!
    
    @IBAction func loginButton(_ sender: Any) {
        
        let parameters: Parameters = [
            "userid": emailTextField.text!,
            "password": passwordTextField.text!
        ]
        
        currentlyLoadingData(bool: true, loadingView: loadingView)
        
        Alamofire.request(Common.loginUser, parameters: parameters).responseJSON { response in
            switch response.result {
            case .success(let jsonString):
                if((response.result.value) != nil) {
                    let json = JSON(jsonString)
                    if(json[Common.jsonMessage] == Common.serverNotValidUser){
                        self.alertUser(title: Common.notValidUser, message: Common.emailPasswordDoNotMatch)
                    } else {
                        let user = User(jsonString: json)
                        let defaults = UserDefaults.standard
                        defaults.set(true, forKey: Common.userLoggedInKey)
                        defaults.setValue(user.userToken.description, forKey: Common.currentUserToken)
                        defaults.setValue(user.accountName.description, forKey: Common.currentUserName)
                        defaults.synchronize()
                        self.dismissKeyboard()
                        self.performSegue(withIdentifier: "userLoggedIn", sender: self)
                    }
                }
            case .failure(let error):
                print(error)
                self.alertUser(title: Common.error, message: Common.couldNotConnectToServer)
            }
            self.currentlyLoadingData(bool: false, loadingView: self.loadingView)
        }
    }
    
    func makeTextFieldUnderline(textField: UITextField) -> CALayer {
        let border = CALayer()
        let width = CGFloat(1.5)
        border.borderColor = UIColor.white.cgColor
        border.frame = CGRect(x: 0, y: textField.frame.size.height - width, width:  textField.frame.size.width, height: textField.frame.size.height)
        
        border.borderWidth = width
        textField.layer.addSublayer(border)
        textField.layer.masksToBounds = true
        return border
    }
}






