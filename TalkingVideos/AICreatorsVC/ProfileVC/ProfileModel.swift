//
//  ProfileModel.swift
//  TalkingVideos
//
//  Created by Nisha Gupta on 20/03/25.
//

import UIKit



// MARK: - ProfileModel
struct ProfileModel: Codable {
    let id: Int
    let name, email: String
    let emailVerifiedAt: String?
    let createdAt, updatedAt: String

    enum CodingKeys: String, CodingKey {
        case id, name, email
        case emailVerifiedAt = "email_verified_at"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}




import Foundation

// MARK: - ProfileModel
struct LogOutModel: Codable {
    let status: Bool
    let message: String
}

