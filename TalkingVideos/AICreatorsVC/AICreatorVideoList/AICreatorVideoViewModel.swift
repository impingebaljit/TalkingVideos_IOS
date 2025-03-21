//
//  AICreatorVideoViewModel.swift
//  TalkingVideos
//
//  Created by Nisha Gupta on 19/03/25.
//

import UIKit
import AuthenticationServices


class AICreatorVideoViewModel {
    private let authService: AuthService
    var thumbnails: [Thumbnail] = []
    var supportedCreators: [String] = []

    init(authService: AuthService) {
        self.authService = authService
    }
    func createModel(at index: Int) -> VideoDetailModel {
           return VideoDetailModel(thumbnail: thumbnails[index], creatorName: supportedCreators[index], color: randomColor())
       }
    
    func randomColor() -> UIColor {
           return UIColor(
               red: CGFloat.random(in: 0...1),
               green: CGFloat.random(in: 0...1),
               blue: CGFloat.random(in: 0...1),
               alpha: 1.0
           )
       }
    
    func getTheVideoList(completion: @escaping (Bool) -> Void) {
        authService.getTheVideoList { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let response):
                
                // ✅ Case 1: If already decoded model is returned
                if let videoList = response as? AICreatorVideoModel {
                    self.thumbnails = Array(videoList.thumbnails.values)
                    self.supportedCreators = Array(videoList.supportedCreators)
                    completion(true)
                    return
                }

                // ✅ Case 2: If raw Data is returned
                if let data = response as? Data {
                    do {
                        // 🟢 Print and inspect the raw JSON
                        if let jsonString = String(data: data, encoding: .utf8) {
                            print("Raw JSON: \(jsonString)")
                        }
                        
                        // 🟢 Decode JSON to VideoList
                        let videoList = try JSONDecoder().decode(AICreatorVideoModel.self, from: data)
                        self.thumbnails = Array(videoList.thumbnails.values)
                        completion(true)
                    } catch {
                        print("❌ JSON Decoding Error: \(error)")
                        completion(false)
                    }
                    return
                }

                // 🟡 Unexpected Type Handling
                print("❌ Unexpected Response Type: \(type(of: response))")
                completion(false)

            case .failure(let error):
                print("❌ API Error: \(error)")
                completion(false)
            }
        }
    }

}
