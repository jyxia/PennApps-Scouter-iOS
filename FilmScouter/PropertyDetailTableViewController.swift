//
//  PropertyDetailTableViewController.swift
//  FilmScouter
//
//  Created by Jinyue Xia on 9/5/15.
//  Copyright (c) 2015 Jinyue Xia. All rights reserved.
//

import UIKit

class PropertyDetailTableViewController: UITableViewController {

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
        return 2
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellNib = UINib(nibName: "ScrollImageViewCell", bundle: NSBundle.mainBundle())
        tableView.registerNib(cellNib, forCellReuseIdentifier: "scrollImageCell")
        if indexPath.row == 0 {
            var scrollCell = tableView.dequeueReusableCellWithIdentifier("scrollImageCell", forIndexPath: indexPath) as! ScrollImageViewCell
            initScrollView(scrollCell)
            return scrollCell
        }
        if indexPath.row == 1 {
            let cellNib = UINib(nibName: "PropertyDetailCell", bundle: NSBundle.mainBundle())
            tableView.registerNib(cellNib, forCellReuseIdentifier: "propertyDetailCell")
            var propertyDetailCell = tableView.dequeueReusableCellWithIdentifier("propertyDetailCell", forIndexPath: indexPath) as! PropertyDetailCell
            return propertyDetailCell
        }
        var cell = tableView.dequeueReusableCellWithIdentifier("defaultcell", forIndexPath: indexPath) as! UITableViewCell
        return cell
    }

    func initScrollView(cell: ScrollImageViewCell) {
        var images: [UIImage] = []
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        let imageWidth = screenSize.width
        let imageHeight = cell.frame.height
        cell.imageScrollView.frame = CGRectMake(10, 10, imageWidth, imageHeight)
        cell.imageScrollView.contentSize = CGSizeMake(imageWidth * 2, imageHeight)
        cell.imageScrollView.pagingEnabled = true
        
        var xPos: CGFloat = 0.0
        var image1 = UIImage(named: "pop")
        var image2 = UIImage(named: "pop")
        images.append(image1!)
        images.append(image2!)
        
        for image in images {
            var imageView = UIImageView(frame: CGRectMake(xPos, 0.0, imageWidth, imageHeight))
            imageView.contentMode = .ScaleAspectFit
            imageView.image = image
            cell.imageScrollView.addSubview(imageView)
            xPos += imageWidth;
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if (indexPath.section == 0) {
            return 200.0
        }
        
        return 44.0
        
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
