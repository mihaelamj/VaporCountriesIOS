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
    let url = "http://localhost:8080/api/"
    //http://localhost:8080/api/continents/
   // http://localhost:8080/api/continets/
    netService = NetworkService(baseUrl: URL(string: url)!, configuration: URLSessionConfiguration.default)
  }
}

public extension Api {
  
  public func continents() throws -> Promise<[Continent]> {
    return try netService.get(path: "continets")
  }

  /// Get a single continent
  public func continent(_ id: Int) throws -> Promise<Continent> {
    return try netService.get(path: "continets/\(id)")
  }
  
  public func countries() throws -> Promise<[Country]> {
    return try netService.get(path: "countries")
  }
  
  
}
