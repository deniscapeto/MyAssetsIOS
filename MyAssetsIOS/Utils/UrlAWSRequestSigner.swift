//
//  UrlAWSRequestSigner.swift
//  MyAssetsIOS
//
//  Created by Denis Sacramento C. Capeto on 1/13/19.
//  Copyright © 2019 Denis Sacramento C. Capeto. All rights reserved.
//

//import Foundation
//import CryptoSwift
//
//class URLRequestSigner: NSObject {
//
//    private let hmacShaTypeString = "AWS4-HMAC-SHA256"
//    private let awsRegion = "us-east-1"
//    private let serviceType = "execute-api"
//    private let aws4Request = "aws4_request"
//
//    private let iso8601Formatter: DateFormatter = {
//        let formatter = DateFormatter()
//        formatter.calendar = Calendar(identifier: .iso8601)
//        formatter.locale = Locale(identifier: "en_US_POSIX")
//        formatter.timeZone = TimeZone(secondsFromGMT: 0)
//        formatter.dateFormat = "yyyyMMdd'T'HHmmssXXXXX"
//        return formatter
//    }()
//
//    private func iso8601() -> (full: String, short: String) {
//        let date = iso8601Formatter.string(from: Date())
//        let index = date.index(date.startIndex, offsetBy: 8)
//        let shortDate = date.substring(to: index)
//        return (full: date, short: shortDate)
//    }
//
//
//    func sign(request: URLRequest, secretSigningKey: String, accessKeyId: String) -> URLRequest? {
//        var signedRequest = request
//        let date = iso8601()
//
//        guard let bodyData = signedRequest.httpBody, let body = String(data: bodyData, encoding: .utf8), let url = signedRequest.url, let host = url.host
//            else { return .none }
//
//        signedRequest.addValue(host, forHTTPHeaderField: "Host")
//        signedRequest.addValue(date.full, forHTTPHeaderField: "X-Amz-Date")
//
//        guard let headers = signedRequest.allHTTPHeaderFields, let method = signedRequest.httpMethod
//            else { return .none }
//
//        let signedHeaders = headers.map{ $0.key.lowercased() }.sorted().joined(separator: ";")
//
//        let canonicalRequestHash = [
//            method,
//            url.path,
//            url.query ?? "",
//            headers.map{ $0.key.lowercased() + ":" + $0.value }.sorted().joined(separator: "\n"),
//            "",
//            signedHeaders,
//            body.sha256()
//            ].joined(separator: "\n").sha256()
//
//        let credential = [date.short, awsRegion, serviceType, aws4Request].joined(separator: "/")
//
//        let stringToSign = [
//            hmacShaTypeString,
//            date.full,
//            credential,
//            canonicalRequestHash
//            ].joined(separator: "\n")
//
//        guard let signature = hmacStringToSign(stringToSign: stringToSign, secretSigningKey: secretSigningKey, shortDateString: date.short)
//            else { return .none }
//
//        let authorization = hmacShaTypeString + " Credential=" + accessKeyId + "/" + credential + ", SignedHeaders=" + signedHeaders + ", Signature=" + signature
//        signedRequest.addValue(authorization, forHTTPHeaderField: "Authorization")
//
//        return signedRequest
//    }
//
//    private func hmacStringToSign(stringToSign: String, secretSigningKey: String, shortDateString: String) -> String? {
//        let k1 = "AWS4" + secretSigningKey
//        guard let sk1 = try? HMAC(key: [UInt8](k1.utf8), variant: .sha256).authenticate([UInt8](shortDateString.utf8)),
//            let sk2 = try? HMAC(key: sk1, variant: .sha256).authenticate([UInt8](awsRegion.utf8)),
//            let sk3 = try? HMAC(key: sk2, variant: .sha256).authenticate([UInt8](serviceType.utf8)),
//            let sk4 = try? HMAC(key: sk3, variant: .sha256).authenticate([UInt8](aws4Request.utf8)),
//            let signature = try? HMAC(key: sk4, variant: .sha256).authenticate([UInt8](stringToSign.utf8)) else { return .none }
//        return signature.toHexString()
//    }
//
//}
