//
//  GraphsViewController.swift
//  MyAssetsIOS
//
//  Created by Denis Sacramento C. Capeto on 2/22/19.
//  Copyright © 2019 Denis Sacramento C. Capeto. All rights reserved.
//

import Foundation
import UIKit
import Charts

class ChartsViewController : UIViewController {
    
    @IBOutlet weak var barChartView: BarChartView!
    @IBOutlet weak var allocationChartView: PieChartView!
    @IBOutlet weak var scrollView: UIScrollView!
    var refreshControl:UIRefreshControl?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.addTarget(self, action: #selector(didRefreshTable), for: .valueChanged)
        self.scrollView.refreshControl = self.refreshControl
        updateCharts()
    }
    
    @objc func didRefreshTable(){
        updateCharts()
        self.refreshControl?.endRefreshing()
    }
    
    func updateCharts(){
        setAllocationChart()
        setAssetsGrowthChart()
    }
    
    func setAssetsGrowthChart(){
        var lista = [BarChartDataEntry]()
        
        TimePositionService().GetAssetPositionHistory(sucesso: { (dicionario) in
            
            var xIndex:Double=1
            
            for item in dicionario {
                var total:Double = 0
                
                item.assetPositions.forEach{asset in
                    total += asset.amount
                }
                
                let p2 = BarChartDataEntry(x: xIndex, y: total)
                lista.append(p2)
                xIndex += 1
            }
            
            let set = BarChartDataSet(values: lista, label: "$ Amount")
            let data = BarChartData(dataSet: set)
            
            DispatchQueue.main.async {
                self.barChartView.data = data
            }
            
        }) { (erro) in
            print(erro.localizedDescription)
        }
    }
    
    func setAllocationChart(){
        var lista = [PieChartDataEntry]()
        
        TimePositionService().GetLastTimePosition(sucesso: { (dicionario) in
            
            for custodian in dicionario.custodiansTotalAmount {
                let p2 = PieChartDataEntry(value: custodian.value, label: custodian.key)
                lista.append(p2)
            }
            
            let set = PieChartDataSet(values: lista, label: "Allocation")
            var  colors: [UIColor] = []
            
            colors.append(#colorLiteral(red: 0.4763481021, green: 0.4931288958, blue: 0.8382745385, alpha: 1))
            colors.append(#colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1))
            colors.append(#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1))
            colors.append(#colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1))
            colors.append(#colorLiteral(red: 1, green: 0.5006016493, blue: 0.6636574864, alpha: 1))
            
            set.colors = colors
            let data = PieChartData(dataSet: set)
            DispatchQueue.main.async {
                self.allocationChartView.data = data
            }
            
        }) { (erro) in
            print(erro.localizedDescription)
        }
    }
}
