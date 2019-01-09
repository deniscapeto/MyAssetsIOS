//
//  SecondViewController.swift
//  MyAssetsIOS
//
//  Created by Denis Sacramento C. Capeto on 1/9/19.
//  Copyright © 2019 Denis Sacramento C. Capeto. All rights reserved.
//

import UIKit

class NewAssetPositionViewController: UIViewController , UITableViewDataSource {
    
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        //tabBarItem = UITabBarItem(title: "Add", image: UIImage(named: "add_32x32"), tag: 3)
    }
    
    @IBOutlet var dateTextField:UITextField?
    @IBOutlet var amaountTextField:UITextField?
    @IBOutlet var assetTextField:UITextField?
    @IBOutlet var custodianTextField:UITextField?
    @IBOutlet var tableView:UITableView?
    var timePosition:TimePosition?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.tableView?.dataSource = self
        self.view.addSubview(tableView!)
        
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.addTarget(self, action: #selector(updateDateField(sender:)), for: .valueChanged)
        
        
        self.dateTextField!.inputView = picker
        let date:String = formatDateForDisplay(date: picker.date)
        dateTextField!.text = date
        self.timePosition = TimePosition(id: 0, date: date, createdTimestamp: "", assetPositions: [])
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let rows = timePosition?.assetPositions.count else {
            return 0
        }
        return rows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: nil)
        
        cell.textLabel?.text = timePosition?.assetPositions[indexPath.row].asset
        return cell
    }
    
    
    @IBAction func adicionarTimePosition(){
                
        _ = TimePositionService().SendToAWSApiAgateway(timePosition: self.timePosition!)
    }
    
    @IBAction func adicionarAssetPosition(){
        
        guard let data:String = dateTextField?.text else{
            print("nao captou")
            return
        }
        let valor = amaountTextField!.text!
        let descricaoDoAtivo = assetTextField!.text!
        let custodiante = custodianTextField!.text!
        
        print("Clicou. Data: \(data) Valor: \(valor) Ativo: \(descricaoDoAtivo) Custodiante: \(custodiante)")

        let posicaoDoAtivo = AssetPosition(id: 0, asset: descricaoDoAtivo, amount: Double(valor)!, custodian: custodiante)
        
        self.timePosition!.addAssetPosition(posicaoDoAtivo)
        
        print("fazer animacao que mostre que foi com sucesso")
        
        self.tableView?.reloadData()
    }

    


    @objc
    func updateDateField(sender: UIDatePicker) {
        dateTextField?.text = formatDateForDisplay(date: sender.date)
    }
    
    func formatDateForDisplay(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        return formatter.string(from: date)
    }

    
}

