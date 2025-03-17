//
//  SignUpModel.swift
//  TalkingVideos
//
//  Created by Nisha Gupta on 17/03/25.
//

import Foundation

    // MARK: - SignUp
    struct SignUpModel: Codable {
        let status: Bool
        let message: String
        let data: DataClass
    }

    // MARK: - DataClass
    struct DataClass: Codable {
        let name, email, updatedAt, createdAt: String
        let id: Int

        enum CodingKeys: String, CodingKey {
            case name, email
            case updatedAt = "updated_at"
            case createdAt = "created_at"
            case id
        }
    }
