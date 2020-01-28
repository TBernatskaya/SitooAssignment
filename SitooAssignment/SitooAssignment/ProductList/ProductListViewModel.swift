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
    var hasNextPage: Bool { get }
    var isFetching: Bool { get }

    func fetchProductList(completion: @escaping (ProductList?, String?) -> ())
}

class ProductListViewModelImpl: ProductListViewModel {

    let productService: ProductService
    var hasNextPage: Bool {
        guard let list = list else { return true }
        return list.totalCount > list.products.count
    }
    var isFetching: Bool = false

    var list: ProductList?
    var nextIndex: Int

    let defaultStartIndex = 0
    let itemsInPage = 15

    init(productService: ProductService = ProductServiceImpl()) {
        self.productService = productService
        self.nextIndex = defaultStartIndex
    }

    func fetchProductList(completion: @escaping (ProductList?, String?) -> ()) {
        isFetching = true
        let startIndex = nextIndex > 0 ? nextIndex : defaultStartIndex

        productService.fetchProductList(startIndex: startIndex, itemsCount: itemsInPage, completion: { list, error in
            self.isFetching = false
            guard let newList = list
            else {
                return completion(nil, error?.localizedDescription ?? "Could not fetch a product list")
            }

            if var oldList = self.list {
                oldList.products.append(contentsOf: newList.products)
                self.list?.products = oldList.products
            } else {
                self.list = newList
            }

            self.nextIndex += self.itemsInPage
            completion(list, error?.localizedDescription)
        })
    }
}
