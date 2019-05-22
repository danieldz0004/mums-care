//
//  ThirdViewController.swift
//  mom's care
//
//  Created by Daniel Dz on 4/4/19.
//  Localized by Siyu Zhang
//  Copyright © 2019 Daniel Dz. All rights reserved.
//

import UIKit
import PopupDialog

class ThirdViewController: UIViewController,UITextFieldDelegate  {
    
    @IBOutlet weak var InfoButton: UIButton!
    
    @IBAction func covInfoBtn(_ sender: Any) {
        let a:Int? = Int(postCodeField.text ?? "0")
        if a != nil{
            if a! >= 3000 && a! <= 4000 {
                let result = findPostcode(postcode: a!)
                if result.count != 2
                {
                    let alert = UIAlertController(title: NSLocalizedString("Sorry", comment: ""), message: NSLocalizedString("No matches\nPlease enter another postcode", comment: ""), preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
                        NSLog("The \"OK\" alert occured.")
                    }))
                    self.present(alert, animated: true, completion: nil)
                }
                else
                {
                    if result[0] == "Good"
                    {
                        let dialogAppearance = PopupDialogDefaultView.appearance()
                        dialogAppearance.titleFont = .systemFont(ofSize: 30)
                        dialogAppearance.titleColor = UIColor(red: 204/255, green: 204/255, blue: 0, alpha: 1)
                        let title = NSLocalizedString("\(result[0]) - \(result[1])%", comment: "")
                        
                        // Create the dialog
                        let popup = PopupDialog(title: title, message: nil, image: nil, preferredWidth: 580)
                        
                        // Create first button
                        let buttonOne = DefaultButton(title: NSLocalizedString("OK", comment: "")) {
                            return
                        }
                        // Add buttons to dialog
                        popup.addButtons([buttonOne])
                        // Present dialog
                        self.present(popup, animated: true, completion: nil)
                        
                    }
                    else if result[0] == "Excellent"{
                        let dialogAppearance = PopupDialogDefaultView.appearance()
                        dialogAppearance.titleFont = .systemFont(ofSize: 30)
                        dialogAppearance.titleColor = .green
                        let title = NSLocalizedString("\(result[0]) - \(result[1])%", comment: "")
                        
                        // Create the dialog
                        let popup = PopupDialog(title: title, message: nil, image: nil, preferredWidth: 580)
                        
                        // Create first button
                        let buttonOne = DefaultButton(title: NSLocalizedString("OK", comment: "")) {
                            return
                        }
                        // Add buttons to dialog
                        popup.addButtons([buttonOne])
                        // Present dialog
                        self.present(popup, animated: true, completion: nil)
                    }
                    else if result[0] == "Poor"{
                        let dialogAppearance = PopupDialogDefaultView.appearance()
                        dialogAppearance.titleFont = .systemFont(ofSize: 30)
                        dialogAppearance.titleColor = .red
                        let title = NSLocalizedString("\(result[0]) - \(result[1])%", comment: "")
                        
                        // Create the dialog
                        let popup = PopupDialog(title: title, message: nil, image: nil, preferredWidth: 580)
                        
                        // Create first button
                        let buttonOne = DefaultButton(title: NSLocalizedString("OK", comment: "")) {
                            return
                        }
                        // Add buttons to dialog
                        popup.addButtons([buttonOne])
                        // Present dialog
                        self.present(popup, animated: true, completion: nil)
                        
                    }
                    else if result[0] == "Average"{
                        let dialogAppearance = PopupDialogDefaultView.appearance()
                        dialogAppearance.titleFont = .systemFont(ofSize: 30)
                        dialogAppearance.titleColor = .orange
                        let title = NSLocalizedString("\(result[0]) - \(result[1])%", comment: "")
                        
                        // Create the dialog
                        let popup = PopupDialog(title: title, message: nil, image: nil, preferredWidth: 580)
                        
                        // Create first button
                        let buttonOne = DefaultButton(title: NSLocalizedString("OK", comment: "")) {
                            return
                        }
                        // Add buttons to dialog
                        popup.addButtons([buttonOne])
                        // Present dialog
                        self.present(popup, animated: true, completion: nil)
                    }
                    else
                    {
                        let alert = UIAlertController(title: NSLocalizedString("Sorry", comment: ""), message: NSLocalizedString("No matches\nPlease enter another postcode", comment: ""), preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
                            NSLog("The \"OK\" alert occured.")
                        }))
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            }
            else
            {
                let alert = UIAlertController(title: NSLocalizedString("Postcode is Incorrect", comment: ""), message: NSLocalizedString("Please input postcode range from 3000 to 3999", comment: ""), preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
                    NSLog("The \"OK\" alert occured.")
                }))
                self.present(alert, animated: true, completion: nil)
            }
        }
        else
        {
            let alert = UIAlertController(title: NSLocalizedString("Sorry", comment: ""), message: NSLocalizedString("The Postcode is Incorrect", comment: ""), preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
                NSLog("The \"OK\" alert occured.")
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBOutlet weak var postCodeField: UITextField!
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLength = 4
        let currentString: NSString = textField.text! as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= maxLength
    }
    
    func findPostcode(postcode:Int) -> [String] {
        for dic:[String:Any] in self.getJson("vaccination_coverage_victoria_final_version") {
            if dic["Postcode"] as! Int == postcode
            {
                return [dic["Immunization status"] as! String, dic["2016-17"] as! String]
            }
        }
        return []
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        postCodeField.delegate = self
        
        self.hideKeyboardWhenTappedAround()
        
        
        InfoButton.layer.cornerRadius = 4
        
        view.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "background"))
        //        self.percentageLabel.text = ""
        
        
        
        postCodeField.layer.masksToBounds = true
        postCodeField.layer.cornerRadius = 12.0
        postCodeField.layer.borderWidth = 2.0
        postCodeField.layer.borderColor = UIColor.blue.cgColor
        postCodeField.placeholder = NSLocalizedString("Please Enter Your Postcode", comment: "")
        postCodeField.clearButtonMode = .whileEditing
        
        // Do any additional setup after loading the view.
    }
    
    
    //    func setChart(dataPoints: [String], values: [Double]) {
    //        var dataEntries: [BarChartDataEntry] = []
    //
    //        for i in 0..<dataPoints.count {
    //            let dataEntry = BarChartDataEntry(x: Double(i), y: Double(values[i]))
    //            dataEntries.append(dataEntry)
    //        }
    //
    //        let chartDataSet = BarChartDataSet(values: dataEntries, label: "Percent full immunised (%)")
    //        let chartData = BarChartData(dataSet: chartDataSet)
    //        barChartView.data = chartData
    //    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    func getJson(_ jsonName:String) ->[[String:Any]] {
        let path = Bundle.main.path(forResource: jsonName, ofType: "json")
        let url = URL(fileURLWithPath: path!)
        do {
            let data = try Data(contentsOf: url)
            let jsonData:Any = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)
            let jsonArr = jsonData as! [[String:Any]]
            return jsonArr
        } catch let error as Error? {
            print("An Error Occur",error as Any)
        }
        return [[:]]
    }
    
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
