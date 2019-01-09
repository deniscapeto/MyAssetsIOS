//
//  HistoryTableViewController.swift
//  MyAssetsIOS
//
//  Created by Denis Sacramento C. Capeto on 1/10/19.
//  Copyright © 2019 Denis Sacramento C. Capeto. All rights reserved.
//

import Foundation
import UIKit

class HistoryTableViewController: UITableViewController {
    
    var timePositions:Array<TimePosition> = []
    
    override init(style: UITableView.Style) {
        super.init(style: style)
    }
    
    override func viewDidLoad() {
        super.refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(didRefreshTable), for: .valueChanged)
        loadAssetPositions()
    }
    
    @objc func didRefreshTable(){
        loadAssetPositions()
        self.refreshControl?.endRefreshing()
    }
    
    func loadAssetPositions(){
        TimePositionService().GetAssetPositionAddHistory(sucesso: { (dicionario) in
            self.timePositions = dicionario        
            
            DispatchQueue.main.async {
                self.tableView?.reloadData()
            }
            
        }) { (erro) in
            print(erro.localizedDescription)
        }
        refreshControl?.attributedTitle = NSAttributedString(string: "Atualizado em \(NSDate())")
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timePositions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if(timePositions.count == 0){
            return UITableViewCell(style: UITableViewCell.CellStyle.default
                , reuseIdentifier: nil)
        }
        
        let row = indexPath.row
        let timePosition = timePositions[row]
        let cell:UITableViewCell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: nil)
        
        cell.textLabel?.font = UIFont.systemFont(ofSize: 12)
        
        cell.textLabel?.text = "\(timePosition.createdTimestamp.prefix(10)) - \(timePosition.date) - \(timePosition.id)"
        return cell
    }
    
}
