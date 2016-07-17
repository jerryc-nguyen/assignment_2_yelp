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
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 120
        
        Business.searchWithTerm("Thai", completion: { (businesses: [Business]!, error: NSError!) -> Void in
            if businesses != nil {
                self.businesses = businesses
                self.tableView.reloadData()
            }
        })
    
/* Example of Yelp search with moreearch options specified
        Business.searchWithTerm("Restaurants", sort: .Distance, categories: ["asianfusion", "burgers"], deals: true) { (businesses: [Business]!, error: NSError!) -> Void in
            self.businesses = businesses
            
            for business in businesses {
                print(business.name!)
                print(business.address!)
            }
        }
*/
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

}

extension BusinessesViewController : FiltersViewControllerDelegate {
    func filtersViewController(filtersViewController: FiltersViewController, didFiltersChanged value: [String : AnyObject]) {
        print("Received signal from filter controller: ", value)
        
        let filteredCategories = value["categories"] as? [String]
        let selectedDistance = value["distance"] as? Int
        let sortBy = value["sortBy"] as? Int
        let isDeal = (value["isDeal"] as? Int) == 1
        Business.searchWithTerm("Restaurants", sort: YelpSortMode(rawValue: sortBy!), categories: filteredCategories, deals: isDeal, distanceInMeter: selectedDistance) { (businesses: [Business]!, error: NSError!) -> Void in
            if businesses != nil {
                self.businesses = businesses
                self.tableView.reloadData()
            }
        }
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
