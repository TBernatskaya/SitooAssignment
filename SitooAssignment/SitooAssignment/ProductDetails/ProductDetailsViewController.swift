//
//  ProductDetailsViewController.swift
//  SitooAssignment
//
//  Created by Tatiana Bernatskaya on 2020-01-27.
//  Copyright © 2020 Tatiana Bernatskaya. All rights reserved.
//

import UIKit

class ProductDetailsViewController: UIViewController {
    var index: Int
    let viewModel: ProductDetailsViewModel
    
    var product: Product? {
        didSet {
            updateView()
        }
    }

    lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [self.titleLabel,
                                                       self.productImage,
                                                       self.priceLabel,
                                                       self.descriptionLabel,
                                                       self.deliveryStatusLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.spacing = 4
        return stackView
    }()

    var productImage = UIImageView()

    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24, weight: .semibold)
        label.textColor = .black
        return label
    }()

    lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = .black
        return label
    }()

    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = .black
        return label
    }()

    lazy var deliveryStatusLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = .black
        return label
    }()

    init(productIndex: Int, productVM: ProductDetailsViewModel = ProductDetailsViewModelImpl()) {
        self.index = productIndex
        self.viewModel = productVM
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        setupConstraints()
        fetchProductImage()
        fetchProductDetails()
    }

    private func setupConstraints() {
        productImage.contentMode = .scaleAspectFit
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 30),
            stackView.bottomAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor, constant: -60),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30)
        ])
    }

    private func fetchProductImage() {
        viewModel.fetchImage(by: index, completion: { self.productImage.image = $0 })
    }

    private func fetchProductDetails() {
        viewModel.fetchProduct(by: index, completion: { product, errorMessage in
            if let product = product {
                DispatchQueue.main.async {
                    self.product = product
                }
            } else {
                self.presentAlert(with: errorMessage)
            }
        })
    }

    private func updateView() {
        guard let product = self.product else { return }

        titleLabel.text = "Title: " + product.title
        priceLabel.text = "Price: " + product.price
        descriptionLabel.text = "Description: " + product.description
        deliveryStatusLabel.text = "Delivery status: " + product.deliveryStatus

    }

    private func presentAlert(with title: String?) {
        let title = title ?? "Unknown error"
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .actionSheet)
        alert.addAction(.init(title: "OK", style: .cancel, handler: nil))

        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
}
