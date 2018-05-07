//
//  Coubtry.swift
//  VaporCountriesIOS
//
//  Created by Mihaela Mihaljevic Jakic on 07/05/2018.
//  Copyright © 2018 Mihaela Mihaljevic Jakic. All rights reserved.
//

/*
 Spice  ⇇↦ Country ⇇↦ Continent
 Country ⇇↦  Continent
 pre-populated
 */

public final class Country : Codable {
  var id : Int?
  var name : String
  var numeric: String
  var alpha2: String
  var alpha3: String
  var calling: String
  var currency: String
//  var continentID: Continent.ID
  
  init(name : String, numeric: String, alpha2: String, alpha3: String, calling: String, currency: String) { //}, continentID: Continent.ID) {
    self.name = name
    self.numeric = numeric
    self.alpha2 = alpha2
    self.alpha3 = alpha3
    self.calling = calling
    self.currency = currency
//    self.continentID = continentID
  }
}

extension Country: CustomStringConvertible {
  public var description: String {
    return "\(name), \(alpha2), \(numeric), \(alpha3), \(calling), \(currency)"
  }
}

