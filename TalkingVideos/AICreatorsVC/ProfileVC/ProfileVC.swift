//
//  ProfileVC.swift
//  TalkingVideos
//
//  Created by Nisha Gupta on 12/03/25.
//

import UIKit

// Profile View Controller
class ProfileVC: UIViewController {
    
    var viewModel: ProfileViewModel!
    @IBOutlet weak var lbl_name: UILabel!
    
    @IBOutlet weak var lbl_Email: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 16/255, green: 9/255, blue: 25/255, alpha: 1.0)
        
        let authService = AuthService() // Assuming AuthService is implemented
        viewModel = ProfileViewModel(authService: authService)

        getProfile()
        
        // Add Custom Tab Bar
        let tabBar = TabBarController()
        tabBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tabBar)

        NSLayoutConstraint.activate([
            tabBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tabBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tabBar.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -15),
            tabBar.heightAnchor.constraint(equalToConstant: 80)
        ])
    }

    func getProfile() {
        CustomLoader.shared.showLoader(in: self) // Show loader while fetching profile

        viewModel.getProfile { [weak self] success in
            DispatchQueue.main.async {
                // Hide the loader when the request completes
                CustomLoader.shared.hideLoader()

                guard let self = self else { return }

                if success {
                    // Successfully fetched the profile
                    if let userProfile = self.viewModel.userProfile {
                                        self.lbl_name.text = userProfile.name
                                        self.lbl_Email.text = userProfile.email
                                    }
                } else {
                    // Handle error case
                    self.showAlert(title: "Error", message: "Failed to fetch profile. Please try again.")
                }
            }
        }
    }

    @IBAction func acn_PrivacyPolicy(_ sender: Any) {
    }
    
    @IBAction func acn_TermsOfUse(_ sender: Any) {
    }
    @IBAction func acn_Subscription(_ sender: Any) {
    }
    
    @IBAction func acn_LogOutBtn(_ sender: Any) {
        
        print("LogOut Button Clicked")
        
        
            CustomLoader.shared.showLoader(in: self) // Show loader while fetching profile

            viewModel.logout() { [weak self] success in
                DispatchQueue.main.async {
                    // Hide the loader when the request completes
                    CustomLoader.shared.hideLoader()

                    guard let self = self else { return }

                    if success {
                        
                      
                        UserDefaults.standard.removeObject(forKey: "authToken")
                        // Successfully fetched the profile
                        self.navigateToSignInVC()
                       

                        
                    } else {
                        //  Handle error case
                        self.showAlert(title: "Error", message: "Failed to fetch profile. Please try again.")
                    }
                }
            }
        
    }
    
    func  navigateToSignInVC(){
        UserDefaults.standard.set(false, forKey: "isUserLoggedIn")
            UserDefaults.standard.synchronize()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let dashboardVC = storyboard.instantiateViewController(withIdentifier: "SignInVC") as? SignInVC {
            let navController = UINavigationController(rootViewController: dashboardVC)
            self.present(navController, animated: false, completion: nil)
        }
    }
    
    @IBAction func acn_DeleteBtn(_ sender: Any) {
        
    }
    
}
