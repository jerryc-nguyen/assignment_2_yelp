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
    var searchTerm = ""
    
    var isMoreDataLoading = false
    
    var loadingMoreView:InfiniteScrollActivityView?
    
    var currentPage = 1
    
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
        
        // Set up Infinite Scroll loading indicator
        let frame = CGRectMake(0, tableView.contentSize.height, tableView.bounds.size.width, InfiniteScrollActivityView.defaultHeight)
        loadingMoreView = InfiniteScrollActivityView(frame: frame)
        loadingMoreView!.hidden = true
        tableView.addSubview(loadingMoreView!)
        
        var insets = tableView.contentInset;
        insets.bottom += InfiniteScrollActivityView.defaultHeight;
        tableView.contentInset = insets
        
        Business.searchWithTerm("Thai", completion: { (businesses: [Business]!, error: NSError!) -> Void in
            if businesses != nil {
                self.businesses = businesses
                self.tableView.reloadData()
            }
        })
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        view.endEditing(true)
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
    
    func performSearch(callBack: (() -> Void)? = nil) {
        let filteredCategories = filteredValues["categories"] as? [String]
        let selectedDistance = filteredValues["distance"] as? Int
        let sortBy = (filteredValues["sortBy"] as? Int) ?? YelpSortMode.BestMatched.rawValue
        let isDeal = (filteredValues["isDeal"] as? Int) == 1
        let offset = YelpClient.responsePerPage * currentPage

        Business.searchWithTerm(searchTerm, sort: YelpSortMode(rawValue: sortBy), categories: filteredCategories, deals: isDeal, distanceInMeter: selectedDistance, offset: offset) { (businesses: [Business]!, error: NSError!) -> Void in
            
            if businesses != nil {
                if self.isMoreDataLoading {
                    for business in businesses {
                        self.businesses.append(business)
                    }
                    callBack?()
                } else {
                    self.businesses = businesses
                    
                }
                
                self.tableView.reloadData()
            }
            
        }
    }
}

extension BusinessesViewController : FiltersViewControllerDelegate {
    func filtersViewController(filtersViewController: FiltersViewController, didFiltersChanged value: [String : AnyObject]) {
        print("Received signal from filter controller: ", value)
        filteredValues = value
        performSearch()
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
        currentPage = 1
        searchTerm = searchText
        performSearch()
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

extension BusinessesViewController : UIScrollViewDelegate {
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if (!isMoreDataLoading) {
            // Calculate the position of one screen length before the bottom of the results
            let scrollViewContentHeight = tableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
            
            // When the user has scrolled past the threshold, start requesting
            if(scrollView.contentOffset.y > scrollOffsetThreshold && tableView.dragging) {
                isMoreDataLoading = true
                currentPage += 1
                
                // Update position of loadingMoreView, and start loading indicator
                let frame = CGRectMake(0, tableView.contentSize.height, tableView.bounds.size.width, InfiniteScrollActivityView.defaultHeight)
                loadingMoreView!.frame = frame
                loadingMoreView!.startAnimating()
                performSearch() { () -> Void in
                    self.isMoreDataLoading = false
                    self.loadingMoreView!.stopAnimating()
                }
            }
        }
    }
}

