//
//  ProfileViewModel.swift
//  TalkingVideos
//
//  Created by Nisha Gupta on 20/03/25.
//

import UIKit
import AuthenticationServices


class ProfileViewModel {
    private let authService: AuthService

    // Store user profile data
    private(set) var userProfile: ProfileModel?

    init(authService: AuthService) {
        self.authService = authService
    }

    // Fetch user profile
    func getProfile(completion: @escaping (Bool) -> Void) {
        authService.getUserProfile { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let profile):
                self.userProfile = profile
                completion(true)

            case .failure(let error):
                print("❌ Failed to fetch profile: \(error.localizedDescription)")
                completion(false)
            }
        }
    }

    // Retrieve token from UserDefaults
    private func getAuthToken() -> String? {
        return UserDefaults.standard.string(forKey: "authToken")
    }

    // Save token after login
    func saveAuthToken(_ token: String) {
        UserDefaults.standard.setValue(token, forKey: "authToken")
    }

    // Clear stored user profile and token
 
       
        
        // Fetch user profile
    func logout(completion: @escaping (Bool) -> Void) {
        // Clear user data
       
        // Perform logout request
        authService.logOutUser() { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }

                switch result {
                case .success:
                    completion(true)

                case .failure(let error):
                    print("❌ Logout failed: \(error.localizedDescription)")
                    completion(false)
                }
            }
        }
    }


    // Helper to check if user is authenticated
    var isAuthenticated: Bool {
        return getAuthToken() != nil
    }
}
