//
//  ListingTableViewController.swift
//  APT Saver
//
//  Created by Jennifer Wang, Jin Joo Lee, Joyce Ye on 4/15/19.
//  Copyright © 2019 nyu.edu. All rights reserved.
//

import UIKit
import SwiftSoup
import GoogleSignIn
import FirebaseAuth
import FBSDKLoginKit

class ListingTableViewController: UITableViewController {
    
    //Calendar button
    @IBOutlet weak var tableHeaderView: UIView!
    
    var selectedIndexPath: IndexPath?
    
    // MARK: - UITableView
    //MARK: -Data model
    var listingTypes: [ListingType] = ListingType.getListingTypes()
    override func viewDidLoad() {
        super.viewDidLoad()
      
        //Setting title "Apartments" on homepage
        self.addTitle(title: "Apartments")
        //self.addTitleListing(title: "Edit Listing")
        self.navigationItem.leftBarButtonItem = editButtonItem
        
        //TableView constrant
        tableView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 50).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: 50).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: 50).isActive = true
        
        //Sign out button on the Apartments page
        //Redirects back to the login page
        var signoutButton = UIButton()
        signoutButton.setTitle("Log out", for: .normal)
        view.addSubview(signoutButton)
        signoutButton.translatesAutoresizingMaskIntoConstraints = false
        signoutButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: 2).isActive = true
        signoutButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
        signoutButton.setTitleColor(.black, for: .normal)
        signoutButton.addTarget(self, action: #selector(logOut), for: .touchUpInside)
    }

    
    //Logout function back to the login page
    @objc func logOut() {
        GIDSignIn.sharedInstance().signOut()
        LoginManager().logOut()
        try? Auth.auth().signOut()
        self.navigationController?.popViewController(animated: true)
    }
    
    //Add Link page
    @IBAction func addListingButton(_ sender: Any) {
        performSegue(withIdentifier: "AddListing", sender: nil)
    }
    
    //MARK: - UItableViewDataSource
    override func numberOfSections(in tableView: UITableView) -> Int {
        return listingTypes.count
    }
    
    //Auto Resizing Table View Cells
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listingTypes[section].listings.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListingCell", for: indexPath) as! ListingTableViewCell
        cell.listing = listingTypes[indexPath.section].listings[indexPath.row]
        
        //Setting favorites button
        let image = UIImage(named: "favHeart")?.withRenderingMode(.alwaysTemplate)
        cell.heartButton.setImage(image, for: .normal)
        
        //Colors the favorites icon according to whether or not the item is favorited
        if cell.listing!.favorited {
            cell.heartButton.tintColor = UIColor.red
            cell.heartButton.setImage(UIImage(named: "favHeartFilled"), for: .normal)
        } else {
            cell.heartButton.tintColor = UIColor.lightGray
            cell.heartButton.setImage(UIImage(named: "favHeart"), for: .normal)
        }
        cell.heartButton.addTarget(self, action: #selector(handleAsFavorite), for: .touchUpInside)
        return cell
    }
    
    //Handling favorites
    //If selected heart icon, it goes to the favorite section
    //Positing the heart
    @objc private func handleAsFavorite(sender: UIButton) {
        let buttonPosition = sender.convert(CGPoint.zero, to: self.tableView)
        let indexPath = self.tableView.indexPathForRow(at: buttonPosition)
        print("Marking as Favorite")
        let aptFavorited = tableView.cellForRow(at: indexPath!)
        let listingType = listingTypes[indexPath!.section]
        let listing = listingType.listings[indexPath!.row]
        if (listing.favorited == true)
        {
            listing.setFavorited(yesorno: false)
            aptFavorited?.accessoryView?.tintColor = UIColor.lightGray
            let row = listingTypes[1].listings.count
            listingTypes[1].listings.insert(listing, at: listingTypes[1].listings.count)
            tableView.insertRows(at: [IndexPath(row: row, section: 1)], with: .automatic)
            listingTypes[0].listings.remove(at: indexPath!.row)
            tableView.deleteRows(at: [indexPath!], with: .automatic)
        } else if(listing.favorited == false)
        {
            listing.setFavorited(yesorno: true)
            aptFavorited?.accessoryView?.tintColor = UIColor.red
            let row = listingTypes[0].listings.count == 0 ? 0 : listingTypes[0].listings.count
            listingTypes[0].listings.insert(listing, at: listingTypes[0].listings.count)
            tableView.insertRows(at: [IndexPath(row: row, section: 0)], with: .automatic)
            listingTypes[1].listings.remove(at: indexPath!.row)
            tableView.deleteRows(at: [indexPath!], with: .automatic)
        }
    }
    
    //Multiple Sections
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let listingType = listingTypes[section]
        return listingType.name
    }
    
    // Delete Rows
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let listingType = listingTypes[indexPath.section]
            listingType.listings.remove(at: indexPath.row)

            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    //Move cells around
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    //Update database
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let listingToMove = listingTypes[sourceIndexPath.section].listings[sourceIndexPath.row]
        listingTypes[destinationIndexPath.section].listings.insert(listingToMove, at: destinationIndexPath.row)
        listingTypes[sourceIndexPath.section].listings.remove(at: sourceIndexPath.row)
    }
    
    //MARK: -UITABLEVIEWDELEGATE
    var selectedListing: Listing?
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let listingType = listingTypes[indexPath.section]
        let listing = listingType.listings[indexPath.row]
        selectedListing = listing
        self.selectedIndexPath = indexPath
        performSegue(withIdentifier: "ShowListingDetail", sender: nil)
    }
    
    //MARK: -NAVIGATION
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowListingDetail" {
            let listingDetailTVC = segue.destination as! ListingDetailTableViewController
            listingDetailTVC.delegate = self
            listingDetailTVC.listing = selectedListing
            listingDetailTVC.selectedIndexPath = self.selectedIndexPath
        }
        if segue.identifier == "AddListing" {
            let listingArray = segue.destination as! AddListingViewController
            listingArray.delegate = self
            //check which type it is
            listingArray.listings = listingTypes[1].listings
        }
    }
}

extension ListingTableViewController: AddListingViewControllerDelegate {
    func didFinishLoadingData(listings: [Listing]) {
        listingTypes[1].listings = listings
        self.tableView.reloadData()
    }
}

extension ListingTableViewController: ListingDetailTableViewControllerDelegate {
    func didChangeAppointmentDate(listing: Listing, indexpath: IndexPath) {
         self.listingTypes[indexpath.section].listings[indexpath.row] = listing
    }
    
    func didChangeNotes(listing: Listing, indexpath: IndexPath) {
        self.listingTypes[indexpath.section].listings[indexpath.row] = listing
    }
}

