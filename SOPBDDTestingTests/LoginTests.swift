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
    
    func testKeychainExists() {
        do {
            let keyChainExists = try Keychain.exists(account: "username")
            XCTAssertTrue(keyChainExists)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func testLoginCredentialsNotNil() {
        let email: String = "demo@ufs.com"
        let password: String = "Pass1234"
        let sut = LoginCredentials(email: email, password: password)
        XCTAssertNotNil(sut)
    }

    func testEmailValidity() throws {
        let email: String = "demo@ufs.com"
        XCTAssertTrue(email.isValidEmail())
    }

    func testPasswordValidity() throws {
        let password: String = "Pass1234"
        XCTAssertTrue(password.isValidPassword())
    }
    
    func testEmailAndPasswordValidity() throws {
        let email: String = "demo@ufs.com"
        let password: String = "Pass1234"
        XCTAssertTrue(loginVC!.isEmailAndPassWordValid(email: email, password: password))
    }

    func testValidEmailAndInvalidPassword() throws {
        let email: String = "demo@ufs.com"
        let password: String = "pass"
        XCTAssertFalse(loginVC!.isEmailAndPassWordValid(email: email, password: password))
    }
    
    func testInvalidEmailAndValidPassword() throws {
        let email: String = "demo@.com"
        let password: String = "Pass1234"
        XCTAssertFalse(loginVC!.isEmailAndPassWordValid(email: email, password: password))
    }
    
    func testInvalidEmailAndPassword() throws {
        let email: String = "@.com"
        let password: String = "passonetwo"
        XCTAssertFalse(loginVC!.isEmailAndPassWordValid(email: email, password: password))
    }
    
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
    
    func testKeyChainValidAndCorrectEmailAndPassword() {
        let email: String = "demo@ufs.com"
        let password: String = "Pass1234"
        XCTAssertTrue(loginVC!.isEmailAndPasswordMatchesWithKeyChain(email: email, password: password))
    }
    
    func testKeyChainValidEmailAndPassword_AndIncorrectEmailAndPassword() {
        let email: String = "demo@ufc.com"
        let password: String = "Pass1235"
        XCTAssertFalse(loginVC!.isEmailAndPasswordMatchesWithKeyChain(email: email, password: password))
    }
    
    func testKeyChainValidEmailAndPassword_AndIncorrectEmailAndCorrectPassword() {
        let email: String = "demo@ufc.com"
        let password: String = "Pass1234"
        XCTAssertFalse(loginVC!.isEmailAndPasswordMatchesWithKeyChain(email: email, password: password))
    }
    
    func testKeychainValidEmailAndPassword_AndCorrectEmailAndIncorrectPassword() {
        let email: String = "demo@ufs.com"
        let password: String = "Pass1235"
        XCTAssertFalse(loginVC!.isEmailAndPasswordMatchesWithKeyChain(email: email, password: password))
    }
}
