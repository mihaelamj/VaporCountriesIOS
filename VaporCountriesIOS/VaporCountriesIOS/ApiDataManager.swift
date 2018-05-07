//
//  APIDataManager.swift
//  VaporCountriesIOS
//
//  Created by Mihaela Mihaljevic Jakic on 07/05/2018.
//  Copyright © 2018 Mihaela Mihaljevic Jakic. All rights reserved.
//

import Foundation

public final class ApiDataManager {
  var continents : [Continent]
  var countries : [Country]
  var api: Api?
  
  init() {
    continents = [Continent]()
    countries = [Country]()
    api = Api()
  }
  
  func loadContinents() {
    do {
      try api?.continents().then( { continents in
        self.continents = continents
        debugPrint("Continents: \(continents)")
        }).error({ error in
          debugPrint("Error: \(error)")
        })
      
    } catch {
      // TODO: Handle! How? :/
      print(error)
    }
    
  }
  
  func loadCountries() {
    do {
      try api?.countries().then( { countries in
        self.countries = countries
        debugPrint("Countries: \(countries)")
      }).error({ error in
        debugPrint("Error: \(error)")
      })
      
    } catch {
      // TODO: Handle! How? :/
      print(error)
    }
    
  }
  
}
