//
//  LoginViewModelTests.swift
//  MapzinTests
//
//  Created by Amir Malamud on 11/06/2024.
//

import XCTest
@testable import Mapzin

class LoginViewModelTests: XCTestCase {
    var sut: LoginViewModel!
    var mockAuthService: MockFirebaseAuthService!

    override func setUpWithError() throws {
        try super.setUpWithError()
        mockAuthService = MockFirebaseAuthService()
        sut = LoginViewModel(authProvider: mockAuthService)
    }

    override func tearDownWithError() throws {
        sut = nil
        mockAuthService = nil
        try super.tearDownWithError()
    }

    func testLoginSuccess() {
        // Given
        let expectation = XCTestExpectation(description: "Login success")
        mockAuthService.signInResult = .success(())
        
        // When
        sut.email = "test@example.com"
        sut.password = "password123"
        sut.login()
        
        // Then
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertTrue(self.sut.isLoggedIn)
            XCTAssertTrue(self.sut.errorMessage.isEmpty)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }

    func testLoginFailure() {
        // Given
        let expectation = XCTestExpectation(description: "Login failure")
        mockAuthService.signInResult = .failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid credentials"]))
        
        // When
        sut.email = "test@example.com"
        sut.password = "wrongpassword"
        sut.login()
        
        // Then
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertFalse(self.sut.isLoggedIn)
            XCTAssertEqual(self.sut.errorMessage, "Invalid credentials")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }

    func testSignUpSuccess() {
        // Given
        let expectation = XCTestExpectation(description: "Sign up success")
        mockAuthService.createUserResult = .success(())
        
        // When
        sut.email = "newuser@example.com"
        sut.password = "newpassword123"
        sut.signUp()
        
        // Then
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertTrue(self.sut.isLoggedIn)
            XCTAssertTrue(self.sut.errorMessage.isEmpty)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }

    func testSignUpFailure() {
        // Given
        let expectation = XCTestExpectation(description: "Sign up failure")
        mockAuthService.createUserResult = .failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Email already in use"]))
        
        // When
        sut.email = "existinguser@example.com"
        sut.password = "password123"
        sut.signUp()
        
        // Then
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertFalse(self.sut.isLoggedIn)
            XCTAssertEqual(self.sut.errorMessage, "Email already in use")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
}

// Mock FirebaseAuthService for testing
class MockFirebaseAuthService: FirebaseAuthService {
    var signInResult: Result<Void, Error>?
    var createUserResult: Result<Void, Error>?

    override func signIn(withEmail email: String, password: String) -> AsyncStream<Result<Void, Error>> {
        return AsyncStream { continuation in
            if let result = signInResult {
                continuation.yield(result)
                continuation.finish()
            }
        }
    }

    override func createUser(withEmail email: String, password: String) -> AsyncStream<Result<Void, Error>> {
        return AsyncStream { continuation in
            if let result = createUserResult {
                continuation.yield(result)
                continuation.finish()
            }
        }
    }
}
