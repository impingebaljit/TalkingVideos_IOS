//
//  ForgotPasswordViewModel.swift
//  TalkingVideos
//
//  Created by Nisha Gupta on 13/03/25.
//

import UIKit
import AuthenticationServices

class ForgotPasswordViewModel {

    var onPasswordResetSuccess: (() -> Void)?
    var onPasswordResetFailure: ((String) -> Void)?
    private let authService: AuthService
    
    
    // Dependency Injection
    init(authService: AuthService) {
        self.authService = authService
    }

    func validateEmail(_ email: String) -> String? {
        if email.isEmpty {
            return "Email cannot be empty"
        }

        if !isValidEmail(email) {
            return "Invalid email format"
        }

        return nil
    }

    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = ".+@.+\\..+"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
    }

    
    func forgotPassword(email: String, completion: @escaping (Bool, String?) -> Void) {
        // Validate input field
        guard !email.isEmpty else {
            completion(false, "Email is required.")
            return
        }

        // Validate email format
        guard isValidEmail(email) else {
            completion(false, "Invalid email format.")
            return
        }

        // Perform the forgot password request asynchronously
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }

            authService.forgotPassword(email: email) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let response):
                        print("✅ Password reset successful: \(response.message)")
                        completion(true, response.message) // Send success message

                    case .failure(let error):
                        print("❌ Forgot password failed: \(error.localizedDescription)")
                        completion(false, error.localizedDescription) // Return error message
                    }
                }
            }
        }
    }

}
