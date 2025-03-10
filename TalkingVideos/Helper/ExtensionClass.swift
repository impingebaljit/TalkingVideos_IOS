//
//  ExtensionClass.swift
//  Bluelight
//
//  Created by Nisha Gupta on 30/01/24.
//

import UIKit


    
    
    extension UIViewController {
        func showAlert(title: String, message: String, completion: (() -> Void)? = nil) {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default) { _ in
                completion?()
            }
            alertController.addAction(okAction)
            present(alertController, animated: true, completion: nil)
        }
        
         func isEmailValid(_ email: String) -> Bool {
            let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
            let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
            return emailPredicate.evaluate(with: email)
        }
    }


