//
//  ProjectCell.swift
//  TalkingVideos
//
//  Created by Nisha Gupta on 02/04/25.
//

import UIKit
import SDWebImage


class ProjectCell: UITableViewCell {
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var projectImageView: UIImageView!
    
    private let progressView: UIProgressView = {
         let progress = UIProgressView(progressViewStyle: .default)
         progress.progressTintColor = UIColor.purple // Purple Progress
         progress.trackTintColor = UIColor.darkGray
         progress.isHidden = true
         return progress
     }()

    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupProgressView()

    }
    private func setupProgressView() {
         addSubview(progressView)
         progressView.translatesAutoresizingMaskIntoConstraints = false
         NSLayoutConstraint.activate([
             progressView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
             progressView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
             progressView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
             progressView.heightAnchor.constraint(equalToConstant: 4)
         ])
     }

//    func configure(with project: DashboardModel) {
//        titleLabel?.text = project.script
//        dateLabel?.text = "Last update on \(project.createdAt)"
//        // projectImageView.image = SDWebImage.image(project.creatorImage)
//        
//        if let imageUrlString = project.creatorImage, let imageUrl = URL(string: imageUrlString) {
//            projectImageView.sd_setImage(with: imageUrl, placeholderImage: UIImage(named: "placeholderImage")) { (image, error, cacheType, url) in
//                if let error = error {
//                    print("Error loading image: \(error)")
//                    // Optionally, handle the error (e.g., show a default image)
//                } else {
//                    // Image loaded successfully, you can perform additional tasks here if needed
//                }
//            }
//        } else {
//            // Handle the case where imageUrlString is nil or invalid
//            projectImageView.image = UIImage(named: "defaultImage") // Or a placeholder
//        }
//        
//        
//        
//     
//        
//        
//    }

//    func configure(with project: DashboardModel) {
//        titleLabel?.text = project.script
//        dateLabel?.text = project.createdAt
//
//        if project.uploadInProgress ?? false {
//            titleLabel.text = "Generating video..."
//            titleLabel.textColor = .white
//            dateLabel.textColor = UIColor.white.withAlphaComponent(0.7)
//
//            // Progress Bar
//            progressView.isHidden = false
//            progressView.progressTintColor = UIColor.purple
//            progressView.trackTintColor = UIColor.darkGray
//
//            if let progress = project.state {
//                progressView.progress = 20
//                dateLabel.text = "\(progress)% complete"
//            } else {
//                progressView.progress = 0.0
//                dateLabel.text = "Starting..."
//            }
//        } else {
//            titleLabel.textColor = .white
//            dateLabel.textColor = .gray
//            progressView.isHidden = true
//        }
//
//        if let imageUrlString = project.creatorImage, let imageUrl = URL(string: imageUrlString) {
//            projectImageView.sd_setImage(with: imageUrl, placeholderImage: UIImage(named: "placeholderImage"))
//        } else {
//            projectImageView.image = UIImage(named: "defaultImage")
//        }
//    }
    
    
    func configure(with status: StatusCheckModel) {
        self.titleLabel.text = "Progress: \(status.progress ?? 0)%"
        self.dateLabel.text = status.state
       // self.progressBar.progress = Float(status.progress ?? 0) / 100.0
    }

    func configure(with project: DashboardModel) {
        self.titleLabel.text = project.script
        self.dateLabel.text = "Last update on \(project.createdAt)"
        
        if let imageUrlString = project.creatorImage, let imageUrl = URL(string: imageUrlString) {
            projectImageView.sd_setImage(with: imageUrl, placeholderImage: UIImage(named: "placeholderImage"))
        } else {
            projectImageView.image = UIImage(named: "defaultImage")
        }
    }

    func updateStatus(state: String, progress: Int) {
           self.dateLabel.text = state
           self.titleLabel.text = "Progress: \(progress)%"
       }
    // Helper function to extract progress value from state string
    private func extractProgress(from state: String) -> Int? {
        let progressText = state.replacingOccurrences(of: "% complete", with: "").trimmingCharacters(in: .whitespaces)
        return Int(progressText)
    }

  
    
    
    
}
