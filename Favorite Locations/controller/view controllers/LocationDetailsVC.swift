//
//  LocationDetailsVC.swift
//  
//
//  Created by Mikeias Nascimento on 02/09/19.
//

import UIKit
import MapKit

class LocationDetailsVC: UIViewController {
    var locationDictionary: NSDictionary?
    @IBOutlet var mapView: MKMapView!
    @IBOutlet var addressLabel: UILabel!
    @IBOutlet var postalCodeLabel: UILabel!
    @IBOutlet var distanceLabel: UILabel!
    
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
    }
}
