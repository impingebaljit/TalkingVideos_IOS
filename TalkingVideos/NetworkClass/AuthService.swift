//
//  AuthService.swift
//  Bluelight
//
//  Created by Nisha Gupta on 16/01/24.
//

import UIKit
import Foundation

class AuthService {
    
    func signUp(name: String, email: String, password: String, completion: @escaping (Result<SignUpModel, Error>) -> Void) {
        // Construct the sign-up URL
        let signUpURL = "\(API.baseURL)\(API.Endpoints.signUp)"
        
        // Validate input fields
        guard !name.isEmpty, !email.isEmpty, !password.isEmpty else {
            completion(.failure(NetworkError.serverError(message: "Name, email, and password are required.")))
            return
        }
        
        // Create the request body
        let requestBody: [String: Any] = [
            "name": name,
            "email": email,
            "password": password
        ]
        
        // Serialize the request body to JSON
        guard let postData = try? JSONSerialization.data(withJSONObject: requestBody) else {
            completion(.failure(NetworkError.serverError(message: "Invalid request body.")))
            return
        }
        
        // Ensure URL is valid
        guard let url = URL(string: signUpURL) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        // Perform the network request
        NetworkService.shared.request(url: url, method: .post, body: postData, headers: nil) { (result: Result<SignUpModel, NetworkError>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let user):
                    print(" User data: \(user)")
                    completion(.success(user))
                    
                case .failure(let error):
                    // Handle the error and map to meaningful messages
                    let errorMessage: String
                    switch error {
                    case .invalidURL:
                        errorMessage = "Invalid URL."
                    case .noData:
                        errorMessage = "No data received from the server."
                    case .decodingError:
                        errorMessage = "Failed to decode the server response."
                    case .requestFailed(let statusCode):
                        errorMessage = "Request failed with status code: \(statusCode)"
                    case .serverError(let message):
                        errorMessage = "Server error: \(message)"
                    }
                    
                    print(" Error: \(errorMessage)")
                    completion(.failure(NetworkError.serverError(message: errorMessage)))
                }
            }
        }
    }
    
    
    
    
    
    func signIn(email: String, password: String, completion: @escaping (Result<SignInModel, Error>) -> Void) {
        // Construct the sign-in URL
        let signInURL = "\(API.baseURL)\(API.Endpoints.signIn)"
        
        // Prepare the request body with email and password
        let requestBody: [String: Any] = [
            "email": email,
            "password": password
        ]
        
        // Serialize the request body to JSON data
        guard let postData = try? JSONSerialization.data(withJSONObject: requestBody) else {
            completion(.failure(NetworkError.invalidURL))
            print("  JSON serialization error")
            return
        }
        
        // Perform the network request using the shared NetworkService
        NetworkService.shared.request(url: URL(string: signInURL)!, method: .post, body: postData, headers: nil) { (result: Result<SignInModel, NetworkError>) in
            
            switch result {
            case .success(let user):
                //  Sign-in successful
                print(" User data: \(user)")
                completion(.success(user))
                
            case .failure(let error):
                //   Handle sign-in errors and map to readable messages
                let errorMessage: String
                
                switch error {
                case .invalidURL:
                    print("  Invalid URL error")
                    errorMessage = "Invalid request URL."
                case .noData:
                    print("  No data error")
                    errorMessage = "No response data received."
                case .decodingError:
                    print("  Decoding error")
                    errorMessage = "Failed to parse server response."
                case .requestFailed(let statusCode):
                    print("  Request failed with status code: \(statusCode)")
                    errorMessage = "Request failed (Status code: \(statusCode))."
                case .serverError(let message):
                    print("  Server error: \(message)")
                    errorMessage = "Server error: \(message)"
                }
                
                // Return the error via completion handler
                completion(.failure(NetworkError.serverError(message: errorMessage)))
            }
        }
    }
    
    
    
    
    
    
    
    func forgotPassword(email: String, completion: @escaping (Result<ForgotPassModel, Error>) -> Void) {
        // Construct the forgot password URL
        let forgotPasswordURL = "\(API.baseURL)\(API.Endpoints.forgotPassword)"
        
        // Prepare the request body with the email
        let requestBody: [String: Any] = ["email": email]
        
        // Serialize the request body to JSON data
        guard let postData = try? JSONSerialization.data(withJSONObject: requestBody) else {
            print("  JSON serialization error")
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        // Perform the network request using the shared NetworkService
        NetworkService.shared.request(
            url: URL(string: forgotPasswordURL)!,
            method: .post,
            body: postData,
            headers: nil
        ) { (result: Result<ForgotPassModel, NetworkError>) in
            
            switch result {
            case .success(let response):
                print(" Password reset email sent: \(response.message)")
                completion(.success(response))
                
            case .failure(let error):
                // Map network errors to user-friendly messages
                let errorMessage: String
                switch error {
                case .invalidURL:
                    print("  Invalid URL error")
                    errorMessage = "Invalid request URL."
                case .noData:
                    print("  No data error")
                    errorMessage = "No response data received."
                case .decodingError:
                    print("  Decoding error")
                    errorMessage = "Failed to parse server response."
                case .requestFailed(let statusCode):
                    print("  Request failed with status code: \(statusCode)")
                    errorMessage = "Request failed (Status code: \(statusCode))."
                case .serverError(let message):
                    print("  Server error: \(message)")
                    errorMessage = message
                }
                
                // Return the error via completion handler
                completion(.failure(NetworkError.serverError(message: errorMessage)))
            }
        }
    }
    
    
    func resetPassword(email: String, newPassword: String, confirmPassword: String, completion: @escaping (Result<ResetPassModel, Error>) -> Void) {
        // Ensure passwords match before making the request
        guard newPassword == confirmPassword else {
            completion(.failure(NetworkError.serverError(message: "Passwords do not match.")))
            return
        }
        
        // Construct the reset password URL
        let resetPasswordURL = "\(API.baseURL)\(API.Endpoints.resetPassword)"
        
        // Prepare the request body with email and new password
        let requestBody: [String: Any] = [
            "email": email,
            "new_password": newPassword,
            "confirm_password": confirmPassword
        ]
        
        // Serialize the request body to JSON data
        guard let postData = try? JSONSerialization.data(withJSONObject: requestBody) else {
            print("  JSON serialization error")
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        // Perform the network request using the shared NetworkService
        NetworkService.shared.request(
            url: URL(string: resetPasswordURL)!,
            method: .post,
            body: postData,
            headers: nil
        ) { (result: Result<ResetPassModel, NetworkError>) in
            
            switch result {
            case .success(let response):
                print(" Password reset successful: \(response.message)")
                completion(.success(response))
                
            case .failure(let error):
                // Map network errors to user-friendly messages
                let errorMessage: String
                switch error {
                case .invalidURL:
                    print("  Invalid URL error")
                    errorMessage = "Invalid request URL."
                case .noData:
                    print("  No data error")
                    errorMessage = "No response data received."
                case .decodingError:
                    print("  Decoding error")
                    errorMessage = "Failed to parse server response."
                case .requestFailed(let statusCode):
                    print("  Request failed with status code: \(statusCode)")
                    errorMessage = "Request failed (Status code: \(statusCode))."
                case .serverError(let message):
                    print("  Server error: \(message)")
                    errorMessage = message
                }
                
                // Return the error via completion handler
                completion(.failure(NetworkError.serverError(message: errorMessage)))
            }
        }
    }
    
    
    
    
    
    func getTheVideoList(completion: @escaping (Result<AICreatorVideoModel, Error>) -> Void) {
        // Construct the video list URL
        let videoListURL = "\(API.baseURL)\(API.Endpoints.videoList)"
        
        // Prepare the request body (if needed)
        let requestBody: [String: Any] = [:] // Add any required parameters here
        
        // Serialize the request body to JSON
        guard let postData = try? JSONSerialization.data(withJSONObject: requestBody) else {
            print("  JSON serialization error")
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        // Perform the network request using the shared NetworkService
        NetworkService.shared.request(
            url: URL(string: videoListURL)!,
            method: .post,
            body: postData,
            headers: ["Content-Type": "application/json"]
        ) { (result: Result<AICreatorVideoModel, NetworkError>) in
            
            switch result {
            case .success(let response):
                print(" Video list fetched successfully: \(response)")
                completion(.success(response))
                
            case .failure(let error):
                // Map network errors to user-friendly messages
                let errorMessage: String
                switch error {
                case .invalidURL:
                    print("  Invalid URL error")
                    errorMessage = "Invalid request URL."
                case .noData:
                    print("  No data error")
                    errorMessage = "No response data received."
                case .decodingError:
                    print("  Decoding error")
                    errorMessage = "Failed to parse server response."
                case .requestFailed(let statusCode):
                    print("  Request failed with status code: \(statusCode)")
                    errorMessage = "Request failed (Status code: \(statusCode))."
                case .serverError(let message):
                    print("  Server error: \(message)")
                    errorMessage = message
                }
                
                // Return the error via completion handler
                completion(.failure(NetworkError.serverError(message: errorMessage)))
            }
        }
    }
    
    
    func getUserProfile(completion: @escaping (Result<ProfileModel, Error>) -> Void) {
      
            guard let token = UserDefaults.standard.string(forKey: "authToken") else {
                print("  Missing Bearer Token")
                completion(.failure(NetworkError.invalidURL))
                return
            }

            let videoListURL = "\(API.baseURL)\(API.Endpoints.getProfile)"

            guard let url = URL(string: videoListURL) else {
                print("  Invalid URL")
                completion(.failure(NetworkError.invalidURL))
                return
            }

            var request = URLRequest(url: url)
            request.httpMethod = "GET"

            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")

            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("  Request error: \(error.localizedDescription)")
                    completion(.failure(error))
                    return
                }

                guard let httpResponse = response as? HTTPURLResponse else {
                    print("  Invalid server response")
                    completion(.failure(NetworkError.noData))
                    return
                }

                guard (200...299).contains(httpResponse.statusCode) else {
                    print("  Request failed with status code: \(httpResponse.statusCode)")
                    completion(.failure(NetworkError.requestFailed(httpResponse.statusCode as! Error)))
                    return
                }

                guard let data = data else {
                    print("  No data received")
                    completion(.failure(NetworkError.noData))
                    return
                }

                do {
                    let profile = try JSONDecoder().decode(ProfileModel.self, from: data)
                    print(" User profile fetched successfully: \(profile)")
                    completion(.success(profile))
                } catch {
                    print("  Decoding error: \(error.localizedDescription)")
                    completion(.failure(NetworkError.decodingError))
                }
            }.resume()
        }
    
    
    
    func logOutUser(completion: @escaping (Result<LogOutModel, Error>) -> Void) {
       
            guard let token = UserDefaults.standard.string(forKey: "authToken") else {
                print("  Missing Bearer Token")
                completion(.failure(NetworkError.invalidURL))
                return
            }

            let logoutURL = "\(API.baseURL)\(API.Endpoints.logout)"

            guard let url = URL(string: logoutURL) else {
                print("  Invalid URL")
                completion(.failure(NetworkError.invalidURL))
                return
            }

            var request = URLRequest(url: url)
            request.httpMethod = "POST"

            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")

            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("  Request error: \(error.localizedDescription)")
                    completion(.failure(error))
                    return
                }

                guard let httpResponse = response as? HTTPURLResponse else {
                    print("  Invalid server response")
                    completion(.failure(NetworkError.noData))
                    return
                }

                guard (200...299).contains(httpResponse.statusCode) else {
                    print("  Request failed with status code: \(httpResponse.statusCode)")
                    completion(.failure(NetworkError.requestFailed(httpResponse.statusCode as! Error)))
                    return
                }

                guard let data = data else {
                    print("  No data received")
                    completion(.failure(NetworkError.noData))
                    return
                }

                do {
                    let logoutResponse = try JSONDecoder().decode(LogOutModel.self, from: data)
                    print(" User logged out successfully: \(logoutResponse)")
                    completion(.success(logoutResponse))
                } catch {
                    print("  Decoding error: \(error.localizedDescription)")
                    completion(.failure(NetworkError.decodingError))
                }
            }.resume()
        }

    
    func generateScript(prompt: String, completion: @escaping (Result<AIScriptModel, Error>) -> Void) {
        
      
        let generateScriptURL = "\(API.baseURL)\(API.Endpoints.generateScript)"

        let requestBody: [String: Any] = ["prompt": prompt]

        guard let postData = try? JSONSerialization.data(withJSONObject: requestBody) else {
            print("  JSON serialization error")
            completion(.failure(NetworkError.invalidURL))
            return
        }

        NetworkService.shared.request(
            url: URL(string: generateScriptURL)!,
            method: .post,
            body: postData,
            headers: ["Content-Type": "application/json"]
        ) { (result: Result<AIScriptModel, NetworkError>) in

            switch result {
            case .success(let data):
                print(" Script generated successfully")
                completion(.success(data))

            case .failure(let error):
                let errorMessage: String
                switch error {
                case .invalidURL:
                    print("  Invalid URL error")
                    errorMessage = "Invalid request URL."
                case .noData:
                    print("  No data error")
                    errorMessage = "No response data received."
                case .decodingError:
                    print("  Decoding error")
                    errorMessage = "Failed to parse server response."
                case .requestFailed(let statusCode):
                    print("  Request failed with status code: \(statusCode)")
                    errorMessage = "Request failed (Status code: \(statusCode))."
                case .serverError(let message):
                    print("  Server error: \(message)")
                    errorMessage = message
                }

                completion(.failure(NetworkError.serverError(message: errorMessage)))
            }
        }
    }
    
    
    
