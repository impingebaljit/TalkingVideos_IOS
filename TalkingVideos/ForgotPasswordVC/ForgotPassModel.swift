//
//  ForgotPassModel.swift
//  TalkingVideos
//
//  Created by Nisha Gupta on 17/03/25.
//

import Foundation

// MARK: - User
struct ForgotPassModel: Codable {
    let status: Bool
    let message: String
    let error :String?
}

