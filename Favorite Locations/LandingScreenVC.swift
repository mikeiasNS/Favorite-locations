//
//  ViewController.swift
//  Favorite Locations
//
//  Created by Mikeias Nascimento on 29/08/19.
//  Copyright © 2019 Critical Techworks. All rights reserved.
//

import UIKit
import Alamofire

class LandingScreenVC: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    var suggestions: [NSDictionary]? = nil
    @IBOutlet var resultTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.suggestions?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = suggestions?[indexPath.row]["label"] as? String
        cell.detailTextLabel?.text = suggestions?[indexPath.row]["countryCode"] as? String
        
        return cell
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //        TODO: get current Latitude, Longitude
        let query = searchBar.text
        let currentLatitude = -3.801865
        let currentLongitude = -38.6215081
        
        Alamofire.request("http://autocomplete.geocoder.api.here.com/6.2/suggest.json?query=\(query ?? "")&app_id=GJExNBxZYOZ4V3w1KZQc&app_code=DD7aQwczIJTz0UwFt6HxOA&prox=\(currentLatitude),\(currentLongitude)&maxresults=20").responseJSON { (response) in
            if let json = response.result.value as? [String: AnyObject] {
                self.suggestions = json["suggestions"] as? [NSDictionary]
                self.resultTableView.reloadData()
            }
        }
    }
}
