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
            ("Max", "max")
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
                viewModel.fetchCryptoHistoricalChartData(id: viewModel.id, currencyCode: viewModel.currencyCode, timeframe: timeframe)
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
                    Text("\(priceHigher.formatNumber)")
                        .frame(maxWidth: 60)
                }
                
                ForEach(pricesToShow(), id: \.self) { price in
                    HStack {
                        ZStack {
                            Divider()
                        }
                        Text("\(price.formatNumber)")
                            .frame(maxWidth: 60)
                    }
                }
                
                HStack {
                    ZStack {
                        Divider()
                    }
                    Text("\(priceLower.formatNumber)")
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

#Preview {
    DetailChartView(viewModel: DetailViewModel(id: "ethereum", name: "Ethereum", currencyCode: "usd", currencySymbol: "$", coinSymbol: "ETH"), data: [3401.843655996634, 3419.793217060178, 3407.835401114872, 3377.513159034392, 3420.3480433930995, 3439.888677826772, 3447.3778135346915, 3441.683336291546, 3441.6644312245194, 3442.747775675738, 3433.4804503257237, 3420.4322448501066, 3425.3468613449236, 3437.931172723552, 3450.1101699188916, 3475.1664052867495, 3457.5039248748344, 3452.022695664036, 3452.289337238462, 3447.4322680556156, 3460.806187618847, 3472.5047237512995, 3436.865530053698, 3447.3078177130997, 3443.2366440675537, 3457.5294848462236, 3448.59140008858, 3456.4301284493204, 3448.5510978251973, 3462.844691345752, 3463.587646525585, 3452.656905091575, 3448.00196720818, 3450.3793742916123, 3457.831593505517, 3453.642250306763, 3464.2106031717776, 3445.545489553795, 3472.470379669516, 3454.9164903857986, 3464.3204259732815, 3466.577173256941, 3490.4279519867578, 3487.3938941660263, 3507.0541605939698, 3508.8447862033395, 3510.006072154783, 3506.4868444721947, 3509.5992041593167, 3550.9635113532413, 3535.3069146402586, 3559.8471681930914, 3546.6989438461114, 3544.2713325660793, 3564.4423095454063, 3557.182103054959, 3550.7995271868267, 3534.0142570021517, 3525.3983823466265, 3536.5526016379786, 3577.7641257737064, 3610.5864111118676, 3605.2610562653745, 3607.3444960608463, 3601.1640168859394, 3593.637996898256, 3606.724190272433, 3605.881200689149, 3591.554891961233, 3601.8351741545725, 3591.4089178968425, 3604.085846444867, 3618.120194852748, 3631.58731664622, 3645.8989025927654, 3633.275340137397, 3625.6942209101812, 3612.4222632925043, 3564.57009954096, 3578.777424105468, 3575.5427180745355, 3575.9879126159585, 3585.3029767506905, 3566.392106389303, 3530.4309943098197, 3548.666714826918, 3542.8785136393967, 3523.9813049173094, 3546.374228724134, 3543.966404349898, 3534.7992016238727, 3562.754365040948, 3565.6059580935694, 3585.8034303805857, 3578.9080723721854, 3573.3341981836566, 3545.086913831386, 3546.137645892667, 3545.273795364613, 3513.046631355237, 3514.7110241791006, 3499.3685621148447, 3526.6371134249057, 3525.656976714])
}
