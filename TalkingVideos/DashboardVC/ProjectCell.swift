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
    
    @IBOutlet weak var progressView_Bar: UIProgressView!
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
        
        progressView_Bar.isHidden = true

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



    
//    func configure(with status: StatusCheckModel) {
//        self.titleLabel.text = "Progress: \(status.progress ?? 0)%"
//        self.dateLabel.text = status.state
//       // self.progressBar.progress = Float(status.progress ?? 0) / 100.0
//    }
    
//    func configure(with status: StatusCheckModel) {
//        if status.state.uppercased() == "COMPLETE" {
//            self.titleLabel.text = "Video generation successful"
//            self.progressView_Bar.isHidden = false
//            self.dateLabel.text = "100% complete"
//            // self.progressBar.progress = 1.0
//        } else {
//            self.titleLabel.text = "Generating Video..."
//            self.dateLabel.text = "\(status.progress ?? 0)% complete"
//            self.progressView_Bar.isHidden = false
//            print("GEt The Status Progress;- \(status.progress ?? 0)")
//            self.progressView_Bar.progress = Float(status.progress ?? 0) / 100.0
//        }
//    }

    
    
    func configure(with status: StatusCheckModel) {
        let state = status.state.uppercased()

        switch state {
        case "COMPLETE":
            self.titleLabel.text = "Video generation successful"
            self.dateLabel.text = "100% complete"
            self.progressView_Bar.isHidden = true
            self.progressView_Bar.progress = 1.0

        case "PROCESSING":
            self.titleLabel.text = "Generating video..."
            let progress = Float(status.progress ?? 0)
            self.dateLabel.text = "\(Int(progress))% complete"
            self.progressView_Bar.isHidden = false
            self.progressView_Bar.progress = progress / 100.0

        case "QUEUED":
            self.titleLabel.text = "Waiting in queue..."
            self.dateLabel.text = "Queued - starting soon"
            self.progressView_Bar.isHidden = false
            self.progressView_Bar.progress = 0.0

        default:
            self.titleLabel.text = "Preparing video..."
            self.dateLabel.text = "\(status.progress ?? 0)% complete"
            self.progressView_Bar.isHidden = true
            self.progressView_Bar.progress = Float(status.progress ?? 0) / 100.0
        }

        print("Status: \(state), Progress: \(status.progress ?? 0)")
    }
    
    
    
    func configure(with project: DashboardModel) {
        self.titleLabel.text = project.script
      //  self.dateLabel.text = "Last update on \(project.createdAt)"
        self.progressView_Bar.isHidden = true
        let input = project.createdAt
        let result = formatDate(input)
        print(result)  // Output: Last update on Mar 25
        self.dateLabel.text = "Last update on \(result)"
        
        if let imageUrlString = project.creatorImage, let imageUrl = URL(string: imageUrlString) {
            projectImageView.sd_setImage(with: imageUrl, placeholderImage: UIImage(named: "placeholderImage"))
        } else {
            projectImageView.image = UIImage(named: "defaultImage")
        }
    }
    func formatDate(_ dateString: String) -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSZ"
        inputFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        if let date = inputFormatter.date(from: dateString) {
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = "MMM dd, yyyy"
            let formattedDate = outputFormatter.string(from: date)
            return "\(formattedDate)"
        } else {
            return "Invalid date"
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
