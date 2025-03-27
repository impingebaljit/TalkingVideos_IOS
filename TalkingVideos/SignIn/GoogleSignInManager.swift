//
//  Untitled.swift
//  TalkingVideos
//
//  Created by Nisha Gupta on 27/03/25.
//

import UIKit
import GoogleSignIn



class GoogleSignInManager {
    static let shared = GoogleSignInManager()

    func signInWithGoogle(presenting viewController: UIViewController, completion: @escaping (Result<GIDGoogleUser, Error>) -> Void) {
        let clientID = API.Keys.googleSignInClientIdKey  // Directly use the non-optional String

        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config

        GIDSignIn.sharedInstance.signIn(withPresenting: viewController) { result, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let user = result?.user else {
                completion(.failure(NSError(domain: "GoogleAuth", code: 0, userInfo: [NSLocalizedDescriptionKey: "Google Sign-In failed"])))
                return
            }

            completion(.success(user))
        }
    }
}
