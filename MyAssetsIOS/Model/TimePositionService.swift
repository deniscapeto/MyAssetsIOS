//
//  AssetService.swift
//  MyAssetsIOS
//
//  Created by Denis Sacramento C. Capeto on 1/10/19.
//  Copyright © 2019 Denis Sacramento C. Capeto. All rights reserved.
//

import Foundation

class TimePositionService{
    
    func assetsToDctionary(assetPositions:Array<AssetPosition>) -> [[String: Any]]{
        var retorno:[[String: Any]] = [[String: Any]]()
        
        for asset in assetPositions{
            
            let param =  [
                "Asset": asset.asset,
                "Amount": Double(asset.amount),
                "Custodian": asset.custodian
                ] as [String : Any]
            
            retorno.append(param)
        }
        
        return retorno
        
    }
    
    func SendToAWSApiAgateway(timePosition:TimePosition) -> Bool{
        
        print("Message".hmac(algorithm: CryptoAlgorithm.SHA256, key: "secret"))
        
        let headers = [
            "Content-Type": "application/json",
            "Content-Length": "88",
            "Authorization": "AWS4-HMAC-SHA256 Credential=\(AppSecrets.authAWSCredential)/20190110/sa-east-1/execute-api/aws4_request, SignedHeaders=content-length;content-type;host;x-amz-date, Signature=\(AppSecrets.authSignatureAddTimePosition)",
            "cache-control": "no-cache",
        ]
        
        let parameters = [
            "Date": timePosition.date,
            "AssetPositions": assetsToDctionary(assetPositions: timePosition.assetPositions) as [[String: Any]]
        ] as [String : Any]
        
        do{
            let postData = try JSONSerialization.data(withJSONObject: parameters, options: [])
            
            guard let url = URL(string: AppSecrets.gatewayApiUrl) else { return false }
            var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy , timeoutInterval: 20.0)
            
            request.httpMethod = "PUT"
            request.allHTTPHeaderFields = headers
            request.httpBody = postData as Data
            request.timeoutInterval = 5000
            
            let session = URLSession.shared
            let dataTask = session.dataTask(with: request, completionHandler:
            {
                (data, response, error) in
                if (error != nil) {
                    print(error!)
                } else {
                    if let httpResponse = response as? HTTPURLResponse{
                        print(httpResponse)
                        print(data!)
                    }
                }
            })
            
            dataTask.resume()
            return true
        }
        catch{
            print(error.localizedDescription)
            return false
        }
    }
    
    func GetAssetPositionHistory(sucesso: @escaping(_ assetPositions:Array<TimePosition>) -> Void, falha: @escaping(_ error:Error) -> Void)
    {
        
        let headers = [
            "Content-Type": "application/json",
            "Authorization": "AWS4-HMAC-SHA256 Credential=\(AppSecrets.authAWSCredential)/20190110/sa-east-1/execute-api/aws4_request, SignedHeaders=cache-control;content-type;host;postman-token;x-amz-date, Signature=\(AppSecrets.authSignatureGetPositions)",
            "cache-control": "no-cache",
        ]
        
        var request = URLRequest(url: URL(string: AppSecrets.gatewayApiUrl)! ,
                                 cachePolicy: .useProtocolCachePolicy,
                                 timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler:
        { (data, response, error)  in
            
            if (error == nil) {
                if (response as? HTTPURLResponse) != nil{
                    do{
                        let dicionario = try JSONSerialization.jsonObject(with: data!, options: [])
                        let lista = dicionario as! NSArray
                        var timePositions = Array<TimePosition>()
                        
                        timePositions = lista.map({(timePosition) -> TimePosition in
                            return TimePosition(json: timePosition as! [String: Any] )!
                        })
                        let orderedList = timePositions.sorted(by: { $0.createdTimestamp > $1.createdTimestamp })
                        sucesso(orderedList)
                    }
                    catch{
                        print(error.localizedDescription)
                    }
                }
            } else {
                print(error!)
            }
        })
        
        dataTask.resume()
    }
    
    
    func GetLastTimePosition(sucesso: @escaping(_ assetPositions:TimePosition) -> Void, falha: @escaping(_ error:Error) -> Void)
    {
        
        var headers = [
            "Content-Type": "application/json",
            "cache-control": "no-cache",
        ]
        
        headers["Authorization"] = "AWS4-HMAC-SHA256 Credential=\(AppSecrets.authAWSCredential)/20190110/sa-east-1/execute-api/aws4_request, SignedHeaders=cache-control;content-type;host;postman-token;x-amz-date, Signature=\(AppSecrets.authSignatureGetPositions)"
        
        //headers["Authorization"] = 
        
        var request = URLRequest(url: URL(string: AppSecrets.gatewayApiUrl)! ,
                                 cachePolicy: .useProtocolCachePolicy,
                                 timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler:
        { (data, response, error)  in
            
            if (error == nil) {
                if (response as? HTTPURLResponse) != nil{
                    do{
                        let dicionario = try JSONSerialization.jsonObject(with: data!, options: [])
                        let lista = dicionario as! NSArray
                        var timePositions = Array<TimePosition>()
                        
                        timePositions = lista.map({(timePosition) -> TimePosition in
                            return TimePosition(json: timePosition as! [String: Any] )!
                        })
                        
                        sucesso(timePositions.sorted(by: { $0.createdTimestamp < $1.createdTimestamp }).last!)
                    }
                    catch{
                        print(error.localizedDescription)
                    }
                }
            } else {
                print(error!)
            }
        })
        
        dataTask.resume()
    }
}
