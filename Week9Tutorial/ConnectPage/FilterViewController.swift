//
//  FilterViewController.swift
//  Week9Tutorial
//
//  Created by Ziyi Deng on 10/5/19.
//  Copyright © 2019 Jason Haasz. All rights reserved.
//

import UIKit
import PopupDialog
import ZKCarousel

class FilterViewController: UIViewController {

    @IBOutlet weak var englishField: UITextField!
    @IBOutlet weak var languageField: UITextField!
    @IBOutlet var carousel: ZKCarousel! = ZKCarousel()
    var populationArray: [String] = []
    var languageArray: [String] = []
    var englishArray: [String] = []
    var intersection: Set<String> = []
    var suburbArray: [String] = []
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }
    
    private func setupCarousel() {
        
        // Create as many slides as you'd like to show in the carousel
        let slide = ZKCarouselSlide(image: #imageLiteral(resourceName: "connect1"), title: "",  description: "Connecting to the same culturally rich community can imbibe the cultural values in your kids and keep them related to their own culture")
        let slide1 = ZKCarouselSlide(image: #imageLiteral(resourceName: "connect2"), title: "", description: "Reconnecting to your culture can enrich your sense of self-identity and overall wellbeing")
        let slide2 = ZKCarouselSlide(image: #imageLiteral(resourceName: "connect3"), title: "", description: "Learning from the experiences to relate more effectively across cultural lines can boost your self-confidence to socialize with other cultures")
        
        
        // Add the slides to the carousel
        self.carousel.slides = [slide, slide1, slide2]
        
        
        // You can optionally use the 'interval' property to set the timing for automatic slide changes. The default is 1 second.
        self.carousel.interval = 8
        
        // Optional - automatic switching between slides.
        self.carousel.start()
    }
    
    @IBAction func submitButton(_ sender: Any) {
        populationArray.removeAll()
        englishArray.removeAll()
        languageArray.removeAll()
        suburbArray.removeAll()
        intersection.removeAll()
        
        if populationField.text != "" || englishField.text != "" || languageField.text != ""{
            switch populationField.text {
            case "More":
                for dic:[String:Any] in self.getJson("Population") {
                    if (dic["Population"]!) as! Double >= 3.0 {
                        self.populationArray.append(dic["Name"] as! String)
                    }
                }
                //print(self.populationArray)
            case "Less":
                for dic:[String:Any] in self.getJson("Population") {
                    if ((dic["Population"]!) as! Double) < 3.0 {
                        self.populationArray.append(dic["Name"] as! String)
                    }
                }
                //print(self.populationArray)
                
            default:
                print("Some other character")
            }
            
            switch languageField.text {
            case "Mandarin":
                let array = findTopThree(jsonName: "Language", attribute: "Mandarin")
                for dic:[String:Any] in self.getJson("Language"){
                    for i in array{
                        if dic["Mandarin"]! as! Double == i{
                            languageArray.append(dic["Name"] as! String)
                        }
                    }
                }
                //print(self.languageArray)
                
            case "Cantonese":
                let array = findTopThree(jsonName: "Language", attribute: "Cantonese")
                for dic:[String:Any] in self.getJson("Language"){
                    for i in array{
                        if dic["Cantonese"]! as! Double == i{
                            languageArray.append(dic["Name"] as! String)
                        }
                    }
                }
                //print(self.languageArray)
            case "Other Chinese language":
                let array = findTopThree(jsonName: "Language", attribute: "Chinese nfd")
                for dic:[String:Any] in self.getJson("Language"){
                    for i in array{
                        if dic["Chinese nfd"]! as! Double == i{
                            languageArray.append(dic["Name"] as! String)
                        }
                    }
                }
                //print(self.languageArray)
            case "English Only":
                let array = findTopThree(jsonName: "Language", attribute: "English only")
                for dic:[String:Any] in self.getJson("Language"){
                    for i in array{
                        if dic["English only"]! as! Double == i{
                            languageArray.append(dic["Name"] as! String)
                        }
                    }
                }
                //print(self.languageArray)
                
            default:
                print("Some other character")
            }
            
            switch englishField.text {
            case "Excellent":
                let array = findTopThree(jsonName: "Proficiency", attribute: "Very well")
                for dic:[String:Any] in self.getJson("Proficiency"){
                    for i in array{
                        if dic["Very well"]! as! Double == i{
                            englishArray.append(dic["Name"] as! String)
                        }
                    }
                }
                //print(self.englishArray)
                
            case "Good":
                let array = findTopThree(jsonName: "Proficiency", attribute: "Well")
                for dic:[String:Any] in self.getJson("Proficiency"){
                    for i in array{
                        if dic["Well"]! as! Double == i{
                            englishArray.append(dic["Name"] as! String)
                        }
                    }
                }
                //print(self.englishArray)
                
            case "Average":
                let array = findTopThree(jsonName: "Proficiency", attribute: "Not well")
                for dic:[String:Any] in self.getJson("Proficiency"){
                    for i in array{
                        if dic["Not well"]! as! Double == i{
                            englishArray.append(dic["Name"] as! String)
                        }
                    }
                }
                //print(self.englishArray)
                
            case "Poor":
                
                let array = findTopThree(jsonName: "Proficiency", attribute: "Not at all")
                for dic:[String:Any] in self.getJson("Proficiency"){
                    for i in array{
                        if dic["Not at all"]! as! Double == i{
                            englishArray.append(dic["Name"] as! String)
                        }
                    }
                }
                //print(self.englishArray)
                
            default:
                print("Some other character")
            }
            
            self.intersection = findIntersection()
            
            if (self.intersection.count == 0){
                let alert = UIAlertController(title: "Sorry", message: "There is no result, please try other selections", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
                    NSLog("The \"OK\" alert occured.")
                }))
                self.present(alert, animated: true, completion: nil)
            }
            else{
                
                for dic:[String:Any] in self.getJson("Suburb"){
                    for i in intersection{
                        if (dic["Name"]!) as! String == i {
                            self.suburbArray.append(dic["Suburbs"] as! String)
                        }
                    }
                    
                }
                
                self.performSegue(withIdentifier: "connectResult", sender: self)
            }
        }
        else{
            let alert = UIAlertController(title: "Sorry", message: "You must select at least one option", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
                NSLog("The \"OK\" alert occured.")
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBOutlet weak var populationField: UITextField!
    
    func findTopThree(jsonName:String, attribute:String) -> [Double]{
        var tempArray:[Double] = []
        for dic:[String:Any] in self.getJson(jsonName) {
            tempArray.append(dic[attribute]! as! Double)
        }
        tempArray.sort()
        return [tempArray.popLast()!,tempArray.popLast()!,tempArray.popLast()!,tempArray.popLast()!,tempArray.popLast()!]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Setup
        self.setupCarousel()
        
        populationField.addTarget(self, action: #selector(myTargetFunction), for: .touchDown)
        languageField.addTarget(self, action: #selector(selectLanguageFunction), for: .touchDown)
        englishField.addTarget(self, action: #selector(selectEnglishFunction), for: .touchDown)
        
        // Do any additional setup after loading the view.
    }
    
    @objc func selectLanguageFunction(textField: UITextField) {
        let title = "Langugage"
        
        let message = "Find a suburb where Chinese people speaks:"
        
        let image = UIImage.init(named: "home1")
        
        // Create the dialog
        let popup = PopupDialog(title: title, message: message, image: image, preferredWidth: 580)
        
        // Create first button
        let buttonOne = DefaultButton(title: "Mandarin") {
            self.languageField.text = "Mandarin"
        }
        
        let buttonTwo = DefaultButton(title: "Cantonese") {
            self.languageField.text = "Cantonese"
        }
        
        let buttonThree = DefaultButton(title: "Other Chinese language") {
            self.languageField.text = "Other Chinese language"
        }
        
        let buttonFour = DefaultButton(title: "English Only") {
            self.languageField.text = "English Only"
        }
        
        let buttonFive = CancelButton(title: "Cancel") {
            self.languageField.placeholder = "Tap to Select"
        }
        
        // Add buttons to dialog
        popup.addButtons([buttonOne, buttonTwo, buttonThree, buttonFour, buttonFive])
        
        // Present dialog
        self.present(popup, animated: true, completion: nil)
    }
    
    @objc func selectEnglishFunction(textField: UITextField) {
        let title = "English Proficiency"
        
        let message = "Find the suburb where the Chinese people's proficiency is:"
        
        let image = UIImage.init(named: "home1")
        
        // Create the dialog
        let popup = PopupDialog(title: title, message: message, image: image, preferredWidth: 580)
        
        // Create first button
        let buttonOne = DefaultButton(title: "Excellent") {
            self.englishField.text = "Excellent"
        }
        
        let buttonTwo = DefaultButton(title: "Good") {
            self.englishField.text = "Good"
        }
        
        let buttonThree = DefaultButton(title: "Average") {
            self.englishField.text = "Average"
        }
        
        let buttonFour = DefaultButton(title: "Poor") {
            self.englishField.text = "Poor"
        }
        
        let buttonFive = CancelButton(title: "Cancel") {
            self.englishField.placeholder = "Tap to Select"
        }
        
        // Add buttons to dialog
        popup.addButtons([buttonOne, buttonTwo, buttonThree, buttonFour, buttonFive])
        
        // Present dialog
        self.present(popup, animated: true, completion: nil)
    }
    
    @objc func myTargetFunction(textField: UITextField) {
        let title = "Chinese Population"
        
        let message = "Find a suburb where the number of Chinese people is:"
        
        let image = UIImage.init(named: "home1")
        
        // Create the dialog
        let popup = PopupDialog(title: title, message: message, image: image, preferredWidth: 580)
        
        // Create first button
        let buttonOne = DefaultButton(title: "More") {
            self.populationField.text = "More"
        }
        
        let buttonTwo = DefaultButton(title: "Less") {
            self.populationField.text = "Less"
        }
        
        
        let buttonFour = CancelButton(title: "Cancel") {
            self.populationField.placeholder = "Tap to Select"
        }
        
        // Add buttons to dialog
        popup.addButtons([buttonOne, buttonTwo, buttonFour])
        
        // Present dialog
        self.present(popup, animated: true, completion: nil)
    }
    
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

    func findIntersection() -> Set<String> {
        let set1:Set<String> = Set(populationArray)
        let set2:Set<String> = Set(englishArray)
        let set3:Set<String> = Set(languageArray)
        
        if populationArray.count != 0 && englishArray.count != 0 && languageArray.count != 0{
            return set1.intersection(set2).intersection(set3)
        }
        else if populationArray.count != 0 && englishArray.count != 0 && languageArray.count == 0{
            return set1.intersection(set2)
        }
        else if populationArray.count != 0 && englishArray.count == 0 && languageArray.count != 0{
            return set1.intersection(set3)
        }
        else if populationArray.count == 0 && englishArray.count != 0 && languageArray.count != 0{
            return set2.intersection(set3)
        }
        else if populationArray.count != 0 && englishArray.count == 0 && languageArray.count == 0{
            return set1
        }
        else if populationArray.count == 0 && englishArray.count != 0 && languageArray.count == 0{
            return set2
        }
        else {
            return set3
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "connectResult") {
            //Checking identifier is crucial as there might be multiple
            // segues attached to same view
            let cmapVC = segue.destination as! ConnectMapViewController;
            cmapVC.resultArray = suburbArray
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
