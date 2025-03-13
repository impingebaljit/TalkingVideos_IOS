//
//  ForgotPasswordViewModel.swift
//  TalkingVideos
//
//  Created by Nisha Gupta on 13/03/25.
//

import UIKit

class ForgotPasswordViewModel {

    var onPasswordResetSuccess: (() -> Void)?
    var onPasswordResetFailure: ((String) -> Void)?

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

    func resetPassword(email: String) {
        // Simulate an API call (replace with real API request)
        DispatchQueue.global().asyncAfter(deadline: .now() + 2) {
            if email == "test@example.com" {
                DispatchQueue.main.async {
                    self.onPasswordResetFailure?("Email not registered")
                }
            } else {
                DispatchQueue.main.async {
                    self.onPasswordResetSuccess?()
                }
            }
        }
    }
}
