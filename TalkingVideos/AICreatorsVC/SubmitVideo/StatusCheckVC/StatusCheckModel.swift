//
//  StatusCheckModel.swift
//  TalkingVideos
//
//  Created by Nisha Gupta on 25/03/25.
//

import UIKit



struct StatusCheckModel: Decodable {
    let state: String
    let progress: Int?

    private enum CodingKeys: String, CodingKey {
        case state
        case progress
    }
}



