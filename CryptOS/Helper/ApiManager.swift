//
//  ApiManager.swift
//  CryptOS
//
//  Created by Evgeniia Kiriushina on 07.07.2022.
//

import Foundation

final class ApiManager {
    
    func loadGeneralData(results: inout [Crypto]) async {
        guard let url = URL(string: "https://api.coingecko.com/api/v3/coins/markets?vs_currency=eur&order=market_cap_desc&per_page=10&page=1&sparkline=false") else {
            print("Invalid URL")
            return
        }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let decodedResponse = try? JSONDecoder().decode([Crypto].self, from: data) {
                results = decodedResponse
            }
        } catch {
            print("Invalid data")
        }
    }
    
    func loadDetailedData(id: String, results: inout DetailedCrypto) async {
        guard let url = URL(string: "https://api.coingecko.com/api/v3/coins/\(id)?localization=false&tickers=false&market_data=true&community_data=true&developer_data=false&sparkline=false") else {
            print("Invalid URL")
            return
        }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let decodedResponse = try? JSONDecoder().decode(CryptoInfo.self, from: data) {
                results = self.fillDetailedCryptoStruct(json: decodedResponse)
            }
        } catch {
            print("Invalid data")
        }
    }
    
    func loadPricesData(id: String, results: inout [(date: String, price: Double)]) async {
        guard let url = URL(string: "https://api.coingecko.com/api/v3/coins/\(id)/market_chart?vs_currency=eur&days=7&interval=daily") else {
            print("Invalid URL")
            return
        }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let decodedResponse = try? JSONDecoder().decode(PriceHistoryInfo.self, from: data) {
                results = self.fillWeekPricesArray(json: decodedResponse)
            }
        } catch {
            print("Invalid data")
        }
    }
    
    func fillDetailedCryptoStruct(json: CryptoInfo) -> DetailedCrypto {
        let name = json.name
        let description = json.description.en.html2String
        let link = json.links.homepage[0]
        return DetailedCrypto(name: name, description: description, link: link)
    }
    
    func fillWeekPricesArray(json: PriceHistoryInfo) -> [(date: String, price: Double)] {
        var weekPrices = [(date: String, price: Double)]()
        guard let priceHystory = json.prices else {
            return weekPrices
        }
        for item in priceHystory {
            let milliseconds = Int64(item[0])
            let date = Date(milliseconds: milliseconds)
            let formatter = DateFormatter()
            formatter.dateStyle = .short
            let stringDate = formatter.string(from: date)
            let price = item[1]
            weekPrices.append((date: stringDate, price: price))
        }
        weekPrices.removeLast()
        return weekPrices
    }
}
