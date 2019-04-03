//
//  TimePosition.swift
//  MyAssetsIOS
//
//  Created by Denis Sacramento C. Capeto on 1/16/19.
//  Copyright © 2019 Denis Sacramento C. Capeto. All rights reserved.
//

import Foundation

class TimePosition {
    let id: Int
    var date: String
    let createdTimestamp: String
    var assetPositions: [AssetPosition]
    
    init(id: Int, date: String, createdTimestamp: String, assetPositions: [AssetPosition]) {
        self.id = id
        self.date = date
        self.createdTimestamp = createdTimestamp
        self.assetPositions = assetPositions
    }
    
    init?(json: [String: Any])
    {
        self.id = json["Id"] as! Int
        self.date = json["Date"] as! String
        self.createdTimestamp = json["CreatedTimestamp"] as! String
        self.assetPositions = []
        
        let jsonAsset =  json["AssetPositions"] as! [[String:Any]];
        
        self.assetPositions = jsonAsset.map({(asset) -> AssetPosition in
            return AssetPosition(json: asset)!
        })
    }
    
    func addAssetPosition(_ assetPosition:AssetPosition) {
        self.assetPositions.append(assetPosition)
    }
    
    var totalAmount:Double{
        var total:Double = 0
        for custodiante in self.custodians {
            for asset in custodiante.value{
                total = total + asset.amount
            }
        }
        return total
    }
    
    var custodians: Dictionary<String, Array<AssetPosition>>{
        return  Dictionary(grouping: self.assetPositions, by: {  $0.custodian ?? "NaoInformado" })
    }
    
    var custodiansTotalAmount: Dictionary<String, Double>{
        
        var custodiansTotalAmount:Dictionary<String, Double> = Dictionary<String, Double>()
        
        for custodian in self.custodians {
            var total:Double = 0
            for asset in custodian.value{
                total = total + asset.amount
            }
            
            custodiansTotalAmount[custodian.key] = total
            
        }
        return custodiansTotalAmount
    }
    
}
