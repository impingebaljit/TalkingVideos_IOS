//
//  ScriptVC.swift
//  TalkingVideos
//
//  Created by Nisha Gupta on 21/03/25.
//

import UIKit
import AuthenticationServices



class ScriptVC: UIViewController, UITextViewDelegate {

    @IBOutlet weak var btn_Back: UIButton!
   

    @IBOutlet weak var txtVw_Script: UITextView!
    var scriptText: String?
    
    private var viewModel: SubmitViewModel!
    
    var videoModelNew: VideoDetailModel?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.hidesBackButton = true
        self.navigationController?.isNavigationBarHidden = true

        // Display the script if available
        txtVw_Script.delegate = self
        txtVw_Script.text = scriptText ?? "Type your own script"
        
        print("VideoModelData CreatorName:-\(String(describing: videoModelNew?.creatorName))")
        
        
        
        let authService = AuthService() // Assuming AuthService is implemented
        viewModel = SubmitViewModel(authService: authService)
    }

    @IBAction func acn_backBTn(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }

    @IBAction func acn_GenerateVideo(_ sender: Any) {
        print("Generate Video tapped")
       // callSubmitVideoApi()
    }
//    func callSubmitVideoApi(){
//        let name = videoModelNew?.creatorName
//        
//        print("Get Name Script VC:-\(name ?? "abc")")
//        
//        viewModel.submitVideo(
//            prompt: txtVw_Script.text,
//            creatorName: name ?? "name",
//            resolution: "fhd"
//        ) { success, submitModel in
//            if success, let model = submitModel {
//                print("SubmitModel: \(model)")
//                
//                let operationID = model.operationID
//                
//                DispatchQueue.main.async {
//                 
//                    guard let detailVC = self.storyboard?.instantiateViewController(withIdentifier: "StatusCheckVC") as? StatusCheckVC else {
//                        print("Failed to instantiate AICreatorContinueVC")
//                        return
//                    }
//                    detailVC.videoModelNewData = self.videoModelNew
//                    detailVC.operationIdSend = model.operationID
//                    self.navigationController?.pushViewController(detailVC, animated: true)
//                }
//            } else {
//                print("Video submission failed")
//            }
//        }
//    }
    
    func callSubmitVideoApi() {
        let name = videoModelNew?.creatorName ?? "name"
        
        viewModel.submitVideo(prompt: txtVw_Script.text, creatorName: name, resolution: "fhd") { success, submitModel, errorMessage in
            DispatchQueue.main.async {
                if success, let model = submitModel {
                    guard let detailVC = self.storyboard?.instantiateViewController(withIdentifier: "StatusCheckVC") as? StatusCheckVC else {
                        self.showAlert(message: "Failed to instantiate StatusCheckVC")
                        return
                    }
                    detailVC.videoModelNewData = self.videoModelNew
                    detailVC.operationIdSend = model.operationID
                    print("OperationID:-\(model.operationID)")
                    self.navigationController?.pushViewController(detailVC, animated: true)
                } else {
                    self.showAlert(message: errorMessage ?? "Video submission failed")
                }
            }
        }
    }

    func showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
    // Remove placeholder when user starts typing
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Type your own script" {
            textView.text = ""
            textView.textColor = .white // Change to normal text color
        }
    }

    // Restore placeholder if user leaves it empty
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = "Type your own script"
            textView.textColor = .white
        }
    }
}
