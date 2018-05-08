//
//  NetworkService.swift
//  VaporCountriesIOS
//
//  Created by Mihaela Mihaljevic Jakic on 03/05/2018.
//  Copyright © 2018 Mihaela Mihaljevic Jakic. All rights reserved.
//

/*
 //GET /api/countries
 //GET /api/countries/:ID
 //GET /api/countries/:ID/continent
 
 //GET /api/continets
 //GET /api/continents/:ID
 //GET /api/continents/:ID/countries
 */

import Foundation
import UIKit

/// See https://tools.ietf.org/html/rfc7231#section-4.3
public enum HTTPMethod: String {
  case options = "OPTIONS"
  case get     = "GET"
  case head    = "HEAD"
  case post    = "POST"
  case put     = "PUT"
  case patch   = "PATCH"
  case delete  = "DELETE"
  case trace   = "TRACE"
  case connect = "CONNECT"
}

/// A dictionary of parameters to apply to a `URLRequest`.
public typealias Parameters = [String: Any]

/// A dictionary of headers to apply to a `URLRequest`.
public typealias HTTPHeaders = [String: String]

/// A network operation response `URLResponse`.
public typealias DataResponse = (data: Data?, response: URLResponse)

public typealias DataTaskResultBlock = ((_ result: Result<DataResponse>) -> ())


open class NetworkService {
  
//  let queue = DispatchQueue(label: "org.mihaelamj.network-service." + UUID().uuidString)
  let session : URLSession
  
/// Base URL
  let baseUrl: URL
  
/// URLSession configuration
  let configuration : URLSessionConfiguration
  
/// Dictionary of all active Requests
  var requests = [String: SessionRequest]()
  
/// Array of all Requests that are pending Authentication
  var requestsPendingAuthentication = [SessionRequest]()
  
  // MARK: - Helper
  
  private static func startOperation() {
    UIApplication.shared.isNetworkActivityIndicatorVisible = true
  }
  
  private static func endOperation() {
    UIApplication.shared.isNetworkActivityIndicatorVisible = false
  }
  
  private func configureSessionForNoCookies(_ sessionConf: URLSessionConfiguration) {
    sessionConf.httpCookieStorage = nil
    sessionConf.httpShouldSetCookies = false
    sessionConf.httpCookieAcceptPolicy = .never
    sessionConf.urlCredentialStorage = nil
  }
  
  // MARK: - Initialization
  
  init(baseUrl: URL, configuration: URLSessionConfiguration) {
    self.baseUrl = baseUrl
    self.configuration = configuration
    self.session = URLSession(configuration: self.configuration)
  }
  
  open static let `default`: NetworkService = {
    let configuration = URLSessionConfiguration.default

    let url = URL(string: "")!
    return NetworkService(baseUrl: url, configuration: configuration)
  }()
  
  // MARK: - Private
  
  private func makeRequest(with path: String) -> URLRequest {
    var request: URLRequest
    let parts = path.split(separator: "?").map { String($0) }
    let url = baseUrl.appendingPathComponent(parts[0])
    if parts.count == 2, let query = parts.last, var components = URLComponents(string: url.absoluteString) {
      components.query = query
      request = URLRequest(url: components.url ?? url)
    } else {
      request = URLRequest(url: url)
    }
    return request
  }
  
  private func buildHTTPHeaders( for request: inout URLRequest, headers: HTTPHeaders = [:]) {
    let headers = headers
//    if let jwtToken = jwtToken {
//      headers["Authorization"] = jwtToken
//    }
    request.allHTTPHeaderFields = headers
  }
  
  // MARK: - Public
  
  private func removeRequest(sessionRequest: SessionRequest) {
    self.requests.removeValue(forKey: sessionRequest.requestIdentifier)
  }
  
  private func removeRequestsPendingAuthentication(sessionRequest: SessionRequest) {
    if let index = self.requestsPendingAuthentication.index(of:sessionRequest) {
      self.requestsPendingAuthentication.remove(at: index)
    }
  }
  

// MARK: - Base Actions
  
//  func submitRequest(path: String, data: Data? = nil, method: HTTPMethod, headers: HTTPHeaders = [:], expectedStatus : HTTPStatusCode, _ result: @escaping ((_ result: Result<DataResponse>) -> ()) ) {
  public func submitRequest(path: String, data: Data? = nil, method: HTTPMethod, headers: HTTPHeaders = [:], expectedStatuses : [HTTPStatusCode], _ result: @escaping DataTaskResultBlock ) {
    
    //build path
    var request = makeRequest(with: path)
    
    debugPrint("Path : \(path)")
    debugPrint("method : \(method.rawValue)")
    debugPrint("Full Path: \(request.url!)")
    
    //set body
    if let data = data { request.httpBody = data }
    
    //set method
    request.httpMethod = method.rawValue
    
    //set HTTPHeaders
    buildHTTPHeaders(for: &request)
    
    //make SessionRequest
    let sessionRequest = SessionRequest(request: request, expectedStatuses: expectedStatuses, session: self.session, resultBlock: result, delegate: self)
    
    //save networkRequest in dictionary
    self.requests[sessionRequest.requestIdentifier] = sessionRequest
    debugPrint("The request with ID \(sessionRequest.requestIdentifier) was added to requests.")

  }
  
  public func cancelRequest(with identifier: String) {
    if let request = self.requests[identifier] {
      request.cancel()
      self.requests.removeValue(forKey: identifier)
    }
  }
  
  public func resendRequestsPendingAuthentication() {
    _ = self.requestsPendingAuthentication.map {
      $0.restart()
    }
  }

}

// MARK: - Request Delegate

extension NetworkService : SessionRequestProtocol {
  
  private func removeRequestFromCollections(sessionRequest: SessionRequest) {
    let identifier = sessionRequest.requestIdentifier
    if let value = self.requests.removeValue(forKey: identifier) {
      debugPrint("The request with ID \(identifier) was removed from requests.")
    }
    
    if let index = self.requestsPendingAuthentication.index(of:sessionRequest) {
      self.requestsPendingAuthentication.remove(at: index)
      debugPrint("The request at index \(index) was removed.")
    }
  }
  
  func sessionRequestDidComplete(sessionRequest: SessionRequest) {
    removeRequestFromCollections(sessionRequest: sessionRequest)
  }
  
  func sessionRequestFailed(sessionRequest: SessionRequest, error: Error?) {
    if let err = error {
      debugPrint("Error \(err)")
    }
    removeRequestFromCollections(sessionRequest: sessionRequest)
  }
  
  func sessionRequestRequiresAuthentication(sessionRequest: SessionRequest) {
    self.requestsPendingAuthentication.append(sessionRequest)
    //TODO: Send Notification
//    [[NSNotificationCenter defaultCenter] postNotificationName:CCVChatcaveServiceAuthRequiredNotification object:nil];
  }
  
  
}
