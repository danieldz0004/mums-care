//
//  NewfourthViewController.swift
//  Week9Tutorial
//
//  Created by Daniel Dz on 2019/4/24.
//  Copyright © 2019 Jason Haasz. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import Charts

class NewfourthViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var tableview: UITableView!
    var ref: DatabaseReference?
    var tableViewDataDArray:[[String:Any]] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableview.delegate = self
        self.tableview.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let alertvc = UIAlertController.init(title: "Please Entre your Postcode", message: nil, preferredStyle: .alert)
        let alertAction0 = UIAlertAction.init(title: "Confirm", style: .default) { (action) in
            //push
            
//            self.placeid(["-37.80968063155256,144.98339868157058","-37.81676535064923,144.97867159232348"])
            self.searchLoaction(alertvc.textFields![0].text!)
            
        }
        let alertAction1 = UIAlertAction.init(title: "Cancel", style: .cancel) { (action) in
            //no code
        }
        alertvc.addAction(alertAction0)
        alertvc.addAction(alertAction1)
        alertvc.addTextField(configurationHandler: nil)
        self.present(alertvc, animated: true, completion: nil)
    }
    
    func placeid(_ loactions:[String]) {
        var placeidArray:[String] = []
        
        let workingGroup = DispatchGroup()
        let workingQueue = DispatchQueue(label: "requestPlaceid_queue")
        
        for loaction:String in loactions {
            workingGroup.enter()
            workingQueue.async {
                let url = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(loaction)&radius=1500&type=restaurant&keyword=cruise&key=AIzaSyBQJdd3kF5mxAYLk_e2kzMXY6stXJie_TA"
                HttpServerManager().getServerData(url) { (data) in
                    let dataArray:[[String:Any]] = data["results"] as! [[String : Any]]
                    for dic:[String:Any] in dataArray {
                        placeidArray.append(dic["place_id"]! as! String)
                    }
                    print(placeidArray)
                    workingGroup.leave()
                }
            }
        }
        workingGroup.notify(queue: workingQueue) {
            self.getRatings(placeidArray)
        }
//        let url = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(location)&radius=1500&type=restaurant&keyword=cruise&key=AIzaSyBQJdd3kF5mxAYLk_e2kzMXY6stXJie_TA"
//        HttpServerManager().getServerData(url) { (data) in
//            let dataArray:[[String:Any]] = data["results"] as! [[String : Any]]
//            for dic:[String:Any] in dataArray {
//                placeidArray.append(dic["place_id"]! as! String)
//            }
//            self.getRatings(placeidArray)
//        }
    }
    
    //通线程组同时进行多个网络请求
    func getRatings(_ placeidArray:[String]) {
        
        let workingGroup = DispatchGroup()
        let workingQueue = DispatchQueue(label: "request_queue")
        
        weak var weakself = self
        for placeid:String in placeidArray {
            workingGroup.enter()
            workingQueue.async {
                let url = "https://maps.googleapis.com/maps/api/place/details/json?placeid=\(placeid)&key=AIzaSyBQJdd3kF5mxAYLk_e2kzMXY6stXJie_TA"
                HttpServerManager().getServerData(url) { (data) in
                    let dic:[String:Any] = data["result"] as! [String : Any]
                    weakself?.tableViewDataDArray.append(dic)
                    workingGroup.leave()
                }
            }
        }
        workingGroup.notify(queue: workingQueue) {
            weakself?.bubble_SortArr(array: &weakself!.tableViewDataDArray)
        }
    }
    
    //排序
    func bubble_SortArr(array :inout[[String:Any]]) {
        
        for i in 0..<array.count - 1{
            for j in 0..<array.count - i - 1{
                
                let dic:[String:Any] = array[j]
                let rating:Float = (dic["rating"] as! NSNumber).floatValue
                
                let dic1:[String:Any] = array[j+1]
                let rating1:Float = (dic1["rating"] as! NSNumber).floatValue
                
                if rating > rating1{
                    array.swapAt(j, j+1)
                }
            }
        }
        weak var weakself = self
        DispatchQueue.main.async {
            let vc:RatingListViewController = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RatingList") as! RatingListViewController
            vc.dataArray = weakself?.tableViewDataDArray
            weakself?.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
//    func getData() {
//        Auth.auth().signIn(withEmail: "localhost@theshield.com", password: "4theshield.com")
//        ref = Database.database().reference()
//        ref?.child("Coverage").observeSingleEvent(of: .value, with: { (snapshot) in
//            let value = snapshot.value as? [String:[Double]]
//            let dic:NSDictionary = value! as NSDictionary
//
//            print(dic)
//            NSLog("%@", dic)
//            print(value!)
//        }) { (error) in
//            print(error.localizedDescription)
//        }
//    }
    
    func searchLoaction(_ postCode:String) {
        var locationArray:[String] = []
        
        for dic:[String:Any] in self.json() {
            if "\(dic["postcode"]!)" == postCode {
                locationArray.append("\(String(describing: dic["lat"]!)),\(String(describing: dic["long"]!))")
            }
        }
        self.placeid(locationArray)
    }
    
    func json() -> [[String:Any]] {
        return [[
            "address" : "23,CLARENDONSTREET,EAST MELBOURNE",
            "lat" : -37.80968063155256,
            "long" : 144.98339868157058,
            "name" : "East Melbourne Specialist Day Hospital",
            "postcode" : 3002
            ], [
                "address" : "17,WINDSORAVENUE,GREATER DANDENONG",
                "lat" : -37.951399999673185,
                "long" : 145.1493000009933,
                "name" : "Windsor Avenue Day Surgery",
                "postcode" : 3171
            ], [
                "address" : "3,GIBBSTREET,BERWICK",
                "lat" : -38.03458048694108,
                "long" : 145.34465270350745,
                "name" : "Hyperbaric Health Wound Centre Berwick",
                "postcode" : 3806
            ], [
                "address" : "1117-1123,HOWITTSTREET,BALLARAT",
                "lat" : -37.54055255892396,
                "long" : 143.83228608782127,
                "name" : "Ballarat Day Procedure Centre",
                "postcode" : 3355
            ], [
                "address" : "141,CRANBOURNEROAD,FRANKSTON",
                "lat" : -38.148188631165404,
                "long" : 145.1433792563343,
                "name" : "Bayside Day Procedure and Specialist Centre",
                "postcode" : 3199
            ] ]
    }

}
