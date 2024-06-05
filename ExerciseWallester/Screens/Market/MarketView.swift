//
//  MarketView.swift
//  Wallester
//
//  Created by Denis Sinitsa on 20.05.2024.
//

import SwiftUI

struct MarketView: View {
    @StateObject var viewModel = MarketViewModel()

    var body: some View {
        NavigationStack {
            ScrollView {
                CoinListView(viewModel: viewModel)
            }
            .fullScreenCover(isPresented: $viewModel.isLoading) {
                LoadingView()
            }
        }
    }
}

#Preview {
    MarketView()
}
