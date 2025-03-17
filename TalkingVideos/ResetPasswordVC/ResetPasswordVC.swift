//
//  ResetPasswordVC.swift
//  TalkingVideos
//
//  Created by Nisha Gupta on 12/03/25.
//

import UIKit
import AuthenticationServices

class ResetPasswordVC: UIViewController {

    @IBOutlet weak var tf_EnterNewPassw: UITextField!
    @IBOutlet weak var tf_ConfirmPassw: UITextField!
    var viewModel: ResetPassViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.hidesBackButton = true
        
        let authService = AuthService() // Assuming AuthService is implemented
        viewModel = ResetPassViewModel(authService: authService)
    }
    

    @IBAction func acn_Submit(_ sender: Any) {
      
       
            // Validate new password and confirm password
            guard let newPassword = tf_EnterNewPassw.text, !newPassword.isEmpty else {
                self.showAlert(title: "Error", message: "Please enter a new password.")
                return
            }
            
            guard let confirmPassword = tf_ConfirmPassw.text, !confirmPassword.isEmpty else {
                self.showAlert(title: "Error", message: "Please confirm your password.")
                return
            }
            
            // Check if passwords match
            guard newPassword == confirmPassword else {
                self.showAlert(title: "Error", message: "Passwords do not match.")
                return
            }
            
            // Show loader while processing
          //  CustomLoader.shared.showLoader()

            // Call Reset Password API
        viewModel.resetPassword(email: "email", newPassword: newPassword, confirmPassword: confirmPassword) { [weak self] success, errorMessage in
                DispatchQueue.main.async {
                //    CustomLoader.shared.hideLoader()

                    if success {
                        self?.showAlert(title: "Success", message: "Password reset successfully.") {
                            self?.navigateToLoginVC() // Navigate to LoginVC
                        }
                    } else {
                        let error = errorMessage ?? "Failed to reset password. Please try again."
                        self?.showAlert(title: "Error", message: error)
                    }
                }
            }
        }

      

        

    private func navigateToLoginVC() {
        // Navigate to LoginVC
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let dashboardVC = storyboard.instantiateViewController(withIdentifier: "SignInVC") as? SignInVC {
            let navController = UINavigationController(rootViewController: dashboardVC)
            self.present(navController, animated: false, completion: nil)
        }
    }
    
    private func showAlert(_ message: String) {
           let alert = UIAlertController(title: "Message", message: message, preferredStyle: .alert)
           alert.addAction(UIAlertAction(title: "OK", style: .default))
           present(alert, animated: true)
       }
    
    
}
