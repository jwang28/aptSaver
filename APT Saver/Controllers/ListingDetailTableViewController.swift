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
import EventKit

protocol ListingDetailTableViewControllerDelegate {
    func didChangeNotes(listing: Listing, indexpath: IndexPath)
    func didChangeAppointmentDate(listing: Listing, indexpath: IndexPath)
}

class ListingDetailTableViewController: UITableViewController, UICollectionViewDelegateFlowLayout {
    
    //interface builder
    @IBOutlet weak var listingTitleTextField: UILabel!
    @IBOutlet weak var listingDescriptionLabel: UILabel!
    @IBOutlet weak var listingPriceLabel: UILabel!
    @IBOutlet weak var listingImageView: UIImageView!
    @IBOutlet weak var listingBedLabel: UILabel!
    @IBOutlet weak var listingAmenitiesLabel: UILabel!
    @IBOutlet weak var listingTransportationLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var mapButton: UIButton!
    @IBOutlet weak var notesTextView: UITextView!
    @IBOutlet weak var appointmentTextField: UITextField!
    
    //constant
    private let characterLimitOnTheNote = 150
    
    //properties
    var listing: Listing?
    var selectedIndexPath: IndexPath?
    var delegate: ListingDetailTableViewControllerDelegate?
    var datePicker =  UIDatePicker()
    var initialLocation = CLLocation(latitude: 40.758896, longitude: -73.985130)
    var locationLat = 40.758896
    var locationLong = -73.985130
    var selectedAppointmentDate: Date?
    
    //viewcontroller's lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //datepicker
        self.appointmentTextField.inputView = self.datePicker
        self.addDoneButtonOnPickerView()
        self.datePicker.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
        
        //Giving the page a title called "Edit Listing"
        self.addTitleListing(title: "Edit Listing")
        
        //Parsing in data on the edit page
        listingImageView.image = listing?.image
        listingTitleTextField.text  = listing?.address
        listingDescriptionLabel.text = listing?.description
        listingPriceLabel.text = listing?.price
        listingBedLabel.text = listing?.bed
        listingAmenitiesLabel.text = listing?.amenities
        listingTransportationLabel.text = listing?.transportation
        notesTextView.text = listing?.notes
        appointmentTextField.text = listing?.appointmentDate
        
        notesTextView.contentInset = UIEdgeInsets(top: -4, left: 0, bottom: 0, right: -4)
        
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
    
    //custom methods
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
    
    //This is for when the map is clicked on
    //Navigate to Apple map app
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
    
    //This is adding button on top of the dataPicker view
    func addDoneButtonOnPickerView() {
        let doneToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButtonPressed))
        doneToolbar.items = [flexSpace, doneButton]
        doneToolbar.sizeToFit()
        self.appointmentTextField.inputAccessoryView = doneToolbar
    }
    
    //Adding event to IOS Calendar
    func addCalenderEvent(title: String, description: String, startDate: Date, endDate: Date, completion: @escaping (_ success: Bool, _ error: Error?) -> Void) {
        let eventStore = EKEventStore()
        eventStore.requestAccess(to: .event) { (granted, error) in
            if granted == true && error == nil {
                let event  = EKEvent(eventStore: eventStore)
                event.title = title
                event.startDate = startDate
                event.endDate = endDate
                event.notes = description
                event.calendar = eventStore.defaultCalendarForNewEvents
                do {
                    try eventStore.save(event, span: .thisEvent)
                } catch let error {
                    print(error)
                    completion(false, error)
                }
                completion(true, nil)
            } else {
                completion(false, error!)
            }
        }
    }
    
    
    //buttons actions
    //Button that leads to Apple Map when pressed on the map
    @IBAction func mapClicked(_ sender: Any) {
        openMapForPlace(lat: locationLat, long: locationLong, placeName: "Apartment")
    }
    
    //Calling the function of creating event in IOS Calendar
    @objc func doneButtonPressed() {
        self.view.endEditing(true)
        if selectedAppointmentDate != nil {
            let endDate = Calendar.current.date(byAdding: .hour, value: 1, to: self.selectedAppointmentDate!)
            self.addCalenderEvent(title: listing!.address, description: "Visit \(listing!.address)", startDate: self.selectedAppointmentDate!, endDate: endDate!) { (isAdded, error) in
                if isAdded == true {
                    print("Event Added!")
                    DispatchQueue.main.async {
                        self.listing?.appointmentDate = self.appointmentTextField.text!
                        self.delegate?.didChangeAppointmentDate(listing: self.listing!, indexpath: self.selectedIndexPath!)
                        self.showAlert(titleString: "Success!", messageString: "Successfully added your event.")
                    }
                } else {
                    print("Error!")
                    self.showAlert(titleString: "Error!", messageString: "Please try again. Please check that you provided access to your calender.")
                }
            }
        }
    }
    
    //datepicker actions
    @objc func datePickerValueChanged(sender: UIDatePicker) {
        self.selectedAppointmentDate = sender.date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        let dateString = dateFormatter.string(from: sender.date)
        self.appointmentTextField.text = dateString
    }
}

//TableView Delegate and Datasource Methods
extension ListingDetailTableViewController {
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    //Switches cases for height of tableView cell
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
            return UITableView.automaticDimension
        }
    }
    
}

extension ListingDetailTableViewController : UITextViewDelegate {
    
    // MARK: - UITextViewDelegate
    //when user is typing, this method is called
    //controlling the input of the user
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let finalText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        // Check the character limit
        if finalText.count > characterLimitOnTheNote {
            // Deny the change of the text if the result would be over the character limit
            return false
        }
        
        if text == "\n" {
            self.view.endEditing(true)
            self.listing?.notes = textView.text
            delegate?.didChangeNotes(listing: self.listing!, indexpath: self.selectedIndexPath!)
            return false
        }
        
        // Recalculate the height of the cell
        tableView.beginUpdates()
        tableView.endUpdates()
        
        return true
    }
    
    
    
}
