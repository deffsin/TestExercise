//
//  SortCoins.swift
//  CoinGekoWallester
//
//  Created by Denis Sinitsa on 24.05.2024.
//

import Foundation

extension MarketViewModel {
    func sortCoins(sort: SortOption, coins: [CoinModel]) -> [CoinModel] {
        switch sort {
        case .rank:
            return coins.sorted { $0.rank < $1.rank }
            
        case .rankReversed:
            return coins.sorted { $0.rank > $1.rank }
            
        case .price:
            return coins.sorted { ($0.currentPrice) < ($1.currentPrice) }
            
        case .priceReversed:
            return coins.sorted { ($0.currentPrice) > ($1.currentPrice) }
            
        case .pricePercentage1h:
            return coins.sorted { ($0.priceChangePercentage1H ?? 0.0) < ($1.priceChangePercentage1H ?? 0.0) }
            
        case .pricePercentage1hReversed:
            return coins.sorted { ($0.priceChangePercentage1H ?? 0.0) > ($1.priceChangePercentage1H ?? 0.0) }
            
        case .pricePercentage24h:
            return coins.sorted { ($0.priceChangePercentage24H ?? 0.0) < ($1.priceChangePercentage24H ?? 0.0) }
            
        case .pricePercentage24hReversed:
            return coins.sorted { ($0.priceChangePercentage24H ?? 0.0) > ($1.priceChangePercentage24H ?? 0.0) }
            
        case .pricePercentage7d:
            return coins.sorted { ($0.priceChangePercentage7D ?? 0.0) < ($1.priceChangePercentage7D ?? 0.0) }
            
        case .pricePercentage7dReversed:
            return coins.sorted { ($0.priceChangePercentage7D ?? 0.0) > ($1.priceChangePercentage7D ?? 0.0) }
            
        case .volume24h:
            return coins.sorted { ($0.volume24h ?? 0.0) < ($1.volume24h ?? 0.0) }
            
        case .volume24hReversed:
            return coins.sorted { ($0.volume24h ?? 0.0) > ($1.volume24h ?? 0.0) }
            
        case .marketCap:
            return coins.sorted { ($0.marketCap ?? 0.0) < ($1.marketCap ?? 0.0) }
            
        case .marketCapReversed:
            return coins.sorted { ($0.marketCap ?? 0.0) > ($1.marketCap ?? 0.0) }
        }
    }
}
