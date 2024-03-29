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
    @IBOutlet var searchBar: UISearchBar!
    private let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 10.0, *) {
            resultTableView.refreshControl = refreshControl
        } else {
            resultTableView.addSubview(refreshControl)
        }
        
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
    }
    
    @objc func refresh() {
        self.updateList(query: self.searchBar.text)
    }
    
    func updateList(query: String?) {
        if !refreshControl.isRefreshing {
            refreshControl.beginRefreshing()
            //            When calling refresh control to begin programmatically we have to scroll the tableview ourselves :S
            resultTableView.setContentOffset(CGPoint(x: 0, y: -refreshControl.frame.size.height), animated: true)
        }
        self.locationManager = CLLocationManager()
        self.locationManager?.requestWhenInUseAuthorization()
        var currentLocation: CLLocation?
        
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() ==  .authorizedAlways {
            currentLocation = self.locationManager?.location
            
            let currentLatitude = currentLocation?.coordinate.latitude
            let currentLongitude = currentLocation?.coordinate.longitude
            
            Alamofire.request("http://autocomplete.geocoder.api.here.com/6.2/suggest.json?query=\(query?.replacingOccurrences(of: " ", with: "%20") ?? "")&app_id=GJExNBxZYOZ4V3w1KZQc&app_code=DD7aQwczIJTz0UwFt6HxOA&maxresults=20\(currentLocation != nil ? "&prox=\(currentLatitude!),\(currentLongitude!)" : "")").responseJSON { (response) in
                
                self.refreshControl.endRefreshing()
                
                if let json = response.result.value as? [String: AnyObject] {
                    self.suggestions = (json["suggestions"] as? [NSDictionary])?.sorted(by: { $0["distance"] as? Int ?? 0 < $1["distance"] as? Int ?? 0 })
                    self.resultTableView.reloadData()
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let detailsVC = segue.destination as? LocationDetailsVC, let location = sender as? NSDictionary {
            detailsVC.locationDictionary = location
        }
    }
    
    //    MARK: table view methods
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: Segues.locationDetailsSegue, sender: suggestions?[indexPath.row])
    }
    
    //    MARK: search bar  methods
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count >= 3 {
            updateList(query: searchText)
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let query = searchBar.text
        updateList(query: query)
    }
}
