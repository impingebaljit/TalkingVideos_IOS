//
//  SignInVC.swift
//  Bluelight
//
//  Created by Nisha Gupta on 30/10/23.
//

import UIKit
import AuthenticationServices
import GoogleSignIn

class SignInVC: UIViewController {

    @IBOutlet weak var btnContinue: UIButton!
    @IBOutlet weak var tf_Password: UITextField!
    @IBOutlet weak var tf_Email: UITextField!

    var signInViewModel: SignInViewModel!
    var userToParse: SignInModel?
    

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTextfields()
        self.navigationItem.setHidesBackButton(true, animated: true)
        self.navigationController?.navigationBar.isHidden = true

        // Check if the user has previously logged in
        if UserDefaults.standard.bool(forKey: "hasLoggedInBefore") {
            print("User has logged in before. Consider Face ID flow if required.")
        }

        let authService = AuthService() // Assuming AuthService is implemented
        signInViewModel = SignInViewModel(authService: authService)
        
        
        setupBindings()
    }
    // Usage within setupBindings
    // Usage within setupBindings
    private func setupBindings() {
        
            signInViewModel.onAppleSignInSuccess = { [weak self] name, email, identityToken in
                self?.tf_Email.text = email

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
            }

            signInViewModel.onAppleSignInFailure = { [weak self] error in
                self?.showAlert("Apple Sign-In Error: \(error)")
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
    // MARK: - Actions
    private func showAlert(_ message: String) {
           let alert = UIAlertController(title: "Message", message: message, preferredStyle: .alert)
           alert.addAction(UIAlertAction(title: "OK", style: .default))
           present(alert, animated: true)
       }
    @IBAction func acn_SignupBtn(_ sender: Any) {
        navigateToViewController(identifier: "SignUpVC")
    }

    @IBAction func acn_ForgotPassword(_ sender: Any) {
        print("Forgot password tapped")
    }

    @IBAction func acn_LoginwithApple(_ sender: Any) {
        print("Login with Apple tapped")
        signInViewModel.handleAppleSignIn()
    }

    @IBAction func acn_GoToSignUp(_ sender: Any) {
        navigateToViewController(identifier: "SignUpVC")
        DispatchQueue.main.async {
            CustomLoader.shared.showLoader(in: self)
            self.handleGoogleSignIn()
        }
    }

    @IBAction func acn_LoginBtn(_ sender: Any) {
        view.endEditing(true)

        DispatchQueue.main.async {
            CustomLoader.shared.showLoader(in: self)
            self.signInButtonTapped()
        }
    }

    // MARK: - Sign In Logic

    private func signInButtonTapped() {
        guard let email = tf_Email.text, !email.isEmpty,
              let password = tf_Password.text, !password.isEmpty else {
            showAlert(title: "Error", message: "Email and password are required.")
            CustomLoader.shared.hideLoader()
            return
        }

       

        signInViewModel.signIn(email: email, password: password) { [weak self] success, errorMessage in
            guard let self = self else { return }

            DispatchQueue.main.async {
                CustomLoader.shared.hideLoader()

                if success {
                    print("Sign-in successful")
                    self.handleSuccessfulLogin()
                } else {
                    print("Sign-in failed: \(errorMessage ?? "Unknown error")")
                    self.showAlert(title: "Error", message: errorMessage ?? "Sign-in failed. Please try again.")
                }
            }
        }
    }

    private func handleSuccessfulLogin() {
        guard let user = signInViewModel.user?.user else { return }

        let userId = String(user.id)
        let accessToken = signInViewModel.user?.token ?? ""
        
       

        SingletonClass.shared.userId = userId
        SingletonClass.shared.accessToken = accessToken

        UserDefaults.standard.set(userId, forKey: "userID")
        UserDefaults.standard.set(accessToken, forKey: "authToken")
        UserDefaults.standard.set(true, forKey: "isUserLoggedIn")
        UserDefaults.standard.synchronize()

        navigateToDashboard()
    }

    // MARK: - Navigation Helpers

    private func navigateToDashboard() {
        let alert = UIAlertController(title: "Success", message: "User signed in successfully!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            self?.navigateToViewController(identifier: "DashboardVC")
        })

        present(alert, animated: true, completion: nil)
    }

    private func navigateToViewController(identifier: String) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: identifier)
        let navController = UINavigationController(rootViewController: viewController)
        self.present(navController, animated: false, completion: nil)
    }


    // MARK: - Alert Helper

    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }

    // MARK: - UI Setup

    private func setupTextfields() {
        tf_Email.placeholder = "Email ID"
        tf_Password.placeholder = "Password"
        //iostest@gmail.com
      //   tf_Email.text = "johndoe@example.com"
     //tf_Password.text = "password123"
      // tf_Email.text = "nisha@gmail.com"//"johndoe@example.com"//
   // tf_Password.text = "123456"//"password123"
    }
}
