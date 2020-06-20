//
//  ProductsDetailsVC.swift
//  MakersTest
//
//  Created by Abai Abakirov on 6/20/20.
//  Copyright © 2020 Abaikirov. All rights reserved.
//

import UIKit
import Kingfisher

class ProductsDetailsVC: ScrollVC {
  private let product: Product
  private var imageView: UIImageView!
  private var productName: UILabel!
  private var productDescription: UILabel!
  private var productPrice: UILabel!
  private var productCompany: UILabel!
  private var productCategory: UILabel!
  
  init(_ product: Product) {
    self.product = product
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground
    fetchProductImage()
  }
  
  override func setupContentView(_ contentView: UIView) {
    imageView = UIImageView()
    imageView.contentMode = .scaleAspectFill
    imageView.clipsToBounds = true
    contentView.addSubview(imageView)
    imageView.snp.makeConstraints { (maker) in
      maker.top.leading.trailing.equalToSuperview()
      maker.height.equalTo(200)
    }
    
    productName = UILabel()
    productName.numberOfLines = 0
    productName.font = .boldSystemFont(ofSize: 24)
    productName.text = product.name
    contentView.addSubview(productName)
    
    productPrice = UILabel()
    productPrice.numberOfLines = 1
    productPrice.font = .systemFont(ofSize: 20)
    productPrice.text = "$\(product.price)"
    productPrice.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    productPrice.setContentCompressionResistancePriority(.required, for: .horizontal)
    contentView.addSubview(productPrice)
    productPrice.snp.makeConstraints { (maker) in
      maker.top.equalTo(imageView.snp.bottom).offset(Constants.offset)
      maker.trailing.equalToSuperview().inset(Constants.offset)
      maker.centerY.equalTo(productName.snp.centerY)
    }
    
    productName.snp.makeConstraints { (maker) in
      maker.top.equalTo(imageView.snp.bottom).offset(Constants.offset)
      maker.trailing.equalTo(productPrice.snp.leading).offset(-Constants.offset)
      maker.leading.equalToSuperview().inset(Constants.offset)
    }
    
    productDescription = UILabel()
    productDescription.numberOfLines = 0
    productDescription.text = product.desc
    contentView.addSubview(productDescription)
    productDescription.snp.makeConstraints { (maker) in
      maker.top.equalTo(productName.snp.bottom).offset(Constants.offset)
      maker.leading.trailing.equalToSuperview().inset(Constants.offset)
    }
    
    productCategory = UILabel()
    productCategory.numberOfLines = 0
    productCategory.text = product.category
    productCategory.textColor = .systemGray4
    contentView.addSubview(productCategory)
    productCategory.snp.makeConstraints { (maker) in
      maker.top.equalTo(productDescription.snp.bottom).offset(Constants.offset)
      maker.leading.trailing.equalToSuperview().inset(Constants.offset)
    }
    
    productCompany = UILabel()
    productCompany.numberOfLines = 0
    productCompany.text = product.company
    productCompany.textColor = .systemGray4
    contentView.addSubview(productCompany)
    productCompany.snp.makeConstraints { (maker) in
      maker.top.equalTo(productCategory.snp.bottom).offset(Constants.offset)
      maker.leading.trailing.bottom.equalToSuperview().inset(Constants.offset)
    }
  }
  
  private func fetchProductImage() {
    imageView.kf.setImage(with: URL(string: product.img))
  }
}
