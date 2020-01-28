//
//  ProductListVMTests.swift
//  SitooAssignmentTests
//
//  Created by Tatiana Bernatskaya on 2020-01-28.
//  Copyright © 2020 Tatiana Bernatskaya. All rights reserved.
//

import XCTest
@testable import SitooAssignment

class ProductListVMTests: XCTestCase {

    func testFetchProductList_successfull() {
        let serviceMock = ProductServiceMock(shouldReturnError: false)
        let vm = ProductListViewModelImpl(productService: serviceMock)
        let expectation1 = XCTestExpectation(description: "List is fetched")
        let expectation2 = XCTestExpectation(description: "List is fetched again")

        vm.verifyInitialState()

        vm.fetchProductList(completion: { list, error in
            XCTAssertNil(error)
            XCTAssertEqual(vm.list?.totalCount, 2)
            XCTAssertEqual(vm.list?.products.count, 2)
            XCTAssertEqual(vm.nextIndex, vm.itemsInPage)

            vm.verifyCompletedState()
            expectation1.fulfill()
        })

        // fetch product list again to make sure that new items are added to existing list
        vm.fetchProductList(completion: { list, error in
            XCTAssertNil(error)
            XCTAssertEqual(vm.list?.products.count, 4)
            XCTAssertEqual(vm.nextIndex, vm.itemsInPage*2)

            vm.verifyCompletedState()
            expectation2.fulfill()
        })
        wait(for: [expectation1, expectation2], timeout: 1)
    }

    func testFetchProductList_recievedError() {
        let serviceMock = ProductServiceMock(shouldReturnError: true)
        let vm = ProductListViewModelImpl(productService: serviceMock)
        let expectation = XCTestExpectation(description: "Received an error")

        vm.verifyInitialState()

        vm.fetchProductList(completion: { list, error in
            XCTAssertNotNil(error)
            XCTAssertNil(list)

            vm.verifyInitialState()
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 1)
    }

    struct ProductServiceMock: ProductService {
        var shouldReturnError: Bool
        let error = NSError(domain: "Service", code: 456, userInfo: nil)

        func fetchProduct(by productID: Int, completion: @escaping (Product?, Error?) -> ()) {}

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
}

fileprivate extension ProductListViewModelImpl {
    func verifyInitialState() {
        XCTAssertNil(self.list)
        XCTAssertFalse(self.hasFetchedAll)
        XCTAssertFalse(self.isFetching)
        XCTAssertEqual(self.nextIndex, 0)
    }

    func verifyCompletedState() {
        XCTAssertNotNil(self.list)
        XCTAssertTrue(self.hasFetchedAll)
        XCTAssertFalse(self.isFetching)
    }
}
