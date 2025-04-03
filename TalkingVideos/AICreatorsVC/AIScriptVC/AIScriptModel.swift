//
//  AIScriptModel.swift
//  TalkingVideos
//
//  Created by Nisha Gupta on 24/03/25.
//

import UIKit

import Foundation

//// MARK: - ScriptModel
//struct AIScriptModel: Codable {
//    let script: String
//}


struct AIScriptModel: Codable {
    let script: Script
}

// MARK: - Script
struct Script: Codable {
    let id, type, role, model: String
    let content: [Content]
    let stopReason: String
    let stopSequence: String?
    let usage: Usage

    enum CodingKeys: String, CodingKey {
        case id, type, role, model, content
        case stopReason = "stop_reason"
        case stopSequence = "stop_sequence"
        case usage
    }
}

// MARK: - Content
struct Content: Codable {
    let type, text: String
}

// MARK: - Usage
struct Usage: Codable {
    let inputTokens, cacheCreationInputTokens, cacheReadInputTokens, outputTokens: Int

    enum CodingKeys: String, CodingKey {
        case inputTokens = "input_tokens"
        case cacheCreationInputTokens = "cache_creation_input_tokens"
        case cacheReadInputTokens = "cache_read_input_tokens"
        case outputTokens = "output_tokens"
    }
}

