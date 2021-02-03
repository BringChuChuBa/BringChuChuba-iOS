//
//  AuthTests.swift
//  BringChuChubaTests
//
//  Created by 홍다희 on 2021/02/02.
//

import XCTest
import FirebaseAuth

class AuthTests: XCTestCase {
  func signInAnonymously() {
    // Create an expectation for a background download task.
    let expectation = self.expectation(description: "Anonymous sign-in finished.")

    let auth = Auth.auth()

    // Start the background task.
    auth.signInAnonymously() { (result, error) in
      if let error = error {
        print("Anonymous sign in error: \(error)")
      }
      // Fulfill the expectation to indicate that the background task has finished successfully.
      expectation.fulfill()
    }

    // Wait until the expectation is fulfilled, with a timeout of 10 seconds.
    waitForExpectations(timeout: 10.0)
  }

  func signOut() {
    let auth = Auth.auth()
    do {
      try auth.signOut()
    } catch (let error) {
      print("Error signing out: \(error)")
    }
  }

  func deleteCurrentUser() {
    let auth = Auth.auth()
    let expectation = self.expectation(description: "Delete current user finished.")
    auth.currentUser?.delete() { (error) in
      if let error = error {
        print("Anonymous sign in error: \(error)")
      }
      expectation.fulfill()
    }
    waitForExpectations(timeout:10.0)
  }

}
