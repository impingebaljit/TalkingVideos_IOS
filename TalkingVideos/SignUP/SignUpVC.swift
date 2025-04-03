//
//  SignUpVC.swift
//  TalkingVideos
//
//  Created by Nisha Gupta on 12/03/25.
//

import UIKit
import AuthenticationServices

class SignUpVC: UIViewController {

    @IBOutlet weak var tf_Name: CustomTextField!
    
    @IBOutlet weak var tf_Email: CustomTextField!
    
    @IBOutlet weak var tf_Password: CustomTextField!
  
    var viewModel: SignUpViewModel!
    
    var userToParse: SignUpModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        tf_Name.placeholderColor = UIColor.white
        tf_Email.placeholderColor = UIColor.white
        tf_Password.placeholderColor = UIColor.white
        
        let authService = AuthService() // Assuming AuthService is implemented
        viewModel = SignUpViewModel(authService: authService)
        
        setupBindings()
       
    }
    
    
    
    private func setupBindings() {
        viewModel.onAppleSignInSuccess = { [weak self] name, email, identityToken in
            self?.tf_Name.text = name
            self?.tf_Email.text = email
            // self?.showAlert("Apple Sign-In Successful")
            
            //self?.navigateToDashboard()
            
            // Call appleLoginApi
            let authService = AuthService()
            authService.appleLoginApi(identity_token: identityToken) { result in
                switch result {
                case .success(let user):
                    print("🎉 Successfully logged in: \(user)")
                    
                    // Save token in UserDefaults
                    UserDefaults.standard.set(user.token, forKey: "authToken")
                    UserDefaults.standard.set(true, forKey: "isUserLoggedIn")
                    UserDefaults.standard.synchronize()
                    
                    let alert = UIAlertController(title: "Success", message: "Apple Sign-In Successful!", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        if let dashboardVC = storyboard.instantiateViewController(withIdentifier: "DashboardVC") as? DashboardVC {
                            let navController = UINavigationController(rootViewController: dashboardVC)
                            self?.present(navController, animated: true, completion: nil)
                        }
                    })
                    self?.present(alert, animated: true, completion: nil)
                    
                case .failure(let error):
                    print("Login failed: \(error.localizedDescription)")
                    self?.showAlert("Apple Sign-In Error: \(error.localizedDescription)")
                }
                
                
                
            }
            
            self?.viewModel.onAppleSignInFailure = { [weak self] error in
                self?.showAlert("Apple Sign-In Error: \(error)")
            }
        }
    }
    
   
    @IBAction func acn_SignUp(_ sender: Any)  {
        guard let name = tf_Name.text, !name.isEmpty,
              let email = tf_Email.text, !email.isEmpty,
              let password = tf_Password.text, !password.isEmpty else {
            showAlert("All fields are required.")
            return
        }
        DispatchQueue.main.async {
            CustomLoader.shared.showLoader(in: self)
            
        }
        // Validate using ViewModel's method
        if let errorMessage = viewModel.validateFields(name: name, email: email, password: password) {
            showAlert(errorMessage)
            return
        }

        // Call the sign-up function
        viewModel.signUp(name: name, email: email, password: password) { [weak self] success, message in
            guard let self = self else { return }

            if success {
                CustomLoader.shared.hideLoader()
                
                // Show success alert and navigate after dismissal
                            let alert = UIAlertController(title: "Success", message: "You have signed up successfully!", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
                                // Navigate to DashboardVC after user acknowledges the alert
                                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                if let dashboardVC = storyboard.instantiateViewController(withIdentifier: "SignInVC") as? SignInVC {
                                    let navController = UINavigationController(rootViewController: dashboardVC)
                                    self.present(navController, animated: true, completion: nil)
                                }
                            })
                            self.present(alert, animated: true, completion: nil)
                
            } else {
                print("Sign-up failed: \(message ?? "Unknown error")")
                self.showAlert(message ?? "Sign-up failed. Please try again.")
            }
        }
    }

    
    @IBAction func acn_GoogleSignIn(_ sender: Any) {
        
        DispatchQueue.main.async {
            CustomLoader.shared.showLoader(in: self)
            self.handleGoogleSignIn()
        }
    }
    
    @objc func handleGoogleSignIn() {
            GoogleSignInManager.shared.signInWithGoogle(presenting: self) { result in
                CustomLoader.shared.hideLoader()
                switch result {
                    
                case .success(let user):
                    print("Google Sign-In successful!")
                    print("User ID: \(user.userID ?? "No ID")")
                    print("Name: \(user.profile?.name ?? "No Name")")
                    print("Email: \(user.profile?.email ?? "No Email")")
                    print("ID Token: \(user.idToken?.tokenString ?? "No Token")")
                    
                    self.loginWithGoogleToken(idToken: user.idToken?.tokenString ?? "token")

                case .failure(let error):
                    print("Google Sign-In failed: \(error.localizedDescription)")
                }
            }
        }
    
    
    func loginWithGoogleToken(idToken: String) {
        let authService = AuthService()
        authService.googleLoginApi(identity_token: idToken) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let user):
                    print("Successfully logged in: \(user)")

                    // Save token in UserDefaults
                    UserDefaults.standard.set(user.token, forKey: "authToken")
                    UserDefaults.standard.set(true, forKey: "isUserLoggedIn")
                    UserDefaults.standard.synchronize()

                    let alert = UIAlertController(title: "Success", message: "Google Sign-In Successful!", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
                        self.navigateToDashboardScreen()
                    })

                    if let presentedVC = self.presentedViewController {
                        presentedVC.dismiss(animated: false) {
                            self.present(alert, animated: true, completion: nil)
                        }
                    } else {
                        self.present(alert, animated: true, completion: nil)
                    }

                case .failure(let error):
                    print("Login failed: \(error.localizedDescription)")
                    self.showAlert("Google Sign-In Error: \(error.localizedDescription)")
                }
            }
        }
    }
    private func navigateToDashboardScreen() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let dashboardVC = storyboard.instantiateViewController(withIdentifier: "DashboardVC") as? DashboardVC {
            let navController = UINavigationController(rootViewController: dashboardVC)
            if let window = UIApplication.shared.windows.first {
                window.rootViewController = navController
                window.makeKeyAndVisible()
            }
        }
    }
    
    @IBAction func acn_Login(_ sender: Any) {
//        if let dashboardVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SignInVC") as? SignInVC {
//            self.navigationController?.pushViewController(dashboardVC, animated: true)
//        }
    }
    
    @IBAction func acn_SignUpwithApple(_ sender: Any) {
        viewModel.handleAppleSignIn()
    }
    private func showAlert(_ message: String) {
           let alert = UIAlertController(title: "Message", message: message, preferredStyle: .alert)
           alert.addAction(UIAlertAction(title: "OK", style: .default))
           present(alert, animated: true)
       }
    
   

     
}



extension SignUpVC: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}

// //Helper extension to find the parent view controller
//extension UIView {
//    func findViewController() -> UIViewController? {
//        if let nextResponder = next as? UIViewController {
//            return nextResponder
//        } else if let nextResponder = next as? UIView {
//            return nextResponder.findViewController()
//        } else {
//            return nil
//        }
//    }
//}
