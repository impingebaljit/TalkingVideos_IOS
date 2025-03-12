//
//  ProfileVC.swift
//  TalkingVideos
//
//  Created by Nisha Gupta on 12/03/25.
//

import UIKit

// Profile View Controller
class ProfileVC: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 16/255, green: 9/255, blue: 25/255, alpha: 1.0)

      //  setupUI()
    }

    private func setupUI() {
        // Connect Section
        let connectLabel = createLabel(text: "CONNECT", color: UIColor(red: 140/255, green: 32/255, blue: 248/255, alpha: 1.0))
        let socialStackView = createSocialStackView()

        // Legal Section
        let privacyButton = createOptionButton(title: "Privacy Policy")
        let termsButton = createOptionButton(title: "Terms of Use")

        // Action Buttons
        let logoutButton = createActionButton(title: "Log Out", action: #selector(logoutTapped))
        let deleteButton = createActionButton(title: "Delete Account", action: #selector(deleteAccountTapped))

        let stackView = UIStackView(arrangedSubviews: [
            connectLabel, socialStackView,
            privacyButton, termsButton,
            logoutButton, deleteButton
        ])

        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }

    private func createLabel(text: String, color: UIColor) -> UILabel {
        let label = UILabel()
        label.text = text
        label.textColor = color
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }

    private func createSocialStackView() -> UIStackView {
        let platforms = ["Youtube", "Instagram", "Twitter"]
        let icons = ["youtube_icon", "instagram_icon", "twitter_icon"]
        let views = zip(platforms, icons).map { createSocialButton(title: $0, icon: $1) }
        let stack = UIStackView(arrangedSubviews: views)
        stack.axis = .horizontal
        stack.spacing = 16
        return stack
    }

    private func createSocialButton(title: String, icon: String) -> UIButton {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: icon), for: .normal)
        button.setTitle(title, for: .normal)
        button.tintColor = .white
        return button
    }

    private func createOptionButton(title: String) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.setTitleColor(.white, for: .normal)
        return button
    }

    private func createActionButton(title: String, action: Selector) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: action, for: .touchUpInside)
        return button
    }

    @objc private func logoutTapped() {
        print("Logout Tapped")
    }

    @objc private func deleteAccountTapped() {
        print("Delete Account Tapped")
    }
    
    @IBAction func acn_CancelBtn(_ sender: Any) {
        print("print Cancel")

        
        if let navController = self.navigationController {
               let dashboardVC = DashboardVC()
               navController.pushViewController(dashboardVC, animated: false)
           } else {
               let dashboardVC = DashboardVC()
               let navController = UINavigationController(rootViewController: dashboardVC)
               navController.modalPresentationStyle = .fullScreen
               present(navController, animated: false, completion: nil)
           }
        
    }
}
