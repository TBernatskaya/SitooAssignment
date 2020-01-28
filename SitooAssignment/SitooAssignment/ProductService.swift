//
//  ProductService.swift
//  SitooAssignment
//
//  Created by Tatiana Bernatskaya on 2020-01-27.
//  Copyright © 2020 Tatiana Bernatskaya. All rights reserved.
//

import UIKit

protocol ProductService {
    func fetchImage(by productID: Int, completion: @escaping (UIImage?) -> ())
    func fetchProduct(by productID: Int, completion: @escaping (Product?, Error?) -> ())
    func fetchProductList(startIndex: Int, itemsCount: Int, completion: @escaping (ProductList?, Error?) -> ())
}

class ProductServiceImpl: ProductService {

    let router = Router()

    func fetchImage(by productID: Int, completion: @escaping (UIImage?) -> ()) {
        let url = URL(
            string: router.productImages
                .replacingOccurrences(of: "{id}", with: String(describing: productID))
        )!

        // I didn't manage to fetch any images from https://testproject-sandbox.mysitoo.com/res/{resourceid}
        // or from GET sites/{siteid}/products/{productid}/images
        // so that I've added fallbackImageURL for testing purposes
        let fallbackImageURL = URL(string: "https://i.pinimg.com/564x/fd/47/3f/fd473f9622e2b8d1868a89db5897a02a.jpg")!

        downloadImage(from: url, completion: { image in
            if let image = image {
                completion(image)
            } else {
                self.downloadImage(from: fallbackImageURL, completion: completion)
            }
        })
    }

    func fetchProduct(by productID: Int, completion: @escaping (Product?, Error?) -> ()) {
        let url = URL(
            string: router.productDetails
                .replacingOccurrences(of: "{id}", with: String(describing: productID))
        )!
        print(url.absoluteString) // for testing purposes only
        var request = URLRequest(url: url)
        request.addAuthorizationHeaders()

        send(request: request, completion: { data, error in
            guard let data = data else { return completion(nil, error) }
            do {
                let decoder = JSONDecoder()
                let product = try decoder.decode(Product.self, from: data)
                completion(product, nil)
            }
            catch {
                completion(nil, error)
            }
        })
    }

    func fetchProductList(startIndex: Int, itemsCount: Int, completion: @escaping (ProductList?, Error?) -> ()) {
        let url = URL(
            string: router.productList
                .replacingOccurrences(of: "{startIndex}", with: String(describing: startIndex))
                .replacingOccurrences(of: "{itemsCount}", with: String(describing: itemsCount))
        )!
        print(url.absoluteString) // for testing purposes only
        var request = URLRequest(url: url)
        request.addAuthorizationHeaders()

        send(request: request, completion: { data, error in
            guard let data = data else { return completion(nil, error) }
            do {
                let decoder = JSONDecoder()
                let list = try decoder.decode(ProductList.self, from: data)
                completion(list, nil)
            }
            catch {
                completion(nil, error)
            }
        })
    }

    private func send(request: URLRequest, completion: @escaping (Data?, Error?) -> ()) {
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard
                error == nil,
                let response = response as? HTTPURLResponse, response.statusCode == 200,
                let data = data
            else {
                return completion(nil, error)
            }
           completion(data, nil)
        }
        task.resume()
    }

    private func downloadImage(from url: URL, completion: @escaping (UIImage?) -> ()) {
        do {
            let data = try Data(contentsOf: url)
            completion(UIImage(data: data))
        }
        catch { completion(nil) }
    }
}

struct Router {
    let baseURLString = "https://api-sandbox.mysitoo.com/v2/accounts/90316"

    var productList: String {
        baseURLString + "\(Route.productList.rawValue)"
    }

    var productDetails: String {
        baseURLString + "\(Route.productDetails.rawValue)"
    }

    var productImages: String {
        baseURLString + "\(Route.productImages.rawValue)"
    }

    private enum Route: String {
        case productList = "/sites/1/products.json?start={startIndex}&num={itemsCount}&fields=productid,title,moneyprice"
        case productDetails = "/sites/1/products/{id}.json"
        case productImages = "/sites/1/products/{id}/images.json?num=1"
    }
}

extension URLRequest {
    mutating func addAuthorizationHeaders() {
        let apiID = "90316-125"
        let password = "pfX0Y7A2TYAlZ571IKEO7AKoXza6YlvsP8kKvAu3"

        self.setValue("Basic OTAzMTYtMTI1OnBmWDBZN0EyVFlBbFo1NzFJS0VPN0FLb1h6YTZZbHZzUDhrS3ZBdTM=", forHTTPHeaderField: "Authorization")
        self.setValue(password, forHTTPHeaderField: apiID)
    }
}
