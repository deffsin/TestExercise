//
//  CoinHistoricalChartDataModel.swift
//  CoinGekoWallester
//
//  Created by Denis Sinitsa on 31.05.2024.
//

import Foundation

struct CoinHistoricalChartDataModel: Codable {
    let prices: [[Double]]

    enum CodingKeys: String, CodingKey {
        case prices
    }
}
