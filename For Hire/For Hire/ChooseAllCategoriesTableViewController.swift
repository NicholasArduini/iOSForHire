//
//  ChooseAllCategoriesTableViewController.swift
//  For Hire
//
//  Created by Nicholas Arduini on 2016-10-30.
//  Copyright © 2016 Nicholas Arduini. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

protocol SelectedCategoriesDelegate: class {
    func userDidEnterCategories(categories: [String])
}

protocol UpdatedCategoriesDelegate: class {
    func userDidUpdateCategories()
}

class ChooseAllCategoriesTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        findSelectedRows()
        
        setupLoadingView(loadingView: &loadingView)
        
        // Uncomment the following line to preserve selection between presentations
        self.clearsSelectionOnViewWillAppear = false
        
        for row in selectedRows {
            let indexPath = IndexPath(row: row, section: 0)
            self.tableView.selectRow(at: indexPath, animated: false, scrollPosition: UITableViewScrollPosition.none)
            self.tableView(self.tableView, didSelectRowAt: indexPath)
        }
        
        if(showSave){
            self.navigationItem.setRightBarButton(UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(self.saveSelectedCategories)), animated: true)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet var categoriesTableView: UITableView!
    
    var loadingView = UIActivityIndicatorView()
    let categories = Common.categories
    var selectedCategories = [String]()
    var selectedRows = [Int]()
    var userToken = ""
    var showSave = false
    
    weak var selectedDelegate: SelectedCategoriesDelegate? = nil
    weak var updatedDelegate: UpdatedCategoriesDelegate? = nil
    
    func saveSelectedCategories(){
        let parameters: Parameters = [
            "userToken": userToken,
            "categories": JSON(selectedCategories)
        ]
        
        currentlyLoadingData(bool: true, loadingView: loadingView)
        
        Alamofire.request(Common.updateCategories, method: .post, parameters: parameters).responseJSON { response in
            switch response.result {
            case .success(let jsonString):
                if((response.result.value) != nil) {
                    let json = JSON(jsonString)
                    if(json[Common.jsonMessage] == Common.serverNotValidUser){
                        self.alertUser(title: Common.error, message: Common.couldNotUpdateUser)
                    } else {
                        self.dismissKeyboard()
                        self.updatedDelegate?.userDidUpdateCategories()
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
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = categories[indexPath.row]
        cell.setSelected(true, animated: true)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedCategories.append(categories[indexPath.row])
        selectedDelegate?.userDidEnterCategories(categories: selectedCategories)
    }
    
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        var i = 0
        for sCat in selectedCategories {
            if(sCat == categories[indexPath.row]){
                selectedCategories.remove(at: i)
            }
            i += 1
        }
        selectedDelegate?.userDidEnterCategories(categories: selectedCategories)
    }
    
    func findSelectedRows(){
        var i = 0
        for cat in categories {
            for sCat in selectedCategories {
                if(cat == sCat){
                    selectedRows.append(i)
                }
            }
            i += 1
        }
        selectedCategories = []
    }
    
}
