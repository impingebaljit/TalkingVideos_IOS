//
//  ResetPassViewModel.swift
//  TalkingVideos
//
//  Created by Nisha Gupta on 17/03/25.
//

import UIKit
import AuthenticationServices

class ResetPassViewModel {

    var onPasswordResetSuccess: (() -> Void)?
    var onPasswordResetFailure: ((String) -> Void)?
    private let authService: AuthService
    
    
    // Dependency Injection
    init(authService: AuthService) {
        self.authService = authService
    }

   

    func resetPassword(email: String, newPassword: String, confirmPassword: String, completion: @escaping (Bool, String?) -> Void) {
        // Ensure passwords match before making the request
        guard newPassword == confirmPassword else {
            completion(false, "Passwords do not match.")
            return
        }

        // Construct the request body
        let requestBody: [String: Any] = [
            "email": email,
            "new_password": newPassword,
            "confirm_password": confirmPassword
        ]

        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }

            authService.resetPassword(email: email, newPassword: newPassword, confirmPassword: confirmPassword) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let response):
                        print(" Password reset successful: \(response.message)")
                        completion(true, response.message) // Send success message

                    case .failure(let error):
                        print("Password reset failed: \(error.localizedDescription)")
                        completion(false, error.localizedDescription) // Return error message
                    }
                }
            }
        }
    }


}
