//
//  ViewOffsetKey.swift
//  CoinGekoWallester
//
//  Created by Denis Sinitsa on 28.05.2024.
//

import SwiftUI

struct ViewOffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = 0

    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value += nextValue()
    }
}
