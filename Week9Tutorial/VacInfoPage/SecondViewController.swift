//
//  SecondViewController.swift
//  mom's care
//
//  Created by Daniel Dz on 4/4/19.
//  Copyright © 2019 Daniel Dz. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBAction func infoButton(_ sender: Any) {
    }
    @IBOutlet weak var agePicker: UIPickerView!
    @IBOutlet weak var regionPicker: UIPickerView!
    
    @IBOutlet weak var infoButton: UIButton!
    var agePickerData: [String] = [String]()
    var regionPickerData: [String] = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        infoButton.layer.cornerRadius = 4
        
        regionPickerData = ["China", "India"]
        
        agePickerData = ["0-2","2-4","4-6", "6-12"]
        
        self.agePicker.dataSource = self
        self.regionPicker.dataSource = self
        self.agePicker.delegate = self
        self.regionPicker.delegate = self
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Number of columns of data
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // The number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == agePicker{
            return agePickerData.count
        }
        else{
            return regionPickerData.count
        }
    }
    
    // The data to return fopr the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == agePicker{
            return agePickerData[row]
        }
        else{
            return regionPickerData[row]
        }
    }
    
//    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
//        if pickerView == agePicker{
//            let attributedString = NSAttributedString(string: agePickerData[row], attributes: [NSAttributedStringKey.foregroundColor : UIColor.white])
//            return attributedString
//        }
//        else{
//            let attributedString = NSAttributedString(string: regionPickerData[row], attributes: [NSAttributedStringKey.foregroundColor : UIColor.white])
//            return attributedString
//        }
//
//    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "showVacInfo") {
            //Checking identifier is crucial as there might be multiple
            // segues attached to same view
            let vacVC = segue.destination as! TestViewController;
            let selectedAgePicker = agePickerData[agePicker.selectedRow(inComponent: 0)]
            let selectedRegionPicker = regionPickerData[regionPicker.selectedRow(inComponent: 0)]
            vacVC.selection = selectedRegionPicker + selectedAgePicker
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
