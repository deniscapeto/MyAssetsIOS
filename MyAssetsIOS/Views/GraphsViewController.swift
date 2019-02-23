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

class GraphsViewController : UIViewController {
    
    @IBOutlet weak var lineChartView: LineChartView!
    @IBOutlet weak var barChartView: BarChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //setChartValues()
        setChartValues2()
    }
    
    func setChartValues2(){
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
    
    func setChartValues(){
                var lista = [ChartDataEntry]()
        
        TimePositionService().GetAssetPositionHistory(sucesso: { (dicionario) in

            var xIndex:Double=1
            
            for item in dicionario {
                var total:Double = 0
                
                item.assetPositions.forEach{asset in
                    total += asset.amount
                }

                let p2 = ChartDataEntry(x: xIndex, y: total)
                lista.append(p2)
                xIndex += 1 
            }
            
            let set = LineChartDataSet(values: lista, label: "Your Progress")
            let data = LineChartData(dataSet: set)
            
            DispatchQueue.main.async {
                self.lineChartView.data = data
            }
            
        }) { (erro) in
            print(erro.localizedDescription)
        }
    }
}
