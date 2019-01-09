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
    let date: String
    let createdTimestamp: String
    var assetPositions: [AssetPosition]
    
    func addAssetPosition(_ assetPosition:AssetPosition) {
        self.assetPositions.append(assetPosition)
    }
    
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
    
}
