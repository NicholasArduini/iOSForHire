//
//  ChooseCategoriesTableViewController.swift
//  For Hire
//
//  Created by Nicholas Arduini on 2016-10-25.
//  Copyright © 2016 Nicholas Arduini. All rights reserved.
//

import UIKit

protocol SelectedCategoryDelegate: class {
    func userDidEnterCategory(category: String)
}

class ChooseCategoriesTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        if(canSelectMultiple){
            tableView.allowsMultipleSelection = true
        } else {
            tableView.allowsMultipleSelection = false
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet var categoryTableView: UITableView!
    
    var canSelectMultiple = false
    var jobs = Common.categories
    
    weak var delegate: SelectedCategoryDelegate? = nil
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return jobs.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = jobs[indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let indexPaths = self.categoryTableView.indexPathsForSelectedRows
        let indexPath = (indexPaths?[0])! as IndexPath
        
        if(!canSelectMultiple){
            delegate?.userDidEnterCategory(category: jobs[indexPath.row])
            _ = navigationController?.popViewController(animated: true)
        }
    }
}
