//
//  ForgotPasswordVC.swift
//  TalkingVideos
//
//  Created by Nisha Gupta on 12/03/25.
//

import UIKit

class ForgotPasswordVC: UIViewController {

    @IBOutlet weak var tf_Email: UITextField!
    private let viewModel = ForgotPasswordViewModel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.hidesBackButton = true
        
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
        
//        guard let email = tf_Email.text else { return }
//
//               if let errorMessage = viewModel.validateEmail(email) {
//                   showAlert(errorMessage)
//                   return
//               }
//
//               viewModel.resetPassword(email: email)
    }
    
    private func showAlert(_ message: String) {
          let alert = UIAlertController(title: "Message", message: message, preferredStyle: .alert)
          alert.addAction(UIAlertAction(title: "OK", style: .default))
          present(alert, animated: true)
      }
}
