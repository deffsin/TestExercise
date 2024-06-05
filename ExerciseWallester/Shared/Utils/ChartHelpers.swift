//
//  ChartHelpers.swift
//  CoinGekoWallester
//
//  Created by Denis Sinitsa on 26.05.2024.
//

import SwiftUI

struct LineGraph: Shape {
    var dataPoints: [Double]
    
    func path(in rect: CGRect) -> Path {
        var path = Path()

        guard dataPoints.count > 1 else { return path }
        
        let maxValue = dataPoints.max() ?? 0
        let minValue = dataPoints.min() ?? 0

        let yRange = maxValue - minValue
        let xStep = rect.width / CGFloat(dataPoints.count - 1)
        let yStep = rect.height / yRange

        let firstPoint = CGPoint(x: 0, y: rect.height - (dataPoints[0] - minValue) * yStep)
        path.move(to: firstPoint)

        for idx in dataPoints.indices.dropFirst() {
            let point = CGPoint(x: CGFloat(idx) * xStep, y: rect.height - (dataPoints[idx] - minValue) * yStep)
            path.addLine(to: point)
        }
        return path
    }
}
