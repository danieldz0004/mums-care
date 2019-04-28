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
import FirebaseDatabase
import CoreLocation
import PopupWindow

class MapViewController: UIViewController,MKMapViewDelegate {

    var dic:[String:Any]?
    
    @IBOutlet weak var map: MKMapView!
    var googleMapsView: GMSMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialMapView()
        
//        let geometry:[String:Any] = dic!["geometry"] as! [String : Any]
//        let locationdic:[String:Any] = geometry["location"] as! [String : Any]
//
//
//        let latitude = (locationdic["lat"] as! NSNumber).doubleValue
//        let longitude = (locationdic["lng"] as! NSNumber).doubleValue
//        let latDelta: CLLocationDegrees = 0.002
//        let lonDelta: CLLocationDegrees = 0.002
//        let span = MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: lonDelta)
//        let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
//        let region = MKCoordinateRegion(center: location, span: span)
//        self.map.setRegion(region, animated: true)
//
//
//        let objectAnnotation = MKPointAnnotation()
//        objectAnnotation.coordinate = location
//        objectAnnotation.title = dic!["name"] as? String
//        objectAnnotation.subtitle = dic!["formatted_address"] as? String
//        map.addAnnotation(objectAnnotation)
    }
    
    func initialMapView(){
        
        let geometry:[String:Any] = dic!["geometry"] as! [String : Any]
        let locationdic:[String:Any] = geometry["location"] as! [String : Any]
        let latitude = (locationdic["lat"] as! NSNumber).doubleValue
        let longitude = (locationdic["lng"] as! NSNumber).doubleValue
        
        self.googleMapsView = GMSMapView(frame: self.view.bounds)
        self.googleMapsView?.isMyLocationEnabled = true
        let camera = GMSCameraPosition.camera(withLatitude: latitude, longitude: longitude, zoom: 17.0)
        self.googleMapsView.camera = camera
        self.view.addSubview(self.googleMapsView)
        
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2DMake(latitude, longitude)
        marker.title = dic!["name"] as? String
        marker.snippet = dic!["formatted_address"] as? String
        marker.map = self.googleMapsView
    }

}
