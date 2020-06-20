//
//  ProductsListVC.swift
//  MakersTest
//
//  Created by Abai Abakirov on 6/18/20.
//  Copyright © 2020 Abaikirov. All rights reserved.
//

import UIKit

protocol IProductsListVC: class {
  func show(products: [Product])
  func show(error: String)
}

class ProductsListVC: BaseVC {
  private var vm: IProductsListVM = ProductsListVM()
  private var productsList: UICollectionView!
  private var products = [Product]() {
    didSet {
      productsList.reloadData()
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    vm.productsListVC = self
    setupViews()
    fetchProducts()
  }
  
  private func setupViews() {
    productsList = UICollectionView(frame: .zero, collectionViewLayout: DoubleColumnLayout())
    productsList.backgroundColor = .systemBackground
    productsList.dataSource = self
    productsList.delegate = self
    productsList.register(ProductsListCVC.self, forCellWithReuseIdentifier: ProductsListCVC.reuseID)
    view.addSubview(productsList)
    productsList.snp.makeConstraints { (maker) in
      maker.edges.equalTo(view.safeAreaLayoutGuide.snp.edges)
    }
    
    navigationItem.title = "Products"
    navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Filter", style: .plain, target: self, action: #selector(onFilter))
  }
  
  private func fetchProducts() {
    vm.fetchProducts()
  }
  
  @objc private func onFilter() {
    let filterVC = FilterVC(vm: vm as! IFilterVM)
    present(filterVC, animated: true, completion: nil)
  }
}

extension ProductsListVC: UICollectionViewDataSource, UICollectionViewDelegate {
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
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    collectionView.deselectItem(at: indexPath, animated: true)
    show(ProductsDetailsVC(products[indexPath.item]), sender: self)
  }
}

extension ProductsListVC: IProductsListVC {
  func show(error: String) {
    showErrorAlert(error)
  }
  
  func show(products: [Product]) {
    self.products = products
  }
}
