//
//  FilterVC.swift
//  MakersTest
//
//  Created by Abai Abakirov on 6/20/20.
//  Copyright © 2020 Abaikirov. All rights reserved.
//

import UIKit

protocol IFilterVM {
  var selectedCategoryIndex: Int? { get }
  var minPrice: Decimal? { get }
  var maxPrice: Decimal? { get }
  
  var catCount: Int { get }
  
  func categoryName(for index: Int) -> String
  func filter(categoryIndex: Int?, minPrice: Decimal?, maxPrice: Decimal?)
  func clearFilters()
}

class FilterVC: BaseVC {
  private var minPrice: UITextField!
  private var maxPrice: UITextField!
  private var categoriesTable: UITableView!
  private var vm: IFilterVM
  
  private var selectedCategoryIndex: Int?
  
  private var selectedMinPrice: Decimal? {
    Decimal(string: minPrice.text ?? "")
  }
  
  private var selectedMaxPrice: Decimal? {
    Decimal(string: maxPrice.text ?? "")
  }
  
  init(vm: IFilterVM) {
    self.vm = vm
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    minPrice.becomeFirstResponder()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupKeyboardListener()
    setupViews()
  }
  
  private func setupKeyboardListener() {
    let center = NotificationCenter.default
    center.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
    center.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
  }
  
  @objc private func keyboardWillShow(_ notification: Notification) {
    let userInfo = notification.userInfo
    let frame  = userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
    let contentInset = UIEdgeInsets(top: 0, left: 0, bottom: frame.height, right: 0)
    categoriesTable.contentInset = contentInset
  }
  
  @objc private func keyboardWillHide(_ notification: Notification) {
    categoriesTable.contentInset = UIEdgeInsets.zero
  }
  
  private func setupViews() {
    view.backgroundColor = .systemBackground
    selectedCategoryIndex = vm.selectedCategoryIndex
    
    let closeButton = UIButton()
    closeButton.setTitle("Clear", for: .normal)
    closeButton.setTitleColor(view.tintColor, for: .normal)
    closeButton.addTarget(self, action: #selector(onClose), for: .touchUpInside)
    view.addSubview(closeButton)
    closeButton.snp.makeConstraints { (maker) in
      maker.top.leading.equalToSuperview().inset(Constants.offset)
    }
    
    let showButton = UIButton()
    showButton.setTitle("Show", for: .normal)
    showButton.setTitleColor(view.tintColor, for: .normal)
    showButton.addTarget(self, action: #selector(onShow), for: .touchUpInside)
    view.addSubview(showButton)
    showButton.snp.makeConstraints { (maker) in
      maker.top.trailing.equalToSuperview().inset(Constants.offset)
    }
    
    let priceLabel = UILabel()
    priceLabel.text = "Price"
    priceLabel.font = .boldSystemFont(ofSize: 20)
    view.addSubview(priceLabel)
    priceLabel.snp.makeConstraints { (maker) in
      maker.top.equalTo(closeButton.snp.bottom).offset(Constants.offset)
      maker.leading.trailing.equalToSuperview().inset(Constants.offset)
    }
    
    minPrice = UITextField()
    minPrice.borderStyle = .roundedRect
    minPrice.keyboardType = .decimalPad
    minPrice.placeholder = "Min"
    if let min = vm.minPrice {
      minPrice.text = "\(min)"
    }
    
    
    maxPrice = UITextField()
    maxPrice.borderStyle = .roundedRect
    maxPrice.keyboardType = .decimalPad
    maxPrice.placeholder = "Max"
    if let max = vm.maxPrice {
      maxPrice.text = "\(max)"
    }
    
    let priceStack = UIStackView(arrangedSubviews: [minPrice, maxPrice])
    priceStack.axis = .horizontal
    priceStack.distribution = .fillEqually
    priceStack.spacing = Constants.offset
    view.addSubview(priceStack)
    priceStack.snp.makeConstraints { (maker) in
      maker.top.equalTo(priceLabel.snp.bottom).offset(Constants.offset)
      maker.leading.trailing.equalToSuperview().inset(Constants.offset)
    }
    
    let categoriesLabel = UILabel()
    categoriesLabel.text = "Categories"
    categoriesLabel.font = .boldSystemFont(ofSize: 20)
    view.addSubview(categoriesLabel)
    categoriesLabel.snp.makeConstraints { (maker) in
      maker.top.equalTo(priceStack.snp.bottom).offset(Constants.offset)
      maker.leading.trailing.equalToSuperview().inset(Constants.offset)
    }
    
    categoriesTable = UITableView()
    categoriesTable.register(FilterCategoryTVC.self, forCellReuseIdentifier: FilterCategoryTVC.reuseID)
    categoriesTable.dataSource = self
    categoriesTable.delegate = self
    categoriesTable.separatorStyle = .none
    categoriesTable.rowHeight = 50
    view.addSubview(categoriesTable)
    categoriesTable.snp.makeConstraints { (maker) in
      maker.top.equalTo(categoriesLabel.snp.bottom).offset(Constants.offset)
      maker.leading.trailing.equalToSuperview()
      maker.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
    }
  }
  
  @objc private func onClose() {
    vm.clearFilters()
    dismiss(animated: true, completion: nil)
  }
  
  @objc private func onShow() {
    vm.filter(categoryIndex: selectedCategoryIndex, minPrice: selectedMinPrice, maxPrice: selectedMaxPrice)
    dismiss(animated: true, completion: nil)
  }
}

extension FilterVC: UITableViewDataSource, UITableViewDelegate {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    vm.catCount
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: FilterCategoryTVC.reuseID) as? FilterCategoryTVC else {
      fatalError()
    }
    
    cell.onBind(vm.categoryName(for: indexPath.item), selected: indexPath.item == selectedCategoryIndex, isOdd: indexPath.item % 2 == 0)
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    var updateCells: [IndexPath] = []
    if let selected = selectedCategoryIndex {
      updateCells.append(IndexPath(item: selected, section: 0))
    }
    updateCells.append(indexPath)
    selectedCategoryIndex = indexPath.item
    tableView.reloadRows(at: updateCells, with: .automatic)
  }
}
