//
//  CreatorVideoOptionsVC.swift
//  TalkingVideos
//
//  Created by Nisha Gupta on 18/03/25.
//

import UIKit

class AICreatorImgCarouselVC: UIViewController {

    var viewModel: AICreatorVideoViewModel!

    @IBOutlet weak var imgVw_Carousel: UIImageView!

    private var thumbnails: [Thumbnail] = []
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

    // MARK: - Get Thumbnails
    func getTheThumbnailImages() {
        viewModel.getTheVideoList { [weak self] success in
            guard let self = self, success else { return }

            self.thumbnails = self.viewModel.thumbnails

            guard !self.thumbnails.isEmpty else {
                print("No thumbnails available")
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
        timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(updateImage), userInfo: nil, repeats: true)
    }

    @objc private func updateImage() {
        guard !thumbnails.isEmpty else { return }

        let imageUrlString = thumbnails[currentIndex].imageURL
        loadImage(from: imageUrlString)

        currentIndex = (currentIndex + 1) % thumbnails.count
    }

    // MARK: - Load Image
    private func loadImage(from urlString: String) {
        guard let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let self = self, let data = data, error == nil, let image = UIImage(data: data) else {
                print("Error loading image: \(String(describing: error))")
                return
            }

            DispatchQueue.main.async {
                UIView.transition(with: self.containerView, duration: 0.8, options: .transitionCrossDissolve, animations: {
                    self.backgroundImageView.image = image
                    self.characterImageView.image = image
                })
            }
        }.resume()
    }

    deinit {
        timer?.invalidate()
    }
}
