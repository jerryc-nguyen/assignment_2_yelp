//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit

class BusinessesViewController: UIViewController {
    
    var businesses = [Business]()
    
    var filteredValues = NSDictionary()
    
    @IBOutlet var searchBar: UISearchBar!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.titleView = searchBar
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 120
        
        self.searchBar.delegate = self
        self.searchBar.showsCancelButton = true
        
        Business.searchWithTerm("Thai", completion: { (businesses: [Business]!, error: NSError!) -> Void in
            if businesses != nil {
                self.businesses = businesses
                self.tableView.reloadData()
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let navigationController = segue.destinationViewController as! UINavigationController
        let filtersVC = navigationController.topViewController as! FiltersViewController
        
        filtersVC.delegate = self
    }
    
    func performSearch(searchTerm: String) {
        let filteredCategories = filteredValues["categories"] as? [String]
        let selectedDistance = filteredValues["distance"] as? Int
        let sortBy = (filteredValues["sortBy"] as? Int) ?? YelpSortMode.BestMatched.rawValue
        let isDeal = (filteredValues["isDeal"] as? Int) == 1
        
        Business.searchWithTerm(searchTerm, sort: YelpSortMode(rawValue: sortBy), categories: filteredCategories, deals: isDeal, distanceInMeter: selectedDistance) { (businesses: [Business]!, error: NSError!) -> Void in
            if businesses != nil {
                self.businesses = businesses
                self.tableView.reloadData()
            }
        }
    }

}

extension BusinessesViewController : FiltersViewControllerDelegate {
    func filtersViewController(filtersViewController: FiltersViewController, didFiltersChanged value: [String : AnyObject]) {
        print("Received signal from filter controller: ", value)
        filteredValues = value
        performSearch("")
    }
}

extension BusinessesViewController : UITableViewDataSource, UITableViewDelegate {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.businesses.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("BusinessCell") as! BusinessCell
        
        cell.business = businesses[indexPath.row]

        return cell
    }
}


extension BusinessesViewController : UISearchBarDelegate {
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        performSearch(searchText)
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }
}