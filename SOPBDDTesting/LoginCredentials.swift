//
//  LoginCredentials.swift
//  SOPBDDTesting
//
//  Created by OPS on 9/16/20.
//  Copyright © 2020 OPSolutions. All rights reserved.
//

import Foundation

struct LoginCredentials: Decodable {
    
    var email: String?
    var password: String?
    
    init(email: String?, password: String?) {
        self.email = email
        self.password = password
    }
}

extension String {
    
    func isValidEmail() -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: self)
    }
    
    //(?=.*[a-z]) - Check if password contains any character from a to z
    //.{8,} - Check if password is eight character long
    //(?=.*[A-Z]) - Check if password contains at least one big letter.
    //(?=.*[0-9]) - Check if password contains at least one number.
    func isValidPassword() -> Bool {
        let passwordRegex = "^(?=.*[a-z])(?=.*[0-9])(?=.*[A-Z]).{8,}$"
        return NSPredicate(format: "SELF MATCHES %@ ", passwordRegex).evaluate(with: self)
    }
}
