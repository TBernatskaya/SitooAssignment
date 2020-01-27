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
    let listItems: [ProductListItem]

    enum CodingKeys: String, CodingKey {
        case totalCount = "totalcount"
        case listItems = "items"
    }

    struct ProductListItem: Codable {
        let title: String
        let price: String

        enum CodingKeys: String, CodingKey {
            case title
            case price = "moneyprice"
        }
    }
}
