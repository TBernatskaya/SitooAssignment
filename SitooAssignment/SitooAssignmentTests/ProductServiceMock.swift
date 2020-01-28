//
//  ProductServiceMock.swift
//  SitooAssignmentTests
//
//  Created by Tatiana Bernatskaya on 2020-01-28.
//  Copyright © 2020 Tatiana Bernatskaya. All rights reserved.
//

import UIKit
@testable import SitooAssignment

struct ProductServiceMock: ProductService {
    var shouldReturnError: Bool
    let error = NSError(domain: "Service", code: 456, userInfo: nil)

    func fetchImage(by productID: Int, completion: @escaping (UIImage?) -> ()) {}

    func fetchProduct(by productID: Int, completion: @escaping (Product?, Error?) -> ()) {
        if shouldReturnError {
            completion(nil, error)
        } else {
            completion(Product(
                id: 1,
                title: "Test product",
                description: "Description text",
                deliveryStatus: "Shipped",
                price: "123.00"
            ), nil)
        }
    }

    func fetchProductList(startIndex: Int, itemsCount: Int, completion: @escaping (ProductList?, Error?) -> ()) {
        if shouldReturnError {
            completion(nil, error)
        } else {
            completion(ProductList(
                totalCount: 2,
                products:
                    [ProductList.ProductListItem(id: 1, title: "Test product 1", price: "123.00"),
                     ProductList.ProductListItem(id: 2, title: "Test product 2", price: "456.00"
                    )]
            ), nil)
        }
    }
}