//    func submitVideo(script: String, creatorName: String, resolution: String, completion: @escaping (Result<SubmitModel, Error>) -> Void) {
//
//        
//        let submitCaptionURL = "\(API.baseURL)\(API.Endpoints.submitVideo)"
//         
//
//            let requestBody: [String: Any] = [
//                "script": script,
//                "creatorName": creatorName,
//                "resolution": resolution
//            ]
//
//            guard let postData = try? JSONSerialization.data(withJSONObject: requestBody) else {
//                print("  JSON serialization error")
//                completion(.failure(NetworkError.invalidURL))
//                return
//            }
//
//            NetworkService.shared.request(
//                url: URL(string: submitCaptionURL)!,
//                method: .post,
//                body: postData,
//                headers: ["Content-Type": "application/json"]
//            ) { (result: Result<SubmitModel, NetworkError>) in
//
//                switch result {
//                case .success(let data):
//                    print(" Caption submitted successfully")
//                    completion(.success(data))
//
//                case .failure(let error):
//                    let errorMessage: String
//                    switch error {
//                    case .invalidURL:
//                        print("  Invalid URL error")
//                        errorMessage = "Invalid request URL."
//                    case .noData:
//                        print("  No data error")
//                        errorMessage = "No response data received."
//                    case .decodingError:
//                        print("  Decoding error")
//                        errorMessage = "Failed to parse server response."
//                    case .requestFailed(let statusCode):
//                        print("  Request failed with status code: \(statusCode)")
//                        errorMessage = "Request failed (Status code: \(statusCode))."
//                    case .serverError(let message):
//                        print("  Server error: \(message)")
//                        errorMessage = message
//                    }
//
//                    completion(.failure(NetworkError.serverError(message: errorMessage)))
//                }
//            }
//        }

    func submitVideo(script: String, creatorName: String, resolution: String, completion: @escaping (Result<SubmitModel, Error>) -> Void) {
            // Ensure token is available
            guard let token = UserDefaults.standard.string(forKey: "authToken"), !token.isEmpty else {
                print("  Missing or empty Bearer Token")
                completion(.failure(NetworkError.invalidURL))
                return
            }
            
            // Validate URL
            guard let submitCaptionURL = URL(string: "\(API.baseURL)\(API.Endpoints.submitVideo)") else {
                print("  Invalid URL")
                completion(.failure(NetworkError.invalidURL))
                return
            }
            
            // Prepare request body
            let requestBody: [String: Any] = [
                "script": script,
                "creatorName": creatorName,
                "resolution": resolution
            ]
            
            // Serialize request body to JSON
            guard let postData = try? JSONSerialization.data(withJSONObject: requestBody) else {
                print("  JSON serialization error")
                completion(.failure(NetworkError.decodingError))
                return
            }
            
            // Perform network request
            NetworkService.shared.request(
                url: submitCaptionURL,
                method: .post,
                body: postData,
                headers: [
                    "Authorization": "Bearer \(token)",
                    "Content-Type": "application/json"
                ]
            ) { (result: Result<SubmitModel, NetworkError>) in
                
                switch result {
                case .success(let data):
                    print(" Caption submitted successfully: \(data)")
                    completion(.success(data))
                    
                case .failure(let error):
                    // Map error to meaningful message
                    let errorMessage: String
                    switch error {
                    case .invalidURL:
                        errorMessage = "Invalid request URL."
                    case .noData:
                        errorMessage = "No response data received."
                    case .decodingError:
                        errorMessage = "Failed to parse server response."
                    case .requestFailed(let statusCode):
                        errorMessage = "Request failed (Status code: \(statusCode))."
                    case .serverError(let message):
                        errorMessage = message
                    }
                    
                    print("  Submission failed: \(errorMessage)")
                    completion(.failure(error))
                }
            }
        

    }


    func pollCaptionStatus(operationId: String, progressHandler: @escaping (String) -> Void, completion: @escaping (Bool, StatusCheckModel?) -> Void) {

       
        
        let pollURL = "\(API.baseURL)\(API.Endpoints.statusCheck)"

           let parameters: [String: Any] = ["operationId": operationId]

           guard let postData = try? JSONSerialization.data(withJSONObject: parameters) else {
               print("  JSON serialization error")
               completion(false, nil)
               return
           }

           NetworkService.shared.request(
               url: URL(string: pollURL)!,
               method: .post,
               body: postData,
               headers: ["Content-Type": "application/json"]
           ) { (result: Result<Data, NetworkError>) in

               switch result {
               case .success(let data):
                   if let jsonString = String(data: data, encoding: .utf8) {
                       print("Raw JSON: \(jsonString)")
                   }

                   do {
                       let submitModel = try JSONDecoder().decode(StatusCheckModel.self, from: data)
                       progressHandler(submitModel.state)
                       if submitModel.state == "completed" {
                           completion(true, submitModel)
                       } else {
                           DispatchQueue.global().asyncAfter(deadline: .now() + 5) {
                               self.pollCaptionStatus(operationId: operationId, progressHandler: progressHandler, completion: completion)
                           }
                       }
                   } catch {
                       print("  JSON Decoding Error: \(error)")
                       completion(false, nil)
                   }

               case .failure(let error):
                   print("  API Error: \(error)")
                   completion(false, nil)
               }
           }
       }
    
    
    func uploadData(operationId: String, progressHandler: @escaping (String) -> Void, completion: @escaping (Result<StatusCheckModel, Error>) -> Void) {
        
        var progressObservation: NSKeyValueObservation?
            let boundary = "Boundary-\(UUID().uuidString)"

            var body = ""
            body += "--\(boundary)\r\n"
            body += "Content-Disposition: form-data; name=\"operationId\"\r\n\r\n\(operationId)\r\n"
            body += "--\(boundary)--\r\n"

            guard let postData = body.data(using: .utf8) else {
                completion(.failure(NSError(domain: "Invalid Data", code: 0, userInfo: nil)))
                return
            }

            var request = URLRequest(url: URL(string: "https://ugcreels.urtestsite.com/api/captions/poll")!, timeoutInterval: 30)
            request.httpMethod = "POST"
            request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            request.httpBody = postData

            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }

                guard let data = data else {
                    completion(.failure(NSError(domain: "Invalid Response", code: 0, userInfo: nil)))
                    return
                }

                do {
                    let statusModel = try JSONDecoder().decode(StatusCheckModel.self, from: data)
                    completion(.success(statusModel))
                } catch {
                    completion(.failure(error))
                }
            }

            // Observe upload progress
            progressObservation = task.progress.observe(\.fractionCompleted, options: [.new]) { progress, _ in
                let percentage = String(format: "%.0f%%", progress.fractionCompleted * 100)
                progressHandler(percentage)
            }

            task.resume()
        }
  
        
        // MARK: - Fetch Videos API
    func fetchFinalVideos(completion: @escaping (Result<[DashboardModel], Error>) -> Void) {
        
      

      
                guard let token = UserDefaults.standard.string(forKey: "authToken") else {
                    print("  Missing Bearer Token")
                    completion(.failure(NetworkErrorr.invalidToken))
                    return
                }

                let videoListURL = "\(API.baseURL)\(API.Endpoints.finalVideos)"
                guard let url = URL(string: videoListURL) else {
                    print("  Invalid URL: \(videoListURL)")
                    completion(.failure(NetworkErrorr.invalidURL))
                    return
                }

                var request = URLRequest(url: url)
                request.httpMethod = "GET"
                request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

                let task = URLSession.shared.dataTask(with: request) { data, response, error in
                    if let error = error {
                        print("  Request error: \(error.localizedDescription)")
                        completion(.failure(error))
                        return
                    }

                    guard let httpResponse = response as? HTTPURLResponse else {
                        print("  Invalid response")
                        completion(.failure(NetworkErrorr.invalidResponse))
                        return
                    }

                    guard (200...299).contains(httpResponse.statusCode) else {
                        print("  Request failed with status code: \(httpResponse.statusCode)")
                        completion(.failure(NetworkErrorr.requestFailed(statusCode: httpResponse.statusCode)))
                        return
                    }

                    guard let data = data else {
                        print("  No data received")
                        completion(.failure(NetworkErrorr.noData))
                        return
                    }

                    do {
                        let decodedResponse = try JSONDecoder().decode([DashboardModel].self, from: data)
                        completion(.success(decodedResponse))
                    } catch {
                        print("  Decoding error: \(error.localizedDescription)")
                        completion(.failure(NetworkErrorr.decodingError))
                    }
                }
                task.resume()
            }

    
    func appleLoginApi(identity_token: String, completion: @escaping (Result<AppleLoginModel, Error>) -> Void) {

        let videoListURL = "\(API.baseURL)\(API.Endpoints.loginApple)"
        guard let url = URL(string: videoListURL) else {
            print("  Invalid URL: \(videoListURL)")
            completion(.failure(NetworkErrorr.invalidURL))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
      

        // Create the request body
        let requestBody: [String: Any] = ["identity_token": identity_token]

        // Serialize the request body to JSON
        guard let postData = try? JSONSerialization.data(withJSONObject: requestBody) else {
            completion(.failure(NetworkError.serverError(message: "Invalid request body.")))
            return
        }

        // Perform the network request
        NetworkService.shared.request(url: url, method: .post, body: postData, headers: nil) { (result: Result<AppleLoginModel, NetworkError>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let user):
                    print(" User data: \(user)")
                    completion(.success(user))

                case .failure(let error):
                    let errorMessage: String
                    switch error {
                    case .invalidURL:
                        errorMessage = "Invalid URL."
                    case .noData:
                        errorMessage = "No data received from the server."
                    case .decodingError:
                        errorMessage = "Failed to decode the server response."
                    case .requestFailed(let statusCode):
                        errorMessage = "Request failed with status code: \(statusCode)"
                    case .serverError(let message):
                        errorMessage = "Server error: \(message)"
                    }

                    print(" Error: \(errorMessage)")
                    completion(.failure(NetworkError.serverError(message: errorMessage)))
                }
            }
        }
    }

    
    func googleLoginApi(identity_token: String, completion: @escaping (Result<GoogleLoginModel, Error>) -> Void) {

        let videoListURL = "\(API.baseURL)\(API.Endpoints.loginGoogle)"
        guard let url = URL(string: videoListURL) else {
            print("  Invalid URL: \(videoListURL)")
            completion(.failure(NetworkErrorr.invalidURL))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
      

        // Create the request body
        let requestBody: [String: Any] = ["identity_token": identity_token]

        // Serialize the request body to JSON
        guard let postData = try? JSONSerialization.data(withJSONObject: requestBody) else {
            completion(.failure(NetworkError.serverError(message: "Invalid request body.")))
            return
        }

        // Perform the network request
        NetworkService.shared.request(url: url, method: .post, body: postData, headers: nil) { (result: Result<GoogleLoginModel, NetworkError>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let user):
                    print(" User data: \(user)")
                    completion(.success(user))

                case .failure(let error):
                    let errorMessage: String
                    switch error {
                    case .invalidURL:
                        errorMessage = "Invalid URL."
                    case .noData:
                        errorMessage = "No data received from the server."
                    case .decodingError:
                        errorMessage = "Failed to decode the server response."
                    case .requestFailed(let statusCode):
                        errorMessage = "Request failed with status code: \(statusCode)"
                    case .serverError(let message):
                        errorMessage = "Server error: \(message)"
                    }

                    print(" Error: \(errorMessage)")
                    completion(.failure(NetworkError.serverError(message: errorMessage)))
                }
            }
        }
    }

}

    
