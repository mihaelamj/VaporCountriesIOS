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

func checkResponseStatus(status : NSInteger, expectedStatuses : [HTTPStatusCode]) -> Bool {
  return expectedStatuses.filter({
    $0.rawValue == status
  }).count > 0
}

func statusesString(_ statuses : [HTTPStatusCode]) -> String {
  var all : String = ""
  _ = statuses.map {
    all = all + "\($0.description)"
  }
  return all
}

// MARK: - Protocol
protocol SessionRequestProtocol : class {
  // 'class' means only class types can implement it
  func sessionRequestDidComplete(sessionRequest: SessionRequest)
  func sessionRequestRequiresAuthentication(sessionRequest: SessionRequest)
  func sessionRequestFailed(sessionRequest: SessionRequest, error: Error?)
}



// MARK: - Class

//let result: ((_ result: Result<DataResponseTuple>) -> ())

public class SessionRequest {
  let request : URLRequest
  let expectedStatuses : [HTTPStatusCode]
  let session : URLSession
  let taskKind : TaskKind = .data
  let requestIdentifier : String
  let resultBlock : DataTaskResultBlock
  weak var delegate : SessionRequestProtocol?
  
  //A trick to use methods in initializer and avoid the error: 'self' used before all stored properties are initialized
  private var _task: URLSessionDataTask!
  var task: URLSessionDataTask {
    return _task
  }
  
// MARK: - Init
  
  init(request: URLRequest, expectedStatuses : [HTTPStatusCode], session : URLSession, resultBlock : @escaping DataTaskResultBlock, delegate: SessionRequestProtocol? = nil) {
    self.expectedStatuses = expectedStatuses
    self.session = session
    self.request = request
    self.delegate = delegate
    self.resultBlock = resultBlock
    self.requestIdentifier = UUID().uuidString
    self._task = self.makeDataTaskWeak()
    self.task.resume()
  }
  
// MARK: - Base
  
  private func makeDataTaskUnowned() -> URLSessionDataTask {
    
    let _atask = session.dataTask(with: request) { [unowned self] (data, response, error) in
      
      if let response = response as? HTTPURLResponse {
        
        let request = self.request
        
        if (checkResponseStatus(status: response.statusCode, expectedStatuses: self.expectedStatuses)) {
          debugPrint("Success: \(request.httpMethod!), \(request.url!), \(self.expectedStatuses) ")
          DispatchQueue.main.async {
            
            //call result block as success
            self.resultBlock(Result.success((data: data, response: response)))
            
            //call delegate
            if let delegate = self.delegate {
              delegate.sessionRequestDidComplete(sessionRequest: self)
            }
            
          }
          
        } else if (response.statusCode == HTTPStatusCode.unauthorized.rawValue) {
          debugPrint("Authentication required for: \(request.httpMethod!), \(request.url!), \(self.expectedStatuses) ")
          DispatchQueue.main.async {
            //call delegate
            if let delegate = self.delegate {
              delegate.sessionRequestRequiresAuthentication(sessionRequest: self)
            }
          }
          
        } else {
          debugPrint("Invalid status code \(response.statusCode) for: \(request.httpMethod!), \(request.url!), \(self.expectedStatuses) ")
          DispatchQueue.main.async {
            
            //call result block as error
            self.resultBlock(Result.error(Problem.invalidStatusCode))
            
            //call delegate
            if let delegate = self.delegate {
              delegate.sessionRequestFailed(sessionRequest: self, error: error)
            }
          }
          
        }
        
      }
    }
    return _atask
  }
  
