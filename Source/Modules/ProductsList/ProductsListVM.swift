//
//  ProductsListVM.swift
//  MakersTest
//
//  Created by Abai Abakirov on 6/20/20.
//  Copyright © 2020 Abaikirov. All rights reserved.
//

import Foundation

protocol IProductsListVM {
  var productsListVC: IProductsListVC? { get set }
  var productsCount: Int { get }
  
  func fetchProducts()
  func product(for index: Int) -> Product
}

class ProductsListVM: IProductsListVM, IFilterVM {
  weak var productsListVC: IProductsListVC?
  
  var minPrice: Decimal?
  var maxPrice: Decimal?
  var selectedCategoryIndex: Int?
  
  var catCount: Int {
    categories.count
  }
  
  func categoryName(for index: Int) -> String {
    Array(categories)[index]
  }
  
  private var categories: Set<String> = []
  
  var productsCount: Int {
    filteredProducts.count
  }
  
  private var products: [Product] = []
  
  private var filteredProducts: [Product] = [] {
    didSet {
      productsListVC?.showProducts()
    }
  }
  
  func product(for index: Int) -> Product {
    filteredProducts[index]
  }
  
  func fetchProducts() {
    let networkManager: INetworkManager = NetworkManager()
    networkManager.fetchProducts { result in
      switch result {
      case .success(let products):
        self.products = products
        for categoryName in products.map({ $0.category }) {
          self.categories.insert(categoryName)
        }
        self.filteredProducts = products
      case .failure(let error):
        self.productsListVC?.show(error: error.localizedDescription)
      }
    }
  }
  
  func clearFilters() {
    selectedCategoryIndex = nil
    minPrice = nil
    maxPrice = nil
    filteredProducts = products
  }
  
  func filter(categoryIndex: Int?, minPrice: Decimal?, maxPrice: Decimal?) {
    selectedCategoryIndex = categoryIndex
    self.minPrice = minPrice
    self.maxPrice = maxPrice
    
    var category: String? = nil
    if categoryIndex != nil {
      category = Array(categories)[categoryIndex!]
    }
    
    filteredProducts = products.filter { (product) -> Bool in
      var categoryFilter = true
      if category != nil {
        categoryFilter = product.category == category!
      }
      
      var minFilter = true
      if minPrice != nil {
        minFilter = product.price >= minPrice!
      }
      
      var maxFilter = true
      if maxPrice != nil {
        maxFilter = product.price <= maxPrice!
      }
      
      return categoryFilter && minFilter && maxFilter
    }
  }
}
