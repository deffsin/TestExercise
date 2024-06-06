//
//  Double.swift
//  CoinGekoWallester
//
//  Created by Denis Sinitsa on 21.05.2024.
//

import SwiftUI

extension Double {
    var formattedForDetailChart: String { // used in the DetailChartView for the better side display of the chart
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
