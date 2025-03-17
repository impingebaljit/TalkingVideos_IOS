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
    
    private let authService: AuthService
    
    var signUp: SignUpModel?
    
   
    
    // Inputs
    var name: String = ""
    var email: String = ""
    var password: String = ""

    // Dependency Injection
    init(authService: AuthService) {
        self.authService = authService
    }

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

//    private func isValidPassword(_ password: String) -> Bool {
//        let passwordRegex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d).{6,}$"
//        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: password)
//    }
    
    private func isValidPassword(_ password: String) -> Bool {
        return password.count >= 6
    }

    func signUp(name: String, email: String, password: String, completion: @escaping (Bool, String?) -> Void) {
        // Validate input fields
        guard !name.isEmpty, !email.isEmpty, !password.isEmpty else {
            completion(false, "Name, email, and password are required.")
            return
        }

        // Validate email and password format
        guard isValidEmail(email), isValidPassword(password) else {
            completion(false, "Invalid email or password format.")
            return
        }

        // Perform sign-up asynchronously
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }

            authService.signUp(name: name, email: email, password: password) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let user):
                        // Handle successful authentication
                        print("User successfully signed up with ID: \(user)")
                        //self.user = user
                        completion(true, nil)

                    case .failure(let error):
                        // Handle authentication failure
                        completion(false, error.localizedDescription)
                    }
                }
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
