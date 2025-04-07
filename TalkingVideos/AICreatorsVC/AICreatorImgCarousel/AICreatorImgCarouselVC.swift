//
//  CreatorVideoOptionsVC.swift
//  TalkingVideos
//
//  Created by Nisha Gupta on 18/03/25.
//

import UIKit
import SDWebImage

class AICreatorImgCarouselVC: UIViewController {

    var viewModel: AICreatorVideoViewModel!

    @IBOutlet weak var imgVw_Carousel: UIImageView!

  
    private var currentIndex = 0
    private var timer: Timer?

    private var containerView: UIView!
    private var backgroundImageView: UIImageView!
    private var characterImageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.hidesBackButton = true
        self.navigationController?.isNavigationBarHidden = true

        let authService = AuthService()
        viewModel = AICreatorVideoViewModel(authService: authService)

        setupImageViews()
        setup3DEffect()
        getTheThumbnailImages()
    }

    // MARK: - Set up Image Views
    private func setupImageViews() {
        containerView = UIView(frame: imgVw_Carousel.frame)
        containerView.clipsToBounds = true
        containerView.layer.cornerRadius = 20
        containerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(containerView)

        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: imgVw_Carousel.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: imgVw_Carousel.trailingAnchor),
            containerView.topAnchor.constraint(equalTo: imgVw_Carousel.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: imgVw_Carousel.bottomAnchor)
        ])

        // Background image view (for vignette and blur effect)
        backgroundImageView = UIImageView(frame: containerView.bounds)
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.clipsToBounds = true
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(backgroundImageView)

        // Character image view (for pop-out effect)
        characterImageView = UIImageView(frame: containerView.bounds)
        characterImageView.contentMode = .scaleAspectFit
        characterImageView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(characterImageView)

        NSLayoutConstraint.activate([
            backgroundImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            backgroundImageView.topAnchor.constraint(equalTo: containerView.topAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),

            characterImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            characterImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            characterImageView.topAnchor.constraint(equalTo: containerView.topAnchor),
            characterImageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
    }

    // MARK: - Apply 3D Effect
    private func setup3DEffect() {
        addVignetteEffect()

        characterImageView.layer.shadowColor = UIColor.black.cgColor
        characterImageView.layer.shadowOpacity = 0.9
        characterImageView.layer.shadowOffset = CGSize(width: 0, height: 15)
        characterImageView.layer.shadowRadius = 30
        characterImageView.layer.masksToBounds = false
    }

    // MARK: - Add Vignette Effect
    private func addVignetteEffect() {
        let vignetteLayer = CAGradientLayer()
        vignetteLayer.frame = backgroundImageView.bounds
        vignetteLayer.colors = [
            UIColor.clear.cgColor,
            UIColor.black.withAlphaComponent(0.9).cgColor
        ]
        vignetteLayer.locations = [0.5, 1.0]
        vignetteLayer.startPoint = CGPoint(x: 0.5, y: 0.3)
        vignetteLayer.endPoint = CGPoint(x: 0.5, y: 1.0)

        backgroundImageView.layer.addSublayer(vignetteLayer)
    }


    func getTheThumbnailImages() {
        DispatchQueue.main.async {
            CustomLoader.shared.showLoader(in: self)
        }

        viewModel.getTheVideoList { [weak self] success in
            guard let self = self else { return }

            DispatchQueue.main.async {
                CustomLoader.shared.hideLoader()
            }

            guard success else {
                print("Failed to fetch video list")
                return
            }

            // Check if videoDetails is empty
            guard !self.viewModel.videoDetails.isEmpty else {
                print("No video details available")
                return
            }

            DispatchQueue.main.async {
                self.startThumbnailCarousel()
            }
        }
    }
    // MARK: - Start Carousel
    private func startThumbnailCarousel() {
        updateImage()
        timer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(updateImage), userInfo: nil, repeats: true)
    }

    @objc private func updateImage() {
        guard !viewModel.videoDetails.isEmpty else { return }

        let imageUrlString = viewModel.videoDetails[currentIndex].thumbnail.imageURL
        print("Displaying image at index \(currentIndex): \(imageUrlString)")

        loadImage(from: imageUrlString)

        currentIndex = (currentIndex + 1) % viewModel.videoDetails.count
    }

    private func loadImage(from urlString: String) {
        guard let url = URL(string: urlString) else { return }

        DispatchQueue.main.async {
            UIView.transition(with: self.containerView, duration: 0.8, options: .transitionCrossDissolve) {
                self.backgroundImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder"))
                self.characterImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder"))
            }
        }
    }

    deinit {
        timer?.invalidate()
    }
    
    
    @IBAction func acn_promptToVideo(_ sender: Any) {
        
    }
    @IBAction func acn_BackBtn(_ sender: Any) {
     //  navigationController?.popViewController(animated: true)
        
//        //self.dismiss(animated: true, completion: nil)
//        self.navigationController?.popViewController(animated: true)
////        if let navController = self.navigationController {
////                navController.popViewController(animated: true)
////            } else {
////                self.dismiss(animated: true, completion: nil)
////            }
        ///self.navigationController?.popViewController(animated: true)
        ///
        ///     let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let dashboardVC = storyboard?.instantiateViewController(withIdentifier: "DashboardVC") as? DashboardVC {
                let navController = UINavigationController(rootViewController: dashboardVC)
                if let window = UIApplication.shared.windows.first {
                    window.rootViewController = navController
                    window.makeKeyAndVisible()
                }
            }
        ///
    }
}
