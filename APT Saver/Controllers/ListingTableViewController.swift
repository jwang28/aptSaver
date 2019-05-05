//
//  ListingTableViewController.swift
//  APT Saver
//
//  Created by Jennifer Wang on 4/29/19.
//  Copyright © 2019 nyu.edu. All rights reserved.
//

import UIKit
import SwiftSoup

class ListingTableViewController: UITableViewController {
    // MARK: - UITableView
    
    //MARK: -Data model
    //var test: String? = "hi"
    var listingTypes: [ListingType] = ListingType.getListingTypes()
    override func viewDidLoad() {
        super.viewDidLoad()
        //var htmlContent: String?
        //Get HTML 
      
            
        self.title = "Apartments"
        
        self.tableView.estimatedRowHeight = tableView.rowHeight
        //resize to fit the contents of the description
        self.tableView.rowHeight = UITableView.automaticDimension
        
        self.navigationItem.leftBarButtonItem = editButtonItem
        //print (test)
    }
    
    @IBAction func addListingButton(_ sender: Any) {
        performSegue(withIdentifier: "AddListing", sender: nil)
    }
    
    
    //MARK: - UItableViewDataSource
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return listingTypes.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listingTypes[section].listings.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListingCell", for: indexPath) as! ListingTableViewCell
        
        cell.listing = listingTypes[indexPath.section].listings[indexPath.row]
        
        
        //setting favorites button
        let starButton = UIButton(type: .system)
        starButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        starButton.setImage(UIImage(named:"favHeartFilled.png"), for: .normal)
        cell.accessoryView = starButton
        //colors the favorites icon according to whether or not the item is favorited
        starButton.tintColor = cell.listing!.favorited ? UIColor.red : UIColor.lightGray
        //tableView.reloadRows(at: [indexPath], with: .fade)
        //handles as favorite when tapped
        //starButton.tag = indexPath.row + 100000*(indexPath.section)
        

        starButton.addTarget(self, action: #selector(handleAsFavorite), for: .touchUpInside)
        
        return cell
    }
    

    @objc private func handleAsFavorite(sender: UIButton){
        let buttonPosition = sender.convert(CGPoint.zero, to: self.tableView)
        let indexPath = self.tableView.indexPathForRow(at:buttonPosition)

        print("sec, row", indexPath!.section, " ", indexPath!.row)

        let aptFavorited = tableView.cellForRow(at: indexPath!)
        let listingType = listingTypes[indexPath!.section]
        let listing = listingType.listings[indexPath!.row]
        
        if (listing.favorited == true){
            listing.setFavorited(yesorno: false)
            //print(listing.favorited)
            aptFavorited?.accessoryView?.tintColor = UIColor.lightGray
            
            let row = listingTypes[1].listings.count
            
            listingTypes[1].listings.insert(listing, at: listingTypes[1].listings.count)
            tableView.insertRows(at: [IndexPath(row: row, section: 1)], with: .automatic)
            listingTypes[0].listings.remove(at: indexPath!.row)
            tableView.deleteRows(at: [indexPath!], with: .automatic)
        }
        else if(listing.favorited == false){
            listing.setFavorited(yesorno: true)
            //print(listing.favorited)
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
    
    //move cells around
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    //update database
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
        
        performSegue(withIdentifier: "ShowListingDetail", sender: nil)
    }
    
    //MARK: -NAVIGATION
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowListingDetail" {
            let listingDetailTVC = segue.destination as! ListingDetailTableViewController
            listingDetailTVC.listing = selectedListing
        }
        if segue.identifier == "AddListing" {
            let listingArray = segue.destination as! AddListingViewController
            //check which type it is
            listingArray.listings = listingTypes[0].listings
            
        }
    }
}
