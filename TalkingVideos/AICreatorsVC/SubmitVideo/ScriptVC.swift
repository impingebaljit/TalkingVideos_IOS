//
//  ScriptVC.swift
//  TalkingVideos
//
//  Created by Nisha Gupta on 21/03/25.
//

import UIKit
import AuthenticationServices



class ScriptVC: UIViewController {

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
        txtVw_Script.text = scriptText ?? "No script available."
        
        print("VideoModelData CreatorName:-\(String(describing: videoModelNew?.creatorName))")
        
        
        
        let authService = AuthService() // Assuming AuthService is implemented
        viewModel = SubmitViewModel(authService: authService)
    }

    @IBAction func acn_backBTn(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }

    @IBAction func acn_GenerateVideo(_ sender: Any) {
        print("Generate Video tapped")
        callSubmitVideoApi()
    }
    func callSubmitVideoApi(){
        let name = videoModelNew?.creatorName
        
        print("Get Name Script VC:-\(name ?? "abc")")
        
        viewModel.submitVideo(
            prompt: txtVw_Script.text,
            creatorName: name ?? "name",
            resolution: "fhd"
        ) { success, submitModel in
            if success, let model = submitModel {
                print("SubmitModel: \(model)")
                
                let operationID = model.operationID
                
                DispatchQueue.main.async {
                 
                    guard let detailVC = self.storyboard?.instantiateViewController(withIdentifier: "StatusCheckVC") as? StatusCheckVC else {
                        print("Failed to instantiate AICreatorContinueVC")
                        return
                    }
                    detailVC.videoModelNewData = self.videoModelNew
                    detailVC.operationIdSend = model.operationID
                    self.navigationController?.pushViewController(detailVC, animated: true)
                }
            } else {
                print("Video submission failed")
            }
        }
    }
}
