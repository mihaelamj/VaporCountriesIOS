//
//  NetworkService+REST.swift
//  VaporCountriesIOS
//
//  Created by Mihaela Mihaljevic Jakic on 07/05/2018.
//  Copyright © 2018 Mihaela Mihaljevic Jakic. All rights reserved.
//

import Foundation

extension NetworkService {
  
  //public func submitRequest(path: String, data: Data? = nil, method: HTTPMethod, headers: HTTPHeaders = [:], expectedStatus : HTTPStatusCode, _ result: @escaping DataTaskResultBlock ) {
  
  func get(path: String, _ result: @escaping DataTaskResultBlock) {
    return submitRequest(path: path, data: nil, method: .get, headers: [:], expectedStatuses: [.ok], result)
  }
  
  func post(path: String, object: Encodable, _ result: @escaping DataTaskResultBlock) {
    
  }
  
}
