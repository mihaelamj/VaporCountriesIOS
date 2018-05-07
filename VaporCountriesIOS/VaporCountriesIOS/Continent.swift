//
//  Continent.swift
//  VaporCountriesIOS
//
//  Created by Mihaela Mihaljevic Jakic on 07/05/2018.
//  Copyright © 2018 Mihaela Mihaljevic Jakic. All rights reserved.
//

/*
 Spice  ⇇↦ Country ⇇↦ Continent
 Continent ↤⇉ Country
 pre-populated
 */

public final class Continent : Codable {
  var id : Int?
  var name : String
  var alpha2: String
  
  init(name : String, alpha2: String) {
    self.name = name
    self.alpha2 = alpha2
  }
}

extension Continent: CustomStringConvertible {
  public var description: String {
    return "\(name), \(alpha2)"
  }
}

