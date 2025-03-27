//
//  GoogleLoginModel.swift
//  TalkingVideos
//
//  Created by Nisha Gupta on 27/03/25.
//

import Foundation

// MARK: - DashboardModel
struct GoogleLoginModel: Codable {
    let status: Bool
    let message, token: String
    let user: UserGoogleLogin
}

// MARK: - User
struct UserGoogleLogin: Codable {
    let id: Int
    let name, email: String
    let emailVerifiedAt: String?
    let authProvider: String
    let appleID: String?
    let googleID, createdAt, updatedAt: String

    enum CodingKeys: String, CodingKey {
        case id, name, email
        case emailVerifiedAt = "email_verified_at"
        case authProvider = "auth_provider"
        case appleID = "apple_id"
        case googleID = "google_id"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

