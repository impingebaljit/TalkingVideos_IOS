//
//  SignUpViewModel.swift
//  TalkingVideos
//
//  Created by Nisha Gupta on 13/03/25.
//

import UIKit

import Foundation
import AuthenticationServices

class SignUpViewModel: NSObject {

    var onAppleSignInSuccess: ((String, String) -> Void)?
    var onAppleSignInFailure: ((String) -> Void)?

    func validateFields(name: String, email: String, password: String) -> String? {
        if name.isEmpty { return "Name cannot be empty" }
        if !isValidEmail(email) { return "Invalid email address" }
        if !isValidPassword(password) {
            return "Password must be at least 6 characters long and contain uppercase, lowercase, and a number"
        }
        return nil
    }

    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = ".+@.+\\..+"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
    }

    private func isValidPassword(_ password: String) -> Bool {
        let passwordRegex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d).{6,}$"
        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: password)
    }

    func signUp(user: User, completion: @escaping (Bool, String?) -> Void) {
        // Simulated API call (Replace with real network request)
        DispatchQueue.global().asyncAfter(deadline: .now() + 2) {
            if user.email == "test@example.com" {
                completion(false, "User already exists")
            } else {
                completion(true, nil) // Success
            }
        }
    }

    func handleAppleSignIn() {
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.fullName, .email]

        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.performRequests()
    }
}

extension SignUpViewModel: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            let fullName = appleIDCredential.fullName?.givenName ?? ""
            let email = appleIDCredential.email ?? ""
            onAppleSignInSuccess?(fullName, email)
        }
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        onAppleSignInFailure?(error.localizedDescription)
    }
}
