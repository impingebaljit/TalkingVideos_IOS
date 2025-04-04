//
//  ScriptVC.swift
//  TalkingVideos
//
//  Created by Nisha Gupta on 21/03/25.
//

import UIKit
import AuthenticationServices
import AVFoundation


class ScriptVC: UIViewController, UITextViewDelegate {

    @IBOutlet weak var btn_Back: UIButton!
   
    @IBOutlet weak var lbl_CountWords: UILabel!
    
    @IBOutlet weak var txtVw_Script: UITextView!
    var scriptText: String?
    
    private var viewModel: SubmitViewModel!
    
    let speechSynthesizer = AVSpeechSynthesizer()
    
    var videoModelNew: VideoDetailModel?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.hidesBackButton = true
        self.navigationController?.isNavigationBarHidden = true

        // Display the script if available
        txtVw_Script.delegate = self
        txtVw_Script.text = scriptText ?? "Type your own script"
        
        print("VideoModelData CreatorName:-\(String(describing: videoModelNew?.creatorName))")
        updateWordCount()
        
        
        let authService = AuthService() // Assuming AuthService is implemented
        viewModel = SubmitViewModel(authService: authService)
        
        // Add observers for keyboard notifications
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            let keyboardHeight = keyboardFrame.height
            let bottomInset = keyboardHeight - view.safeAreaInsets.bottom

            UIView.animate(withDuration: 0.3) {
                self.txtVw_Script.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: bottomInset, right: 0)
                self.txtVw_Script.scrollIndicatorInsets = self.txtVw_Script.contentInset
            }
        }
    }

    @objc func keyboardWillHide(_ notification: Notification) {
        UIView.animate(withDuration: 0.3) {
            self.txtVw_Script.contentInset = .zero
            self.txtVw_Script.scrollIndicatorInsets = .zero
        }
    }
    
    func updateWordCount() {
          let text = txtVw_Script.text ?? ""
          
          // Split the text into words and count
          let wordCount = text.split { $0.isWhitespace || $0.isNewline }.count
         
          
          // Calculate time: Assuming average speaking speed of 150 words per minute
          let speakingRate = 150.0 // words per minute
          let secondsPerWord = 60.0 / speakingRate
          let timeInSeconds = Double(wordCount) * secondsPerWord
          
          // Display the time in seconds
         // timeLabel.text = String(format: "Time to speak: %.2f seconds", timeInSeconds)
        
     

        lbl_CountWords.text = "\(wordCount) words \(Int(timeInSeconds))s"
        
      }
    // Function to speak the words
    @IBAction func acn_playWords(_ sender: Any) {
        speakWords()  // Star
    }
    func speakWords() {
           let text = txtVw_Script.text ?? ""
           let utterance = AVSpeechUtterance(string: text)
           
           // Set properties for speech
           utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
           utterance.rate = 0.5  // Adjust rate as needed (0.0 to 1.0)
           
           // Speak the text
           speechSynthesizer.speak(utterance)
       }
    
    @IBAction func acn_backBTn(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }

    @IBAction func acn_GenerateVideo(_ sender: Any) {
        print("Generate Video tapped")
        DispatchQueue.main.async {
            CustomLoader.shared.showLoader(in: self)
        self.callSubmitVideoApi()
            
//            guard let detailVC = self.storyboard?.instantiateViewController(withIdentifier: "DashboardVC") as? DashboardVC else {
//                self.showAlert(message: "Failed to instantiate DashboardVC")
//                return
//            }
//            detailVC.operationIdSend = "fdfdfdsfds"
//            detailVC.comesFromSubmitVideo = true
//            //print("OperationID:-\(model.operationID)")
//            self.navigationController?.pushViewController(detailVC, animated: true)
        }
     
    }

    @IBAction func acn_DeleteBtn(_ sender: Any) {
        txtVw_Script.text = ""  // Clear the text view
            lbl_CountWords.text = "0 words 0s"  // Reset word count display if needed
    }
    
    func callSubmitVideoApi() {
        let name = videoModelNew?.creatorName ?? "name"
        
        viewModel.submitVideo(prompt: txtVw_Script.text, creatorName: name, resolution: "fhd") { success, submitModel, errorMessage in
            DispatchQueue.main.async {
                CustomLoader.shared.hideLoader()
                if success, let model = submitModel {
                    self.showSuccessAlert {
                        guard let detailVC = self.storyboard?.instantiateViewController(withIdentifier: "DashboardVC") as? DashboardVC else {
                            self.showAlert(message: "Failed to instantiate DashboardVC")
                            return
                        }
                        detailVC.operationIdSend = model.operationID
                        detailVC.comesFromSubmitVideo = true
                        print("OperationID:-\(model.operationID)")
                        self.navigationController?.pushViewController(detailVC, animated: true)
                    }
                } else {
                    self.showAlert(message: errorMessage ?? "Video submission failed")
                }
            }
        }
    }

    // Show success alert with a completion handler
    func showSuccessAlert(completion: @escaping () -> Void) {
        let alert = UIAlertController(title: "Success", message: "Video submitted successfully!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            completion() // Navigate to DashboardVC after user taps OK
        })
        self.present(alert, animated: true, completion: nil)
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
    
   
        func textViewDidChange(_ textView: UITextView) {
            updateWordCount()  // Update word count when text changes
        }
    
}
