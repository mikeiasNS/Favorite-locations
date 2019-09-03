//
//  LocationDetailsVC.swift
//  
//
//  Created by Mikeias Nascimento on 02/09/19.
//

import UIKit
import MapKit
import RealmSwift

class LocationDetailsVC: UIViewController {
    var locationDictionary: NSDictionary?
    @IBOutlet var mapView: MKMapView!
    @IBOutlet var addressLabel: UILabel!
    @IBOutlet var postalCodeLabel: UILabel!
    @IBOutlet var distanceLabel: UILabel!
    
    @IBOutlet var favoriteBtnImage: UIImageView!
    @IBOutlet var favoriteBtnLabel: UILabel!
    
    fileprivate func setupMap(_ address: String) {
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(address) { (placeMarks, error) in
            if let placeMark = placeMarks?.first, let location = placeMark.location {
                let pin = MKPointAnnotation()
                pin.coordinate = location.coordinate
                self.mapView.addAnnotation(pin)
                let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: CLLocationDistance(exactly: 1000)!, longitudinalMeters: CLLocationDistance(exactly: 1000)!)
                self.mapView.setRegion(region, animated: true)
            }
        }
    }
    
    override func viewDidLoad() {
        if locationDictionary != nil, let address = locationDictionary?["label"] as? String {
            setupMap(address)
            
            addressLabel.text = "Address: \(address)"
            postalCodeLabel.text = "Postal code: \((locationDictionary!["address"] as! NSDictionary)["postalCode"] as? String ?? "")"
            distanceLabel.text = "Distance: \(Double(locationDictionary!["distance"] as? Int ?? 0) / 1000.0) Km"
        }
        
        if let _ = favoriteLocation() {
            favoriteBtnImage.image = UIImage(named: "favorited")
            favoriteBtnLabel.text = "Remove from Favorites"
        }
    }
    
    @IBAction func favoriteButtonTapped(_ sender: Any) {
        let realm = try! Realm()
        if let stored = favoriteLocation() {
            try! realm.write {
                realm.delete(stored)
            }
            
            favoriteBtnImage.image = UIImage(named: "favorite")
            favoriteBtnLabel.text = "Save to Favorites"
        } else {
            let location = Location()
            location.locationId = locationDictionary?["locationId"] as? String ?? ""
            location.address = addressLabel.text?.replacingOccurrences(of: "Address: ", with: "") ?? ""
            location.postalCode = postalCodeLabel.text?.replacingOccurrences(of: "Postal code: ", with: "") ?? ""
            location.latitude = Int(mapView.centerCoordinate.latitude)
            location.longitude = Int(mapView.centerCoordinate.longitude)
            try! realm.write {
                realm.add(location)
            }
            
            favoriteBtnImage.image = UIImage(named: "favorited")
            favoriteBtnLabel.text = "Remove from Favorites"
        }
        
    }
    
    func favoriteLocation() -> Location? {
        let realm = try! Realm()
        let result = realm.objects(Location.self).filter("locationId = %@", locationDictionary?["locationId"] as? String ?? "")
        return result.first
    }
}
