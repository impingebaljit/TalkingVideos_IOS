//
//  AICreatorContinueVC.swift
//  TalkingVideos
//
//  Created by Nisha Gupta on 21/03/25.
//

import UIKit

class AICreatorContinueVC: UIViewController {

    @IBOutlet weak var lblnameColor: UILabel!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var lbl_name: UILabel!
    @IBOutlet weak var imgVw: UIImageView!
    @IBOutlet weak var continueBtn: UIButton!

    var videoModel: VideoDetailModel?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Ensure videoModel is available
        guard let model = videoModel else {
            print("videoModel not found")
            return
        }

        // Set name, image, and colors
        lbl_name.text = model.creatorName
        lblnameColor.text = model.creatorName

        lbl_name.textColor = .white // Updated to white color
        lblnameColor.textColor = model.color
        lblnameColor.font = UIFont.systemFont(ofSize: 48, weight: .bold) // Bigger and attractive

        // Ensure the back button uses the storyboard image
        backBtn.tintColor = .white
        backBtn.isHidden = false
        
        DispatchQueue.main.async {
                  CustomLoader.shared.showLoader(in: self)
            self.loadImage(from: model.thumbnail.imageURL)
              }

      

        // Set button title and style
        continueBtn.setTitle("Continue with \(model.creatorName)", for: .normal)
        continueBtn.backgroundColor = model.color
        continueBtn.setTitleColor(.white, for: .normal) // Title in white color
        continueBtn.layer.cornerRadius = continueBtn.frame.height / 2
        continueBtn.clipsToBounds = true

        // ImageView styling to match design
        imgVw.layer.cornerRadius = 20
        imgVw.clipsToBounds = true
    }

    private func loadImage(from urlString: String) {
        CustomLoader.shared.hideLoader()
        
        guard let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
            guard let self = self, let data = data else { return }
            DispatchQueue.main.async {
                self.imgVw.image = UIImage(data: data)
            }
        }.resume()
    }

    @IBAction func acn_ContinueBtn(_ sender: Any) {
        print("Continue button tapped")
      
        guard let detailVC = storyboard?.instantiateViewController(withIdentifier: "AIScriptVC") as? AIScriptVC else {
            print("Failed to instantiate AICreatorContinueVC")
            return
        }
        detailVC.videoModelData = videoModel
        navigationController?.pushViewController(detailVC, animated: true)
    }

    @IBAction func acn_BackBtn(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}
