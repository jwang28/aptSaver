//
//  FavoriteListingViewController.swift
//  APT Saver
//
//  Created by Jennifer Wang on 10/05/19.
//  Copyright © 2019 nyu.edu. All rights reserved.
//

import UIKit

class FavouriteListingViewController: UIViewController {
    
    //interface builder
    @IBOutlet weak var tableView: UITableView!
    
    //properties
    var listings = [Listing]()
    var selectedListing: Listing?
    
    
    //viewcontroller's lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.listings.removeAll()
        self.tableView.reloadData()
        //fetch favorited apartments from firebase
        self.fetchApartmetsFromFirebase()
    }
    
    //custom methods
    func fetchApartmetsFromFirebase() {
        NetworkServices.fetchApartments { (apartments) in
            if apartments == nil {
                self.showAlert(messageString: "Something went wrong. Try again later.")
                return
            } else {
                let apartmetnsFromFirebase = apartments as! [Listing]
                for apertment in apartmetnsFromFirebase {
                    if apertment.favorited == true {
                        self.listings.append(apertment)
                    }
                }
                self.tableView.reloadData()
            }
        }
    }
    
    //Handling favorites
    //If selected heart icon, it goes to the favorite section
    //Positing the heart
    @objc private func handleAsFavorite(sender: UIButton) {
        let indexPath = IndexPath(row: sender.tag, section: 0)
        let listing = self.listings[indexPath.row]
        let cell = tableView.cellForRow(at: indexPath) as! ListingTableViewCell
        if (listing.favorited == true) {
            self.listings[indexPath.row].favorited = false
            NetworkServices.markApartmentFavourite(data: self.listings[indexPath.row].dictionary()) { (success, error) in
                if success == true {
                    cell.heartButton.setImage(UIImage(named: "favHeart"), for: .normal)
                } else {
                    self.listings[indexPath.row].favorited = true
                }
            }
        } else if(listing.favorited == false) {
            self.listings[indexPath.row].favorited = true
            NetworkServices.markApartmentFavourite(data: self.listings[indexPath.row].dictionary()) { (success, error) in
                if success == true {
                    cell.heartButton.setImage(UIImage(named: "favHeartFilled"), for: .normal)
                } else {
                    self.listings[indexPath.row].favorited = false
                }
            }
        }
    }
    
    
    //MARK:- navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowFavListingDetail" {
            let listingDetailTVC = segue.destination as! ListingDetailTableViewController
            listingDetailTVC.listing = selectedListing
        }
    }
}

//table view datasource and delegate methods
extension FavouriteListingViewController: UITableViewDelegate, UITableViewDataSource {
    //Auto Resizing Table View Cells
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListingCell", for: indexPath) as! ListingTableViewCell
        cell.listing = listings[indexPath.row]
        
        //Setting favorites button
        let image = UIImage(named: "favHeart")?.withRenderingMode(.alwaysTemplate)
        cell.heartButton.setImage(image, for: .normal)
        cell.heartButton.tag = indexPath.row
        
        //Colors the favorites icon according to whether or not the item is favorited
        if cell.listing!.favorited {
            cell.heartButton.tintColor = UIColor.white
            cell.heartButton.setImage(UIImage(named: "favHeartFilled"), for: .normal)
        } else {
            cell.heartButton.tintColor = UIColor.white
            cell.heartButton.setImage(UIImage(named: "favHeart"), for: .normal)
        }
        cell.heartButton.addTarget(self, action: #selector(handleAsFavorite), for: .touchUpInside)
        return cell
    }
    
    // Delete Rows
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.listings.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    //MARK:- UITABLEVIEWDELEGATE
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let listing = listings[indexPath.row]
        selectedListing = listing
        performSegue(withIdentifier: "ShowFavListingDetail", sender: nil)
    }
}
