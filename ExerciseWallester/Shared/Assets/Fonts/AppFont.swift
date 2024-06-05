//
//  AppFont.swift
//  CoinGekoWallester
//
//  Created by Denis Sinitsa on 22.05.2024.
//

import SwiftUI

enum AppFont {
    case semiBold
    case regular
    
    func font(size: CGFloat) -> Font {
        switch self {
        case .semiBold:
            if let customFont = UIFont(name: "Poppins-SemiBold", size: size) {
                return Font(customFont)
            }
            return Font.system(size: size, weight: .semibold, design: .default)
            
        case .regular:
            if let customFont = UIFont(name: "Poppins-Regular", size: size) {
                return Font(customFont)
            }
            return Font.system(size: size, weight: .regular, design: .default)
        }
    }
}
