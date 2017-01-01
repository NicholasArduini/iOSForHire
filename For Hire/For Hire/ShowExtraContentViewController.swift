//
//  ShowExtraContentViewController.swift
//  For Hire
//
//  Created by Nicholas Arduini on 2016-10-29.
//  Copyright © 2016 Nicholas Arduini. All rights reserved.
//

import UIKit

class ShowExtraContentViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(showTableView){
            self.title = "All Bids"
            tableView.isHidden = false
            textArea.isHidden = true
        } else {
            self.title = "Description"
            tableView.isHidden = true
            textArea.isHidden = false
            textArea.text = textInput
        }
        
        titleLabel.text = titleText
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textArea: UITextView!
    @IBOutlet weak var tableView: UITableView!
    
    var showTableView = false
    
    let bidders = ["Dan the man"] //looking for ad demo data
    var textInput = ""
    var titleText = ""
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bidders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "cell"
        var cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.value2, reuseIdentifier: cellIdentifier)
        }
        
        //looking for ad demo data
        cell?.textLabel?.text = bidders[indexPath.row]
        cell?.detailTextLabel?.text = "bid $250"
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}
