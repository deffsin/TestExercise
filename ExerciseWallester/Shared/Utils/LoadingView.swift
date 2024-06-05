//
//  LoadingView.swift
//  TestExerciseWallester
//
//  Created by Denis Sinitsa on 03.06.2024.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        ZStack {
            Color.white.opacity(0.4)
                .ignoresSafeArea(.all)
            
            ProgressView("Loading...")
                .progressViewStyle(.circular)
        }
    }
}
