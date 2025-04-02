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
    
   

    override func awakeFromNib() {
        super.awakeFromNib()
        
       // progressView.isHidden = true
           //    progressLabel.isHidden = true
    }


    func configure(with project: DashboardModel) {
        titleLabel?.text = project.script
        dateLabel?.text = "Last update on \(project.createdAt)"
        // projectImageView.image = SDWebImage.image(project.creatorImage)
        
        if let imageUrlString = project.creatorImage, let imageUrl = URL(string: imageUrlString) {
            projectImageView.sd_setImage(with: imageUrl, placeholderImage: UIImage(named: "placeholderImage")) { (image, error, cacheType, url) in
                if let error = error {
                    print("Error loading image: \(error)")
                    // Optionally, handle the error (e.g., show a default image)
                } else {
                    // Image loaded successfully, you can perform additional tasks here if needed
                }
            }
        } else {
            // Handle the case where imageUrlString is nil or invalid
            projectImageView.image = UIImage(named: "defaultImage") // Or a placeholder
        }
        
        
        
     
        
        
    }

}
