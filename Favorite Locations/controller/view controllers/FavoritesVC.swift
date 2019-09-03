//
//  FavoritesVC.swift
//  Favorite Locations
//
//  Created by Mikeias Nascimento on 03/09/19.
//  Copyright © 2019 Critical Techworks. All rights reserved.
//

import UIKit
import RealmSwift
import MapKit
import CoreLocation

class FavoritesVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var locations = [Location]()
    @IBOutlet var mapView: MKMapView!
    @IBOutlet var tableView: UITableView!
    
    override func viewDidAppear(_ animated: Bool) {
        let realm = try! Realm()
        locations = Array(realm.objects(Location.self))
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! FavoriteCell
        
        cell.addressLabel.text = locations[indexPath.row].address
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedLocation = locations[indexPath.row]
        
        mapView.removeAnnotations(mapView.annotations)
        let pin = MKPointAnnotation()
        pin.coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(selectedLocation.latitude), longitude: CLLocationDegrees(selectedLocation.longitude))
        self.mapView.addAnnotation(pin)
        let region = MKCoordinateRegion(center: pin.coordinate, latitudinalMeters: CLLocationDistance(exactly: 5000)!, longitudinalMeters: CLLocationDistance(exactly: 5000)!)
        self.mapView.setRegion(region, animated: true)
    }
}