  private func makeDataTaskWeakOld() -> URLSessionDataTask {
    
    
    let _atask = session.dataTask(with: request) { [weak self] (data, response, error) in
      
      Debug.request(self?.request, response: response, data: data)
      
      if let response = response as? HTTPURLResponse {
        
        guard let strongSelf = self else {
          debugPrint("Error: self is deallocated!!")
          return
        }
        
        let request = strongSelf.request
        
        if (checkResponseStatus(status: response.statusCode, expectedStatuses: (self?.expectedStatuses)!)) {
          debugPrint("Success: \(request.httpMethod ?? "no method"), \(String(describing: request.url!) ), \(statusesString((self?.expectedStatuses)!))")
          DispatchQueue.main.async {
            
            //call result block as success
            strongSelf.resultBlock(Result.success((data: data, response: response)))
            
            //call delegate
            if let delegate = strongSelf.delegate {
              delegate.sessionRequestDidComplete(sessionRequest: strongSelf)
            }
            
          }
          
        } else if (response.statusCode == HTTPStatusCode.unauthorized.rawValue) {
          debugPrint("Authentication required for: \(request.httpMethod!), \(String(describing: request.url!)), \(statusesString((strongSelf.expectedStatuses)))")
          DispatchQueue.main.async {
            //call delegate
            if let delegate = strongSelf.delegate {
              delegate.sessionRequestRequiresAuthentication(sessionRequest: strongSelf)
            }
          }
          
        } else {
          debugPrint("Invalid status code \(response.statusCode) for: \(String(describing: request.httpMethod!) ), \(String(describing: request.url!)), \(statusesString((strongSelf.expectedStatuses)))")
          DispatchQueue.main.async {
            
            //call result block as error
            strongSelf.resultBlock(Result.error(Problem.invalidStatusCode))
            
            //call delegate
            if let delegate = strongSelf.delegate {
              delegate.sessionRequestFailed(sessionRequest: strongSelf, error: error)
            }
          }
          
        }
        
      }
    }
    return _atask
  }
  
  private func makeDataTaskWeak() -> URLSessionDataTask {
    
    let mySelf : SessionRequest? = self
    
    let _atask = session.dataTask(with: request) { [weak self] (data, response, error) in
      
//      Debug.request(self?.request, response: response, data: data)
      
      if let response = response as? HTTPURLResponse {
        
        guard let strongSelf = self else {
          debugPrint("Error: self is deallocated!!")
          if (mySelf == nil) {
            debugPrint("mySelf is NIL")
          } else {
            debugPrint("mySelf: \(mySelf!)")
          }
          return
        }
        
        let request = strongSelf.request
        
        if (checkResponseStatus(status: response.statusCode, expectedStatuses: (self?.expectedStatuses)!)) {
          debugPrint("Success: \(request.httpMethod ?? "no method"), \(String(describing: request.url!) ), \(statusesString((self?.expectedStatuses)!))")
          DispatchQueue.main.async {
            
            //call result block as success
            strongSelf.resultBlock(Result.success((data: data, response: response)))
            
            //call delegate
            if let delegate = strongSelf.delegate {
              delegate.sessionRequestDidComplete(sessionRequest: strongSelf)
            }
            
          }
          
        } else if (response.statusCode == HTTPStatusCode.unauthorized.rawValue) {
          debugPrint("Authentication required for: \(request.httpMethod!), \(String(describing: request.url!)), \(statusesString((strongSelf.expectedStatuses)))")
          DispatchQueue.main.async {
            //call delegate
            if let delegate = strongSelf.delegate {
              delegate.sessionRequestRequiresAuthentication(sessionRequest: strongSelf)
            }
          }
          
        } else {
          debugPrint("Invalid status code \(response.statusCode) for: \(String(describing: request.httpMethod!) ), \(String(describing: request.url!)), \(statusesString((strongSelf.expectedStatuses)))")
          DispatchQueue.main.async {
            
            //call result block as error
            strongSelf.resultBlock(Result.error(Problem.invalidStatusCode))
            
            //call delegate
            if let delegate = strongSelf.delegate {
              delegate.sessionRequestFailed(sessionRequest: strongSelf, error: error)
            }
          }
          
        }
        
      }
    }
    return _atask
  }

  
  
// MARK: - Public
  
  public func cancel() {
    self.task.cancel()
  }
  
  public func restart() {
    self._task = makeDataTaskWeak()
    self.task.resume()
  }
  
}

extension SessionRequest: Equatable {
  public static func == (lhs: SessionRequest, rhs: SessionRequest) -> Bool {
    return
      lhs.requestIdentifier == rhs.requestIdentifier
  }
}
