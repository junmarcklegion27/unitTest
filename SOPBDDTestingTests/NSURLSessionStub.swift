//
//  NSURLSessionStub.swift
//  SOPBDDTestingTests
//
//  Created by OPS on 9/16/20.
//  Copyright © 2020 OPSolutions. All rights reserved.
//

import Foundation

public final class URLSessionMock : URLSession {
    
    var url: URL?
    var request: URLRequest?
    private var dataTaskMock: URLSessionDataTaskMock
  
    init(data: Data?, response: URLResponse?, error: Error?) {
        dataTaskMock = URLSessionDataTaskMock()
        dataTaskMock.taskResponse = (data, response, error) as? (Data?, URLResponse?, NSError?)
    }
    
    public override func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        self.url = url
        self.dataTaskMock.completionHandler = completionHandler
        return self.dataTaskMock
    }
    
    public override func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        self.request = request
        self.dataTaskMock.completionHandler = completionHandler
        return self.dataTaskMock
    }
  
    final private class URLSessionDataTaskMock : URLSessionDataTask {
    
        typealias CompletionHandler = (Data?, URLResponse?, NSError?) -> Void
        var completionHandler: CompletionHandler?
        var taskResponse: (Data?, URLResponse?, NSError?)?
    
        override func resume() {
            completionHandler?(taskResponse?.0, taskResponse?.1, taskResponse?.2)
        }
    }
}

