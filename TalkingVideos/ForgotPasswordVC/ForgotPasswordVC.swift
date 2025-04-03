//
//  ForgotPasswordVC.swift
//  TalkingVideos
//
//  Created by Nisha Gupta on 12/03/25.
//

import UIKit
import AuthenticationServices

class ForgotPasswordVC: UIViewController {

    @IBOutlet weak var tf_Email: CustomTextField!
   
    var viewModel: ForgotPasswordViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.hidesBackButton = true
        
        
        tf_Email.placeholderColor = UIColor.white
     
        
        let authService = AuthService() // Assuming AuthService is implemented
        viewModel = ForgotPasswordViewModel(authService: authService)
        
        setupBindings()
    }
    
    private func setupBindings() {
           viewModel.onPasswordResetSuccess = { [weak self] in
               self?.showAlert("Password reset link sent to your email")
           }

           viewModel.onPasswordResetFailure = { [weak self] error in
               self?.showAlert(error)
           }
       }
    
    @IBAction func acn_Send(_ sender: Any) {
        

        
        // Submit Action
       
            guard let email = tf_Email.text, !email.isEmpty else {
                self.showAlert(title: "Error", message: "Please enter a valid email.")
                return
            }
            
            // Call the Forgot Password API
        self.sendPasswordResetRequest(email: email)
        
        
        
    }
    
    
    private func sendPasswordResetRequest(email: String) {
        // Show the loader while the request is being processed
       // CustomLoader.shared.showLoader()

        viewModel.forgotPassword(email: email) { [weak self] success, errorMessage in
            // Ensure UI updates happen on the main thread
            DispatchQueue.main.async {
                CustomLoader.shared.hideLoader()

                if success {
                    self?.showAlert(title: "Success", message: "Password reset link sent successfully.") {
                        self?.navigateToLoginVC() // Navigate to LoginVC
                    }
                } else {
                    let error = errorMessage ?? "Failed to send password reset link. Please try again."
                    self?.showAlert(title: "Error", message: error)
                }
            }
        }
    }

    private func navigateToLoginVC() {
        // Navigate to LoginVC
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        if let dashboardVC = storyboard.instantiateViewController(withIdentifier: "SignInVC") as? SignInVC {
//            let navController = UINavigationController(rootViewController: dashboardVC)
//            self.present(navController, animated: false, completion: nil)
//        }
        
        
        if let dashboardVC = self.storyboard?.instantiateViewController(withIdentifier: "SignInVC") {
            // Push the view controller to the navigation stack
            self.navigationController?.pushViewController(dashboardVC, animated: true)
        }
        
    }
    private func showAlert(_ message: String) {
          let alert = UIAlertController(title: "Message", message: message, preferredStyle: .alert)
          alert.addAction(UIAlertAction(title: "OK", style: .default))
          present(alert, animated: true)
      }
}
