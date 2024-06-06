//
//  DetailChartView.swift
//  CoinGekoWallester
//
//  Created by Denis Sinitsa on 29.05.2024.
//

import SwiftUI

struct DetailChartView: View {
    @ObservedObject var viewModel: DetailViewModel

    @State private var selectedButton: String = "24h"

    var data: [Double]
    var priceHigher: Double {
        let maxPrice = data.max() ?? 0
        let range = (data.max() ?? 0) - (data.min() ?? 0)
        let step = range / 8

        return maxPrice + step
    }

    var priceLower: Double {
        let minPrice = data.min() ?? 0
        let range = (data.max() ?? 0) - (data.min() ?? 0)
        let step = range / 8

        return minPrice - step
    }

    var body: some View {
        ZStack {
            buildMainContent()
        }
    }

    @ViewBuilder
    func buildMainContent() -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 5) {
                textHeader()
                chartSegmentedView(selectedButton: $selectedButton)
                chartView()
                    .padding(.vertical, 95)
                Spacer()
            }
        }
    }

    func textHeader() -> some View {
        VStack {
            Text("\(viewModel.name) Price Chart (\(viewModel.coinSymbol))")
                .font(.fontSemiBoldUltraSmall)
        }
    }

    func chartSegmentedView(selectedButton: Binding<String>) -> some View {
        let buttons = [
            ("24h", "1"),
            ("7d", "7"),
            ("1m", "30"),
            ("3m", "90"),
            ("Max", "max"),
        ]

        return ZStack {
            HStack(spacing: 5) {
                ForEach(buttons, id: \.0) { button in
                    chartButton(label: button.0, timeframe: button.1, selectedButton: selectedButton)
                }
            }
        }
        .frame(width: 275, height: 50)
        .foregroundStyle(.black)
        .background(Color.blue.opacity(0.1))
        .cornerRadius(10)
    }

    func chartButton(label: String, timeframe: String, selectedButton: Binding<String>) -> some View {
        Button(action: {
            withAnimation(.bouncy(duration: 1.0)) {
                selectedButton.wrappedValue = label
                viewModel.timeframe = timeframe
                viewModel.fetchCryptoHistoricalChartData(
                    id: viewModel.id,
                    currencyCode: viewModel.currencyCode,
                    timeframe: timeframe
                )
            }
        }) {
            Text(label)
                .padding(.horizontal, 10)
                .padding(.vertical, 8)
                .background(selectedButton.wrappedValue == label ? Color.white : Color.clear)
                .foregroundColor(.black)
                .cornerRadius(5)
        }
    }

    func chartView() -> some View {
        ZStack {
            HStack {
                if !data.isEmpty {
                    LineGraph(dataPoints: data)
                        .stroke(Color.green, style: StrokeStyle(lineWidth: 1, lineCap: .round, lineJoin: .round))
                        .frame(maxHeight: 350)
                        .padding(.trailing, 72)

                } else {
                    Text("No historical chart data available")
                        .frame(width: 140)
                }
            }

            VStack(alignment: .leading, spacing: 52) {
                HStack {
                    ZStack {
                        Divider()
                    }
                    Text("\(priceHigher.formattedForDetailChart)")
                        .frame(maxWidth: 60)
                }

                ForEach(pricesToShow(), id: \.self) { price in
                    HStack {
                        ZStack {
                            Divider()
                        }
                        Text("\(price.formattedForDetailChart)")
                            .frame(maxWidth: 60)
                    }
                }

                HStack {
                    ZStack {
                        Divider()
                    }
                    Text("\(priceLower.formattedForDetailChart)")
                        .frame(maxWidth: 60)
                }
            }
            .font(.fontRegularUltraSmall)
            .opacity(0.8)
            .frame(minWidth: 50)
            .frame(height: 350)
        }
        .frame(maxHeight: 350)
    }

    func pricesToShow() -> [Double] {
        let maxPrice = data.max() ?? 0
        let minPrice = data.min() ?? 0
        let range = maxPrice - minPrice
        let step = range / 5

        return stride(from: maxPrice, through: minPrice, by: -step).map { $0 }
    }
}
