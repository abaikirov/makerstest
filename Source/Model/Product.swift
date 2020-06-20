//
//  Product.swift
//  MakersTest
//
//  Created by Abai Abakirov on 6/18/20.
//  Copyright © 2020 Abaikirov. All rights reserved.
//

import Foundation

struct Product: Decodable {
  let id: String
  let name: String
  let price: Decimal
  let desc: String
  let company: String
  let category: String
  let img: String
}
