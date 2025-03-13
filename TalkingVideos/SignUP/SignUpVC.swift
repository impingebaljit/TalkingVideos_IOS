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
    private let viewModel = SignUpViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
       
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
    @IBAction func acn_SignUp(_ sender: Any) {
        guard let name = tf_Name.text, let email = tf_Email.text, let password = tf_Password.text else { return }

               if let errorMessage = viewModel.validateFields(name: name, email: email, password: password) {
                   showAlert(errorMessage)
                   return
               }

               let user = User(name: name, email: email, password: password)
               viewModel.signUp(user: user) { [weak self] success, error in
                   if success {
                       self?.showAlert("User registered successfully")
                   } else {
                       self?.showAlert(error ?? "Unknown error")
                   }
               }
    }
    
    @IBAction func acn_Login(_ sender: Any) {
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

