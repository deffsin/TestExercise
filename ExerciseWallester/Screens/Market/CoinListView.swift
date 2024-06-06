//
//  CoinListView.swift
//  CoinGekoWallester
//
//  Created by Denis Sinitsa on 22.05.2024.
//

import SwiftUI

struct CoinListView: View {
    @ObservedObject var viewModel: MarketViewModel
    @State private var rowHeights: [String: CGFloat] = [:]
    
    typealias helpers = ViewHelpers

    var body: some View {
        VStack {
            ScrollView {
                buildMainContent()
            }

            NavigationLink(
                destination: MarketNavigation
                    .detail(id: viewModel.selectedCoin?.id ?? "", name: viewModel.selectedCoin?.name ?? "",
                            currencyCode: viewModel.currencyCode ?? "", currencySymbol: viewModel.currencySymbol ?? "",
                            coinSymbol: viewModel.selectedCoin?.symbol ?? ""),
                isActive: $viewModel.navigateToDetailPage
            ) {
                EmptyView()
            }
        }
        .padding(.horizontal, 10)
    }

    @ViewBuilder
    func buildMainContent() -> some View {
        HStack(spacing: 0) {
            VStack(spacing: 0) {
                leftListHeader()
                ForEach(viewModel.sortedCoins, id: \.id) { coin in
                    VStack(spacing: 0) {
                        HStack(spacing: 0) {
                            leftSide(
                                rank: coin.rank,
                                image: coin.image,
                                name: coin.name,
                                symbol: coin.symbol,
                                coinModel: coin
                            )
                            .background(GeometryReader { geo in
                                Color.clear
                                    .onAppear {
                                        rowHeights[coin.id] = geo.size.height
                                    }
                                    .onChange(of: geo.size.height) { newHeight in
                                        rowHeights[coin.id] = newHeight
                                    }
                            })
                        }
                        .frame(maxHeight: 95)

                        helpers.customDivider()
                    }
                }
            }

            ScrollView(.horizontal) {
                VStack(spacing: 0) {
                    rightListHeader(viewModel: viewModel)
                    ForEach(viewModel.sortedCoins, id: \.id) { coin in
                        rightSide(
                            currentPrice: coin.currentPrice,
                            priceChange1H: coin.priceChangePercentage1H ?? 0.0,
                            priceChange24H: coin.priceChangePercentage24H ?? 0.0,
                            priceChange7D: coin.priceChangePercentage7D ?? 0.0,
                            volume24h: coin.volume24h ?? 0.0,
                            marketCap: coin.marketCap ?? 0.0,
                            id: coin.id,
                            sparkline: coin.sparklineIn7D,
                            viewModel: viewModel
                        )
                        .frame(height: rowHeights[coin.id] ?? 0)

                        helpers.customDivider()
                    }
                }
            }
        }
    }

    private func leftListHeader() -> some View {
        VStack(spacing: 0) {
            HStack(spacing: 8) {
                Image(systemName: "arrowtriangle.up.fill")
                    .font(.system(size: 7))
                    .rotationEffect(Angle(degrees: viewModel.sortOption == .rank ? 0 : 180))
                    .onTapGesture {
                        viewModel.sortOption = viewModel.sortOption == .rank ? .rankReversed : .rank
                    }

                Text("#")
                    .font(.system(size: 9))

                Text(viewModel.localeService.localizedString(forKey: "coin"))
                    .font(.fontSemiBoldUltraSmall)

                Spacer()
            }
            .frame(width: 185)

            helpers.customDivider()
        }
    }

    private func rightListHeader(viewModel: MarketViewModel) -> some View {
        VStack(spacing: 0) {
            HStack(spacing: 10) {
                createHeaderColumn(
                    title: viewModel.localeService.localizedString(forKey: "price"),
                    maxWidth: 115,
                    sortOption: .price,
                    sortOptionReversed: .priceReversed,
                    viewModel: viewModel
                )

                createHeaderColumn(
                    title: viewModel.localeService.localizedString(forKey: "hour1"),
                    maxWidth: 70,
                    sortOption: .pricePercentage1h,
                    sortOptionReversed: .pricePercentage1hReversed,
                    viewModel: viewModel
                )

                createHeaderColumn(
                    title: viewModel.localeService.localizedString(forKey: "hours24"),
                    maxWidth: 85,
                    sortOption: .pricePercentage24h,
                    sortOptionReversed: .pricePercentage24hReversed,
                    viewModel: viewModel
                )

                createHeaderColumn(
                    title: viewModel.localeService.localizedString(forKey: "days7"),
                    maxWidth: 83,
                    sortOption: .pricePercentage7d,
                    sortOptionReversed: .pricePercentage7dReversed,
                    viewModel: viewModel
                )

                createHeaderColumn(
                    title: viewModel.localeService.localizedString(forKey: "volume24h"),
                    maxWidth: 155,
                    sortOption: .volume24h,
                    sortOptionReversed: .volume24hReversed,
                    viewModel: viewModel
                )

                createHeaderColumn(
                    title: viewModel.localeService.localizedString(forKey: "marketCap"),
                    maxWidth: 175,
                    sortOption: .marketCap,
                    sortOptionReversed: .marketCapReversed,
                    viewModel: viewModel
                )

                createHeaderColumn(
                    title: viewModel.localeService.localizedString(forKey: "last7Days"),
                    maxWidth: 170,
                    sortOption: .marketCap,
                    sortOptionReversed: .marketCapReversed,
                    viewModel: viewModel
                )

                Spacer()
            }
            .padding(.leading, 10)
            .frame(width: 940)

            helpers.customDivider()
        }
    }

