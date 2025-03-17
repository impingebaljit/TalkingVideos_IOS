//
//  ResetPassModel.swift
//  TalkingVideos
//
//  Created by Nisha Gupta on 17/03/25.
//

import UIKit
import Foundation

 
    struct ResetPassModel: Codable {
        let status: Bool
        let message: String
        let errors: Errors
    }

    // MARK: - Errors
    struct Errors: Codable {
        let email: [String]
    }
