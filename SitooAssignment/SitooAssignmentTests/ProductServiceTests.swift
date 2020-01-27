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

    let host = "api-sandbox.mysitoo.com"
    let productService = ProductServiceImpl()
    let notConnectedError = NSError(domain:NSURLErrorDomain, code:123, userInfo:nil)

    override func tearDown() {
        super.tearDown()
        OHHTTPStubs.removeAllStubs()
    }

    func testFetchProductList_successfull() {
        let expectation = XCTestExpectation(description: "List is fetched")
        let jsonObject = getJSONObject(from: "productList")!

        stub(condition: isHost(self.host)) { _ in
            return OHHTTPStubsResponse(jsonObject: jsonObject, statusCode: 200, headers: nil)
        }

        productService.fetchProductList(startIndex: 0, itemsCount: 5, completion: { list, error in
            XCTAssertNil(error)
            XCTAssertNotNil(list)
            XCTAssertEqual(list?.totalCount, 31)
            XCTAssertEqual(list?.products.count, 5)
            XCTAssertEqual(list?.products[0].id, 1)
            XCTAssertEqual(list?.products[0].title, "Sofa")
            XCTAssertEqual(list?.products[0].price, "10392.00")
            expectation.fulfill()
        })

        wait(for: [expectation], timeout: 1)
    }

    func testFetchProductList_returnsError() {
        let expectation = XCTestExpectation(description: "Received error")

        stub(condition: isHost(self.host)) { _ in
            return OHHTTPStubsResponse(error: self.notConnectedError)
        }

        productService.fetchProductList(startIndex: 0, itemsCount: 10, completion: { list, error in
            XCTAssertNotNil(error)
            XCTAssertNil(list)
            expectation.fulfill()
        })

        wait(for: [expectation], timeout: 1)
    }

    func testFetchProduct_successfull() {
        let expectation = XCTestExpectation(description: "Product is fetched")
        let jsonObject = getJSONObject(from: "product")!

        stub(condition: isHost(self.host)) { _ in
            return OHHTTPStubsResponse(jsonObject: jsonObject, statusCode: 200, headers: nil)
        }

        productService.fetchProduct(by: 1, completion: { product, error in
            XCTAssertNil(error)
            XCTAssertNotNil(product)
            XCTAssertEqual(product?.id, 1)
            XCTAssertEqual(product?.title, "Blanket Red Striped")
            XCTAssertEqual(product?.description, "test item")
            XCTAssertEqual(product?.deliveryStatus, "Delivered")
            XCTAssertEqual(product?.price, "6392.00")
            expectation.fulfill()
        })

        wait(for: [expectation], timeout: 1)
    }

    func testFetchProduct_returnsError() {
        let expectation = XCTestExpectation(description: "Received error")

        stub(condition: isHost(self.host)) { _ in
            return OHHTTPStubsResponse(error: self.notConnectedError)
        }

        productService.fetchProduct(by: 1, completion: { product, error in
            XCTAssertNotNil(error)
            XCTAssertNil(product)
            expectation.fulfill()
        })

        wait(for: [expectation], timeout: 1)
    }

    private func getJSONObject(from filePath: String) -> Any? {
        let testBundle = Bundle(for: type(of: self))
        let path = testBundle.path(forResource: filePath, ofType: "json")!
        
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
            let jsonObject = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
            return jsonObject
        } catch {
            XCTFail("Cannot read json test file")
            return nil
        }
    }
}
