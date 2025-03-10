//
//  NetworkService.swift
//  Bluelight
//
//  Created by Nisha Gupta on 16/01/24.
//

import UIKit
import Foundation



enum NetworkError: Error {
    case invalidURL
    case noData
    case decodingError
    case requestFailed(Error) // Change the parameter type to Error
    
    //case requestFailed(statusCode: Int)
        case serverError(message: String)
}

class NetworkService {
    static let shared = NetworkService()

    private init() {}

    func request<T: Decodable>(url: URL, method: HTTPMethod, body: Data?, headers: [String: String]?, completion: @escaping (Result<T, NetworkError>) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
    
        print("Get Url value:-\(url)")
        if method != .get {
                request.httpBody = body
            }
            
        request.addValue("application/json", forHTTPHeaderField: "content-type")
        
        let token = SingletonClass.shared.accessToken
        

        // Set token if provided
        request.addValue("Bearer \(token ?? "")", forHTTPHeaderField: "Authorization")
        

//           // Set headers if provided
           headers?.forEach { key, value in
               request.addValue(value, forHTTPHeaderField: key)
           }
//        
        print("Get Request value:-\(request)")

//        // Set headers if provided
//        headers?.forEach { key, value in
//            request.addValue(value, forHTTPHeaderField: key)
//        }

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(.requestFailed(error))) // Pass the error directly
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.requestFailed(NSError(domain: "NetworkService", code: 0, userInfo: nil)))) // Provide a default NSError
                return
            }

            if (200..<300).contains(httpResponse.statusCode) {
                guard let responseData = data else {
                    completion(.failure(.noData))
                    return
                }

                do {
                    
                    
                    print(T.self)
                    
                        
                        // Decode JSON data into the provided generic type T
                        let decodedData = try JSONDecoder().decode(T.self, from: responseData)
                        
                        // Call completion handler with decoded data
                        completion(.success(decodedData))
                 
                    //let decodedData = try JSONDecoder().decode(T.self, from: responseData)
                   // completion(.success(decodedData))
                } catch {
//                    print("Decoding error:", error)
//                    completion(.failure(.decodingError))
                    
                    
                    do {
                        let errorResponse = try JSONDecoder().decode(ErrorResponse.self, from: responseData)
                                       print("Server error message: \(errorResponse.message)")
                        completion(.failure(.serverError(message: errorResponse.message)))
                                        
                                   } catch {
                                       completion(.failure(.decodingError))
                                   }
                    
                }
            } else {
                completion(.failure(.requestFailed(NSError(domain: "NetworkService", code: httpResponse.statusCode, userInfo: nil)))) // Provide a default NSError
            }
        }

        task.resume()
    }
    
    
//
    
    
    
    
    
    
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
    // Add other HTTP methods as needed
}

struct ErrorResponse: Decodable {
    let message: String
    // Add other properties based on your API's error response structure
}







//// GET request
//NetworkService.shared.request(url: yourGetURL, method: .get) { (result: Result<YourResponseType, Error>) in
//    switch result {
//    case .success(let data):
//        // Handle success
//        print("GET success:", data)
//    case .failure(let error):
//        // Handle failure
//        print("GET error:", error)
//    }
//}
//
//// POST request
//let postData = try? JSONSerialization.data(withJSONObject: yourPostData)
//NetworkService.shared.request(url: yourPostURL, method: .post, body: postData, headers: yourHeaders) { (result: Result<YourResponseType, Error>) in
//    switch result {
//    case .success(let data):
//        // Handle success
//        print("POST success:", data)
//    case .failure(let error):
//        // Handle failure
//        print("POST error:", error)
//    }
//}
//
//// PUT request
//let putData = try? JSONSerialization.data(withJSONObject: yourPutData)
//NetworkService.shared.request(url: yourPutURL, method: .put, body: putData, headers: yourHeaders) { (result: Result<YourResponseType, Error>) in
//    switch result {
//    case .success(let data):
//        // Handle success
//        print("PUT success:", data)
//    case .failure(let error):
//        // Handle failure
//        print("PUT error:", error)
//    }
//}
//
//// DELETE request
//NetworkService.shared.request(url: yourDeleteURL, method: .delete) { (result: Result<YourResponseType, Error>) in
//    switch result {
//    case .success(let data):
//        // Handle success
//        print("DELETE success:", data)
//    case .failure(let error):
//        // Handle failure
//        print("DELETE error:", error)
//    }
//}
//
//
