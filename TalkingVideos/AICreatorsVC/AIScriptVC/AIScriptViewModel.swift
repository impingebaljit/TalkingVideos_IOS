
//  AIScriptViewModel.swift
//  TalkingVideos
//
//  Created by Nisha Gupta on 24/03/25.
//

//  AIScriptViewModel.swift
//  TalkingVideos
//
//  Created by Nisha Gupta on 24/03/25.
//

import UIKit

class AIScriptViewModel {
    private let authService: AuthService

    init(authService: AuthService) {
        self.authService = authService
    }

    func generateScript(prompt: String, completion: @escaping (Bool, AIScriptModel?) -> Void) {
        authService.generateScript(prompt: prompt) { result in
            switch result {
            case .success(let response):
                // Case 1: If AIScriptModel is directly returned
                if let scriptModel = response as? AIScriptModel {
                    print("AIScriptModel received: \(scriptModel)")
                    completion(true, scriptModel)
                    return
                }

                // Case 2: If raw Data is returned
                if let data = response as? Data {
                    if let jsonString = String(data: data, encoding: .utf8) {
                        print("Raw JSON: \(jsonString)")
                    }
                    do {
                        let scriptModel = try JSONDecoder().decode(AIScriptModel.self, from: data)
                        completion(true, scriptModel)
                    } catch {
                        print("JSON Decoding Error: \(error)")
                        completion(false, nil)
                    }
                    return
                }

                print("Unexpected response type: \(type(of: response))")
                completion(false, nil)

            case .failure(let error):
                print(" API Error: \(error)")
                completion(false, nil)
            }
        }
    }
}
