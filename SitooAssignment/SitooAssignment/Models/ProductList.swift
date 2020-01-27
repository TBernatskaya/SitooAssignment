//
//  ProductList.swift
//  SitooAssignment
//
//  Created by Tatiana Bernatskaya on 2020-01-27.
//  Copyright © 2020 Tatiana Bernatskaya. All rights reserved.
//

import Foundation

struct ProductList: Codable {
    let totalCount: Int
    let products: [ProductListItem]

    enum CodingKeys: String, CodingKey {
        case totalCount = "totalcount"
        case products = "items"
    }

    struct ProductListItem: Codable {
        let id: Int
        let title: String
        let price: String

        enum CodingKeys: String, CodingKey {
            case id = "productid"
            case title
            case price = "moneyprice"
        }
    }
}
