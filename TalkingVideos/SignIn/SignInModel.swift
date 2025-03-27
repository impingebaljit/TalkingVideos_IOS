//
//  User.swift
//  Bluelight
//
//  Created by Nisha Gupta on 16/01/24.
//

import UIKit
import Foundation



// MARK: - User
struct SignInModel: Codable {
    let status: Bool
    let message, token: String
    let user: UserClass
}

// MARK: - UserClass
struct UserClass: Codable {
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

// MARK: - Encode/decode helpers

class JSONNull: Codable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
            return true
    }

    public var hashValue: Int {
            return 0
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            if !container.decodeNil() {
                    throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
            }
    }

    public func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            try container.encodeNil()
    }
}


//// MARK: - User
//struct User: Codable {
//    let code: Int
//    let status, message: String
//    let userData: UserData
//    let userID, accessToken: String
//
//    enum CodingKeys: String, CodingKey {
//        case code, status, message, userData, userID
//        case accessToken = "access_token"
//    }
//}
//
//// MARK: - UserData
//struct UserData: Codable {
//    let password, userRole, userFirstName: String
//    let profileImage: String
//    let userEmail: String
//
//    enum CodingKeys: String, CodingKey {
//        case password
//        case userRole = "UserRole"
//        case userFirstName = "UserFirstName"
//        case profileImage
//        case userEmail = "UserEmail"
//    }
//}
