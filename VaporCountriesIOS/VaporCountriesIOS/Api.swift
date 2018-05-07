//
//  API.swift
//  VaporCountriesIOS
//
//  Created by Mihaela Mihaljevic Jakic on 07/05/2018.
//  Copyright © 2018 Mihaela Mihaljevic Jakic. All rights reserved.
//

import Foundation

public class Api {

  let netService: NetworkService
  
  public init () {
    netService = NetworkService(baseUrl: URL(string: "http://localhost:8080")!, configuration: URLSessionConfiguration.default)
  }
}

public extension Api {
  
  public func continents() throws -> Promise<[Continent]> {
    return try netService.get(path: "continents")
  }

  /// Get a single continent
  public func continent(_ id: Int) throws -> Promise<Continent> {
    return try netService.get(path: "continents/\(id)")
  }
  
  
}
