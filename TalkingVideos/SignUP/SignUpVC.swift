//
//  SignUpVC.swift
//  TalkingVideos
//
//  Created by Nisha Gupta on 12/03/25.
//

import UIKit
import AuthenticationServices

class SignUpVC: UIViewController {

    @IBOutlet weak var tf_Name: UITextField!
    
    @IBOutlet weak var tf_Email: UITextField!
    
    @IBOutlet weak var tf_Password: UITextField!
  
    var viewModel: SignUpViewModel!
    
    var userToParse: SignUpModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
       // setupBindings()
        
        let authService = AuthService() // Assuming AuthService is implemented
        viewModel = SignUpViewModel(authService: authService)
       
    }
    
    
    
    private func setupBindings() {
            viewModel.onAppleSignInSuccess = { [weak self] name, email in
                self?.tf_Name.text = name
                self?.tf_Email.text = email
                self?.showAlert("Apple Sign-In Successful")
            }

            viewModel.onAppleSignInFailure = { [weak self] error in
                self?.showAlert("Apple Sign-In Error: \(error)")
            }
        }
    @IBAction func acn_SignUp(_ sender: Any)  {
        guard let name = tf_Name.text, !name.isEmpty,
              let email = tf_Email.text, !email.isEmpty,
              let password = tf_Password.text, !password.isEmpty else {
            showAlert("All fields are required.")
            return
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
                // Show success alert and navigate after dismissal
                            let alert = UIAlertController(title: "Success", message: "You have signed up successfully!", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
                                // Navigate to DashboardVC after user acknowledges the alert
                                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                if let dashboardVC = storyboard.instantiateViewController(withIdentifier: "DashboardVC") as? DashboardVC {
                                    let navController = UINavigationController(rootViewController: dashboardVC)
                                    self.present(navController, animated: true, completion: nil)
                                }
                            })
                            self.present(alert, animated: true, completion: nil)
                
            } else {
                print("❌ Sign-up failed: \(message ?? "Unknown error")")
                self.showAlert(message ?? "Sign-up failed. Please try again.")
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
