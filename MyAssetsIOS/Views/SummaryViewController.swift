//
//  FirstViewController.swift
//  MyAssetsIOS
//
//  Created by Denis Sacramento C. Capeto on 1/9/19.
//  Copyright © 2019 Denis Sacramento C. Capeto. All rights reserved.
//

import UIKit
import Foundation

class SummaryViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet var tableView:UITableView?
    @IBOutlet var totalAmountLabel:UILabel?
    @IBOutlet var timePositionDateLabel:UILabel?
    
    var assetPositions:Array<AssetPosition> = []
    var agrupamento = Dictionary<String, Array<AssetPosition>>()
    var refreshControl:UIRefreshControl?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView?.dataSource = self
        self.view.addSubview(tableView!)
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.addTarget(self, action: #selector(didRefreshTable), for: .valueChanged)
        self.tableView?.refreshControl = self.refreshControl
        loadAssetPositions()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return agrupamento.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let custodiante =  Array(agrupamento)[section].key
        let positionsInCustodian = agrupamento[custodiante]
        let totalCustodianAmount = positionsInCustodian!.reduce(0, {(result, assetPosition) -> Double in
            return result + assetPosition.amount
        })
        
        return "\(custodiante)       R$ \(totalCustodianAmount)"
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let custodiante = Array(agrupamento)[section].key
        let positionsInCustodian = agrupamento[custodiante]
        return positionsInCustodian!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if(agrupamento.count == 0){
            return UITableViewCell()
        }
        
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: nil)
        
        let custodiante = Array(agrupamento)[indexPath.section].key
        
        let positionsInCustodian = agrupamento[custodiante]
        
        let position = positionsInCustodian![indexPath.row]
        
        cell.textLabel?.text = "\(position.asset)   \(position.amount)"
        return cell
    }
    
    @objc func didRefreshTable(){
        loadAssetPositions()
        self.refreshControl?.endRefreshing()
    }
    
    func loadAssetPositions(){
        TimePositionService().GetLastTimePosition(sucesso: { (timePosition) in
            
            
            self.assetPositions = timePosition.assetPositions
            
            self.agrupamento = Dictionary(grouping: self.assetPositions, by: {  $0.custodian ?? "NaoInformado" })
            
            var total:Double = 0
            for custodiante in self.agrupamento {
                for asset in custodiante.value{
                    total = total + asset.amount
                }
            }
            
            print(self.agrupamento.count)
            
            DispatchQueue.main.async {
                self.tableView?.reloadData()
                self.totalAmountLabel?.text = "R$ \(String(total))"//"R$ 298.249,87"
                self.timePositionDateLabel?.text = String(timePosition.date.prefix(10))
            }
            
        }){ (erro) in
            print(erro.localizedDescription)
        }
    }
}
