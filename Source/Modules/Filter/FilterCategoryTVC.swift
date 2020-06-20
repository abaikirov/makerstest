//
//  FilterCategoryTVC.swift
//  MakersTest
//
//  Created by Abai Abakirov on 6/20/20.
//  Copyright © 2020 Abaikirov. All rights reserved.
//

import UIKit

class FilterCategoryTVC: UITableViewCell {
  static let reuseID = "\(FilterCategoryTVC.self)"
  
  private var categoryName: UILabel!
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupViews()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupViews() {
    categoryName = UILabel()
    contentView.addSubview(categoryName)
    categoryName.snp.makeConstraints { (maker) in
      maker.edges.equalToSuperview()
    }
  }
  
  func onBind(_ category: String) {
    categoryName.text = category
  }
}
