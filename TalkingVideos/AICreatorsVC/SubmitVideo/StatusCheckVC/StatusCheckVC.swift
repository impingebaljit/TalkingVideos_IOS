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

    
        // Do any additional setup after loading the view.
        
      
       // imgVw.image = img
        
        imgVw.layer.cornerRadius = 20
        imgVw.clipsToBounds = true
        
        let authService = AuthService() // Assuming AuthService is implemented
        viewModel = StatusCheckViewModel(authService: authService)
        
        let img = videoModelNewData?.thumbnail.imageURL
        loadImage(from: img!)
        
        print("VideoModelData CreatorName:-\(String(describing: videoModelNewData?.creatorName))")
             print("VideoModelData CreatorImg:-\(String(describing: videoModelNewData?.thumbnail))")
        
        bindViewModel()
        viewModel.upload(operationId: operationIdSend)
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
                   self?.lbl_state.text = "Progress: \(progress)"
               }
           }

           viewModel.updateState = { [weak self] state in
               DispatchQueue.main.async {
                   self?.lbl_state.text = state
               }
           }
       }
    func apiToCheckStatus() {
           viewModel.checkStatus(operationID: operationIdSend, progressHandler: { [weak self] status in
               print("📊 Progress: \(status)")
               DispatchQueue.main.async {
                   // Update your UI with the progress status
                   self?.updateProgressUI(status: status)
               }
           }, completion: { [weak self] success, statusModel in
               DispatchQueue.main.async {
                   if success, let model = statusModel {
                       print("✅ Final Status: \(model)")
                       self?.handleCompletion(model: model)
                       self?.lbl_state.text = model.state
                   } else {
                       print("❌ Status check failed")
                       self?.handleFailure()
                   }
               }
           })
       }
    
    private func updateProgressUI(status: String) {
           // Implement UI update logic here
           print("UI Updated with status: \(status)")
        //Accordingly the progress the state is updated the lbl value and progress is shwn

       }

       private func handleCompletion(model: StatusCheckModel) {
           // Handle success (e.g., navigate to a new screen or show a success message)
           print("Operation completed successfully: \(model)")
       }

       private func handleFailure() {
           // Handle failure (e.g., show an error message)
           print("Operation failed")
       }

}
