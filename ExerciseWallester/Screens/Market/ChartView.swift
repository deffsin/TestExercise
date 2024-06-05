//
//  ChartView.swift
//  CoinGekoWallester
//
//  Created by Denis Sinitsa on 26.05.2024.
//

import SwiftUI

struct ChartView: View {
    var sparklineIn7D: [Double]
    var lineColor: Color

    var body: some View {
        VStack {
            if !sparklineIn7D.isEmpty {
                LineGraph(dataPoints: sparklineIn7D)
                    .stroke(lineColor, style: StrokeStyle(lineWidth: 1, lineCap: .round, lineJoin: .round))
                    .padding(.vertical, 10)
                    .frame(width: 140)
                    .frame(maxHeight: .infinity)
            } else {
                Text("No sparkline data availble")
                    .frame(width: 140)
                    .frame(maxHeight: .infinity)
            }
        }
    }
}
