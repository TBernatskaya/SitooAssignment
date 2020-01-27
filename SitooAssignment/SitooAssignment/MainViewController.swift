//
//  MainViewController.swift
//  SitooAssignment
//
//  Created by Tatiana Bernatskaya on 2020-01-27.
//  Copyright © 2020 Tatiana Bernatskaya. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    let productService: ProductService

    init(productService: ProductService = ProductServiceImpl()) {
        self.productService = productService
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        productService.fetchProductList(startIndex: 0, itemsCount: 10, completion: { list, error in
            print(error)
            print(list)

            self.productService.fetchProduct(by: 1, completion: { product, error in
                print(error)
                print(product)
            })
        })
    }
}