    private func createHeaderColumn(
        title: String,
        maxWidth: CGFloat,
        sortOption: MarketViewModel.SortOption,
        sortOptionReversed: MarketViewModel.SortOption,
        viewModel: MarketViewModel
    ) -> some View {
        HStack(spacing: 5) {
            Image(systemName: "arrowtriangle.up.fill")
                .font(.system(size: 7))
                .rotationEffect(Angle(degrees: viewModel.sortOption == sortOption ? 0 : 180))
                .onTapGesture {
                    viewModel.sortOption = viewModel.sortOption == sortOption ? sortOptionReversed : sortOption
                }

            Text(title)
                .font(.fontRegularUltraSmall)
                .lineLimit(1)
        }
        .frame(maxWidth: maxWidth, alignment: .trailing)
    }

    private func leftSide(rank: Int, image: String, name: String, symbol: String, coinModel: CoinModel) -> some View {
        HStack(spacing: 1) {
            HStack(spacing: 5) {
                Text("\(rank)")
                    .font(.fontRegularSmall)
                    .frame(maxWidth: 20, alignment: .leading)
            }

            HStack {
                AsyncImage(url: URL(string: image)!)
                    .frame(width: 20, height: 20)

                VStack(alignment: .leading) {
                    Text(name)
                        .font(.fontSemiBoldSmall)
                        .fixedSize(horizontal: false, vertical: true)
                        .multilineTextAlignment(.leading)

                    Text(symbol.uppercased())
                        .font(.fontSemiBoldSmall)
                        .foregroundColor(.gray)
                }
            }
            .padding(.vertical, 20)
            .padding(.leading, 10)
            .onTapGesture {
                withAnimation(.easeIn(duration: 2)) {
                    viewModel.selectCoin(coinModel)
                }
            }

            Spacer()
        }
        .frame(width: 185)
    }

    private func rightSide(
        currentPrice: Double,
        priceChange1H: Double,
        priceChange24H: Double,
        priceChange7D: Double,
        volume24h: Double,
        marketCap: Double,
        id _: String,
        sparkline: SparklineIn7D?,
        viewModel: MarketViewModel
    ) -> some View {
        HStack(spacing: 5) {
            VStack {
                Text("\(viewModel.currencySymbol ?? "usd") \(viewModel.localeService.formatNumber(currentPrice))")
                    .font(.fontRegularUltraSmall)
            }
            .frame(maxWidth: 105, alignment: .trailing)

            HStack(spacing: 25) {
                priceChangeColumn(priceChange: priceChange1H, maxWidth: 100)
                priceChangeColumn(priceChange: priceChange24H, maxWidth: 100)
                priceChangeColumn(priceChange: priceChange7D, maxWidth: 100)
            }
            .frame(width: 255, alignment: .trailing)
            .padding(.leading, 10)

            Text("\(viewModel.currencySymbol!) \(viewModel.localeService.formatNumber(volume24h))")
                .font(.fontRegularUltraSmall)
                .frame(maxWidth: 160, alignment: .trailing)

            Text("\(viewModel.currencySymbol!) \(viewModel.localeService.formatNumber(marketCap))")
                .font(.fontRegularUltraSmall)
                .frame(maxWidth: 180, alignment: .trailing)

            if let sparklineData = sparkline?.price {
                let color: Color = priceChange7D > 0 ? .green : .red
                ChartView(sparklineIn7D: sparklineData, lineColor: color)
                    .padding(.leading, 25)
            }
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 3)
        .frame(width: 940)
    }

    private func priceChangeColumn(priceChange: Double, maxWidth: CGFloat) -> some View {
        HStack(spacing: 2) {
            helpers.getTriangle(priceChange)
            helpers.priceChangeView(priceChange: priceChange)
        }
        .frame(maxWidth: maxWidth, alignment: .trailing)
    }
}

#Preview {
    CoinListView(viewModel: MarketViewModel())
}
