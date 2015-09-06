//
//  HomeViewController.swift
//  FilmScouter
//
//  Created by Jinyue Xia on 9/5/15.
//  Copyright (c) 2015 Jinyue Xia. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class HomeViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, APIControllerProtocol {

    @IBOutlet weak var propertyMapView: MKMapView!
    
    let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        pullLocationsAPI()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.initLocationManager()
        initMap()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func initMap() {
        var tAnnotation = self.getPropertyAnnotations()
        propertyMapView.addAnnotation(tAnnotation)
        var location: CLLocationCoordinate2D = tAnnotation.coordinate
    }
    
    //------------------------------------------------------------------------------------------
    // LocationManager
    //------------------------------------------------------------------------------------------
    func initLocationManager() {
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.startUpdatingLocation()
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        self.locationManager.stopUpdatingLocation()
        var currentLocation = locations[0] as! CLLocation
        var latitude: CLLocationDegrees = currentLocation.coordinate.latitude
        var longitude: CLLocationDegrees = currentLocation.coordinate.longitude
        var location: CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
        var latDelta: CLLocationDegrees = 0.05
        var lonDelta: CLLocationDegrees = 0.05
        var span: MKCoordinateSpan = MKCoordinateSpanMake(latDelta, lonDelta)
        var region: MKCoordinateRegion = MKCoordinateRegionMake(location, span)
        propertyMapView.setRegion(region, animated: true)
        // propertyMapView.showsUserLocation = true
    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        var message = "Our app requires to acess your location"
    }
    
    //------------------------------------------------------------------------------------------
    // mapView delegates
    //------------------------------------------------------------------------------------------
    func mapView(mView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        var customizedView = mView.dequeueReusableAnnotationViewWithIdentifier("CustomizedPin")
        if customizedView == nil {
            customizedView = MKAnnotationView(annotation: annotation, reuseIdentifier: "CustomizedPin")
            customizedView.image = UIImage(named: "bubble")
            var priceLabel = UILabel(frame: CGRectMake(0, 0, 40, 30))
            priceLabel.textColor = UIColor.whiteColor()
            priceLabel.alpha = 0.8;
            priceLabel.tag = 42;
            customizedView.addSubview(priceLabel)
            customizedView.frame = priceLabel.frame
            customizedView.canShowCallout = true
            customizedView.leftCalloutAccessoryView = UIImageView(frame: CGRectMake(0, 0, 40, 40))
        } else {
            customizedView.annotation = annotation
        }
        
        var label = customizedView.viewWithTag(42) as! UILabel
        label.textAlignment = .Center
        label.text = "$20"
        return customizedView
    }

    func mapView(mapView: MKMapView!, didSelectAnnotationView view: MKAnnotationView!) {
        if let calloutView = view.leftCalloutAccessoryView as? UIImageView {
            calloutView.contentMode = .ScaleAspectFit
            if let propertyAnnotation = view.annotation as? PropertyAnnotation {
                calloutView.image = propertyAnnotation.image
            }
        }
        view.rightCalloutAccessoryView = UIButton.buttonWithType(.DetailDisclosure) as! UIButton
    }
    
    func mapView(mapView: MKMapView!, annotationView view: MKAnnotationView!, calloutAccessoryControlTapped control: UIControl!) {
        self.performSegueWithIdentifier("ShowProperty", sender: view)
    }

    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowProperty" {
            
        }
    }
    
    @IBAction func unwindToHomeViewController(segue: UIStoryboardSegue) {
        if let filterViewController = segue.sourceViewController as? FilterTableViewController {
            filterViewController.dismissViewControllerAnimated(true, completion: {})
        }
    }
    
    @IBAction func tapSearch(sender: UIBarButtonItem) {
        self.performSegueWithIdentifier("filterSeg", sender: self)
    }
    
    
    // implement APIControllerProtocal
    func didReceiveAPIResults(response: NSDictionary) {
        println(response)
    }

    func pullLocationsAPI() {
        var apiService = APIService()
        apiService.delegate = self
        let apiURL = APIAdapter.api.getLocationsAPI()
        apiService.request(apiURL)
    }
    
    func getPropertyAnnotations(locationJSONs: [NSDictionary]) -> PropertyAnnotation {
        
        var propertyAnnotation = PropertyAnnotation()
        var imageLink = "https://upload.wikimedia.org/wikipedia/commons/9/95/Wells_Fargo_Center_2012-02-06.jpg"
        var imageURL = NSURL(string: imageLink)
        if let imageData = NSData(contentsOfURL: imageURL!) {
            if let image = UIImage(data: imageData) {
                propertyAnnotation.image = image
            }
        }
        
        var propertyTitle = "New Orleans"
        var latitude: CLLocationDegrees = 39.900411
        var longitude: CLLocationDegrees = -75.172044
        var geoLocation = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        propertyAnnotation.title = propertyTitle
        propertyAnnotation.coordinate = geoLocation
        
        return propertyAnnotation
    }
    
    class PropertyAnnotation: MKPointAnnotation {
        var image: UIImage!
        var thumbLink: String!
    }
}
