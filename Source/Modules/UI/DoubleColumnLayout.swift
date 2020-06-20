//
//  DoubleColumnLayout.swift
//  MakersTest
//
//  Created by Abai Abakirov on 6/18/20.
//  Copyright © 2020 Abaikirov. All rights reserved.
//

import UIKit

class DoubleColumnLayout: UICollectionViewFlowLayout {
  override func prepare() {
    super.prepare()
    self.minimumInteritemSpacing = Constants.offset
    self.itemSize = CGSize(width: Constants.cellWidth, height: 200)
    self.sectionInset = UIEdgeInsets(top: Constants.offset, left: Constants.offset, bottom: Constants.offset, right: Constants.offset)
    self.sectionInsetReference = .fromSafeArea
  }
}
