//
//  FilterTableViewController.swift
//  FilmScouter
//
//  Created by Jinyue Xia on 9/5/15.
//  Copyright (c) 2015 Jinyue Xia. All rights reserved.
//

import UIKit

class FilterTableViewController: UITableViewController, UITextFieldDelegate {
 
    @IBOutlet weak var searchTextView: UITextField!
    @IBOutlet weak var startDatePicker: UIDatePicker!
    @IBOutlet weak var endDatePicker: UIDatePicker!
    var startDatePickerIsShowing = false
    var endDatePickerIsShowing = false

    override func viewDidLoad() {
        super.viewDidLoad()
        startDatePicker.addTarget(self, action: Selector("startDataPickerChanged:"), forControlEvents: UIControlEvents.ValueChanged)
        endDatePicker.addTarget(self, action: Selector("endDataPickerChanged:"), forControlEvents: UIControlEvents.ValueChanged)
        self.hideStartPickerCell()
        self.hideEndPickerCell()
        // Uncomment the following line to preserve selection between presentations
        self.clearsSelectionOnViewWillAppear = true

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    func textFieldDidEndEditing(textField: UITextField) {
        self.resignFirstResponder()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 4
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section == 1 || section == 2) {
            return 2
        }
        return 1
    }
    
    override func tableView(tableview: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        var height = super.tableView(tableview, heightForRowAtIndexPath: indexPath)
        if indexPath.section == 1 {
            if indexPath.row == 1  {
                if !self.startDatePickerIsShowing {
                    height = 0
                }
            }
        }
        if indexPath.section == 2 {
            if indexPath.row == 1  {
                if !self.endDatePickerIsShowing {
                    height = 0
                }
            }
        }
        return height
    }

    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.searchTextView.resignFirstResponder()

        if indexPath.section == 1 {
            if indexPath.row == 0 {
                if self.startDatePickerIsShowing {
                    self.hideStartPickerCell()
                } else {
                    self.showStartDatePickerCell()
                }
            }
        }
        if indexPath.section == 2 {
            if indexPath.row == 0 {
                if self.endDatePickerIsShowing {
                    self.hideEndPickerCell()
                } else {
                    self.showEndDatePickerCell()
                }
            }
        }
        if indexPath.section == 0 || indexPath.section == 3 {
            if self.startDatePickerIsShowing {
                self.hideStartPickerCell()
            }
            if self.endDatePickerIsShowing {
                self.hideEndPickerCell()
            }
        }
        if indexPath.section == 3 {
            self.performSegueWithIdentifier("priceSeg", sender: self)
        }
    }

    func startDataPickerChanged(datePicker:UIDatePicker) {
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
        var strDate = dateFormatter.stringFromDate(startDatePicker.date)
        var indexPath = NSIndexPath(forRow: 0, inSection: 1)
        if let cell = self.tableView.cellForRowAtIndexPath(indexPath)  {
            cell.detailTextLabel!.text = strDate
        }
    }
    
    func endDataPickerChanged(datePicker:UIDatePicker) {
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
        var endDate = dateFormatter.stringFromDate(endDatePicker.date)
        var indexPath = NSIndexPath(forRow: 0, inSection: 2)
        if let cell = self.tableView.cellForRowAtIndexPath(indexPath)  {
            cell.detailTextLabel!.text = endDate
        }
    }
    
    private func showStartDatePickerCell() {
        self.startDatePickerIsShowing = true
        self.tableView.beginUpdates()
        self.tableView.endUpdates()
        self.startDatePicker.hidden = false
    }
    
    private func hideStartPickerCell() {
        self.startDatePickerIsShowing = false
        self.tableView.beginUpdates()
        self.tableView.endUpdates()
        self.startDatePicker.hidden = true
    }

    private func showEndDatePickerCell() {
        self.endDatePickerIsShowing = true
        self.tableView.beginUpdates()
        self.tableView.endUpdates()
        self.endDatePicker.hidden = false
    }
    
    private func hideEndPickerCell() {
        self.endDatePickerIsShowing = false
        self.tableView.beginUpdates()
        self.tableView.endUpdates()
        self.endDatePicker.hidden = true
    }
    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "unwindToHomeSeg" {
    
        }
        if segue.identifier == "priceSeg" {
            var indexPath = NSIndexPath(forRow: 0, inSection: 3)
            if let cell = self.tableView.cellForRowAtIndexPath(indexPath)  {
                let destController = segue.destinationViewController as! PriceListingTableViewController
                destController.selectedPrice = cell.detailTextLabel!.text
            }
        }
    }
    
    @IBAction func passedPriceSelection (segue: UIStoryboardSegue) {
        if let priceViewController = segue.sourceViewController as? PriceListingTableViewController {
            var selectedPrice = priceViewController.selectedPrice
            var indexPath = NSIndexPath(forRow: 0, inSection: 3)
            if let cell = self.tableView.cellForRowAtIndexPath(indexPath)  {
                cell.detailTextLabel!.text = selectedPrice
            }
        self.navigationController?.popViewControllerAnimated(true)        }
    }

}
