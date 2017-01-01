//
//  CategoriesCollectionViewController.swift
//  For Hire
//
//  Created by Nicholas Arduini on 2016-09-23.
//  Copyright © 2016 Nicholas Arduini. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import MapKit

class CategoriesCollectionViewController: UICollectionViewController, CLLocationManagerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        findLocation()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var loadingView: UIActivityIndicatorView!
    
    let locationManager = CLLocationManager()
    var location = ""
    var jobs = Common.categories
    var jobImages = Common.categoriesImages
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return jobs.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! AdCollectionViewCell
        
        cell.imageView.image = jobImages[indexPath.row]
        cell.imageView.layer.cornerRadius = 6
        cell.imageView.layer.masksToBounds = true
        cell.imageLabel.text = self.jobs[indexPath.row]
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "showAd", sender: self)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        findLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location Manager failed with the following error: \(error)")
        alertUser(title: Common.warning, message: Common.couldNotFindCurrentLocation)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "showAd"){
            if(location == ""){
                alertUser(title: "Could not find your current location", message: "")
                findLocation()
            } else {
                let indexPaths = self.collectionView!.indexPathsForSelectedItems!
                let indexPath = indexPaths[0] as IndexPath
                let vc = segue.destination as! AdsByCategoryViewController
                vc.category = jobs[indexPath.row]
                vc.location = location
            }
        }
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
}

