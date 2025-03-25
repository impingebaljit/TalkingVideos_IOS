//
//  SubmitModel.swift
//  TalkingVideos
//
//  Created by Nisha Gupta on 25/03/25.
//

import UIKit
import Foundation

    // MARK: - ScriptModel
    struct SubmitModel: Codable {
        let operationID: String

        enum CodingKeys: String, CodingKey {
            case operationID = "operationId"
        }
    }
