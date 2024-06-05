//
//  LocationManager.swift
//  CoinGekoWallester
//
//  Created by Denis Sinitsa on 26.05.2024.
//

import CoreLocation
import Foundation

class LocationManager: NSObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    private let geocoder = CLGeocoder()

    var currency: ((String) -> Void)?

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }

    func requestLocationAccess() {
        locationManager.requestWhenInUseAuthorization()
    }

    func startUpdatingLocation() {
        locationManager.startUpdatingLocation()
    }

    func locationManager(_: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation() // dlja sohranenija battery
            determineCurrency(location: location)
        }
    }

    func locationManager(_: CLLocationManager, didFailWithError error: Error) {
        print("Failed to find user's location: \(error.localizedDescription)")
    }

    func determineCurrency(location: CLLocation) {
        geocoder.reverseGeocodeLocation(location) { [weak self] placemarks, error in
            if let error = error {
                print("Geocoding failed: \(error)")
                self?.currency?("usd")
                return
            }

            if let placemark = placemarks?.first, let countryCode = placemark.isoCountryCode {
                self?.fetchCurrencyCode(for: countryCode)
            } else {
                print("Country not found")
                self?.currency?("usd")
            }
        }
    }

    private func fetchCurrencyCode(for countryCode: String) {
        let currencyCode = CurrencyService.shared.currencyCode(for: countryCode) ?? "USD"
        let lowerCasedCurrency = currencyCode.lowercased()
        currency?(lowerCasedCurrency)
    }
}
