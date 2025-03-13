//
//  ResetPasswordVC.swift
//  TalkingVideos
//
//  Created by Nisha Gupta on 12/03/25.
//

import UIKit

class ResetPasswordVC: UIViewController {

    @IBOutlet weak var tf_EnterNewPassw: UITextField!
    
    @IBOutlet weak var tf_ConfirmPassw: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.hidesBackButton = true
    }
    

    @IBAction func acn_Submit(_ sender: Any) {
    }
    
}
