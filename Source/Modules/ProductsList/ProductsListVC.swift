//
//  ProductsListVC.swift
//  MakersTest
//
//  Created by Abai Abakirov on 6/18/20.
//  Copyright © 2020 Abaikirov. All rights reserved.
//

import UIKit

class ProductsListVC: UIViewController {
  private var productsList: UICollectionView!
  private var products = [Product]() {
    didSet {
      productsList.reloadData()
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupViews()
    fetchProducts()
  }
  
  private func setupViews() {
    productsList = UICollectionView(frame: .zero, collectionViewLayout: DoubleColumnLayout())
    productsList.dataSource = self
    productsList.register(ProductsListCVC.self, forCellWithReuseIdentifier: ProductsListCVC.reuseID)
    view.addSubview(productsList)
    productsList.snp.makeConstraints { (maker) in
      maker.edges.equalTo(view.safeAreaLayoutGuide.snp.edges)
    }
  }
  
  private func fetchProducts() {
    let networkManager: INetworkManager = NetworkManager()
    networkManager.fetchProducts { (result) in
      switch result {
      case .success(let products):
        self.products = products
      case .failure(let error):
        print(error)
      }
    }
  }
}

extension ProductsListVC: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    products.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductsListCVC.reuseID, for: indexPath) as? ProductsListCVC else {
      fatalError()
    }
    cell.onBind(products[indexPath.item])
    return cell
  }
}
