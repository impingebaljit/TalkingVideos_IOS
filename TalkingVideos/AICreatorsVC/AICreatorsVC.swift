//
//  AICreatorsVC.swift
//  TalkingVideos
//
//  Created by Nisha Gupta on 12/03/25.
//

import UIKit

//class AICreatorsVC: UIViewController {
//
//        override func viewDidLoad() {
//            super.viewDidLoad()
//           // view.backgroundColor = UIColor(red: 16/255, green: 9/255, blue: 25/255, alpha: 1.0)
//            self.navigationItem.hidesBackButton = true
//
//        //  setupUI()
//            
//            self.view.backgroundColor = UIColor.clear
//
//         self.modalPresentationStyle = .overCurrentContext
//            
//            self.view.setContentHuggingPriority(UILayoutPriority(250), for: .horizontal)
//            self.view.setContentHuggingPriority(UILayoutPriority(250), for: .vertical)
//            
//        }
//
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        presentingViewController?.view.alpha = 0.8 // Slight dim
//    }
//
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        presentingViewController?.view.alpha = 1.0 // Restore normal brightness
//    }
//
//    @IBAction func acn_AICreatorBtn(_ sender: Any) {
//        print("AI Creator")
//    }
//    @IBAction func acn_CancelBtn(_ sender: Any) {
//        print("print Cancel")
//        navigationController?.popViewController(animated: false)
//        //self.dismiss(animated: true, completion: nil)
//
//        
////        if let navController = self.navigationController {
////               let dashboardVC = DashboardVC()
////               navController.pushViewController(dashboardVC, animated: false)
////           } else {
////               let dashboardVC = DashboardVC()
////               let navController = UINavigationController(rootViewController: dashboardVC)
////               navController.modalPresentationStyle = .fullScreen
////               present(navController, animated: false, completion: nil)
////           }
//        
//    }
//   
//    }
import UIKit

import UIKit

class AICreatorsVC: UIViewController {

    // This will be set by the presenting VC
    var onAICreatorSelected: (() -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.clear.withAlphaComponent(0.2)
        setupOptionsUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // Customize sheet height (iOS 16+ only)
        if let sheet = self.sheetPresentationController {
            sheet.detents = [
                .custom(resolver: { _ in return 200 }) // fixed height in points
            ]
            sheet.prefersGrabberVisible = true
            sheet.preferredCornerRadius = 20
        }
    }

    private func setupOptionsUI() {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])

        stackView.addArrangedSubview(makeOption(title: "AI Creators", subtitle: "Create talking videos and AI Twins", imageName: "aiCreatorLogo") {
            self.dismiss(animated: true) {
                print("AI Creators selected")
                self.onAICreatorSelected?()
            }
        })

        stackView.addArrangedSubview(makeCancelButton())
    }

    private func makeOption(title: String, subtitle: String, imageName: String, action: @escaping () -> Void) -> UIView {
        let container = UIView()
        container.backgroundColor =  UIColor(red: 41/255, green: 42/255, blue:48/255, alpha: 1.0)
        container.layer.cornerRadius = 12
        container.translatesAutoresizingMaskIntoConstraints = false
        container.heightAnchor.constraint(equalToConstant: 70).isActive = true

        let icon = UIImageView(image: UIImage(named: imageName))
        icon.contentMode = .scaleAspectFit
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.widthAnchor.constraint(equalToConstant: 40).isActive = true
        icon.heightAnchor.constraint(equalToConstant: 40).isActive = true

        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.textColor = .white
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16)

        let subtitleLabel = UILabel()
        subtitleLabel.text = subtitle
        subtitleLabel.textColor = .lightGray
        subtitleLabel.font = UIFont.systemFont(ofSize: 13)

        let labelStack = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        labelStack.axis = .vertical
        labelStack.spacing = 2

        let hStack = UIStackView(arrangedSubviews: [icon, labelStack])
        hStack.axis = .horizontal
        hStack.alignment = .center
        hStack.spacing = 12
        hStack.translatesAutoresizingMaskIntoConstraints = false

        container.addSubview(hStack)
        NSLayoutConstraint.activate([
            hStack.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16),
            hStack.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16),
            hStack.centerYAnchor.constraint(equalTo: container.centerYAnchor)
        ])

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
      //  tapGesture.userInfo = ["action": action]
        container.addGestureRecognizer(tapGesture)

        return container
    }

    @objc private func handleTap(_ gesture: UITapGestureRecognizer) {
        print("fdggfdgdfgfd")
        
        
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let dashboardVC = storyboard.instantiateViewController(withIdentifier: "AICreatorImgCarouselVC") as? AICreatorImgCarouselVC {
                let navController = UINavigationController(rootViewController: dashboardVC)
                if let window = UIApplication.shared.windows.first {
                    window.rootViewController = navController
                    window.makeKeyAndVisible()
                }
            }
        
        

    }

    private func makeCancelButton() -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle("Cancel", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(red: 41/255, green: 42/255, blue:48/255, alpha: 1.0)
        button.layer.cornerRadius = 10
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.addTarget(self, action: #selector(dismissSelf), for: .touchUpInside)
        return button
    }

    @objc private func dismissSelf() {
        dismiss(animated: true, completion: nil)
    }
}
