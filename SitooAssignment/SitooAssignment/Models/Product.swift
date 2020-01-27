//
//  Product.swift
//  SitooAssignment
//
//  Created by Tatiana Bernatskaya on 2020-01-27.
//  Copyright © 2020 Tatiana Bernatskaya. All rights reserved.
//

import Foundation

struct Product: Codable {
    let id: Int
    let title: String
    let description: String
    let deliveryStatus: String
    let price: String

    enum CodingKeys: String, CodingKey {
        case id = "productid"
        case deliveryStatus = "deliverystatus"
        case title, description
        case price = "moneyprice"
    }
}
