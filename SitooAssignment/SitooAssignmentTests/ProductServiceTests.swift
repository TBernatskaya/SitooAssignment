//
//  ProductServiceTests.swift
//  SitooAssignment
//
//  Created by Tatiana Bernatskaya on 2020-01-27.
//  Copyright © 2020 Tatiana Bernatskaya. All rights reserved.
//

import XCTest
import OHHTTPStubs
@testable import SitooAssignment

class ProductServiceTests: XCTestCase {

    lazy var testBundle = Bundle(for: type(of: self))
    let host = "api-sandbox.mysitoo.com"
    let productService = ProductServiceImpl()

    override func tearDown() {
        OHHTTPStubs.removeAllStubs()
    }

    func testFetchProductList_successfull() {
        let expectation = XCTestExpectation(description: "List is fetched")
        let path = testBundle.path(forResource: "productList", ofType: "json")!

        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
            let jsonObject = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)

            stub(condition: isHost(self.host)) { _ in
                return OHHTTPStubsResponse(jsonObject: jsonObject, statusCode: 200, headers: nil)
            }
        } catch {
            XCTFail("Cannot read json test file")
        }

        productService.fetchProductList(startIndex: 0, itemsCount: 5, completion: { list, error in
            XCTAssertNil(error)
            XCTAssertNotNil(list)
            XCTAssertEqual(list?.totalCount, 31)
            XCTAssertEqual(list?.products.count, 5)
            XCTAssertEqual(list?.products[0].title, "Sofa")
            XCTAssertEqual(list?.products[0].price, "10392.00")
            expectation.fulfill()
        })

        wait(for: [expectation], timeout: 1)
    }

    func testFetchProductList_returnsError() {
        let expectation = XCTestExpectation(description: "Received error")
        let notConnectedError = NSError(domain:NSURLErrorDomain, code:123, userInfo:nil)

        stub(condition: isHost(self.host)) { _ in
            return OHHTTPStubsResponse(error: notConnectedError)
        }

        productService.fetchProductList(startIndex: 0, itemsCount: 10, completion: { list, error in
            XCTAssertNotNil(error)
            XCTAssertNil(list)
            expectation.fulfill()
        })

        wait(for: [expectation], timeout: 1)
    }
}
