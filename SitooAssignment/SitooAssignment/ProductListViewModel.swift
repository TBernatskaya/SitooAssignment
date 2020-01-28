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
    var hasFetchedAll: Bool { get }
    var isFetching: Bool { get }

    func fetchProduct(by index: Int, completion: @escaping (Product?, String?) -> ())
    func fetchProductList(completion: @escaping (ProductList?, String?) -> ())
}

class ProductListViewModelImpl: ProductListViewModel {

    let productService: ProductService
    var hasFetchedAll: Bool {
        guard let list = list else { return false }
        return list.totalCount <= list.products.count
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

    func fetchProduct(by index: Int, completion: @escaping (Product?, String?) -> ()) {
        productService.fetchProduct(by: index, completion: { product, error in
            guard let product = product
            else {
                return completion(nil, error?.localizedDescription ?? "Could not fetch a product")
            }
            completion(product, error?.localizedDescription)
        })
    }

    func fetchProductList(completion: @escaping (ProductList?, String?) -> ()) {
        isFetching = true
        let startIndex = nextIndex > 0 ? nextIndex : defaultStartIndex

        productService.fetchProductList(startIndex: startIndex, itemsCount: itemsInPage, completion: { list, error in
            guard let newList = list
            else {
                self.isFetching = false
                return completion(nil, error?.localizedDescription ?? "Could not fetch a product list")
            }
            
            if var oldList = self.list {
                oldList.products.append(contentsOf: newList.products)
                self.list?.products = oldList.products
            } else {
                self.list = newList
            }

            self.nextIndex += self.itemsInPage
            self.isFetching = false
            completion(list, error?.localizedDescription)
        })
    }
}
