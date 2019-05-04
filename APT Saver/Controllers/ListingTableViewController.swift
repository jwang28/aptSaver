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
    var test: String? = "hi"
    var listingTypes: [ListingType] = ListingType.getListingTypes()
    override func viewDidLoad() {
        super.viewDidLoad()
        //var htmlContent: String?
        //Get HTML
        let url = URL(string: "https://streeteasy.com/building/mantena-431-west-37-street-new_york/2a?similar=1")
        
        let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if error != nil {
                print (error)
            }
            else {
                //let htmlContent = NSString(data: data!,encoding: String.Encoding.utf8.rawValue)
                let htmlContent = String(data: data!,encoding: String.Encoding.utf8)!

                print("end")
                do {
                    let doc: Document = try SwiftSoup.parseBodyFragment(htmlContent)
               
                    let address: String? = try doc.getElementsByClass("building-title").text()
                    let price = try doc.getElementsByClass("price").text()
//                    let size = try doc.getElementsByClass("detail_cell first_detail_cell").text()
//                    let rooms = try doc.getElementsByClass("details_info").text()
//                    let description = try doc.getElementsByClass("Description-block jsDescriptionExpanded").text()
                    //get listing details (1=sq ft, price/sq ft, rooms, beds, 5=bath)
//                    let details: [Element] = try doc.getElementsByClass("details_info").get(0).getAllElements().array()
//                    let amenitiesHi: [Element] = try doc.getElementsByClass("AmenitiesBlock-highlights").get(0).getAllElements().array()
//                    let buildingAmenities: [Element] = try doc.getElementsByClass("AmenitiesBlock-list ").get(0).getAllElements().array()
//                    let listingAmenities: [Element] = try doc.getElementsByClass("AmenitiesBlock-list ").get(1).getAllElements().array()
                    //print(try details[4].text())
                    //print (try buildingAmenities[7].text())
                    //print(doc)
                    print(price)
                    
                } catch Exception.Error (let type, let message){
                    print(type,message)
                    print(message)
                } catch {
                    print("")
                }
            }
        }

        task.resume()
            
        self.title = "Apartments"
        
        self.tableView.estimatedRowHeight = tableView.rowHeight
        //resize to fit the contents of the description
        self.tableView.rowHeight = UITableView.automaticDimension
        
        self.navigationItem.leftBarButtonItem = editButtonItem
        print (test)
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
        return cell
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

            //tableView.reloadData()
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
