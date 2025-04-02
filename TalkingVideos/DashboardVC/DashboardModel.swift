//
//  DashboardModel.swift
//  TalkingVideos
//
//  Created by Nisha Gupta on 26/03/25.
//

import UIKit
import Foundation


enum UploadStatus {
    case notStarted
    case inProgress(Double) // Percentage (0-100)
    case completed
    case failed
}

// MARK: - DashboardModelElement
struct DashboardModel: Codable {
    let id, userID: Int
    let script, creatorName, operationID, state: String
    let url: String
    let status: String?
    let createdAt, updatedAt: String
    let creatorImage: String?
    let creatorVideo: String?
       
    
    var isUploading: Bool = false
    var uploadInProgress: Bool?// Add this property

    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case script, creatorName
        case operationID = "operationId"
        case state, url, status
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case  creatorImage, creatorVideo
        
       case uploadInProgress = "uploadInProgress"
    }
}

// MARK: - DeleteVideoModel
struct DeleteVideoModel: Codable {
    let message: String
}

