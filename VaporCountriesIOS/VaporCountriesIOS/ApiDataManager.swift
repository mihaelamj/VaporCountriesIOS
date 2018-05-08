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
  
  func loadContinent(id: Int) {
    do {
      try api?.continent(id).then( { continent in
        debugPrint("Continent: \(continent)")
      }).error({ error in
        debugPrint("Error: \(error)")
      })
      
    } catch {
      // TODO: Handle! How? :/
      print(error)
    }
  }
  
  func loadCountry(id: Int) {
    do {
      try api?.country(id).then( { country in
        debugPrint("Country: \(country)")
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
        debugPrint("Fetched Countries no: \(countries.count)")
      }).error({ error in
        debugPrint("Error: \(error)")
      })
      
    } catch {
      // TODO: Handle! How? :/
      print(error)
    }
  }
  
  func loadCountryContinent(id: Int) {
    do {
      try api?.countryContinent(id).then( { continent in
        debugPrint("Continent: \(continent)")
      }).error({ error in
        debugPrint("Error: \(error)")
      })
      
    } catch {
      // TODO: Handle! How? :/
      print(error)
    }
  }
  
  func loadContinentCountries(id: Int) {
    do {
      try api?.continentCountries(id).then( { countries in
        debugPrint("Fetched Countries no: \(countries.count)")
      }).error({ error in
        debugPrint("Error: \(error)")
      })
      
    } catch {
      // TODO: Handle! How? :/
      print(error)
    }
  }
  
// MARK: - Test
  
  
}
