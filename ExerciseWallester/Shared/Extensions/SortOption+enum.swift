//
//  SortOption+enum.swift
//  CoinGekoWallester
//
//  Created by Denis Sinitsa on 24.05.2024.
//

import Foundation

extension MarketViewModel {
    enum SortOption {
        case rank, rankReversed
        case price, priceReversed
        case pricePercentage1h, pricePercentage1hReversed
        case pricePercentage24h, pricePercentage24hReversed
        case pricePercentage7d, pricePercentage7dReversed
        case marketCap, marketCapReversed
        case volume24h, volume24hReversed
    }
}
