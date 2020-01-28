//
//  ProductListViewController.swift
//  SitooAssignment
//
//  Created by Tatiana Bernatskaya on 2020-01-27.
//  Copyright © 2020 Tatiana Bernatskaya. All rights reserved.
//

import UIKit

class ProductListViewController: UIViewController {
    var viewModel: ProductListViewModel

    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(ProductCell.self, forCellWithReuseIdentifier: ProductCell.reuseIdentifier)
        return collectionView
    }()

    init(viewModel: ProductListViewModel = ProductListViewModelImpl()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.prefetchDataSource = self
        updateConstraints()
        updateList()
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        let flowLayout = collectionView.collectionViewLayout
        flowLayout.invalidateLayout()
    }

    private func updateConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 80),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -60),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -60),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 60)
        ])
    }

    private func updateList() {
        guard !viewModel.isFetching, viewModel.hasNextPage else { return }
        // TODO: add loading indicator
        viewModel.fetchProductList(completion: { list, errorMessage in
            if let _ = list {
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            } else {
                self.presentAlert(with: errorMessage)
            }
        })
    }

    private func openProductDetails(index: Int) {
        DispatchQueue.main.async {
            self.present(
                ProductDetailsViewController(productIndex: index),
                animated: true,
                completion: nil
            )
        }
    }

    // alert logic is duplicated
    private func presentAlert(with title: String?) {
        let title = title ?? "Unknown error"
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .actionSheet)
        alert.addAction(.init(title: "OK", style: .cancel, handler: nil))
        
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
}


extension ProductListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        guard let list = viewModel.list else { return 0 }
        return list.products.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: ProductCell.reuseIdentifier,
                for: indexPath
            ) as? ProductCell,
            let productList = viewModel.list
        else { return UICollectionViewCell() }

        cell.title.text = productList.products[indexPath.row].title
        cell.price.text = productList.products[indexPath.row].price

        return cell
    }
}

extension ProductListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        guard let productList = viewModel.list else { return }
        let index = productList.products[indexPath.row].id
        // TODO: prevent user from double tap
        openProductDetails(index: index)
    }
}

extension ProductListViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView,
                        prefetchItemsAt indexPaths: [IndexPath]) {
        updateList()
    }
}

extension ProductListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: 44)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
}
