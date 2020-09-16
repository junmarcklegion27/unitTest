//
//  LoginTests.swift
//  SOPBDDTestingTests
//
//  Created by OPS on 9/16/20.
//  Copyright © 2020 OPSolutions. All rights reserved.
//

import XCTest
@testable import SOPBDDTesting

class LoginTests: XCTestCase {

    private var loginVC: LoginViewController?
    
    // MARK: - Setup
    
    override func setUpWithError() throws {
        loginVC = LoginViewController()
        let email: String = "demo@ufs.com"
        let password: String = "Pass1234"
        do {
            try Keychain.set(value: (email.data(using: .utf8))!, account: "username")
            try Keychain.set(value: (password.data(using: .utf8))!, account: "password")
        } catch {
            print(error.localizedDescription)
        }
    }
    
    // MARK: - Test if Keychain Exists
    
    func testUsernameKeychainExists() {
        do {
            let keyChainExists = try Keychain.exists(account: "username")
            XCTAssertTrue(keyChainExists)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func testPasswordKeychainExists() {
        do {
            let keyChainExists = try Keychain.exists(account: "password")
            XCTAssertTrue(keyChainExists)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    // MARK: - Test if Login Credentials not nil
    
    func testLoginCredentialsNotNil() {
        let email: String = "demo@ufs.com"
        let password: String = "Pass1234"
        let sut = LoginCredentials(email: email, password: password)
        XCTAssertNotNil(sut)
    }
    
    // MARK: - Test if Email is Valid

    func testEmailValidity() throws {
        let email: String = "demo@ufs.com"
        XCTAssertTrue(email.isValidEmail())
    }
    
    // MARK: - Test if Password is Valid
    
    func testPasswordValidity() throws {
        let password: String = "Pass1234"
        XCTAssertTrue(password.isValidPassword())
    }
    
    // MARK: Given that I am an SR and I am online or offline
    
    /*  When I input valid Username/Email and Password
        Then it should be accepted and show home screen */

    func testEmailAndPasswordValidity() throws {
        let email: String = "demo@ufs.com"
        let password: String = "Pass1234"
        XCTAssertTrue(loginVC!.isEmailAndPassWordValid(email: email, password: password))
    }
    
    /*  When I input an valid Username/Email and invalid Password
        Then a popup should show */

    func testValidEmailAndInvalidPassword() throws {
        let email: String = "demo@ufs.com"
        let password: String = "pass"
        XCTAssertFalse(loginVC!.isEmailAndPassWordValid(email: email, password: password))
    }
    
    /*  When I input an invalid Username/Email and valid Password
        Then a popup should show */
    
    func testInvalidEmailAndValidPassword() throws {
        let email: String = "demo@.com"
        let password: String = "Pass1234"
        XCTAssertFalse(loginVC!.isEmailAndPassWordValid(email: email, password: password))
    }
    
    /*  When I input an invalid Username/Email and  Password
        Then a popup should show */
    
    func testInvalidEmailAndPassword() throws {
        let email: String = "@.com"
        let password: String = "passonetwo"
        XCTAssertFalse(loginVC!.isEmailAndPassWordValid(email: email, password: password))
    }
    
    // MARK: Given that I am an SR and I am offline When I input valid Username/Email and Password
    
    // And Correct Username/Email and Password
    
    func testAPIValidAndCorrectEmailAndPassword() {
        let email: String = "demo@ufs.com"
        let password: String = "Pass1234"
        let responseString = "{\"success\": \"true\"}"
        let responseData = responseString.data(using: .utf8)
        let sessionMock = URLSessionMock(data: responseData, response: nil, error: nil)
        let apiClient = APIClient(session: sessionMock)
      
        apiClient.loginToApp(using: email, and: password)
      
        XCTAssertTrue(apiClient.isAPISuccessful)
    }
    
    // And incorrect Username/Email and password
    
    func testAPIValidEmailAndPassword_AndIncorrectEmailAndPassword() {
        let email: String = "demo@ufc.com"
        let password: String = "Pass1235"
        let responseString = "{\"success\": \"false\"}"
        let responseData = responseString.data(using: .utf8)
        let sessionMock = URLSessionMock(data: responseData, response: nil, error: nil)
        let apiClient = APIClient(session: sessionMock)
      
        apiClient.loginToApp(using: email, and: password)
      
        XCTAssertFalse(apiClient.isAPISuccessful)
    }
    
    // And incorrect Username/Email and correct Password
    
    func testAPIValidEmailAndPassword_AndIncorrectEmailAndCorrectPassword() {
        let email: String = "demo@ufc.com"
        let password: String = "Pass1234"
        let responseString = "{\"success\": \"false\"}"
        let responseData = responseString.data(using: .utf8)
        let sessionMock = URLSessionMock(data: responseData, response: nil, error: nil)
        let apiClient = APIClient(session: sessionMock)
      
        apiClient.loginToApp(using: email, and: password)
      
        XCTAssertFalse(apiClient.isAPISuccessful)
    }
    
    // And correct Username/Email and inorrect Password
    
    func testAPIValidEmailAndPassword_AndCorrectEmailAndIncorrectPassword() {
        let email: String = "demo@ufs.com"
        let password: String = "Pass1235"
        let responseString = "{\"success\": \"false\"}"
        let responseData = responseString.data(using: .utf8)
        let sessionMock = URLSessionMock(data: responseData, response: nil, error: nil)
        let apiClient = APIClient(session: sessionMock)
      
        apiClient.loginToApp(using: email, and: password)
      
        XCTAssertFalse(apiClient.isAPISuccessful)
    }
    
    // MARK: Given that I am an SR and I am online When I input valid Username/Email and Password
    
    // And correct Username/Email and Password
    
    func testKeyChainValidAndCorrectEmailAndPassword() {
        let email: String = "demo@ufs.com"
        let password: String = "Pass1234"
        XCTAssertTrue(loginVC!.isEmailAndPasswordMatchesWithKeyChain(email: email, password: password))
    }
    
    // And incorrect Username/Email and Password
    
    func testKeyChainValidEmailAndPassword_AndIncorrectEmailAndPassword() {
        let email: String = "demo@ufc.com"
        let password: String = "Pass1235"
        XCTAssertFalse(loginVC!.isEmailAndPasswordMatchesWithKeyChain(email: email, password: password))
    }
    
    // And incorrect Username/Email and correct Password
    
    func testKeyChainValidEmailAndPassword_AndIncorrectEmailAndCorrectPassword() {
        let email: String = "demo@ufc.com"
        let password: String = "Pass1234"
        XCTAssertFalse(loginVC!.isEmailAndPasswordMatchesWithKeyChain(email: email, password: password))
    }
    
    // And correct Username/Email and incorrect Password
    
    func testKeychainValidEmailAndPassword_AndCorrectEmailAndIncorrectPassword() {
        let email: String = "demo@ufs.com"
        let password: String = "Pass1235"
        XCTAssertFalse(loginVC!.isEmailAndPasswordMatchesWithKeyChain(email: email, password: password))
    }
}
