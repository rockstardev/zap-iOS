//
//  Zap
//
//  Created by Otto Suess on 31.03.18.
//  Copyright © 2018 Otto Suess. All rights reserved.
//

import Foundation

final class ExchangeUpdaterJob: SchedulerJob {    
    func run() {
        guard let url = URL(string: "https://blockchain.info/ticker") else { fatalError("Invalid ticker url.") }
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            if error != nil {
                print(String(describing: error))
            } else if let data = data,
                let jsonData = try? JSONSerialization.jsonObject(with: data, options: []),
                let json = jsonData as? [String: Any] {
                ExchangeData.availableCurrencies = json.compactMap { self?.parseFiatCurrency(for: $0, data: $1) }
            }
        }
        task.resume()
    }
    
    func parseFiatCurrency(for currencyCode: String, data: Any) -> FiatCurrency? {
        guard
            let localized = Locale.current.localizedString(forCurrencyCode: currencyCode),
            let data = data as? [String: Any],
            let symbol = data["symbol"] as? String,
            let valueNumber = data["15m"] as? NSNumber
            else { return nil }
        let exchangeRate = NSDecimalNumber(decimal: valueNumber.decimalValue)
        
        return FiatCurrency(currencyCode: currencyCode, symbol: symbol, localized: localized, exchangeRate: exchangeRate)
    }
}

final class ExchangeData {
    static var availableCurrencies: [FiatCurrency]? {
        didSet {
            guard let availableCurrencies = availableCurrencies else { return }
            
            let currentFiatCurrencyCode = Settings.fiatCurrency.value.currencyCode
            if let updatedCurrency = availableCurrencies.first(where: { $0.currencyCode == currentFiatCurrencyCode }) {
                Settings.updateCurrency(updatedCurrency)
            }
            
            print(availableCurrencies)
        }
    }
}
