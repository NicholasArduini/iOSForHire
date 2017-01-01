//
//  PostAdViewController.swift
//  For Hire
//
//  Created by Nicholas Arduini on 2016-09-23.
//  Copyright © 2016 Nicholas Arduini. All rights reserved.
//

import UIKit

class PostAdViewController: UITableViewController, SelectedCategoryDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        self.hideKeyboardWhenTappedAround()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var selectCategoryButton: UIButton!
    var category = ""
    
    @IBAction func submitAd(_ sender: AnyObject) {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toChooseCategoryFromPost" {
            let vc = segue.destination as! ChooseCategoriesTableViewController
            vc.delegate = self
        }
    }
    
    func userDidEnterCategory(category: String) {
        self.category = category
        selectCategoryButton.setTitle(category, for: .normal)
    }

}

