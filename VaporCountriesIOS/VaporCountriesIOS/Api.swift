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
    netService = NetworkService(baseUrl: URL(string: url)!, configuration: URLSessionConfiguration.default)
  }
}

public extension Api {
  
  /// Get all continents
  public func continents() throws -> Promise<[Continent]> {
    return try netService.get(path: "continets")
  }

  /// Get a single continent
  public func continent(_ id: Int) throws -> Promise<Continent> {
    return try netService.get(path: "continets/\(id)")
  }
  
  /// get all countries
  public func countries() throws -> Promise<[Country]> {
    return try netService.get(path: "countries")
  }
  
  /// Get a single country
  public func country(_ id: Int) throws -> Promise<Country> {
    return try netService.get(path: "countries/\(id)")
  }
  
  //FIXME: does not work
  /// Get continent for a country
  //http://localhost:8080/api/countries/33/continent
  public func countryContinent(_ id: Int) throws -> Promise<Continent> {
    return try netService.get(path: "countries/\(id)/continent")
  }
  
  //FIXME: does not work
  //Get countries for a continent
  //http://localhost:8080/api/continets/1/countries
  public func continentCountries(_ id: Int) throws -> Promise<[Country]> {
    return try netService.get(path: "continets/\(id)/countries")
  }
  
  //TEST:
  
//  func get(path: String, _ result: @escaping DataTaskResultBlock) throws {
//    return submitRequest(path: path, data: nil, method: .get, headers: [:], expectedStatuses: [.ok, .found, .notModified], result)
//  }
//  
  public func countryContinentTest(_ id: Int, _ result: @escaping DataTaskResultBlock) throws {
    
    try netService.get(path: "countries/\(id)/continent", { (res) in
      do {
        let object = try res.unwrap(to: Continent.self)
        debugPrint("Continent: \(object)")
      } catch {
        fatalError()
      }
      
    })
    
  }
  
}
