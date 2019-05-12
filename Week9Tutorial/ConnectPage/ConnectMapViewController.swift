//
//  ConnectMapViewController.swift
//  Week9Tutorial
//
//  Created by Ziyi Deng on 11/5/19.
//  Copyright © 2019 Jason Haasz. All rights reserved.
//

import UIKit
import MapKit
import GoogleMaps
import GooglePlaces
import Firebase
import FirebaseDatabase
import CoreLocation
import Alamofire
import SwiftyJSON
import PopupDialog

class ConnectMapViewController: UIViewController,MKMapViewDelegate {
    
    var googleMapsView: GMSMapView!
    var resultArray: [String] = []
    var transferArray:[String] = []
    var latArray:[Double] = []
    var longArray:[Double] = []
    let shapeLayer = CAShapeLayer()
    let percentageLabel: UILabel = {
        let label = UILabel()
        label.text = "Loading..."
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 32)
        return label
    }()
    
    var progressHUD:ProgressHUD?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initialMapView()
//        self.googleMapsView.addSubview(self.percentageLabel)
//        self.percentageLabel.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
//        self.percentageLabel.center = self.view.center
//        let trackLayer = CAShapeLayer()
//
//        let circularPath = UIBezierPath(arcCenter: .zero, radius: 100, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
//        trackLayer.path = circularPath.cgPath
//
//        trackLayer.strokeColor = UIColor.lightGray.cgColor
//        trackLayer.lineWidth = 10
//        trackLayer.fillColor = UIColor.clear.cgColor
//        trackLayer.lineCap = CAShapeLayerLineCap.round
//        trackLayer.position = self.view.center
//
//        self.googleMapsView.layer.addSublayer(trackLayer)
//
//        self.shapeLayer.path = circularPath.cgPath
//
//        self.shapeLayer.strokeColor = UIColor.red.cgColor
//        self.shapeLayer.lineWidth = 10
//        self.shapeLayer.fillColor = UIColor.clear.cgColor
//        self.shapeLayer.lineCap = CAShapeLayerLineCap.round
//        self.shapeLayer.position = self.view.center
//
//        self.shapeLayer.transform = CATransform3DMakeRotation(-CGFloat.pi / 2, 0, 0, 1)
//
//        self.shapeLayer.strokeEnd = 0
//
//        self.googleMapsView.layer.addSublayer(self.shapeLayer)
        
        self.beginDownloadingFile()
        
    }
    
    let urlString = ""
    
    private func beginDownloadingFile(){
        findSuburb()
    }
    
    func findSuburb(){
        for i in resultArray{
            let temp = i.split(separator: ",")
            transferArray.append(String(temp[0]).trimmingCharacters(in: .whitespacesAndNewlines))
            transferArray.append(String(temp[1]).trimmingCharacters(in: .whitespacesAndNewlines))
            transferArray.append(String(temp[2]).trimmingCharacters(in: .whitespacesAndNewlines))
        }
        drawLine()
    }
    
    func getJson(_ jsonName:String) ->[[String:Any]] {
        let path = Bundle.main.path(forResource: jsonName, ofType: "json")
        let url = URL(fileURLWithPath: path!)
        do {
            let data = try Data(contentsOf: url)
            let jsonData:Any = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)
            let jsonDic = jsonData as! Dictionary<String, AnyObject>
            let jsonArray = jsonDic["features"] as! [[String:Any]]
            return jsonArray
        } catch let error as Error? {
            print("An Error Occur",error as Any)
        }
        return [[:]]
    }
    
    func findBoundary(suburb:String){
        var temp:NSArray = []
        for dic:[String:Any] in self.getJson("Boundary") {
            let proper = dic["properties"] as! [String:Any]
            if (proper["VIC_LOCA_2"] as! String == suburb.uppercased()){
                let geo = dic["geometry"] as! [String:Any]
                temp = geo["coordinates"] as! NSArray
            }
        }
        let i = temp[0] as! NSArray
        for j in i{
            let temp = j as! NSArray
            latArray.append(temp[1] as! Double)
            longArray.append(temp[0] as! Double)
        }
        print(latArray.count)
        print(longArray.count)
    }
    
    func initialMapView(){
        self.googleMapsView = GMSMapView(frame: self.view.bounds)
        self.googleMapsView?.isMyLocationEnabled = true
        let camera = GMSCameraPosition.camera(withLatitude: -37.877632, longitude: 145.044684, zoom: 11.0)
        //let camera = GMSCameraPosition.camera(withLatitude: 37.36, longitude: -122.0, zoom: 17.0)
        self.googleMapsView.camera = camera
        self.view.addSubview(self.googleMapsView)
    }
    
    func drawLine(){
        shapeLayer.strokeEnd = 0
        self.progressHUD = ProgressHUD().show()
        DispatchQueue.main.async {
            for i in 0...self.transferArray.count - 1{
                self.latArray.removeAll()
                self.longArray.removeAll()
                self.findBoundary(suburb: self.transferArray[i])
                if self.latArray.count != 0
            {
                let rec = GMSMutablePath()
                for j in 0...self.latArray.count - 1{
                    rec.add(CLLocationCoordinate2D(latitude: self.latArray[j], longitude: self.longArray[j]))
                }
                let polygon = GMSPolygon(path: rec)
                polygon.fillColor = .lightGray
                polygon.strokeColor = .blue
                polygon.strokeWidth = 5
                polygon.map = self.googleMapsView
                
                let percentage = CGFloat(i)/CGFloat(self.transferArray.count)
                
                DispatchQueue.main.async {
                    self.percentageLabel.text = "\(Int(percentage * 100))%"
                    self.shapeLayer.strokeEnd = percentage
                }
                
                print(percentage)
                print("done")
                print(self.transferArray[i])
             }
            }
            self.progressHUD?.removeFromSuperview()
         }
        
        }
    
    
}

