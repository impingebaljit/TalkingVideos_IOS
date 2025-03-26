//
//  DashboardModel.swift
//  TalkingVideos
//
//  Created by Nisha Gupta on 26/03/25.
//

import UIKit


 
import Foundation

// MARK: - DashboardModelElement
struct DashboardModel: Codable {
    let id, userID: Int
    let script, creatorName, operationID, state: String
    let url: String
    let status: String?
    let createdAt, updatedAt: String

    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case script, creatorName
        case operationID = "operationId"
        case state, url, status
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}


