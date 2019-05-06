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
    @IBOutlet weak var listingDescriptionTextView: UITextView!
    @IBOutlet weak var listingPriceLabel: UILabel!
    @IBOutlet weak var listingImageView: UIImageView!
    @IBOutlet weak var listingBedLabel: UILabel!
    @IBOutlet weak var listingBathLabel: UILabel!
    // @IBOutlet weak var listingSizeLabel: UILabel!
    @IBOutlet weak var listingPpsqftLabel: UILabel!
    @IBOutlet weak var listingAmenitiesLabel: UILabel!
   //  @IBOutlet weak var listingTransportationLabel: UILabel!
    
    //BUTTON FOR MAP
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var mapButton: UIButton!
    @IBAction func mapClicked(_ sender: Any) {
        openMapForPlace(lat: locationLat, long: locationLong, placeName: "Apartment")
    }
    
    //    var listing: Listing? = ListingType.getListingTypes()[0].listings[0]
    var listing: Listing?
    var initialLocation = CLLocation(latitude: 40.758896, longitude: -73.985130)
    var locationLat = 40.758896
    var locationLong = -73.985130
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Edit Listing"
        transportCollectionView.delegate = self
        transportCollectionView.dataSource = self
        transportCollectionView.register(HeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "headerId")
        
        print("Bed... ", listing?.bed)
        print("Bath... ", listing?.bath)
        print("PPSF ", listing?.ppsqft)
        listingImageView.image = listing?.image
        listingTitleTextField.text  = listing?.address
        listingDescriptionTextView.text = listing?.description
        listingPriceLabel.text = listing?.price
        listingBedLabel.text = listing?.bed
        // listingBathLabel.text = listing?.bath
        // listingSizeLabel.text = listing?.size
        // listingPpsqftLabel.text = listing?.ppsqft
        listingAmenitiesLabel.text = listing?.amenities
        // listingTransportationLabel.text = listing?.transportation
        
        //MAP
        //TODO: Enter address here
        coordinates(forAddress: "117 Elizabeth Street, New York, New York") {
            (location) in
            guard let location = location else {
                // Handle error here
                return
            }
            self.initialLocation = CLLocation(latitude: location.latitude, longitude: location.longitude)
            self.locationLat = location.latitude
            self.locationLong = location.longitude
            centerMapOnLocation(location: self.initialLocation)
        }
        centerMapOnLocation(location: initialLocation)
    }
    @IBOutlet weak var transportCollectionView: UICollectionView!
}

    let regionRadius: CLLocationDistance = 1000
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,regionRadius, regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }

    //forward geocoding in order to obtain coordinates from address
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

    //this is for when the map is clicked on
    public func openMapForPlace(lat:Double = 0, long:Double = 0, placeName:String = "") {
        let latitude: CLLocationDegrees = lat
        let longitude: CLLocationDegrees = long
        
        let regionDistance:CLLocationDistance = 1000
        let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
        let regionSpan = MKCoordinateRegionMakeWithDistance(coordinates, regionDistance, regionDistance)
        let options = [
            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
        ]
        let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = placeName
        mapItem.openInMaps(launchOptions: options)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }



//TRANSPORTATION SECTION ("A", "C", "E")
struct TransportModel {
    var title: String
    var options: [String]
}

var dummyTransportOPtions: [String: [String]] = ["At 24th street":["A", "E", "C"],"At 99th avenue": ["N", "Q"], "At 12th street": ["R", "W", "B", "F"]]
var tm1 = TransportModel(title: "At 24th Street", options: ["A", "E", "C"])
var tm2 = TransportModel(title: "At 99th avenue", options: ["N", "Q"])
var tm3 = TransportModel(title: "At 12th street", options: ["R", "W", "B", "F"])
var transportOptions: [TransportModel] = [tm1, tm2, tm3]

extension ListingDetailTableViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return transportOptions[section].options.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = transportCollectionView.dequeueReusableCell(withReuseIdentifier: "transportCellId", for: indexPath) as! TransportCollectionViewCell
        cell.transportLetter.text = transportOptions[indexPath.section].options[indexPath.row]
        return cell
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return transportOptions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        print("Dequeing...")
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "headerId", for: indexPath) as! HeaderView
        header.titleLabel.text = transportOptions[indexPath.section].title
        header.setupView()
        
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 40)
    }
}

class HeaderView: UICollectionReusableView {
    var titleLabel: UILabel = UILabel()
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        addSubview(titleLabel)
        titleLabel.text = "Hello world"
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
    }
    
}


