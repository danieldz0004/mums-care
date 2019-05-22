//
//  MapViewController.swift
//  Week9Tutorial
//
//  Created by Daniel Dz on 2019/4/24.
//  Copyright © 2019 Jason Haasz. All rights reserved.
//

import UIKit
import MapKit
import GoogleMaps
import GooglePlaces
import Firebase
import CoreLocation
import Alamofire
import SwiftyJSON
import PopupDialog

class MapViewController: UIViewController,MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var hintLable: UILabel!
    
    var dic:[String:Any]?
    var image = UIImage()
    var placesClient : GMSPlacesClient!
    var placeId = "1"
    var placeImage = UIImage(named: "nopic")
    
    var locationName = ""
    var geometry = [String:Any]()
    var locationdic = [String:Any]()
    var latitude = 0.0
    var longitude = 0.0
    
    private let reuseIdentifier = "MyIdentifier"
    
    let locationManager = CLLocationManager()
    
    @IBOutlet weak var map: MKMapView!
    var googleMapsView: GMSMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        placesClient = GMSPlacesClient.shared()
        
        setUpvalue()
        
        locationName = (dic!["name"] as? String)!
        
        DispatchQueue.main.async {
            self.getPlaceId(location: ("\(self.latitude),\(self.longitude)"))
        }
        
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        //self.initialMapView()
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        print("locations = \(locValue.latitude) \(locValue.longitude)")
    }
    
    func setUpvalue() {
        geometry = dic!["geometry"] as! [String : Any]
        locationdic = geometry["location"] as! [String : Any]
        latitude = (locationdic["lat"] as! NSNumber).doubleValue
        longitude = (locationdic["lng"] as! NSNumber).doubleValue
    }
    
    
    func drawPath()
    {
        let origin = "\(locationManager.location?.coordinate.latitude as! Double),\(locationManager.location?.coordinate.longitude as! Double)"
        let destination = "\(latitude),\(longitude)"
        print(destination)
        
        
        let url = "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin)&destination=\(destination)&mode=driving&key=AIzaSyBQJdd3kF5mxAYLk_e2kzMXY6stXJie_TA"
        print(url)
        
        Alamofire.request(url).responseJSON { response in
            
            print(response.request as Any)  // original URL request
            print(response.response as Any) // HTTP URL response
            print(response.data as Any)     // server data
            print(response.result as Any)   // result of response serialization
            if response.data != nil{
                let json = JSON(response.data!)
                let routes = json["routes"].arrayValue
                
                // print route using Polyline
                for route in routes
                {
                    let routeOverviewPolyline = route["overview_polyline"].dictionary
                    let points = routeOverviewPolyline?["points"]?.stringValue
                    let path = GMSPath.init(fromEncodedPath: points!)
                    let polyline = GMSPolyline.init(path: path)
                    polyline.strokeWidth = 6
                    polyline.strokeColor = UIColor(red: 93/255, green: 75/255, blue: 153/255, alpha: 1)
                    polyline.map = self.googleMapsView
                }
                let camera = GMSCameraPosition.camera(withLatitude: (self.locationManager.location?.coordinate.latitude)!, longitude: (self.locationManager.location?.coordinate.longitude)!, zoom: 12.0)
                self.googleMapsView.camera = camera
            }
        }
    }
    
    func initialMapView(){
        
        self.googleMapsView = GMSMapView(frame: self.view.bounds)
        self.googleMapsView?.isMyLocationEnabled = true
        let camera = GMSCameraPosition.camera(withLatitude: latitude, longitude: longitude, zoom: 17.0)
        self.googleMapsView.camera = camera
        self.view.addSubview(self.googleMapsView)
        googleMapsView.addSubview(hintLable)
        
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2DMake(latitude, longitude)
        marker.title = dic!["name"] as? String
        
        
        marker.snippet = dic!["formatted_address"] as? String
        marker.map = self.googleMapsView
    }
    
    func getPlacePhoto() {
        // Specify the place data types to return (in this case, just photos).
        let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt(GMSPlaceField.photos.rawValue))!
        
        if(placeId != "1"){
            placesClient?.fetchPlace(fromPlaceID: placeId,
                                     placeFields: fields,
                                     sessionToken: nil, callback: {
                                        (place: GMSPlace?, error: Error?) in
                                        if let error = error {
                                            print("An error occurred: \(error.localizedDescription)")
                                            return
                                        }
                                        if let place = place {
                                            // Get the metadata for the first photo in the place photo metadata list.
                                            if place.photos == nil {
                                                DispatchQueue.main.async {
                                                    self.initialMapView()
                                                }
                                            }
                                                
                                            else{
                                                let photoMetadata: GMSPlacePhotoMetadata = place.photos![0]
                                                
                                                // Call loadPlacePhoto to display the bitmap and attribution.
                                                self.placesClient?.loadPlacePhoto(photoMetadata, callback: { (photo, error) -> Void in
                                                    if let error = error {
                                                        // TODO: Handle the error.
                                                        print("Error loading photo metadata: \(error.localizedDescription)")
                                                        return
                                                    } else {
                                                        // Display the first image and its attributions.
                                                        //self.imageView.isHidden = false
                                                        self.placeImage = photo!
                                                        
                                                        DispatchQueue.main.async {
                                                            self.initialMapView()
                                                        }
                                                    }
                                                })
                                            }
                                        }
            })
            
        }
        else{
            self.initialMapView()
        }
    }
    
    func getPlaceId(location:String){
        let queue = DispatchQueue(label: "com.cnoon.response-queue", qos: .background, attributes: .concurrent)
        
        Alamofire.request("https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(location)&radius=1&key=AIzaSyBQJdd3kF5mxAYLk_e2kzMXY6stXJie_TA").responseJSON(queue: queue, options: .allowFragments) {
            response in
            
            let responseStr = response.result.value
            if responseStr != nil {
                let jsonResponse = JSON(responseStr!)
                let jsonResult = jsonResponse["results"]
                
                for i in jsonResult.array!{
                    if i["name"].stringValue == self.locationName {
                        let placeId = i["place_id"].stringValue
                        //print(placeId)
                        self.placeId = placeId
                    }
                }
                DispatchQueue.main.async {
                    self.getPlacePhoto()
                }
            }
        }
        
    }
    
    func drawline(suburbName: String){
        // Json find suburb: suburb
        // -> dic
    }
    
    @IBAction func showPhoto(_ sender: Any) {
        drawPath()
        // Prepare the popup assets
//        let title = dic!["name"] as? String
//
//        let message = dic!["formatted_address"] as? String
//        let image = placeImage
//
//        // Create the dialog
//        let popup = PopupDialog(title: title, message: message, image: image, preferredWidth: 580)
//
//        // Create first button
//        let buttonOne = DefaultButton(title: "OK") {
//            print("1")
//        }
//
//        // This button will not the dismiss the dialog
//        let buttonTwo = CancelButton(title: "CANCEL") {
//            return
//        }
//
//        // Add buttons to dialog
//        popup.addButtons([buttonOne, buttonTwo])
//
//        // Present dialog
//        self.present(popup, animated: true, completion: nil)
        
        //        let view1 = UIImageView()
        //        view1.frame = CGRect(x: 60, y: 70, width: 250, height: 250)
        //        view1.image = placeImage
        //        self.view.addSubview(view1)
    }
    
}
