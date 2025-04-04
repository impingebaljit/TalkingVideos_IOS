//
//  AICreatorsVC.swift
//  TalkingVideos
//
//  Created by Nisha Gupta on 12/03/25.
//

import UIKit

class AICreatorsVC: UIViewController {

        override func viewDidLoad() {
            super.viewDidLoad()
           // view.backgroundColor = UIColor(red: 16/255, green: 9/255, blue: 25/255, alpha: 1.0)
            self.navigationItem.hidesBackButton = true

        //  setupUI()
            
            self.view.backgroundColor = UIColor.clear

         self.modalPresentationStyle = .overCurrentContext
            
            self.view.setContentHuggingPriority(UILayoutPriority(250), for: .horizontal)
            self.view.setContentHuggingPriority(UILayoutPriority(250), for: .vertical)
            
        }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presentingViewController?.view.alpha = 0.8 // Slight dim
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        presentingViewController?.view.alpha = 1.0 // Restore normal brightness
    }

    @IBAction func acn_AICreatorBtn(_ sender: Any) {
        print("AI Creator")
    }
    @IBAction func acn_CancelBtn(_ sender: Any) {
        print("print Cancel")
        navigationController?.popViewController(animated: false)
        //self.dismiss(animated: true, completion: nil)

        
//        if let navController = self.navigationController {
//               let dashboardVC = DashboardVC()
//               navController.pushViewController(dashboardVC, animated: false)
//           } else {
//               let dashboardVC = DashboardVC()
//               let navController = UINavigationController(rootViewController: dashboardVC)
//               navController.modalPresentationStyle = .fullScreen
//               present(navController, animated: false, completion: nil)
//           }
        
    }
   
    }
