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
  private var selectedImageView: UIImageView!
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupViews()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupViews() {
    separatorInset = UIEdgeInsets(top: 0, left: Constants.offset, bottom: 0, right: 0)
    
    categoryName = UILabel()
    contentView.addSubview(categoryName)
    categoryName.snp.makeConstraints { (maker) in
      maker.edges.equalToSuperview().inset(Constants.offset)
    }
    
    selectedImageView = UIImageView()
    selectedImageView.image = UIImage(named: "done")?.withRenderingMode(.alwaysTemplate).withTintColor(tintColor)
    contentView.addSubview(selectedImageView)
    selectedImageView.snp.makeConstraints { (maker) in
      maker.centerY.equalToSuperview()
      maker.trailing.equalToSuperview().offset(-Constants.offset)
      maker.width.height.equalTo(20)
    }
  }
  
  func onBind(_ category: String, selected: Bool, isOdd: Bool) {
    backgroundColor = isOdd ? .secondarySystemBackground : .systemBackground
    categoryName.text = category
    selectedImageView.isHidden = !selected
  }
}
