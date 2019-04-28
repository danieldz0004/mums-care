//
//  TestViewController.swift
//  Week9Tutorial
//
//  Created by Daniel Dz on 15/4/19.
//  Copyright © 2019 Jason Haasz. All rights reserved.
//

import UIKit

class TestViewController: UIViewController, UICollectionGridViewSortDelegate {
    
    var gridViewController: UICollectionGridViewController!
    var selection: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gridViewController = UICollectionGridViewController()
        
        if selection == "China0-2" {
            gridViewController.setColumns(columns: ["Same?","Australia", "China"])
            gridViewController.addRow(row: ["Yes","HepB_Pediatric", "HepB_Pediatric"])
            gridViewController.addRow(row: ["No","DTaPHibHepBIPV", "BCG"])
            gridViewController.addRow(row: ["No","Pneumo_conj", "IPV"])
            gridViewController.addRow(row: ["No","Rotavirus", "-"])

        } else if selection == "China2-4" {
            gridViewController.setColumns(columns: ["Same?","Australia", "China"])
            gridViewController.addRow(row: ["No","DTaPHibHepBIPV", "DTaP"])
            gridViewController.addRow(row: ["No","Pneumo_conj", "OPV"])
            gridViewController.addRow(row: ["No","Rotavirus", "-"])
        } else if selection == "China4-6" {
            gridViewController.setColumns(columns: ["Same?","Australia", "China"])
            gridViewController.addRow(row: ["No","DTaPHibHepBIPV", "HepB_Pediatric"])
            gridViewController.addRow(row: ["No","Influenza_Pediatric", "OPV"])
            gridViewController.addRow(row: ["No","Pneumo_conj", "MenA"])
            gridViewController.addRow(row: ["No","Rotavirus", "-"])
        } else if selection == "China6-12" {
            gridViewController.setColumns(columns: ["Same?","Australia", "China"])
            gridViewController.addRow(row: ["No","HepA_Pediatric", "JE_LiveAtd"])
            gridViewController.addRow(row: ["No","HibMenC", "MenA"])
            gridViewController.addRow(row: ["No","MMR", "MR"])
            gridViewController.addRow(row: ["No","Pneumo_conj", "-"])
            
        } else if selection == "India0-2" {
            
        } else if selection == "India2-4" {
            
        } else if selection == "India4-6" {
            
        } else if selection == "India6-8" {
            
        } else if selection == "India8-12" {
            
        } else {
            
        }
        gridViewController.sortDelegate = self
        view.addSubview(gridViewController.view)
        
        
        
    }
    
    override func viewDidLayoutSubviews() {
        gridViewController.view.frame = CGRect(x:0, y:100, width:view.frame.width,
                                               height:view.frame.height-64)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //表格排序函数
    func sort(colIndex: Int, asc: Bool, rows: [[Any]]) -> [[Any]] {
        let sortedRows = rows.sorted { (firstRow: [Any], secondRow: [Any])
            -> Bool in
            let firstRowValue = firstRow[colIndex] as! String
            let secondRowValue = secondRow[colIndex] as! String
            if colIndex == 0 || colIndex == 1 {
                //首例、姓名使用字典排序法
                if asc {
                    return firstRowValue < secondRowValue
                }
                return firstRowValue > secondRowValue
            } else  {
                //中间两列使用数字排序
                if asc {
                    return firstRowValue < secondRowValue
                }
                return firstRowValue > secondRowValue
            }
        }
        return sortedRows
    }
}
