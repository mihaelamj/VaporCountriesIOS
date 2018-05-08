//
//  Debug.swift
//  BoostSDK
//
//  Created by Ondrej Rafaj on 01/04/2018.
//  Copyright © 2018 LiveUI. All rights reserved.
//

import Foundation


class Debug {
    
    static func print(_ message: String) {
        Swift.print("Debug: \(message)")
    }
    
    static func request(_ request: URLRequest?, response: URLResponse?, data: Data?) {
      if let request = request {
        debugPrint("\n\n\n[\(request.httpMethod ?? "???")] request:\n\(request)")
      } else {
        debugPrint("request is NIL!")
      }
      if let response = response {
        debugPrint("\(response.mimeType ?? "???") response:\n\(response)")
      } else {
        debugPrint("response is NIL!")
      }
      if let data = data {
        debugPrint("Data:\n\(String(data: data, encoding: .utf8) ?? "unknown")\n\n")
      } else {
        debugPrint("data is NIL!")
      }
    }
    
}
