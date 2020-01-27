//
//  ProductListViewModel.swift
//  SitooAssignment
//
//  Created by Tatiana Bernatskaya on 2020-01-27.
//  Copyright © 2020 Tatiana Bernatskaya. All rights reserved.
//

import Foundation

protocol ProductListViewModel {
    var list: ProductList? { get }
    func fetchProductList(completion: @escaping (ProductList?, Error?) -> ())
}

class ProductListViewModelImpl: ProductListViewModel {
    var list: ProductList?
    let productService: ProductService
    let defaultStartIndex = 0
    let itemsInPage = 10

    init(productService: ProductService = ProductServiceImpl()) {
        self.productService = productService
    }

    func fetchProductList(completion: @escaping (ProductList?, Error?) -> ()) {
        productService.fetchProductList(startIndex: defaultStartIndex, itemsCount: itemsInPage, completion: { list, error in
            guard let list = list else { return completion(nil, error) }
            self.list = list
            completion(list, error)
        })
    }
}
