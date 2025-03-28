//
//  SignInViewModel.swift
//  Bluelight
//
//  Created by Nisha Gupta on 16/01/24.
//

import UIKit
import Foundation
import AuthenticationServices





class SignInViewModel: NSObject {
    // ViewModel for the Sign In screen

    private let authService: AuthService
    
    var user: SignInModel?
    
    var onAppleSignInSuccess: ((String, String,String) -> Void)?
    var onAppleSignInFailure: ((String) -> Void)?
    
    // Inputs
    var email: String = ""
    var password: String = ""
   

    // Dependency Injection
    init(authService: AuthService) {
        self.authService = authService
    }

    // Outputs
    func handleAppleSignIn() {
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.fullName, .email]

        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.performRequests()
    }
  
        func signIn(email: String, password: String, completion: @escaping (Bool, String?) -> Void) {
            // Validate input fields
            guard !email.isEmpty, !password.isEmpty else {
                completion(false, "Email and password are required.")
                return
            }
            
            guard isEmailValid(email) else {
                completion(false, "Invalid email format.")
                return
            }
            
            guard password.count >= 6 else {
                completion(false, "Password must be at least 6 characters long.")
                return
            }
            
            // Perform the sign-in request on a background thread
            DispatchQueue.global().async { [weak self] in
                guard let self = self else { return }
                
                authService.signIn(email: email, password: password) { result in
                    DispatchQueue.main.async {
                        switch result {
                        case .success(let user):
                            // Authentication successful
                            self.user = user
                            UserDefaults.standard.set(self.user?.token, forKey: "authToken")
                            UserDefaults.standard.set(true, forKey: "isUserLoggedIn")
                               UserDefaults.standard.synchronize()
                            completion(true, nil)
                            
                        case .failure(let error):
                            // Authentication failed
                            completion(false, error.localizedDescription)
                        }
                    }
                }
            }
        }

    
    
    
    
    private func isEmailValid(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }

   

    // Assuming you have a function to check if a textfield is blank
    private func isTextFieldNotBlank(_ text: String) -> Bool {
        return !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}

extension SignInViewModel: ASAuthorizationControllerDelegate {
   
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {

            let fullName = appleIDCredential.fullName?.givenName ?? ""
            let email = appleIDCredential.email ?? ""

            if let identityTokenData = appleIDCredential.identityToken,
               let identityToken = String(data: identityTokenData, encoding: .utf8) {
                print("🪪 Identity Token: \(identityToken)")
                onAppleSignInSuccess?(fullName, email, identityToken)
            } else {
                print("Failed to retrieve identity token")
                onAppleSignInFailure?("Failed to retrieve identity token")
            }
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        onAppleSignInFailure?(error.localizedDescription)
    }
}
