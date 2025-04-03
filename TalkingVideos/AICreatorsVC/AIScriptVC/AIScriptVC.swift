import UIKit

//  AIScriptVC.swift
//  TalkingVideos
//
//  Created by Nisha Gupta on 24/03/25.
//

import UIKit
import AuthenticationServices

class AIScriptVC: UIViewController {

    @IBOutlet weak var imgVw: UIImageView!
    @IBOutlet weak var tf_Script: CustomTextField!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnGenerateScript: UIButton!
    @IBOutlet weak var btnWidthConstraint: NSLayoutConstraint! // Ensure this outlet is connected in storyboard

    private var viewModel: AIScriptViewModel!
    var videoModelData: VideoDetailModel?

    override func viewDidLoad() {
        super.viewDidLoad()

        tf_Script.placeholderColor = UIColor.white
        let authService = AuthService()
        viewModel = AIScriptViewModel(authService: authService)

//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        tf_Script.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        self.navigationController?.isNavigationBarHidden = true
        
        DispatchQueue.main.async {
            CustomLoader.shared.showLoader(in: self)
            if let imageUrl = self.videoModelData?.thumbnail.imageURL {
                self.loadImage(from: imageUrl)
            }
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    private func loadImage(from urlString: String) {
        CustomLoader.shared.hideLoader()
        guard let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
            guard let self = self, let data = data else { return }
            DispatchQueue.main.async {
                self.imgVw.image = UIImage(data: data)
               // self.adjustButtonWidth()
            }
        }.resume()
    }
    
    @IBAction func acn_BtnCustom(_ sender: Any) {
        
        DispatchQueue.main.async {
                 
             
                 guard let detailVC = self.storyboard?.instantiateViewController(withIdentifier: "ScriptVC") as? ScriptVC else {
                     print("Failed to instantiate ScriptVC")
                     return
                 }
                 
                 
                 detailVC.videoModelNew = self.videoModelData
                 self.navigationController?.pushViewController(detailVC, animated: true)
             }
    }
//    private func adjustButtonWidth() {
//        let imageExists = imgVw.image != nil
//        btnWidthConstraint.constant = imageExists ? 350 : 150 // Adjust width accordingly
//        UIView.animate(withDuration: 0.3) {
//            self.view.layoutIfNeeded()
//        }
   // }

    @IBAction func acn_backBtn(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }

    @IBAction func acn_GenerateScript(_ sender: Any) {
        guard let prompt = tf_Script.text, !prompt.isEmpty else {
            print("Prompt is empty")
            return
        }
        DispatchQueue.main.async {
            CustomLoader.shared.showLoader(in: self)
            self.generateScriptApi(prompt: prompt)
        }
    }

    func generateScriptApi(prompt: String) {
        viewModel.generateScript(prompt: prompt) { [weak self] success, scriptModel in
            guard let self = self else { return }
            DispatchQueue.main.async {
                CustomLoader.shared.hideLoader()
                if success, let scriptModel = scriptModel {
                    guard let detailVC = self.storyboard?.instantiateViewController(withIdentifier: "ScriptVC") as? ScriptVC else { return }
                    let scriptText = scriptModel.script.content.compactMap { $0.text }.joined(separator: "\n")
                                   
                    detailVC.scriptText = scriptText
                    print("Get the script Text:- \(scriptText)")
                    detailVC.videoModelNew = self.videoModelData
                    self.navigationController?.pushViewController(detailVC, animated: true)
                } else {
                    print("Failed to generate script")
                }
            }
        }
    }

    @objc func textFieldDidChange(_ textField: UITextField) {
        btnGenerateScript.backgroundColor = textField.text?.isEmpty == false ? UIColor(red: 139/255.0, green: 32/255.0, blue: 247/255.0, alpha: 1.0) : UIColor.lightGray
    }

//    @objc func keyboardWillShow(_ notification: Notification) {
//        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
//            UIView.animate(withDuration: 0.3) {
//                self.btnGenerateScript.transform = CGAffineTransform(translationX: 50, y: -keyboardFrame.height + 55)
//                self.btnWidthConstraint.constant = 260 // Adjust width when keyboard appears
//                self.view.layoutIfNeeded()
//            }
//        }
//    }

//    @objc func keyboardWillHide(_ notification: Notification) {
//        UIView.animate(withDuration: 0.3) {
//            self.btnGenerateScript.transform = .identity
//            self.adjustButtonWidth()
//        }
//    }
    
    
    @IBAction func acn_plusBtn(_ sender: Any) {
        
        
    }
    
    
    
    
}
