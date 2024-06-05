//
//  MarketCryptoCurrencyProtocol.swift
//  TestExerciseWallester
//
//  Created by Denis Sinitsa on 03.06.2024.
//

import Foundation

protocol MarketCryptoCurrencyProtocol {
    func fetchDataIfLocationUnavailable()
    func subscribeToSortedCoinsUpdates()
    func fetchCryptoCurrencies(usingCurrencyCode: String)
    func fetchCachedCryptoCurrencies(usingCurrencyCode: String)
    func setupLocationManager()
    func selectCoin(_ coin: CoinModel)
}
