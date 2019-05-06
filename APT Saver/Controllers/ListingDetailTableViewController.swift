//
//  ListingDetailTableViewController.swift
//  APT Saver
//
//  Created by Jennifer Wang on 5/1/19.
//  Copyright © 2019 nyu.edu. All rights reserved.
//

import UIKit
import GoogleSignIn
import MapKit

class ListingDetailTableViewController: UITableViewController, UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var listingTitleTextField: UILabel!
    
    @IBOutlet weak var listingDescriptionLabel: UILabel!
    @IBOutlet weak var listingPriceLabel: UILabel!
    @IBOutlet weak var listingImageView: UIImageView!
    @IBOutlet weak var listingBedLabel: UILabel!
    @IBOutlet weak var listingAmenitiesLabel: UILabel!
    @IBOutlet weak var listingTransportationLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var mapButton: UIButton!
    
    var listing: Listing?
    
    //If map doesn't work, it will still point to this location
    //Technically, the maps initial location
    let regionRadius: CLLocationDistance = 1000
    var initialLocation = CLLocation(latitude: 40.758896, longitude: -73.985130)
    var locationLat = 40.758896
    var locationLong = -73.985130
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Giving the page a title called "Edit Listing"
        title = "Edit Listing"
        
        //Parsing in data on the edit page
        listingImageView.image = listing?.image
        listingTitleTextField.text  = listing?.address
        listingDescriptionLabel.text = listing?.description
        listingPriceLabel.text = listing?.price
        listingBedLabel.text = listing?.bed
        listingAmenitiesLabel.text = listing?.amenities
        listingTransportationLabel.text = listing?.transportation
        
        //Get the data partse of the location and displaying it on the map
        coordinates(forAddress: (listing?.address)!) {
            (location) in
            guard let location = location else {
                // Handle error here
                self.centerMapOnLocation(location: self.initialLocation)
                return
            }
            self.initialLocation = CLLocation(latitude: location.latitude, longitude: location.longitude)
            self.locationLat = location.latitude
            self.locationLong = location.longitude
            self.centerMapOnLocation(location: self.initialLocation)
        }
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let location = location.coordinate
        let annotation = MKPointAnnotation()
        annotation.title = "Apartment"
        for currentAnnotaion in (self.mapView.annotations) {
            if currentAnnotaion.title == annotation.title {
                return
            }
        }
        //Zoom in to map using span
        let span = MKCoordinateSpan(latitudeDelta: 0.08, longitudeDelta: 0.08)
        let coordinateRegion = MKCoordinateRegion(center: location, span: span)
        annotation.coordinate = location
        self.mapView.setRegion(coordinateRegion, animated: true)
        self.mapView.addAnnotation(annotation)
    }
    
    //Button that leads to Apple Map when pressed on the map
    @IBAction func mapClicked(_ sender: Any) {
        openMapForPlace(lat: locationLat, long: locationLong, placeName: "Apartment")
    }
    
    //This is for when the map is clicked on
    //Showing the pin of the location !!!!!!!!!!!!!!!!!!!!!
    //Label of the location (e.g. Apartment) !!!!!!!!!!!!!!!
    public func openMapForPlace(lat:Double = 0, long:Double = 0, placeName:String = "") {
        let latitude: CLLocationDegrees = lat
        let longitude: CLLocationDegrees = long
        let regionDistance:CLLocationDistance = 1000
        let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
        let regionSpan = MKCoordinateRegion(center: coordinates, latitudinalMeters: regionDistance, longitudinalMeters: regionDistance)
        let options = [
            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
        ]
        let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = placeName
        mapItem.openInMaps(launchOptions: options)
    }
    
    //Forward geocoding in order to obtain coordinates from address
    func coordinates(forAddress address: String, completion: @escaping (CLLocationCoordinate2D?) -> Void) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address) {
            (placemarks, error) in
            guard error == nil else {
                print("Geocoding error: \(error!)")
                completion(nil)
                return
            }
            completion(placemarks?.first?.location?.coordinate)
        }
    }
}

//TableView Delegate and Datasource Methods
extension ListingDetailTableViewController {
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    //Switches cases of constraints !!!!!!!!!!!!!
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return 200.0
        case 1:
            return 65.0
        case 2:
            return 50.0
        case 3:
            return UITableView.automaticDimension
        case 4:
            return 50.0
        case 5:
            return UITableView.automaticDimension
        case 6:
            return UITableView.automaticDimension
        case 7:
            return 250.0
        default:
            return 0.0
        }
    }
}
