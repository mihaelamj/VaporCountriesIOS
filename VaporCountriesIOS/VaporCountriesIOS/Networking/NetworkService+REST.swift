//
//  NetworkService+REST.swift
//  VaporCountriesIOS
//
//  Created by Mihaela Mihaljevic Jakic on 07/05/2018.
//  Copyright © 2018 Mihaela Mihaljevic Jakic. All rights reserved.
//

import Foundation

extension NetworkService {
  
//public typealias DataResponse = (data: Data?, response: URLResponse)
//public typealias DataTaskResultBlock = ((_ result: Result<DataResponse>) -> ())
  
// MARK: - Helper
  
  func jsonHeaders() -> HTTPHeaders {
    return ["Content-Type": "application/json; charset=utf8"]
  }
  
// MARK: - GET
  
  func get(path: String, _ result: @escaping DataTaskResultBlock) throws {
    return submitRequest(path: path, data: nil, method: .get, headers: [:], expectedStatuses: [.ok, .found, .notModified], result)
  }
  
// MARK: - POST
  
  func post(path: String, data: Data, _ result: @escaping DataTaskResultBlock) throws {
    return submitRequest(path: path, data: data, method: .post, headers: jsonHeaders(), expectedStatuses: [.ok, .created], result)
  }
  
  func post(path: String, object: Encodable, _ result: @escaping DataTaskResultBlock) throws {
    let data = try object.asData()
    return submitRequest(path: path, data: data, method: .post, headers: jsonHeaders(), expectedStatuses: [.ok, .created], result)
  }
  
// MARK: - PUT
  
  func put(path: String, object: Encodable, _ result: @escaping DataTaskResultBlock) throws {
    let data = try object.asData()
    return submitRequest(path: path, data: data, method: .put, headers: jsonHeaders(), expectedStatuses: [.ok, .created], result)
  }
  
  func put(path: String, data: Data, _ result: @escaping DataTaskResultBlock) throws {
    return submitRequest(path: path, data: data, method: .put, headers: [:], expectedStatuses: [.ok, .created], result)
  }
  
// MARK: - DELETE
  
  func delete(path: String, _ result: @escaping DataTaskResultBlock) throws {
    return submitRequest(path: path, data: nil, method: .delete, headers: [:], expectedStatuses: [.accepted, .noContent], result)
  }
  
}
