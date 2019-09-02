//
//  ViewController.swift
//  Favorite Locations
//
//  Created by Mikeias Nascimento on 29/08/19.
//  Copyright © 2019 Critical Techworks. All rights reserved.
//

import UIKit
import Alamofire
import CoreLocation

class LandingScreenVC: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    var suggestions: [NSDictionary]? = nil
    var locationManager: CLLocationManager?
    @IBOutlet var resultTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.suggestions?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! LocationCell
        
        cell.locationNameLabel?.text = suggestions?[indexPath.row]["label"] as? String
        cell.countryCodeLabel?.text = suggestions?[indexPath.row]["countryCode"] as? String
        cell.distanceLabel?.text = "distance: \((suggestions?[indexPath.row]["distance"] as? Int ?? 0) / 1000) km"
        
        return cell
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count >= 3 {
            updateList(query: searchText)
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let query = searchBar.text
        updateList(query: query)
    }
    
    func updateList(query: String?) {
        self.locationManager = CLLocationManager()
        self.locationManager?.requestWhenInUseAuthorization()
        var currentLocation: CLLocation?
        
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() ==  .authorizedAlways {
            currentLocation = self.locationManager?.location
            
            let currentLatitude = currentLocation?.coordinate.latitude
            let currentLongitude = currentLocation?.coordinate.longitude
            
            Alamofire.request("http://autocomplete.geocoder.api.here.com/6.2/suggest.json?query=\(query ?? "")&app_id=GJExNBxZYOZ4V3w1KZQc&app_code=DD7aQwczIJTz0UwFt6HxOA&maxresults=20\(currentLocation != nil ? "&prox=\(currentLatitude!),\(currentLongitude!)" : "")").responseJSON { (response) in
                if let json = response.result.value as? [String: AnyObject] {
                    self.suggestions = (json["suggestions"] as? [NSDictionary])?.sorted(by: { $0["distance"] as? Int ?? 0 < $1["distance"] as? Int ?? 0 })
                    self.resultTableView.reloadData()
                }
            }
        }
    }
}
