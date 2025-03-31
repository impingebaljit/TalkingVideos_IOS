//
//  SubmitViewModel.swift
//  TalkingVideos
//
//  Created by Nisha Gupta on 25/03/25.
//

import UIKit

class SubmitViewModel{
    
    private let authService: AuthService

    init(authService: AuthService) {
        self.authService = authService
    }
    
    
//    func submitVideo(prompt: String, creatorName: String, resolution: String, completion: @escaping (Bool, SubmitModel?) -> Void) {
//        authService.submitVideo(script: prompt, creatorName: creatorName, resolution: resolution) { result in
//            switch result {
//            case .success(let response):
//                // Case 1: If AIScriptModel is directly returned
//                if let scriptModel = response as? SubmitModel {
//                    print("AIScriptModel received: \(scriptModel)")
//                    completion(true, scriptModel)
//                    return
//                }
//
//                // Case 2: If raw Data is returned
//                if let data = response as? Data {
//                    if let jsonString = String(data: data, encoding: .utf8) {
//                        print("Raw JSON: \(jsonString)")
//                    }
//                    do {
//                        let scriptModel = try JSONDecoder().decode(SubmitModel.self, from: data)
//                        completion(true, scriptModel)
//                    } catch {
//                        print("JSON Decoding Error: \(error)")
//                        completion(false, nil)
//                    }
//                    return
//                }
//
//                print("Unexpected response type: \(type(of: response))")
//                completion(false, nil)
//
//            case .failure(let error):
//                print("API Error: \(error)")
//                completion(false, nil)
//            }
//           }
//       }
    
    
    func submitVideo(prompt: String, creatorName: String, resolution: String, completion: @escaping (Bool, SubmitModel?, String?) -> Void) {
        authService.submitVideo(script: prompt, creatorName: creatorName, resolution: resolution) { result in
            switch result {
            case .success(let response):
                if let scriptModel = response as? SubmitModel {
                    completion(true, scriptModel, nil)
                } else if let data = response as? Data {
                    do {
                        print("Submit Video Response: \(data)")
                        let scriptModel = try JSONDecoder().decode(SubmitModel.self, from: data)
                        completion(true, scriptModel, nil)
                    } catch {
                        completion(false, nil, "JSON Decoding Error: \(error.localizedDescription)")
                    }
                } else {
                    completion(false, nil, "Unexpected response type: \(type(of: response))")
                }
            
            case .failure(let error):
                completion(false, nil, "API Error: \(error.localizedDescription)")
            }
        }
    }

}
