//
//  CoinModel.swift
//  Wallester
//
//  Created by Denis Sinitsa on 20.05.2024.
//

import Foundation
import SwiftUI

struct CoinModel: Identifiable, Codable {
    let id, symbol, name: String
    let image: String
    let currentPrice: Double
    let marketCap: Double?
    let rank: Int
    let volume24h: Double?
    let priceChangePercentage1H: Double?
    let priceChangePercentage24H: Double?
    let priceChangePercentage7D: Double?
    let sparklineIn7D: SparklineIn7D?

    enum CodingKeys: String, CodingKey {
        case id, symbol, name, image
        case currentPrice = "current_price"
        case marketCap = "market_cap"
        case rank = "market_cap_rank"
        case volume24h = "total_volume"
        case priceChangePercentage1H = "price_change_percentage_1h_in_currency"
        case priceChangePercentage24H = "price_change_percentage_24h_in_currency"
        case priceChangePercentage7D = "price_change_percentage_7d_in_currency"
        case sparklineIn7D = "sparkline_in_7d"
    }
}

struct SparklineIn7D: Codable {
    let price: [Double]?
}
