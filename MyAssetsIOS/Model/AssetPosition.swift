//
//  Asset.swift
//  MyAssetsIOS
//
//  Created by Denis Sacramento C. Capeto on 1/10/19.
//  Copyright © 2019 Denis Sacramento C. Capeto. All rights reserved.
//

import Foundation

class AssetPosition2{
    
    var date:String?
    var amaount:String?
    var assetDescription:String?
    var custodian:String?

    init(date:String, amaount:String, assetDescription:String, custodian:String) {

        self.date = date
        self.amaount = amaount
        self.assetDescription = assetDescription
        self.custodian = custodian
    }
}

class AssetPosition_ {
    let id: Int
    let dateTime: String
    let asset: String
    let amount: Double
    let createdTimestamp: String
    let amountAdded: Int
    let custodian: String?
    
    init(id: Int, dateTime: String, asset: String, amount: Double,createdTimestamp: String ,amountAdded: Int, custodian: String?) {
        self.id = id
        self.dateTime = dateTime
        self.asset = asset
        self.amount = amount
        self.createdTimestamp = createdTimestamp
        self.amountAdded = amountAdded
        self.custodian = custodian
    }
    
    init?(json: [String: Any])
    {
        self.id = json["Id"] as! Int
        self.dateTime = json["DateTime"] as! String
        self.asset = json["Asset"] as! String
        self.amount = json["Amount"] as! Double
        self.createdTimestamp = json["CreatedTimestamp"] as! String
        self.amountAdded = json["AmountAdded"] as! Int
        self.custodian = json["Custodian"] as? String
        
        
//        "Id": 498583921,
//        "DateTime": "1990-11-26T00:00:00+00:00",
//        "Asset": "Itau CDB ate 2020",
//        "Amount": 100.88,
//        "CreatedTimestamp": "2019-01-10T13:16:01.699+00:00",
//        "AmountAdded": 0,
//        "Custodian": null
    }
}

class AssetPosition {
    let id: Int
    let asset: String
    let amount: Double
    let custodian: String
    
    init(id: Int, asset: String, amount: Double, custodian: String) {
        self.id = id
        self.asset = asset
        self.amount = amount
        self.custodian = custodian
    }
    
    init?(json: [String: Any])
    {
        self.id = json["Id"] as! Int
        self.asset = json["Asset"] as! String
        self.amount = json["Amount"] as! Double
        self.custodian = json["Custodian"] as! String
    }
    
}
