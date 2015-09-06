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
    var annotations: [PropertyAnnotation]!
    var selectedProperty: PropertyAnnotation!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.initLocationManager()
        pullLocationsAPI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
        var latDelta: CLLocationDegrees = 0.2
        var lonDelta: CLLocationDegrees = 0.2
        var span: MKCoordinateSpan = MKCoordinateSpanMake(latDelta, lonDelta)
        var region: MKCoordinateRegion = MKCoordinateRegionMake(location, span)
        propertyMapView.setRegion(region, animated: false)
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
            var priceLabel = UILabel(frame: CGRectMake(0, 0, 60, 40))
            priceLabel.textColor = UIColor.whiteColor()
            priceLabel.alpha = 0.8;
            priceLabel.tag = 42;
            customizedView.addSubview(priceLabel)
            customizedView.frame = priceLabel.frame
            customizedView.canShowCallout = true
            customizedView.leftCalloutAccessoryView = UIImageView(frame: CGRectMake(0, 0, 50, 50))
        } else {
            customizedView.annotation = annotation
        }
        
        var label = customizedView.viewWithTag(42) as! UILabel
        label.textAlignment = .Center
        if let pAnnotation = annotation as? PropertyAnnotation {
            label.text = pAnnotation.price
        }
        return customizedView
    }

    func mapView(mapView: MKMapView!, didSelectAnnotationView view: MKAnnotationView!) {
        if let calloutView = view.leftCalloutAccessoryView as? UIImageView {
            if let propertyAnnotation = view.annotation as? PropertyAnnotation {
                calloutView.image = propertyAnnotation.image
                selectedProperty = propertyAnnotation
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
            if let destVC = segue.destinationViewController as? PropertyDetailTableViewController {
                destVC.selectedProperty = selectedProperty
            }
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
        if let data = response["data"] as? [NSDictionary] {
            self.annotations = getPropertyAnnotations(data)
            propertyMapView.removeAnnotations(propertyMapView.annotations)
            propertyMapView.addAnnotations(annotations)
            propertyMapView.showAnnotations(annotations, animated: true)
        }
    }

    func pullLocationsAPI() {
        var apiService = APIService()
        apiService.delegate = self
        let apiURL = APIAdapter.api.getLocationsAPI()
        apiService.request(apiURL)
    }
    
    func getPropertyAnnotations(locationJSONs: [NSDictionary]) -> [PropertyAnnotation] {
        var propertyAnnotations = [PropertyAnnotation] ()
        for locationJSON in locationJSONs {
            if let attributes = locationJSON["attributes"] as? NSDictionary {
                var lat = attributes["lat"] as! NSString
                var long = attributes["long"] as! NSString
                var geoLocation = CLLocationCoordinate2D(latitude: lat.doubleValue, longitude: long.doubleValue)
                var title = attributes["title"] as! String
                var price = attributes["price"] as! String
                var photoLinks = attributes["photos"] as! [String]
                var propertyAnnotation = PropertyAnnotation()
                propertyAnnotation.title = title
                propertyAnnotation.price = price
                propertyAnnotation.coordinate = geoLocation
                propertyAnnotation.imageLinks = photoLinks
                var imageURL = NSURL(string: photoLinks[0])
                if let imageData = NSData(contentsOfURL: imageURL!) {
                    if let image = UIImage(data: imageData) {
                        propertyAnnotation.image = image
                    }
                }
                propertyAnnotations.append(propertyAnnotation)
            }
        }
        
        return propertyAnnotations
    }
    
    class PropertyAnnotation: MKPointAnnotation {
        var image: UIImage!
        var thumbLink: String!
        var imageLinks: [String]!
        var price: String!
    }
}
