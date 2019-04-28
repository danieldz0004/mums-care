//
//  ViewController.swift
//  MonthProject
//
//  Created by Daniel Dz 24 on 2019/4/23.
//  Copyright © 2019 Daniel Dz 24. All rights reserved.
//

import UIKit

class SixthViewController: UIViewController {
    
    


    @IBOutlet weak var mainTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configBaseView()
    }
    
    var dataArray = [
        ["title":"0-6","open":"0","detail":[
            ["title":"Liquids","open":"0","detail":[
                ["title":"Breastmilk","type":"0","image":"1"],
                ["title":"Infant formula","type":"0","image":"2"]]]]],
        ["title":"6-7","open":"0","detail":[
            ["title":"Finely mashed or pureed foods","open":"0","detail":[
                ["title":"Breastmilk","type":"0","image":"3"],
                ["title":"Infant formula","type":"0","image":"4"],
                ["title":"Infant cereals","type":"0","image":"5"],
                ["title":"Smooth mashed pumpkin","type":"0","image":"6"],
                ["title":"Smooth mashed potato","type":"0","image":"7"],
                ["title":"Smooth mashed zucchini","type":"0","image":"8"],
                ["title":"Smooth cooked apple","type":"0","image":"9"],
                ["title":"Smooth mashed pear","type":"0","image":"10"],
                ["title":"Well-cooked pureed liver","type":"0","image":"11"],
                ["title":"Well-cooked pureed meat","type":"0","image":"12"]]]]],
        ["title":"8-12","open":"0","detail":[
            ["title":"Mashed or chopped foods and finger foods","open":"0","detail":[
                ["title":"Breastmilk","type":"0","image":"13"],
                ["title":"Infant formula","type":"0","image":"14"],
                ["title":"Infant cereals","type":"0","image":"15"],
                ["title":"Well-cooked and mashed fish","type":"0","image":"16"],
                ["title":"Well-cooked and minced fish","type":"0","image":"17"],
                ["title":"minced liver and minced","type":"0","image":"18"],
                ["title":"minced liver and finely shredded meat","type":"0","image":"19"],
                ["title":"minced liver and chicken","type":"0","image":"20"],
                ["title":"minced liver and egg","type":"0","image":"21"],
                ["title":"Variety of mashed or soft cooked vegetables","type":"0","image":"22"],
                ["title":"cooked fruit","type":"0","image":"23"],
                ["title":"Chipped soft raw fruit","type":"0","image":"24"],
                ["title":"Cereals such as rice","type":"0","image":"25"]]]]],
        ["title":"9-12","open":"0","detail":[
            ["title":"Soft food","open":"0","detail":[
                ["title":"Breastmilk","type":"0","image":"26"],
                ["title":"Infant formula","type":"0","image":"27"],
                ["title":"Infant cereals","type":"0","image":"28"],
                ["title":"Well-cooked and mashed fish","type":"0","image":"29"],
                ["title":"Well-cooked and minced fish","type":"0","image":"30"],
                ["title":"minced liver and minced","type":"0","image":"31"],
                ["title":"minced liver and finely shredded meat","type":"0","image":"32"],
                ["title":"minced liver and chicken","type":"0","image":"33"],
                ["title":"minced liver and egg","type":"0","image":"34"],
                ["title":"Variety of mashed or soft cooked vegetables","type":"0","image":"35"],
                ["title":"cooked fruit","type":"0","image":"36"],
                ["title":"Chipped soft raw fruit","type":"0","image":"37"],
                ["title":"Cereals such as rice","type":"0","image":"38"],
                ["title":"custards","type":"0","image":"39"],
                ["title":"custards","type":"0","image":"40"],
                ["title":"yoghurt","type":"0","image":"41"]]]]],
        ["title":"12+","open":"0","detail":[
            ["title":"Family foods","open":"0","detail":[
                ["title":"Breastmilk","type":"0","image":"42"],
                ["title":"plain pasteurised full-cream milk","type":"0","image":"43"],
                ["title":"Variety of foods from all food groups","type":"0","image":"44"],
                ["title":"Caution must be taken with hard foods","type":"0","image":"45"]]]]]
        
        
    ]
    
    fileprivate func configBaseView() {
        
        self.navigationItem.title = "Baby's Food in Different Age"
        self.view.backgroundColor = .white
        self.mainTableView.backgroundColor = .white
        self.mainTableView.register(MileMonthListCell.classForCoder(), forCellReuseIdentifier: "MileMonthListCell")
        self.mainTableView.register(MileFirstListCell.classForCoder(), forCellReuseIdentifier: "MileFirstListCell")
        self.mainTableView.register(MileSecondListCell.classForCoder(), forCellReuseIdentifier: "MileSecondListCell")
        
        self.mainTableView.separatorStyle = .none
        //ios11 防止跳动
        self.mainTableView.estimatedRowHeight = 0
        self.mainTableView.estimatedSectionFooterHeight = 0
        self.mainTableView.estimatedSectionHeaderHeight = 0
        
    }
    
    
}

