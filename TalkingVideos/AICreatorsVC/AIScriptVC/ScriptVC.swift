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

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.hidesBackButton = true
        self.navigationController?.isNavigationBarHidden = true

        // Display the script if available
        txtVw_Script.text = scriptText ?? "No script available."
    }

    @IBAction func acn_backBTn(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }

    @IBAction func acn_GenerateVideo(_ sender: Any) {
        print("Generate Video tapped")
    }
}
