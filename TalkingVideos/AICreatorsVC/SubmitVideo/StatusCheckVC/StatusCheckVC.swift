//
//  StatusCheckVC.swift
//  TalkingVideos
//
//  Created by Nisha Gupta on 25/03/25.
//

import UIKit
import AuthenticationServices



class StatusCheckVC: UIViewController {

    @IBOutlet weak var imgVw: UIImageView!
    @IBOutlet weak var lbl_state: UILabel!
    
    var videoModelNewData: VideoDetailModel?
    private var viewModel: StatusCheckViewModel!
    
    var operationIdSend =  String()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imgVw.layer.cornerRadius = 20
        imgVw.clipsToBounds = true
        
        let authService = AuthService()
        viewModel = StatusCheckViewModel(authService: authService)
        
        if let img = videoModelNewData?.thumbnail.imageURL {
            loadImage(from: img)
        }

        print("VideoModelData CreatorName: \(String(describing: videoModelNewData?.creatorName))")
        print("VideoModelData CreatorImg: \(String(describing: videoModelNewData?.thumbnail))")
        
        bindViewModel()
        viewModel.upload(operationId: operationIdSend)
        
        viewModel.onCompletion = { [weak self] in
            DispatchQueue.main.async {
                self?.navigateToDashboard()
            }
        }
    }
    
    private func loadImage(from urlString: String) {
        guard let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
            guard let self = self, let data = data else { return }
            DispatchQueue.main.async {
                self.imgVw.image = UIImage(data: data)
            }
        }.resume()
    }
    
    private func bindViewModel() {
        viewModel.updateProgress = { [weak self] progress in
            DispatchQueue.main.async {
                self?.lbl_state.text = "Progress: \(progress)%"
                print("Progress: \(progress)%")
            }
        }

        viewModel.updateState = { [weak self] state in
            DispatchQueue.main.async {
                self?.lbl_state.text = state
                print("State: \(state)")
            }
        }
    }

    func navigateToDashboard() {
        DispatchQueue.main.async {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let dashboardVC = storyboard.instantiateViewController(withIdentifier: "DashboardVC") as? DashboardVC {
                let navController = UINavigationController(rootViewController: dashboardVC)
                self.present(navController, animated: false, completion: nil)
            }
        }
    }

    @IBAction func acn_backBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: false)
    }
}

