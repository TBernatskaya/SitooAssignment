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
}

fileprivate extension ProductListViewModelImpl {
    func verifyInitialState() {
        XCTAssertNil(self.list)
        XCTAssertTrue(self.hasNextPage)
        XCTAssertFalse(self.isFetching)
        XCTAssertEqual(self.nextIndex, 0)
    }

    func verifyCompletedState() {
        XCTAssertNotNil(self.list)
        XCTAssertFalse(self.hasNextPage)
        XCTAssertFalse(self.isFetching)
    }
}
