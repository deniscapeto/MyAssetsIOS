//
//  ChartXAxisFormatter.swift
//  MyAssetsIOS
//
//  Created by Denis Sacramento C. Capeto on 3/11/19.
//  Copyright © 2019 Denis Sacramento C. Capeto. All rights reserved.
//

import Foundation
import Charts

class ChartXAxisFormatter: NSObject, IAxisValueFormatter {
    var months: [String]! = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
    
    
    var values: [Double:String]!
    
    init(stringValues:[Double:String]) {
        self.values = stringValues
    }
    
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String
    {
        return values![value]!
    }
}
