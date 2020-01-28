//
//  ProductDetailsViewModel.swift
//  SitooAssignment
//
//  Created by Tatiana Bernatskaya on 2020-01-28.
//  Copyright © 2020 Tatiana Bernatskaya. All rights reserved.
//

import UIKit

protocol ProductDetailsViewModel {
    func fetchImage(by productID: Int, completion: @escaping (UIImage?) -> ())
    func fetchProduct(by index: Int, completion: @escaping (Product?, String?) -> ())
}

class ProductDetailsViewModelImpl: ProductDetailsViewModel {
    let productService: ProductService

    init(productService: ProductService = ProductServiceImpl()) {
        self.productService = productService
    }

    func fetchImage(by productID: Int, completion: @escaping (UIImage?) -> ()) {
        productService.fetchImage(by: productID, completion: completion)
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
}
