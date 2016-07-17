//
//  FiltersViewController.swift
//  Yelp
//
//  Created by Welcome on 7/16/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit

@objc protocol FiltersViewControllerDelegate {
    optional func filtersViewController(filtersViewController: FiltersViewController, didFiltersChanged value: [String: AnyObject])
}

class FiltersViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var switchStates = [Int: Bool]()
    
    let distanceOptions: [NSDictionary] = [
        ["name": "Auto", "value": -1],
        ["name": "0.3 miles", "value": 0.3],
        ["name": "1 miles", "value": 1],
        ["name": "3 miles", "value": 3],
        ["name": "5 miles", "value": 5]
    ]
    
    let sortByOptions: [NSDictionary] = [
        ["name" : "Best match", "value": 1],
        ["name" : "Distance", "value": 2],
        ["name" : "Highest rated", "value": 3],
    ]
    
    let sectionTitles: [Int: String] = [
        0: "Offering a Deal",
        1: "Distance",
        2: "Sort by",
        3: "Category"
    ]

    weak var delegate: FiltersViewControllerDelegate?
    
    // show hide logic
    var isSortByShowed: Bool = false
    var isDistanceShowed: Bool = false
    
    // selected filter value
    var selectedDistanceIndex:Int = 0
    var selectedSortIndex:Int = 0
    
    // header config
    let distanceHeaderViewHeight: CGFloat = 70
    
    // cell config
    let defaultFilterCellHeight: CGFloat = 45
    let distanceTableViewCellHeight : CGFloat = 45
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerNibs()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        // Do any additional setup after loading the view.
    }
    
    // register custom cells design from nib
    func registerNibs() {
        self.tableView.registerNib(UINib(nibName: DistanceTableViewCell.ClassName, bundle: NSBundle.mainBundle()), forCellReuseIdentifier: DistanceTableViewCell.ClassName)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onCancelClicked(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func onSearchClicked(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
        var filters = [String: AnyObject]()
        filters["categories"] = selectedCategories()
        delegate?.filtersViewController!(self, didFiltersChanged: filters)
    }

    let categories = [["name" : "Afghan", "code": "afghani"],
                      ["name" : "African", "code": "african"],
                      ["name" : "American, New", "code": "newamerican"],
                      ["name" : "American, Traditional", "code": "tradamerican"],
                      ["name" : "Arabian", "code": "arabian"],
                      ["name" : "Argentine", "code": "argentine"],
                      ["name" : "Armenian", "code": "armenian"],
                      ["name" : "Asian Fusion", "code": "asianfusion"],
                      ["name" : "Asturian", "code": "asturian"],
                      ["name" : "Australian", "code": "australian"],
                      ["name" : "Austrian", "code": "austrian"],
                      ["name" : "Baguettes", "code": "baguettes"],
                      ["name" : "Bangladeshi", "code": "bangladeshi"],
                      ["name" : "Barbeque", "code": "bbq"],
                      ["name" : "Basque", "code": "basque"],
                      ["name" : "Bavarian", "code": "bavarian"],
                      ["name" : "Beer Garden", "code": "beergarden"],
                      ["name" : "Beer Hall", "code": "beerhall"],
                      ["name" : "Beisl", "code": "beisl"],
                      ["name" : "Belgian", "code": "belgian"],
                      ["name" : "Bistros", "code": "bistros"],
                      ["name" : "Black Sea", "code": "blacksea"],
                      ["name" : "Brasseries", "code": "brasseries"],
                      ["name" : "Brazilian", "code": "brazilian"],
                      ["name" : "Breakfast & Brunch", "code": "breakfast_brunch"],
                      ["name" : "British", "code": "british"],
                      ["name" : "Buffets", "code": "buffets"],
                      ["name" : "Bulgarian", "code": "bulgarian"],
                      ["name" : "Burgers", "code": "burgers"],
                      ["name" : "Burmese", "code": "burmese"],
                      ["name" : "Cafes", "code": "cafes"],
                      ["name" : "Cafeteria", "code": "cafeteria"],
                      ["name" : "Cajun/Creole", "code": "cajun"],
                      ["name" : "Cambodian", "code": "cambodian"],
                      ["name" : "Canadian", "code": "New)"],
                      ["name" : "Canteen", "code": "canteen"],
                      ["name" : "Caribbean", "code": "caribbean"],
                      ["name" : "Catalan", "code": "catalan"],
                      ["name" : "Chech", "code": "chech"],
                      ["name" : "Cheesesteaks", "code": "cheesesteaks"],
                      ["name" : "Chicken Shop", "code": "chickenshop"],
                      ["name" : "Chicken Wings", "code": "chicken_wings"],
                      ["name" : "Chilean", "code": "chilean"],
                      ["name" : "Chinese", "code": "chinese"],
                      ["name" : "Comfort Food", "code": "comfortfood"],
                      ["name" : "Corsican", "code": "corsican"],
                      ["name" : "Creperies", "code": "creperies"],
                      ["name" : "Cuban", "code": "cuban"],
                      ["name" : "Curry Sausage", "code": "currysausage"],
                      ["name" : "Cypriot", "code": "cypriot"],
                      ["name" : "Czech", "code": "czech"],
                      ["name" : "Czech/Slovakian", "code": "czechslovakian"],
                      ["name" : "Danish", "code": "danish"],
                      ["name" : "Delis", "code": "delis"],
                      ["name" : "Diners", "code": "diners"],
                      ["name" : "Dumplings", "code": "dumplings"],
                      ["name" : "Eastern European", "code": "eastern_european"],
                      ["name" : "Ethiopian", "code": "ethiopian"],
                      ["name" : "Fast Food", "code": "hotdogs"],
                      ["name" : "Filipino", "code": "filipino"],
                      ["name" : "Fish & Chips", "code": "fishnchips"],
                      ["name" : "Fondue", "code": "fondue"],
                      ["name" : "Food Court", "code": "food_court"],
                      ["name" : "Food Stands", "code": "foodstands"],
                      ["name" : "French", "code": "french"],
                      ["name" : "French Southwest", "code": "sud_ouest"],
                      ["name" : "Galician", "code": "galician"],
                      ["name" : "Gastropubs", "code": "gastropubs"],
                      ["name" : "Georgian", "code": "georgian"],
                      ["name" : "German", "code": "german"],
                      ["name" : "Giblets", "code": "giblets"],
                      ["name" : "Gluten-Free", "code": "gluten_free"],
                      ["name" : "Greek", "code": "greek"],
                      ["name" : "Halal", "code": "halal"],
                      ["name" : "Hawaiian", "code": "hawaiian"],
                      ["name" : "Heuriger", "code": "heuriger"],
                      ["name" : "Himalayan/Nepalese", "code": "himalayan"],
                      ["name" : "Hong Kong Style Cafe", "code": "hkcafe"],
                      ["name" : "Hot Dogs", "code": "hotdog"],
                      ["name" : "Hot Pot", "code": "hotpot"],
                      ["name" : "Hungarian", "code": "hungarian"],
                      ["name" : "Iberian", "code": "iberian"],
                      ["name" : "Indian", "code": "indpak"],
                      ["name" : "Indonesian", "code": "indonesian"],
                      ["name" : "International", "code": "international"],
                      ["name" : "Irish", "code": "irish"],
                      ["name" : "Island Pub", "code": "island_pub"],
                      ["name" : "Israeli", "code": "israeli"],
                      ["name" : "Italian", "code": "italian"],
                      ["name" : "Japanese", "code": "japanese"],
                      ["name" : "Jewish", "code": "jewish"],
                      ["name" : "Kebab", "code": "kebab"],
                      ["name" : "Korean", "code": "korean"],
                      ["name" : "Kosher", "code": "kosher"],
                      ["name" : "Kurdish", "code": "kurdish"],
                      ["name" : "Laos", "code": "laos"],
                      ["name" : "Laotian", "code": "laotian"],
                      ["name" : "Latin American", "code": "latin"],
                      ["name" : "Live/Raw Food", "code": "raw_food"],
                      ["name" : "Lyonnais", "code": "lyonnais"],
                      ["name" : "Malaysian", "code": "malaysian"],
                      ["name" : "Meatballs", "code": "meatballs"],
                      ["name" : "Mediterranean", "code": "mediterranean"],
                      ["name" : "Mexican", "code": "mexican"],
                      ["name" : "Middle Eastern", "code": "mideastern"],
                      ["name" : "Milk Bars", "code": "milkbars"],
                      ["name" : "Modern Australian", "code": "modern_australian"],
                      ["name" : "Modern European", "code": "modern_european"],
                      ["name" : "Mongolian", "code": "mongolian"],
                      ["name" : "Moroccan", "code": "moroccan"],
                      ["name" : "New Zealand", "code": "newzealand"],
                      ["name" : "Night Food", "code": "nightfood"],
                      ["name" : "Norcinerie", "code": "norcinerie"],
                      ["name" : "Open Sandwiches", "code": "opensandwiches"],
                      ["name" : "Oriental", "code": "oriental"],
                      ["name" : "Pakistani", "code": "pakistani"],
                      ["name" : "Parent Cafes", "code": "eltern_cafes"],
                      ["name" : "Parma", "code": "parma"],
                      ["name" : "Persian/Iranian", "code": "persian"],
                      ["name" : "Peruvian", "code": "peruvian"],
                      ["name" : "Pita", "code": "pita"],
                      ["name" : "Pizza", "code": "pizza"],
                      ["name" : "Polish", "code": "polish"],
                      ["name" : "Portuguese", "code": "portuguese"],
                      ["name" : "Potatoes", "code": "potatoes"],
                      ["name" : "Poutineries", "code": "poutineries"],
                      ["name" : "Pub Food", "code": "pubfood"],
                      ["name" : "Rice", "code": "riceshop"],
                      ["name" : "Romanian", "code": "romanian"],
                      ["name" : "Rotisserie Chicken", "code": "rotisserie_chicken"],
                      ["name" : "Rumanian", "code": "rumanian"],
                      ["name" : "Russian", "code": "russian"],
                      ["name" : "Salad", "code": "salad"],
                      ["name" : "Sandwiches", "code": "sandwiches"],
                      ["name" : "Scandinavian", "code": "scandinavian"],
                      ["name" : "Scottish", "code": "scottish"],
                      ["name" : "Seafood", "code": "seafood"],
                      ["name" : "Serbo Croatian", "code": "serbocroatian"],
                      ["name" : "Signature Cuisine", "code": "signature_cuisine"],
                      ["name" : "Singaporean", "code": "singaporean"],
                      ["name" : "Slovakian", "code": "slovakian"],
                      ["name" : "Soul Food", "code": "soulfood"],
                      ["name" : "Soup", "code": "soup"],
                      ["name" : "Southern", "code": "southern"],
                      ["name" : "Spanish", "code": "spanish"],
                      ["name" : "Steakhouses", "code": "steak"],
                      ["name" : "Sushi Bars", "code": "sushi"],
                      ["name" : "Swabian", "code": "swabian"],
                      ["name" : "Swedish", "code": "swedish"],
                      ["name" : "Swiss Food", "code": "swissfood"],
                      ["name" : "Tabernas", "code": "tabernas"],
                      ["name" : "Taiwanese", "code": "taiwanese"],
                      ["name" : "Tapas Bars", "code": "tapas"],
                      ["name" : "Tapas/Small Plates", "code": "tapasmallplates"],
                      ["name" : "Tex-Mex", "code": "tex-mex"],
                      ["name" : "Thai", "code": "thai"],
                      ["name" : "Traditional Norwegian", "code": "norwegian"],
                      ["name" : "Traditional Swedish", "code": "traditional_swedish"],
                      ["name" : "Trattorie", "code": "trattorie"],
                      ["name" : "Turkish", "code": "turkish"],
                      ["name" : "Ukrainian", "code": "ukrainian"],
                      ["name" : "Uzbek", "code": "uzbek"],
                      ["name" : "Vegan", "code": "vegan"],
                      ["name" : "Vegetarian", "code": "vegetarian"],
                      ["name" : "Venison", "code": "venison"],
                      ["name" : "Vietnamese", "code": "vietnamese"],
                      ["name" : "Wok", "code": "wok"],
                      ["name" : "Wraps", "code": "wraps"],
                      ["name" : "Yugoslav", "code": "yugoslav"]]
    
    func selectedCategories() -> [String] {
        var result = [String]()
        for (cellIndex, isSelected) in switchStates {
            if isSelected {
                result.append(categories[cellIndex]["code"]!)
            }
        }
        return result
    }
}

extension FiltersViewController : UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return sectionTitles.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 1:
            return isDistanceShowed ? distanceOptions.count : 0
        case 2:
            return isSortByShowed ? sortByOptions.count : 0
        case 3:
            return self.categories.count
        default:
            return 1
        }
    }
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch indexPath.section {
        case 1:
            return distanceTableViewCellHeight
        default:
            return defaultFilterCellHeight
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
        switch (indexPath.section) {
        case 0:
            return tableView.dequeueReusableCellWithIdentifier("DealCell") as! DealCell
        case 1:
            let cell = tableView.dequeueReusableCellWithIdentifier(DistanceTableViewCell.ClassName) as! DistanceTableViewCell
            let distanceItem = distanceOptions[indexPath.row]
            cell.leftLabel.text = distanceItem["name"] as? String
            cell.checked = indexPath.row == selectedDistanceIndex
            return cell
        case 2:
            let cell = tableView.dequeueReusableCellWithIdentifier(DistanceTableViewCell.ClassName) as! DistanceTableViewCell
            let sortByItem = sortByOptions[indexPath.row]
            cell.leftLabel.text = sortByItem["name"] as? String
            cell.checked = indexPath.row == selectedSortIndex
            return cell
        default:
            let cell = tableView.dequeueReusableCellWithIdentifier("SwitchCell") as! SwitchCell
            let category = categories[indexPath.row]
            cell.switchLabel.text = category["name"]!
            cell.switcher.on = switchStates[indexPath.row] ?? false
            cell.delegate = self
            return cell
        }
    }
}

