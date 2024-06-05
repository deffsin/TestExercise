//
//  DetailCryptoCurrencyProtocol.swift
//  TestExerciseWallester
//
//  Created by Denis Sinitsa on 03.06.2024.
//

import Foundation

protocol DetailCryptoCurrencyProtocol {
    func fetchCryptoData(id: String, currencyCode: String)
    func fetchCachedCryptoData(id: String, currencyCode: String)
    func fetchCryptoHistoricalChartData(id: String, currencyCode: String, timeframe: String)
    func fetchCachedHistoricalChartData(id: String, currencyCode: String, timeframe: String)
}
