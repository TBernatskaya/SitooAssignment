//
//  ProductDetailsVMTests.swift
//  SitooAssignmentTests
//
//  Created by Tatiana Bernatskaya on 2020-01-28.
//  Copyright © 2020 Tatiana Bernatskaya. All rights reserved.
//

import XCTest
@testable import SitooAssignment

class ProductDetailsVMTests: XCTestCase {

    func testFetchProduct_successfull() {
        let serviceMock = ProductServiceMock(shouldReturnError: false)
        let vm = ProductDetailsViewModelImpl(productService: serviceMock)
        let expectation = XCTestExpectation(description: "Product is fetched")

        vm.fetchProduct(by: 1, completion: { product, error in
            XCTAssertNil(error)
            XCTAssertNotNil(product)
            XCTAssertEqual(product?.id, 1)
            XCTAssertEqual(product?.title, "Test product")
            XCTAssertEqual(product?.description, "Description text")
            XCTAssertEqual(product?.deliveryStatus, "Shipped")
            XCTAssertEqual(product?.price, "123.00")
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 1)
    }

    func testFetchProduct_recievedError() {
        let serviceMock = ProductServiceMock(shouldReturnError: true)
        let vm = ProductDetailsViewModelImpl(productService: serviceMock)
        let expectation = XCTestExpectation(description: "Received an error")

        vm.fetchProduct(by: 1, completion: { product, error in
            XCTAssertNotNil(error)
            XCTAssertNil(product)
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 1)
    }

    struct ProductServiceMock: ProductService {
        var shouldReturnError: Bool
        let error = NSError(domain: "Service", code: 456, userInfo: nil)

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

        func fetchImage(by productID: Int, completion: @escaping (UIImage?) -> ()) {}

        func fetchProductList(startIndex: Int, itemsCount: Int, completion: @escaping (ProductList?, Error?) -> ()) {}
    }
    
}
