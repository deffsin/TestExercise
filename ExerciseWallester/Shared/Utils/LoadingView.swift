//
//  LoadingView.swift
//  TestExerciseWallester
//
//  Created by Denis Sinitsa on 03.06.2024.
//

import SwiftUI

struct LoadingView: View {
    private var localeService = LocaleService.shared
    
    var body: some View {
        ZStack {
            Color.white.opacity(0.4)
                .ignoresSafeArea(.all)

            ProgressView(localeService.localizedString(forKey: "loading"))
                .progressViewStyle(.circular)
        }
    }
}
