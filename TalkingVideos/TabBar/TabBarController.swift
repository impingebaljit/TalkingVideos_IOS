//
//  TabBarController.swift
//  TalkingVideos
//
//  Created by Nisha Gupta on 12/03/25.
//

import UIKit

class TabBarController: UITabBar {

    private let iconWidth: CGFloat = 30.0
    private let iconHeight: CGFloat = 30.0

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupTabBar()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupTabBar()
    }

    private func setupTabBar() {
        tintColor = UIColor(red: 140/255, green: 32/255, blue: 248/255, alpha: 1.0)
        unselectedItemTintColor = UIColor.gray
        barTintColor = UIColor(red: 16/255, green: 9/255, blue: 25/255, alpha: 1.0)

        let projectsItem = createTabBarItem(title: "Projects", imageName: "project", tag: 0)
        let createItem = UITabBarItem(title: "", image: nil, tag: 1)
        let profileItem = createTabBarItem(title: "Profile", imageName: "profile", tag: 2)

        items = [projectsItem, createItem, profileItem]
        selectedItem = createItem

        setupCreateButton()
    }

    private func createTabBarItem(title: String, imageName: String, tag: Int) -> UITabBarItem {
        guard let originalImage = UIImage(named: imageName) else {
            return UITabBarItem(title: title, image: UIImage(systemName: "folder"), tag: tag)
        }

        let resizedImage = originalImage.resize(toFit: CGSize(width: iconWidth, height: iconHeight))
        return UITabBarItem(title: title, image: resizedImage, tag: tag)
    }

    private func setupCreateButton() {
           let createButton = UIButton(type: .system)
           createButton.setTitle("Create", for: .normal)
           createButton.backgroundColor = UIColor(red: 140/255, green: 32/255, blue: 248/255, alpha: 1.0)
           createButton.setTitleColor(.white, for: .normal)
           createButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
           createButton.layer.cornerRadius = 12
           createButton.translatesAutoresizingMaskIntoConstraints = false

           createButton.addTarget(self, action: #selector(createButtonTapped), for: .touchUpInside)

           addSubview(createButton)

           NSLayoutConstraint.activate([
               createButton.centerXAnchor.constraint(equalTo: centerXAnchor),
               createButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: 0),
               createButton.widthAnchor.constraint(equalToConstant: 120),
               createButton.heightAnchor.constraint(equalToConstant: 50)
           ])
       }

       @objc private func createButtonTapped() {
//           guard let parentVC = self.findViewController() else { return }
//           let aICreatorsVC = AICreatorsVC()
//           aICreatorsVC.modalPresentationStyle = .fullScreen
//           parentVC.present(aICreatorsVC, animated: true, completion: nil)
//           guard let parentVC = self.findViewController() else { return }
//            let aiCreatorsVC = AICreatorsVC() // Ensure it's not nil
//                   let navController = UINavigationController(rootViewController: aiCreatorsVC)
//                   navController.modalPresentationStyle = .fullScreen
//                   parentVC.present(navController, animated: true, completion: nil)
           
//           let storyboard = UIStoryboard(name: "Main", bundle: nil)
//           let loginViewController = storyboard.instantiateViewController(withIdentifier: "AICreatorsVC") as! AICreatorsVC
//           let navigationController = UINavigationController(rootViewController: loginViewController)
//           
//           window?.rootViewController = navigationController
//           window?.makeKeyAndVisible()
           
           
           guard let parentVC = self.findViewController() else { return }

                  let storyboard = UIStoryboard(name: "Main", bundle: nil)
                  if let aiCreatorsVC = storyboard.instantiateViewController(withIdentifier: "AICreatorsVC") as? AICreatorsVC {
                      let navController = UINavigationController(rootViewController: aiCreatorsVC)
                      navController.modalPresentationStyle = .pageSheet
                      parentVC.present(navController, animated: true, completion: nil)
                  }
           
       }
    override func didMoveToWindow() {
        super.didMoveToWindow()
        delegate = self
    }
    
    func handleTabSelection(item: UITabBarItem) {
            guard let parentVC = self.findViewController() else { return }
        
        
        if item.tag == 0 { // Profile Tab
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let loginViewController = storyboard.instantiateViewController(withIdentifier: "DashboardVC") as! DashboardVC
            let navigationController = UINavigationController(rootViewController: loginViewController)
            
            window?.rootViewController = navigationController
            window?.makeKeyAndVisible()
        }

            if item.tag == 2 { // Profile Tab
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let loginViewController = storyboard.instantiateViewController(withIdentifier: "ProfileVC") as! ProfileVC
                let navigationController = UINavigationController(rootViewController: loginViewController)
                
                window?.rootViewController = navigationController
                window?.makeKeyAndVisible()
            }
        }
}
extension TabBarController: UITabBarDelegate {
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        handleTabSelection(item: item)
    }
}
// Image resizing extension
extension UIImage {
    func resize(toFit size: CGSize) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { _ in draw(in: CGRect(origin: .zero, size: size)) }
    }
}

// Helper extension to find the parent view controller
extension UIView {
    func findViewController() -> UIViewController? {
        if let nextResponder = next as? UIViewController {
            return nextResponder
        } else if let nextResponder = next as? UIView {
            return nextResponder.findViewController()
        } else {
            return nil
        }
    }
}
