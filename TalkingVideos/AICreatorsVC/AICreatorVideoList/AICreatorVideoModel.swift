//
//  AICreatorVideoModel.swift
//  TalkingVideos
//
//  Created by Nisha Gupta on 19/03/25.
//

import UIKit

// MARK: - VideoList
struct AICreatorVideoModel: Codable {
    let supportedCreators: [String]
    let thumbnails: [String: Thumbnail]
}

// MARK: - Thumbnail
struct Thumbnail: Codable {
    let imageURL: String
    let videoURL: String

    enum CodingKeys: String, CodingKey {
        case imageURL = "imageUrl"
        case videoURL = "videoUrl"
    }
}
