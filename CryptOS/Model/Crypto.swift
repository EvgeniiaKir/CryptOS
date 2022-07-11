//
//  Crypto.swift
//  CryptOS
//
//  Created by Evgeniia Kiriushina on 07.07.2022.
//

import Foundation

struct Crypto: Hashable, Codable {
    var id: String
    var name: String
    var image: String
    var current_price: Double
}

struct CryptoInfo: Hashable, Codable {
    var id: String
    var name: String
    var description: Description
    var links: Links
}

struct Description: Hashable, Codable {
    var en: String
}

struct Links: Hashable, Codable {
    var homepage: [String]
}

struct PriceHistoryInfo: Hashable, Decodable {
    var prices: [[Double]]?
}

public struct DetailedCrypto: Hashable, Codable {
    var name: String?
    var description: String?
    var link: String?
}
