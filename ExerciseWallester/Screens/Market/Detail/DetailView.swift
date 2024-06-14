//
//  DetailView.swift
//  CoinGekoWallester
//
//  Created by Denis Sinitsa on 28.05.2024.
//

import Combine
import SwiftUI

struct DetailView: View {
    @ObservedObject var viewModel: DetailViewModel

    @State private var scrollOffset: CGFloat = 0

    typealias helpers = ViewHelpers

    var body: some View {
        ZStack {
            if viewModel.isLoading {
                LoadingView()
            } else {
                buildMainContent()
            }
        }
    }

    @ViewBuilder
    private func buildMainContent() -> some View {
        ScrollView {
            VStack(spacing: 10) {
                if let vm = viewModel.coinDetailData {
                    currencyInfoHeader(
                        image: vm.image!.thumb,
                        symbol: vm.symbol,
                        price: vm.marketData.currentPrice[viewModel.currencyCode] ?? 0.0,
                        rank: vm.rank ?? 0,
                        priceChangeIn24h: vm.marketData
                            .priceChangePercentage24HInCurrency[viewModel.currencyCode] ?? 0.0
                    )
                }

                if let data = viewModel.coinHistoricalChartData?.prices.flatMap({ $0 }) {
                    DetailChartView(viewModel: viewModel, data: data)
                }

                coinStatistics()
            }
            .background(GeometryReader {
                Color.clear.preference(key: ViewOffsetKey.self, value: $0.frame(in: .global).minY)
            })
            .padding(.horizontal, 10)
        }
        .overlay(alignment: .top) {
            if scrollOffset < -25 {
                if let vm = viewModel.coinDetailData {
                    customNavBar(
                        image: vm.image!.thumb,
                        name: vm.name,
                        price: vm.marketData.currentPrice[viewModel.currencyCode] ?? 0.0,
                        priceChangeIn24h: vm.marketData
                            .priceChangePercentage24HInCurrency[viewModel.currencyCode] ?? 0.0
                    )
                }
            }
        }
        .onPreferenceChange(ViewOffsetKey.self) { offset in
            self.scrollOffset = offset

        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private func currencyInfoHeader(image: String, symbol: String, price: Double, rank: Int,
                            priceChangeIn24h: Double) -> some View
    {
        VStack(spacing: 7) {
            HStack(spacing: 5) {
                AsyncImage(url: URL(string: image)!)
                    .frame(width: 20, height: 20)

                VStack(alignment: .leading) {
                    Text(symbol.uppercased())
                        .font(.fontSemiBoldSmall)
                        .fixedSize(horizontal: false, vertical: true)
                        .multilineTextAlignment(.leading)
                }

                HStack(spacing: 10) {
                    Text("\(symbol.uppercased()) \(viewModel.localeService.localizedString(forKey: "price"))")
                        .font(.fontRegularUltraSmall)
                        .frame(minWidth: 45, alignment: .leading)
                        .opacity(0.7)

                    Text("\(rank)")
                        .font(.fontRegularUltraSmall)
                        .padding(5)
                        .background(.gray.opacity(0.1))
                        .cornerRadius(5)
                }
                .padding(.leading, 3)

                Spacer()
            }

            HStack {
                Text("\(viewModel.currencySymbol)\(viewModel.localeService.formatNumber(price))")
                    .frame(minWidth: 25, alignment: .leading)
                    .font(.fontSemiBoldLarge)

                HStack(spacing: 2) {
                    helpers.getTriangle(priceChangeIn24h)
                    helpers.priceChangeView(priceChange: priceChangeIn24h)
                }
                .frame(maxWidth: 100, alignment: .leading)

                Spacer()
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 80)
    }

    private func customNavBar(image: String, name: String, price: Double, priceChangeIn24h: Double) -> some View {
        VStack {
            HStack {
                currencyInfoInNavBar(image: image, name: name, price: price, priceChangeIn24h: priceChangeIn24h)

                Spacer()
            }
            .foregroundColor(.black)
        }
        .background(.white)
        .frame(height: 12)
        .padding(.top, 5)
        .background(.white)
        .padding(.horizontal, 10)
    }

    private func currencyInfoInNavBar(image: String, name: String, price: Double, priceChangeIn24h: Double) -> some View {
        HStack(spacing: 4) {
            HStack(spacing: 2) {
                AsyncImage(url: URL(string: image)!)
                    .frame(width: 20, height: 20)

                Text(name)
                    .font(.fontSemiBoldSmall)
                    .fixedSize(horizontal: false, vertical: true)
                    .multilineTextAlignment(.leading)
            }
            .padding(.vertical, 5)

            HStack {
                Text("\(viewModel.currencySymbol)\(viewModel.localeService.formatNumber(price))")
                    .frame(minWidth: 25, alignment: .leading)
                    .font(.fontSemiBoldSmall)

                HStack(spacing: 2) {
                    helpers.getTriangle(priceChangeIn24h)
                    helpers.priceChangeView(priceChange: priceChangeIn24h)
                }
                .frame(minWidth: 50, alignment: .leading)

                Spacer()
            }
            .padding(.vertical, 5)
        }
    }

    private func coinStatistics() -> some View {
        VStack {
            HStack {
                Text("\(viewModel.name) \(viewModel.localeService.localizedString(forKey: "statistics"))")
                    .font(.fontSemiBoldLarge)

                Spacer()
            }

            Divider()

            statisticsField(
                text: viewModel.localeService.localizedString(forKey: "marketCap"),
                currencyCode: viewModel.currencySymbol,
                value: viewModel.coinDetailData?.marketData.marketCap[viewModel.currencyCode] ?? 0.0
            )

            statisticsField(
                text: viewModel.localeService.localizedString(forKey: "volume24h"),
                currencyCode: viewModel.currencySymbol,
                value: viewModel.coinDetailData?.marketData.totalVolume[viewModel.currencyCode] ?? 0.0
            )

            statisticsField(
                text: viewModel.localeService.localizedString(forKey: "circulatingSupply"),
                currencyCode: "",
                value: viewModel.coinDetailData?.marketData.circulatingSupply ?? 0.0
            )

            statisticsField(
                text: viewModel.localeService.localizedString(forKey: "totalSupply"),
                currencyCode: "",
                value: viewModel.coinDetailData?.marketData.totalSupply ?? 0.0
            )

            statisticsField(
                text: viewModel.localeService.localizedString(forKey: "maxSupply"),
                currencyCode: "",
                value: viewModel.coinDetailData?.marketData.maxSupply ?? 0.0
            )
        }
    }

    private func statisticsField(text: String, currencyCode: String, value: Double) -> some View {
        VStack {
            HStack {
                Text(text)
                    .font(.fontSemiBoldSmall)
                    .opacity(0.6)

                Spacer()

                Text("\(currencyCode) \(viewModel.localeService.formatNumber(value))")
                    .font(.fontRegularSmall)
            }
            .frame(height: 30)

            Divider()
        }
    }
}

#Preview {
    DetailView(viewModel: DetailViewModel(
        id: "ethereum",
        name: "Ethereum",
        currencyCode: "usd",
        currencySymbol: "$",
        coinSymbol: "ETH"
    ))
}
