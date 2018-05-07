//
//  NetworkRequest.swift
//  VaporCountriesIOS
//
//  Created by Mihaela Mihaljevic Jakic on 07/05/2018.
//  Copyright © 2018 Mihaela Mihaljevic Jakic. All rights reserved.
//

import UIKit

public enum TaskKind : String {
  case data = "data"
  case upload = "upload"
  case download = "download"
}

// MARK: - Protocol
protocol SessionRequestProtocol : class {
  // 'class' means only class types can implement it
  func sessionRequestDidComplete(sessionRequest: SessionRequest)
  func sessionRequestRequiresAuthentication(sessionRequest: SessionRequest)
  func sessionRequestFailed(sessionRequest: SessionRequest, error: inout Error)
}

// MARK: - Class


public class SessionRequest {
  let request : URLRequest
  let expectedStatus : HTTPStatusCode
  let session : URLSession
  let taskKind : TaskKind = .data
  let requestIdentifier : String
  weak var delegate : SessionRequestProtocol?
  
  //A trick to use methods in initializer and avoid the error:
  //'self' used before all stored properties are initialized
  private var _task: URLSessionDataTask!
  var task: URLSessionDataTask {
    return _task
  }
  
  init(request: URLRequest, expectedStatus : HTTPStatusCode, session : URLSession, delegate: SessionRequestProtocol? = nil) {
    self.expectedStatus = expectedStatus
    self.session = session
    self.request = request
    self.delegate = delegate
    self.requestIdentifier = UUID().uuidString
    self._task = self.makeDataTask()
    self.task.resume()
  }
  
  private func makeDataTask() -> URLSessionDataTask {
    
    let _task = session.dataTask(with: request) { [unowned self] (data, response, error) in
      
      if let response = response as? HTTPURLResponse {

        let request = self.request
        
        if (response.statusCode == self.expectedStatus.rawValue) {
          debugPrint("Success: \(request.httpMethod!), \(request.url!), \(self.expectedStatus) ")
          
          DispatchQueue.main.async {
            if let delegate = self.delegate {
              delegate.sessionRequestDidComplete(sessionRequest: self)
            }
            
          }
          
        } else if (response.statusCode == HTTPStatusCode.unauthorized.rawValue) {
          
        } else {
          
        }
        
      }
      
    }
    return _task
    
  }
  
}

extension SessionRequest: Equatable {
  public static func == (lhs: SessionRequest, rhs: SessionRequest) -> Bool {
    return
      lhs.requestIdentifier == rhs.requestIdentifier
  }
}
