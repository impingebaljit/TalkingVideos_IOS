//
//  AppleLoginModel.swift
//  TalkingVideos
//
//  Created by Nisha Gupta on 26/03/25.
//

import UIKit


    
    // MARK: - DashboardModel
    class AppleLoginModel: Codable {
        let user: Apple
        let token: String
    }

    // MARK: - User
    struct Apple: Codable {
        let id: Int
        let name, email: String
        let emailVerifiedAt: String?
        let authProvider, appleID, createdAt, updatedAt: String

        enum CodingKeys: String, CodingKey {
            case id, name, email
            case emailVerifiedAt = "email_verified_at"
            case authProvider = "auth_provider"
            case appleID = "apple_id"
            case createdAt = "created_at"
            case updatedAt = "updated_at"
        }
    }

    
