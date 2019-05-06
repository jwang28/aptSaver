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
import VACalendar

class ListingTableViewController: UITableViewController {
    
    @IBOutlet weak var tableHeaderView: UIView!
    @IBOutlet weak var monthHeaderView: VAMonthHeaderView! {
        didSet {
            let formatter = DateFormatter()
            formatter.dateFormat = "LLLL"
            let appereance = VAMonthHeaderViewAppearance(
                previousButtonImage: UIImage(named: "favHeart")!,
                nextButtonImage: UIImage(named: "favHeart")!,
                dateFormatter: formatter
            )
            monthHeaderView.delegate = self
            monthHeaderView.appearance = appereance
        }
    }
    
    @IBOutlet weak var weekDaysView: VAWeekDaysView! {
        didSet {
            let appereance = VAWeekDaysViewAppearance(symbolsType: .veryShort, calendar: defaultCalendar)
            weekDaysView.appearance = appereance
        }
    }
    
    var calendarView : VACalendarView!
    
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
    
        let calendar = VACalendar(calendar: defaultCalendar)
        calendarView = VACalendarView(frame: .zero, calendar: calendar)
        calendarView.showDaysOut = true
        calendarView.selectionStyle = .multi
        calendarView.monthDelegate = monthHeaderView
        calendarView.dayViewAppearanceDelegate = self
        calendarView.monthViewAppearanceDelegate = self
        calendarView.calendarDelegate = self
        calendarView.scrollDirection = .horizontal
        tableHeaderView.addSubview(calendarView)
        
        reloadEvents()
    }
    
    func reloadEvents() {
        calendarView.setSupplementaries([
            (Date().addingTimeInterval(-(60 * 60 * 70)), [VADaySupplementary.bottomDots([.red, .magenta])]),
            (Date().addingTimeInterval((60 * 60 * 110)), [VADaySupplementary.bottomDots([.red])]),
            (Date().addingTimeInterval((60 * 60 * 370)), [VADaySupplementary.bottomDots([.blue, .darkGray])]),
            (Date().addingTimeInterval((60 * 60 * 430)), [VADaySupplementary.bottomDots([.orange, .purple, .cyan])])
            ])
    }
    
    let defaultCalendar: Calendar = {
        var calendar = Calendar.current
        calendar.firstWeekday = 1
        calendar.timeZone = TimeZone(secondsFromGMT: 0)!
        return calendar
    }()
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if calendarView.frame == .zero {
            calendarView.frame = CGRect(
                x: 0,
                y: weekDaysView.frame.maxY,
                width: tableHeaderView.frame.width,
                height: tableHeaderView.frame.height - weekDaysView.frame.maxY
            )
            calendarView.setup()
        }
    }
    
    @objc func logOut()
    {
        GIDSignIn.sharedInstance().signOut()
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func addListingButton(_ sender: Any)
    {
        performSegue(withIdentifier: "AddListing", sender: nil)
    }
    
    //MARK: - UItableViewDataSource
    override func numberOfSections(in tableView: UITableView) -> Int
    {
        return listingTypes.count
    }
    
    //Auto Resizing Table View Cells
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return listingTypes[section].listings.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListingCell", for: indexPath) as! ListingTableViewCell
        cell.listing = listingTypes[indexPath.section].listings[indexPath.row]
        
        //Setting favorites button
        let starButton = UIButton(type: .system)
        let image = UIImage(named: "favHeart")?.withRenderingMode(.alwaysTemplate)
        cell.heartButton.setImage(image, for: .normal)
        
        //Colors the favorites icon according to whether or not the item is favorited
        if cell.listing!.favorited
        {
            cell.heartButton.tintColor = UIColor.red
            cell.heartButton.setImage(UIImage(named: "favHeartFilled"), for: .normal)
        } else
        {
            cell.heartButton.tintColor = UIColor.lightGray
            cell.heartButton.setImage(UIImage(named: "favHeart"), for: .normal)
        }
        cell.heartButton.addTarget(self, action: #selector(handleAsFavorite), for: .touchUpInside)
        return cell
    }
    
    //Handling favorites
    //If selected heart icon, it goes to the favorite section
    //Positing the heart
    @objc private func handleAsFavorite(sender: UIButton)
    {
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
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        let listingType = listingTypes[section]
        return listingType.name
    }
    
    // Delete Rows
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath)
    {
        if editingStyle == .delete
        {
            let listingType = listingTypes[indexPath.section]
            listingType.listings.remove(at: indexPath.row)

            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    //move cells around
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool
    {
        return true
    }
    
    //update database
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath)
    {
        let listingToMove = listingTypes[sourceIndexPath.section].listings[sourceIndexPath.row]
        listingTypes[destinationIndexPath.section].listings.insert(listingToMove, at: destinationIndexPath.row)
        listingTypes[sourceIndexPath.section].listings.remove(at: sourceIndexPath.row)
    }
    
    //MARK: -UITABLEVIEWDELEGATE
    var selectedListing: Listing?
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let listingType = listingTypes[indexPath.section]
        let listing = listingType.listings[indexPath.row]
        selectedListing = listing
        performSegue(withIdentifier: "ShowListingDetail", sender: nil)
    }
    
    //MARK: -NAVIGATION
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "ShowListingDetail"
        {
            let listingDetailTVC = segue.destination as! ListingDetailTableViewController
            listingDetailTVC.listing = selectedListing
        }
        if segue.identifier == "AddListing"
        {
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


extension ListingTableViewController: VAMonthHeaderViewDelegate {
    
    func didTapNextMonth() {
        calendarView.nextMonth()
    }
    
    func didTapPreviousMonth() {
        calendarView.previousMonth()
    }
    
}

extension ListingTableViewController: VAMonthViewAppearanceDelegate {
    
    func leftInset() -> CGFloat {
        return 10.0
    }
    
    func rightInset() -> CGFloat {
        return 10.0
    }
    
    func verticalMonthTitleFont() -> UIFont {
        return UIFont.systemFont(ofSize: 16, weight: .semibold)
    }
    
    func verticalMonthTitleColor() -> UIColor {
        return .black
    }
    
    func verticalCurrentMonthTitleColor() -> UIColor {
        return .red
    }
    
}

extension ListingTableViewController: VADayViewAppearanceDelegate {
    
    func textColor(for state: VADayState) -> UIColor {
        switch state {
        case .out:
            return UIColor(red: 214 / 255, green: 214 / 255, blue: 219 / 255, alpha: 1.0)
        case .selected:
            return .white
        case .unavailable:
            return .lightGray
        default:
            return .black
        }
    }
    
    func textBackgroundColor(for state: VADayState) -> UIColor {
        switch state {
        case .selected:
            return .red
        default:
            return .clear
        }
    }
    
    func shape() -> VADayShape {
        return .circle
    }
    
    func dotBottomVerticalOffset(for state: VADayState) -> CGFloat {
        switch state {
        case .selected:
            return 2
        default:
            return -7
        }
    }
    
}

extension ListingTableViewController: VACalendarViewDelegate {
    
    func selectedDates(_ dates: [Date]) {
        calendarView.startDate = dates.last ?? Date()
        print(dates)
    }
    
}

