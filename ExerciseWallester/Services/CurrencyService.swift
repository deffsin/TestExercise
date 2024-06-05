//
//  CurrencyService.swift
//  CoinGekoWallester
//
//  Created by Denis Sinitsa on 26.05.2024.
//

import SwiftUI

class CurrencyService {
    static let shared = CurrencyService()

    private init() {}

    func getCurrencySymbol(for currencyCode: String) -> String? {
        let locale = NSLocale(localeIdentifier: currencyCode)
        return locale.displayName(forKey: .currencySymbol, value: currencyCode)
    }
    
    // polu4aem currencyCode 4erez Locale
    func currencyCode(for countryCode: String) -> String? {
        let localeIdentifier = Locale.identifier(fromComponents: [NSLocale.Key.countryCode.rawValue: countryCode])
        let locale = Locale(identifier: localeIdentifier)
        return locale.currency?.identifier
    }
}
