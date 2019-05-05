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
        tableView.reloadRows(at: [indexPath], with: .fade)
        //handles as favorite when tapped
        starButton.tag = indexPath.row + 100000*(indexPath.section)

        starButton.addTarget(self, action: #selector(handleAsFavorite), for: .touchUpInside)
        
        return cell
    }
    
    @objc private func handleAsFavorite(sender: UIButton){
        print("Marking as Favorite")
        //let aptFavorited = sender.tag
        let indexSec = (sender.tag)/100000
        let indexRow = (sender.tag)%100000
        let indexPath = IndexPath(row: indexRow, section: indexSec)
        let aptFavorited = tableView.cellForRow(at: indexPath)
        let listingType = listingTypes[indexSec]
        
        if (listingType.listings[indexRow].favorited == true){
            listingType.listings[indexRow].setFavorited(yesorno: false)
            print(listingType.listings[indexRow].favorited)
            aptFavorited?.accessoryView?.tintColor = UIColor.lightGray
        }
        else if(listingType.listings[indexRow].favorited == false){
            listingType.listings[indexRow].setFavorited(yesorno: true)
            print(listingType.listings[indexRow].favorited)
            aptFavorited?.accessoryView?.tintColor = UIColor.red
        }
        tableView.reloadRows(at: [indexPath], with: .fade)
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
