//
//  NetworkManager.swift
//  MakersTest
//
//  Created by Abai Abakirov on 6/18/20.
//  Copyright © 2020 Abaikirov. All rights reserved.
//

import Foundation

protocol INetworkManager {
  func fetchProducts(completion: @escaping(Result<[Product], Error>) -> Void)
}

class NetworkManager: INetworkManager {
  func fetchProducts(completion: @escaping (Result<[Product], Error>) -> Void) {
    guard let path = Bundle(for: type(of: self)).path(forResource: "MOCK_DATA", ofType: "json") else {
      completion(.failure(MTError.failed))
      return
    }
    do {
      let data = try Data(contentsOf: URL(fileURLWithPath: path))
      let decoded = try JSONDecoder().decode([Product].self, from: data)
      completion(.success(decoded))
    } catch {
      completion(.failure(error))
    }
  }
}
