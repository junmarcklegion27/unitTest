//
//  LoginViewController.swift
//  SOPBDDTesting
//
//  Created by OPS on 9/16/20.
//  Copyright © 2020 OPSolutions. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak private var emailTextField: UITextField!
    @IBOutlet weak private var passwordTextField: UITextField!
    @IBOutlet weak private var signInButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    func isEmailAndPassWordValid(email: String, password: String) -> Bool {
        if (email.isValidEmail() && password.isValidPassword()) {
            return true;
        }
        return false;
    }
    
    func isEmailAndPasswordMatchesWithKeyChain(email: String, password: String) -> Bool {
        let emailKeychain: String = getEmailFromKeychain()
        let passwordKeychain: String = getPasswordFromKeychain()
        let isEmailMatched: Bool = (emailKeychain == email)
        let isPasswordMatched: Bool = (passwordKeychain == password)
        if (isEmailMatched && isPasswordMatched) {
            return true
        }
        return false
    }
    
    private func getEmailFromKeychain() -> String {
        do {
            let usernameData: Data! = try Keychain.get(account: "username")
            return String(decoding: usernameData, as: UTF8.self)
        } catch {
            print(error.localizedDescription)
            return ""
        }
    }
    
    private func getPasswordFromKeychain() -> String {
        do {
            let passwordData: Data! = try Keychain.get(account: "password")
            return String(decoding: passwordData, as: UTF8.self)
        } catch {
            print(error.localizedDescription)
            return ""
        }
    }
    
}

