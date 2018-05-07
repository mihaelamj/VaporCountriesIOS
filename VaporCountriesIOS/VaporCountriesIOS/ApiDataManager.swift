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
  var api: Api?
  
  init() {
    continents = [Continent]()
    api = Api()
  }
  
  func loadData() {
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
  
}
