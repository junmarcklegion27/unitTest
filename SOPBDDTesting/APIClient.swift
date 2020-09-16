//
//  APIClient.swift
//  SOPBDDTesting
//
//  Created by OPS on 9/16/20.
//  Copyright © 2020 OPSolutions. All rights reserved.
//

import UIKit

class APIClient: NSObject {
    var session: URLSession
    var isAPISuccessful: Bool
    
    init(session: URLSession) {
        self.session = session
        isAPISuccessful = false
    }
    
    func loginToApp(using email: String, and password: String) {
        let url = URL(string: "https://sample.api.com?email=\(email)&pass=\(password)&&time_zone=Asia%2FManila")!
        self.session.dataTask(with: url) { (data, response, error) in
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: [.mutableContainers]) as? NSDictionary
                self.apiSuccessful(json: json ?? NSDictionary())
                
            } catch {
                print(error.localizedDescription)
            }
        }.resume()
    }
    
    private func apiSuccessful(json: NSDictionary) {
        let apiSuccessful: String = json.object(forKey: "success") as! String
        if (apiSuccessful == "true") {
            self.isAPISuccessful = true
            return
        }
        self.isAPISuccessful = false
    }

}
