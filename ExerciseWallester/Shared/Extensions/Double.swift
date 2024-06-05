//
//  Double+customFormatted.swift
//  CoinGekoWallester
//
//  Created by Denis Sinitsa on 21.05.2024.
//

import SwiftUI

extension Double {
    var customFormatted: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = "," // razdelitel dlja thousands
        formatter.locale = Locale(identifier: "en_US") // poka wto en_US
        formatter.usesSignificantDigits = true
        
        if self >= 1 {
            formatter.maximumFractionDigits = 2
            formatter.minimumFractionDigits = 2
        } else if self >= 0.001 {
            formatter.maximumFractionDigits = 4 // 0.001 & 1
        } else {
            formatter.maximumFractionDigits = 8 // dlja o4en malenkih cifr, naprimer kak PEPE
        }
        
        return formatter.string(from: NSNumber(value: self)) ?? "\(self)"
    }
    
    var formatNumber: String { // used in the DetailChartView
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.usesGroupingSeparator = true
        formatter.groupingSeparator = ","
        formatter.decimalSeparator = "."
        formatter.locale = Locale(identifier: "en_US")
        
        if self >= 1000 {
            formatter.positiveSuffix = "k"
            formatter.negativeSuffix = "k"
            formatter.minimumFractionDigits = 1
            formatter.maximumFractionDigits = 2
            let scaledNumber = self / 1000
            return formatter.string(from: NSNumber(value: scaledNumber)) ?? ""
        }
        
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter.string(from: NSNumber(value: self)) ?? ""
    }
}