extension FiltersViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch (section) {
        case 1, 2:
            return distanceHeaderViewHeight
        default:
            return 45
        }
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionTitle = sectionTitles[section]! as String
        switch (section) {
        case 1:
            let view = DistanceHeaderView.initFromNib()
            view.sectionIndex = section
            view.headerTitle.text = sectionTitle
            view.delegate = self
            let btnTitle = distanceOptions[selectedDistanceIndex]["name"] as? String
            view.selectedItemBtn.setTitle(btnTitle, forState: .Normal)
            return view
        case 2:
            let view = DistanceHeaderView.initFromNib()
            view.sectionIndex = section
            view.headerTitle.text = sectionTitle
            view.delegate = self
            let btnTitle = sortByOptions[selectedSortIndex]["name"] as? String
            view.selectedItemBtn.setTitle(btnTitle, forState: .Normal)
            return view
        default:
            let view = CategoryHeaderView.initFromNib()
            view.sectionIndex = section
            view.headerTitle.text = sectionTitle
            return view
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.section == 1 {
            isDistanceShowed = false
            selectedDistanceIndex = indexPath.row
            self.tableView.reloadSections(NSIndexSet(index: indexPath.section), withRowAnimation: .Fade)
        } else if indexPath.section == 2 {
            selectedSortIndex = indexPath.row
            isSortByShowed = false
            self.tableView.reloadSections(NSIndexSet(index: indexPath.section), withRowAnimation: .Fade)
        }
    }
}

extension FiltersViewController: DistanceHeaderViewDelegate {
    func distanceHeaderViewDelegate(headerView: DistanceHeaderView, didSelectSection value: Int) {
        
        if value == 1 {
            isDistanceShowed = !isDistanceShowed
        } else if value == 2 {
            isSortByShowed = !isSortByShowed
        }
        
        self.tableView.reloadSections(NSIndexSet(index: value), withRowAnimation: .Fade)
    }
}

extension FiltersViewController: SwitchCellDelegate {
    func switchCell(switchedCell: SwitchCell, didChangeValue value: Bool) {
        let indexPath = tableView.indexPathForCell(switchedCell)!
        switchStates[indexPath.row] = value
        print("Filter got signal from cell", indexPath.row)
    }
}

