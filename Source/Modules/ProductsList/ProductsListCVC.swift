//
//  ProductsListCVC.swift
//  MakersTest
//
//  Created by Abai Abakirov on 6/18/20.
//  Copyright © 2020 Abaikirov. All rights reserved.
//

import UIKit
import SnapKit
import Kingfisher

class ProductsListCVC: UICollectionViewCell {
  static let reuseID = "\(ProductsListCVC.self)"
  
  private var titleLabel: UILabel!
  private var imageView: UIImageView!
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupViews()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func systemLayoutSizeFitting(_ targetSize: CGSize) -> CGSize {
    return contentView.systemLayoutSizeFitting(CGSize(width: Constants.cellWidth, height: 1))
  }
  
  private func setupViews() {
    
    imageView = UIImageView()
    imageView.contentMode = .scaleAspectFill
    imageView.clipsToBounds = true
    contentView.addSubview(imageView)
    
    imageView.snp.makeConstraints { (maker) in
      maker.top.leading.trailing.equalToSuperview()
    }
    
    titleLabel = UILabel()
    titleLabel.numberOfLines = 0
    titleLabel.textAlignment = .center
    contentView.addSubview(titleLabel)
    titleLabel.snp.makeConstraints { (maker) in
      maker.top.equalTo(imageView.snp.bottom).offset(8)
      maker.leading.trailing.bottom.equalToSuperview().inset(8)
    }
  }
  
  public func onBind(_ product: Product) {
    titleLabel.text = product.name
    imageView.kf.setImage(with: URL(string: product.img))
  }
}
