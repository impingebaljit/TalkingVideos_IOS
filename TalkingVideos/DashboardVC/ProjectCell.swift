//
//  ProjectCell.swift
//  TalkingVideos
//
//  Created by Nisha Gupta on 02/04/25.
//

import UIKit
import SDWebImage

protocol ProjectCellDelegate: AnyObject {
    func didTapCancelInCell(_ cell: ProjectCell)
}
class ProjectCell: UITableViewCell {
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var projectImageView: UIImageView!
    
    @IBOutlet weak var dateTop: NSLayoutConstraint!
    @IBOutlet weak var height_ProgressBar: NSLayoutConstraint!
    @IBOutlet weak var lbl_VideoSize: UILabel!
    
    
    @IBOutlet weak var topConstraint_Progress: NSLayoutConstraint!
    @IBOutlet weak var acn_DleteBtn: UIButton!
    @IBOutlet weak var imgArrow: UIImageView!
    @IBOutlet weak var progressView_Bar: UIProgressView!
    
    weak var delegate: ProjectCellDelegate?
    
    private let progressView: UIProgressView = {
         let progress = UIProgressView(progressViewStyle: .default)
         progress.progressTintColor = UIColor.purple // Purple Progress
         progress.trackTintColor = UIColor.darkGray
         progress.isHidden = true
         return progress
     }()
    
   

    @IBAction func acn_DeleteBtn(_ sender: Any) {
       
        delegate?.didTapCancelInCell(self)
    }
    
   
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

    func configure(with status: StatusCheckModel, and project: DashboardModel) {
 //   func configure(with status: StatusCheckModel) {
        let state = status.state.uppercased()
        acn_DleteBtn.isUserInteractionEnabled = true
        
        topConstraint_Progress.constant = 11
        
        dateTop.constant = 4
        
        height_ProgressBar.constant = 4
        
        if let imageUrlString = project.creatorImage, let imageUrl = URL(string: imageUrlString) {
            projectImageView.sd_setImage(with: imageUrl, placeholderImage: UIImage(named: "defaultImage"))
        } else {
            projectImageView.image = UIImage(named: "defaultImage")
        }

        switch state {
        case "COMPLETE":
            self.titleLabel.text = "Video generation successful"
            self.dateLabel.text = "100% complete"
            self.progressView_Bar.isHidden = true
            self.progressView_Bar.progress = 1.0
            imgArrow.image = UIImage(named: "arrow")

        case "PROCESSING":
            self.titleLabel.text = "Generating video..."
            let progress = Float(status.progress ?? 0)
            self.dateLabel.text = "\(Int(progress))% complete"
            self.progressView_Bar.isHidden = false
            self.progressView_Bar.progress = progress / 100.0
            imgArrow.image = UIImage(named: "cross")

        case "QUEUED":
            self.titleLabel.text = "Queued"
            self.dateLabel.text = "Please wait"
            self.progressView_Bar.isHidden = false
            let progress = Float(status.progress ?? 0)
            self.progressView_Bar.progress = progress / 100.0
            imgArrow.image = UIImage(named: "cross")

        default:
            self.titleLabel.text = "Preparing video..."
            self.dateLabel.text = "\(status.progress ?? 0)% complete"
            self.progressView_Bar.isHidden = false
            self.progressView_Bar.progress = 50//Float(status.progress ?? 0) / 100.0
            imgArrow.image = UIImage(named: "cross")
        }

        print("Status: \(state), Progress: \(status.progress ?? 0)")
        
        lbl_VideoSize.isHidden = true
        
    }
    
  
      

 func configure(with project: DashboardModel) {
     lbl_VideoSize.isHidden = false
        acn_DleteBtn.isUserInteractionEnabled = false
     height_ProgressBar.constant = 0
     dateTop.constant = -1
        self.titleLabel.text = project.script ?? "ABC"
        imgArrow.image = UIImage(named: "arrow")
      //  self.dateLabel.text = "Last update on \(project.createdAt)"
        self.progressView_Bar.isHidden = true
        let input = project.createdAt
        let result = formatDate(input)
        print(result)  // Output: Last update on Mar 25
        self.dateLabel.text = "Last update on \(result)"
        
        if let imageUrlString = project.creatorImage, let imageUrl = URL(string: imageUrlString) {
            projectImageView.sd_setImage(with: imageUrl, placeholderImage: UIImage(named: "defaultImage"))
        } else {
            projectImageView.image = UIImage(named: "defaultImage")
        }
     
//     if let videoURL = project.url {
//                lbl_VideoSize.text = "Size"
//                fetchVideoSize(from: videoURL) { [weak self] sizeString in
//                    DispatchQueue.main.async {
//                        self?.lbl_VideoSize.text = sizeString
//                    }
//                }
//            } else {
     lbl_VideoSize.text = "Size \(project.size ?? "30") MB"
           // }
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

    

//    func fetchVideoSize(from urlString: String, completion: @escaping (String) -> Void) {
//        guard let url = URL(string: urlString) else {
//            print("Invalid URL")
//            completion("Size: Invalid URL")
//            return
//        }
//
//        var request = URLRequest(url: url)
//        request.httpMethod = "HEAD"
//
//        let task = URLSession.shared.dataTask(with: request) { (_, response, error) in
//            if let error = error {
//                print("Error fetching video size: \(error)")
//                completion("Size: Error")
//                return
//            }
//
//            if let httpResponse = response as? HTTPURLResponse,
//                      let contentLength = httpResponse.value(forHTTPHeaderField: "Content-Length"),
//                      let sizeInBytes = Int64(contentLength) {
//                       let sizeInMB = Int(Double(sizeInBytes) / (1024 * 1024)) // 👈 convert to integer
//                       completion("Size: \(sizeInMB) MB")
//                   } else {
//                       completion("Size: Unknown")
//                   }
//        }
//
//        task.resume()
//    }


    
    
    
}
