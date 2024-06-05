//
//  CoinDetailModel.swift
//  TestExerciseWallester
//
//  Created by Denis Sinitsa on 01.06.2024.
//

import Foundation

struct CoinDetailModel: Identifiable, Codable {
    let id, symbol, name: String
    let image: CoinImage?
    let marketData: MarketData
    let rank: Int?
    
    enum CodingKeys: String, CodingKey {
        case id, symbol, name, image
        case marketData = "market_data"
        case rank = "market_cap_rank"
    }
    
    struct CoinImage: Codable {
        let thumb: String
        let small: String
        let large: String
    }
    
    struct MarketData: Codable {
        let currentPrice: [String: Double]
        let priceChangePercentage24HInCurrency: [String: Double]
        let marketCap: [String: Double]
        let totalVolume: [String: Double]
        let circulatingSupply: Double?
        let totalSupply: Double?
        let maxSupply: Double?
        
        enum CodingKeys: String, CodingKey {
            case currentPrice = "current_price"
            case priceChangePercentage24HInCurrency = "price_change_percentage_24h_in_currency"
            case marketCap = "market_cap"
            case totalVolume = "total_volume"
            case circulatingSupply = "circulating_supply"
            case totalSupply = "total_supply"
            case maxSupply = "max_supply"
        }
    }
}
