//
//  MarketViewModel.swift
//  Wallester
//
//  Created by Denis Sinitsa on 20.05.2024.
//

import Combine
import Foundation
import SwiftUI

class MarketViewModel: ObservableObject, MarketCryptoCurrencyProtocol, TimerProtocol {
    @Published var allCoins: [CoinModel] = [] // list of all coins fetched from API
    @Published var sortedCoins: [CoinModel] = [] // coins sorted according to the selected sort option
    @Published var selectedCoin: CoinModel?
    @Published var sparklineIn7D: [Double] = []

    @Published var isLoading = false
    @Published var errorMessage: String? = nil
    @Published var sortOption: SortOption = .rank
    @Published var currencyCode: String? = ""
    @Published var currencySymbol: String? = ""
    @Published var coinSymbol: String? = ""
    @Published var navigateToDetailPage: Bool = false

    private var cancellables = Set<AnyCancellable>()
    private var locationManager = LocationManager()
    private var currencyService = CurrencyService.shared
    private var timer: AnyCancellable?

    init() {
        isLoading = true
        setupLocationManager()
        subscribers()
    }

    func subscribers() {
        subscribeToSortedCoinsUpdates()
        initializeDataFetchTimer()
    }

    func initializeDataFetchTimer() {
        timer = Timer.publish(every: 30, on: .main, in: .common).autoconnect()
            .sink { [weak self] _ in
                self?.fetchCryptoCurrencies(usingCurrencyCode: self?.currencyCode ?? "usd")
            }
        cancellables.insert(timer!)
    }

    func subscribeToSortedCoinsUpdates() {
        Publishers.CombineLatest($allCoins, $sortOption)
            .map { coins, sortOption in
                let sorted = self.sortCoins(sort: sortOption, coins: coins)
                return sorted
            }
            .assign(to: \.sortedCoins, on: self)
            .store(in: &cancellables)
    }

    func fetchCryptoCurrencies(usingCurrencyCode: String) {
        CoinDataService.shared.fetchCryptoCurrencies(currency: usingCurrencyCode, forceUpdate: true)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case let .failure(error):
                    print("Error fetching data, trying cached data: \(error)")
                    self?.fetchCachedCryptoCurrencies(usingCurrencyCode: self?.currencyCode ?? "usd")

                case .finished:
                    print("Finished fetching crypto data")
                    self?.isLoading = false
                }
            }, receiveValue: { [weak self] coins in
                self?.allCoins = coins
                self?.sparklineIn7D = coins.flatMap { $0.sparklineIn7D?.price ?? [] }
            })
            .store(in: &cancellables)
    }

    func fetchCachedCryptoCurrencies(usingCurrencyCode: String) {
        CoinDataService.shared.fetchCryptoCurrencies(currency: usingCurrencyCode, forceUpdate: false)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case let .failure(error):
                    print("Failed to fetch cached data: \(error)")

                case .finished:
                    print("Finished fetching cached crypto data")
                    self.isLoading = false
                }
            }, receiveValue: { coins in
                self.allCoins = coins
                self.sparklineIn7D = coins.flatMap { $0.sparklineIn7D?.price ?? [] }
            })
            .store(in: &cancellables)
    }

    func setupLocationManager() {
        locationManager.currency = { [weak self] currencyCode in
            self?.fetchCryptoCurrencies(usingCurrencyCode: currencyCode)

            if let symbol = self?.currencyService.getCurrencySymbol(for: currencyCode) {
                self?.currencyCode = currencyCode
                self?.currencySymbol = symbol

            } else {
                self?.currencySymbol = "$"
            }
        }
        locationManager.requestLocationAccess()
        locationManager.startUpdatingLocation()

        fetchDataIfLocationUnavailable()
    }

    // esli net dannqh o location, vse ravno vqzavaem
    func fetchDataIfLocationUnavailable() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) { [weak self] in
            if self?.currencySymbol == "" {
                self?.fetchCryptoCurrencies(usingCurrencyCode: "usd")
                self?.currencySymbol = "$"
            }
        }
    }

    func selectCoin(_ coin: CoinModel) {
        selectedCoin = coin
        navigateToDetailPage = true
    }
}
