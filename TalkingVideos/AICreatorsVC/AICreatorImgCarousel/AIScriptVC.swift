import UIKit

class AIScriptVC: UIViewController {

    @IBOutlet weak var tf_Script: UITextField!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnGenerateScript: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Observe keyboard events
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)

        // Monitor text changes
        tf_Script.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    @IBAction func acn_backBtn(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }

    @IBAction func acn_GenerateScript(_ sender: Any) {
        print("Generate Script tapped")
        guard let detailVC = storyboard?.instantiateViewController(withIdentifier: "ScriptVC") as? ScriptVC else {
            print("❌ Failed to instantiate AICreatorContinueVC")
            return
        }
        navigationController?.pushViewController(detailVC, animated: true)
    }

    @objc func textFieldDidChange(_ textField: UITextField) {
        if let text = textField.text, !text.isEmpty {
            btnGenerateScript.backgroundColor = UIColor(red: 140/255, green: 32/255, blue: 248/255, alpha: 1.0) // Purple color
        } else {
            btnGenerateScript.backgroundColor = UIColor.lightGray // Default color
        }
    }

    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            UIView.animate(withDuration: 0.3) {
                self.btnGenerateScript.transform = CGAffineTransform(translationX: 0, y: -keyboardFrame.height + 20)
            }
        }
    }

    @objc func keyboardWillHide(_ notification: Notification) {
        UIView.animate(withDuration: 0.3) {
            self.btnGenerateScript.transform = .identity
        }
    }
}