extension SixthViewController : UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return dataArray.count + 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            let dic = dataArray[section - 1]
            var rowNumber = 1
            if let open = dic["open"] {
                if open is String {
                    let changeOpen = open as? String
                    if changeOpen == "1" {
                        //展开
                        let firstAry = dic["detail"] as? Array<Dictionary<String,Any>>
                        rowNumber = rowNumber + firstAry!.count
                        for firstDic in firstAry! {
                            if let firstOpen = firstDic["open"] {
                                let changeFirstOpen = firstOpen as? String
                                if changeFirstOpen == "1" {
                                    let secondAry = firstDic["detail"] as? Array<Dictionary<String,Any>>
                                    rowNumber = rowNumber + secondAry!.count
                                }
                            }
                        }
                    }
                }
            }
            return rowNumber
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MileMonthListCell",
                                                     for: indexPath) as! MileMonthListCell
            cell.cellModel(title: "Month", detialOpen: false,isOpen: false)
            cell.backgroundColor = .white
            cell.selectionStyle = .none
            return cell
        } else {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "MileMonthListCell",
                                                         for: indexPath) as! MileMonthListCell
                let dic = dataArray[indexPath.section - 1]
                let title = dic["title"] as? String
                let open = dic["open"] as? String
                cell.cellModel(title: title ?? "", detialOpen: true,isOpen: open == "1")
                cell.backgroundColor = .white
                cell.selectionStyle = .none
                return cell
            } else if indexPath.row == 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "MileFirstListCell",
                                                         for: indexPath) as! MileFirstListCell
                let dic = dataArray[indexPath.section - 1]
                if let open = dic["open"] {
                    if open is String {
                        let changeOpen = open as? String
                        if changeOpen == "1" {
                            //展开
                            let firstAry = dic["detail"] as? Array<Dictionary<String,Any>>
                            let firstDic = firstAry?.first
                            let title = firstDic!["title"] as? String
                            let open = firstDic!["open"] as? String
                            cell.cellModel(title: title ?? "", detialOpen: true,isOpen:open == "1" )
                        }
                    }
                }
                cell.backgroundColor = .white
                cell.selectionStyle = .none
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "MileSecondListCell",
                                                         for: indexPath) as! MileSecondListCell
                let dic = dataArray[indexPath.section - 1]
                if let open = dic["open"] {
                    if open is String {
                        let changeOpen = open as? String
                        if changeOpen == "1" {
                            //展开
                            let firstAry = dic["detail"] as? Array<Dictionary<String,Any>>
                            let firstDic = firstAry?.first
                            let sectionAry = firstDic!["detail"] as? Array<Dictionary<String,Any>>
                            let sectionDic = sectionAry![indexPath.row - 2]
                            let title = sectionDic["title"] as? String
                            let type = sectionDic["type"] as? String
                            if type == "1" {
                                cell.backgroundColor = .darkGray
                            } else {
                                cell.backgroundColor = .white
                            }
                            cell.cellModel(title: title ?? "")
                        }
                    }
                }
                cell.selectionStyle = .none
                return cell
            }
        }
        
        
        
    }
    
}
extension SixthViewController :UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        }
        return 0
        
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        //        view.backgroundColor = STBackViewBackViewColor
        return view
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            
        } else {
            //修改参数
            configChangeDataWith(indexPath: indexPath)
        }
    }
    
}

extension SixthViewController {
    fileprivate func configChangeDataWith(indexPath: IndexPath) {
        var changeDic = dataArray[indexPath.section - 1]
        if indexPath.row == 0 {
            if let open = changeDic["open"] {
                if open is String {
                    let changeOpen = open as? String
                    if changeOpen == "0" {
                        changeDic["open"] = "1"
                    } else if changeOpen == "1" {
                        changeDic["open"] = "0"
                    }
                }
            }
            dataArray[indexPath.section - 1] = changeDic
            self.mainTableView.reloadSections([indexPath.section], with: .none)
        } else if indexPath.row == 1 {
            
            var firstAry = changeDic["detail"] as? Array<Dictionary<String,Any>>
            var firstDic = firstAry![0]
            
            if let open = firstDic["open"] {
                if open is String {
                    let changeOpen = open as? String
                    if changeOpen == "0" {
                        firstDic["open"] = "1"
                    } else if changeOpen == "1" {
                        firstDic["open"] = "0"
                    }
                }
            }
            firstAry![0] = firstDic
            changeDic["detail"] = firstAry
            dataArray[indexPath.section - 1] = changeDic
            self.mainTableView.reloadSections([indexPath.section], with: .none)
        } else {
            var firstAry = changeDic["detail"] as? Array<Dictionary<String,Any>>
            var firstDic = firstAry![0]
            var sectionAry = firstDic["detail"] as? Array<Dictionary<String,Any>>
            var sectionDic = sectionAry![indexPath.row - 2]
            var type = sectionDic["type"] as? String
            let image = sectionDic["image"] as? String

            //显示弹框 --
            let view = MonthAlertView(frame: CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height))
            view.configDataWithImage(image ?? "")
            view.enterClickBtnAction = {[unowned self] in
                type = "1"
                sectionDic["type"] = type
                sectionAry![indexPath.row - 2] = sectionDic
                firstDic["detail"] = sectionAry
                firstAry![0] = firstDic
                changeDic["detail"] = firstAry
                self.dataArray[indexPath.section - 1] = changeDic
                self.mainTableView.reloadSections([indexPath.section], with: .none)
            }
            view.closeImageBlock = {[unowned self] in
                type = "0"
                sectionDic["type"] = type
                sectionAry![indexPath.row - 2] = sectionDic
                firstDic["detail"] = sectionAry
                firstAry![0] = firstDic
                changeDic["detail"] = firstAry
                self.dataArray[indexPath.section - 1] = changeDic
                self.mainTableView.reloadSections([indexPath.section], with: .none)
            }
            UIApplication.shared.keyWindow?.addSubview(view)
        }
    }
    
}

