//
//  PriceListingTableViewController.swift
//  FilmScouter
//
//  Created by Jinyue Xia on 9/5/15.
//  Copyright (c) 2015 Jinyue Xia. All rights reserved.
//

import UIKit

class PriceListingTableViewController: UITableViewController {
    
    var prices = ["10000", "10000-15000", "15000-20000", "20000+"]
    var selectedPrice: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return prices.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("priceSelectionCell", forIndexPath: indexPath) as! UITableViewCell
        cell.textLabel?.text = prices[indexPath.row]
        if selectedPrice == prices[indexPath.row] {
            cell.accessoryType = .Checkmark
        } else {
            cell.accessoryType = .None
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        var selectedIndex = getIndex(selectedPrice)
        //Other row is selected - need to deselect it
        let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: selectedIndex, inSection: 0))
        cell?.accessoryType = .None
        selectedPrice = prices[indexPath.row]
        //update the checkmark for the current row
        let newcell = self.tableView.cellForRowAtIndexPath(indexPath)
        newcell?.accessoryType = .Checkmark
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "passedPriceSelection" {
            let cell = sender as! UITableViewCell
            let indexPath = self.tableView.indexPathForCell(cell)
            selectedPrice = prices[indexPath!.row]
        }
    }
    
    func getIndex(selectedPrice: String) -> Int {
        var index = 0
        for price in prices {
            if price == selectedPrice {
                break
            }
            index++
        }
        return index
    }
}
