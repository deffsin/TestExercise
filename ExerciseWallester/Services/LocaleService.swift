//
//  LocaleService.swift
//  ExerciseWallester
//
//  Created by Denis Sinitsa on 06.06.2024.
//

import Foundation
import Foundation

class LocaleService {
    static let shared = LocaleService()
    
    private init() {}
    
    func formatNumber(_ number: Double) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.locale = Locale.current
        
        return numberFormatter.string(from: NSNumber(value: number)) ?? "\(number)"
    }
    
    func getCurrentLanguage() -> String {
        let preferredLanguage = Locale.preferredLanguages.first ?? "en"
        if preferredLanguage.starts(with: "ru") {
            return "ru"
        } else {
            return "en"
        }
    }
    
    func localizedString(forKey key: String) -> String {
        return NSLocalizedString(key, comment: "")
    }
}
