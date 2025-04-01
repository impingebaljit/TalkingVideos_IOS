//
//  DashboardVC.swift
//  TalkingVideos
//
//  Created by Nisha Gupta on 12/03/25.
//

import UIKit
import AVFoundation
import AVKit
import SDWebImage

class DashboardVC: UIViewController {

    @IBOutlet weak var tblVw_Projects: UITableView!

    private let emptyStateView = UIStackView()

    private let viewModel = DashboardViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.hidesBackButton = true
        
        self.navigationController?.isNavigationBarHidden = true

        setupUI()
        setupTableView()
        setupViewModel()

        viewModel.fetchProjects()
    }

    private func setupUI() {
        view.backgroundColor = UIColor(red: 16/255, green: 9/255, blue: 25/255, alpha: 1.0)

        // Empty State Icon
        let folderIcon = UIImageView(image: UIImage(named: "folderIcon"))
        folderIcon.tintColor = UIColor.darkGray
        folderIcon.translatesAutoresizingMaskIntoConstraints = false

        // Empty State Label
        let titleLabel = UILabel()
        titleLabel.text = "No projects yet"
        titleLabel.textColor = UIColor.white
        titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)

        let subtitleLabel = UILabel()
        subtitleLabel.text = "Hit the button below to add your first project"
        subtitleLabel.textColor = UIColor.gray
        subtitleLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)

        // Center Content Stack
        emptyStateView.axis = .vertical
        emptyStateView.spacing = 12
        emptyStateView.alignment = .center
        emptyStateView.translatesAutoresizingMaskIntoConstraints = false

        emptyStateView.addArrangedSubview(folderIcon)
        emptyStateView.addArrangedSubview(titleLabel)
        emptyStateView.addArrangedSubview(subtitleLabel)

        view.addSubview(emptyStateView)

        NSLayoutConstraint.activate([
            emptyStateView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyStateView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])

        // Add Custom Tab Bar
        let tabBar = TabBarController()
        tabBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tabBar)

        NSLayoutConstraint.activate([
            tabBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tabBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tabBar.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -15),
            tabBar.heightAnchor.constraint(equalToConstant: 80)
        ])
    }

    private func setupTableView() {
        tblVw_Projects.delegate = self
        tblVw_Projects.dataSource = self
        tblVw_Projects.register(ProjectCell.self, forCellReuseIdentifier: "ProjectCell")
        tblVw_Projects.tableFooterView = UIView()
    }

    private func setupViewModel() {
        viewModel.onProjectsUpdated = { [weak self] in
            DispatchQueue.main.async {
                self?.checkEmptyState()
                self?.tblVw_Projects.reloadData()
            }
        }
    }

    private func checkEmptyState() {
        let isEmpty = viewModel.projectCount() == 0
        emptyStateView.isHidden = !isEmpty
        tblVw_Projects.isHidden = isEmpty
    }
}

class ProjectCell: UITableViewCell {
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var projectImageView: UIImageView!
    
   

    override func awakeFromNib() {
        super.awakeFromNib()
    }

//    func configure(with project: DashboardModel) {
//            titleLabel?.text = project.script
//            dateLabel?.text = "Last update on \(project.createdAt)"
//
//            if let imageURL = URL(string: project.url) {
//                DispatchQueue.global().async {
//                    if let imageData = try? Data(contentsOf: imageURL) {
//                        let image = UIImage(data: imageData)
//                        DispatchQueue.main.async {
//                            self.projectImageView?.image = image
//                        }
//                    }
//                }
//            } else {
//                projectImageView?.image = UIImage(named: "projectPlaceholder")
//            }
//        }
    
    static let thumbnailCache = NSCache<NSURL, UIImage>()

      func configure(with project: DashboardModel) {
          titleLabel?.text = project.script
          dateLabel?.text = "Last update on \(project.createdAt)"
          
          guard let url = URL(string: project.url) else {
              print("❌ Invalid URL: \(project.url)")
              projectImageView?.image = UIImage(named: "projectPlaceholder")
              return
          }

          // Reset the image to avoid flickering while loading
          projectImageView?.image = UIImage(named: "projectPlaceholder")

          if url.pathExtension.lowercased() == "mp4" {
              print("🎬 Loading video thumbnail from \(url)")

              // Check cache first
              if let cachedThumbnail = ProjectCell.thumbnailCache.object(forKey: url as NSURL) {
                  projectImageView?.image = cachedThumbnail
                  return
              }

              // Generate the thumbnail asynchronously
              DispatchQueue.global(qos: .background).async {
                  if let thumbnail = self.createThumbnailOfVideoFromRemoteUrl(url: url) {
                      ProjectCell.thumbnailCache.setObject(thumbnail, forKey: url as NSURL)
                      
                      DispatchQueue.main.async {
                          if url.absoluteString == project.url {  // Ensure correct cell reuse behavior
                              self.projectImageView?.image = thumbnail
                          }
                      }
                  } else {
                      print("⚠️ Failed to generate thumbnail for \(url)")
                  }
              }
          } else {
              print("🖼️ Loading image from \(url)")
              projectImageView?.sd_setImage(with: url, placeholderImage: UIImage(named: "projectPlaceholder"))
          }
      }
    
func createThumbnailOfVideoFromRemoteUrl(url: URL) -> UIImage? {
    let asset = AVAsset(url: url)
    let assetImgGenerate = AVAssetImageGenerator(asset: asset)
    assetImgGenerate.appliesPreferredTrackTransform = true
    
    // Set a reasonable maximum size to improve performance
    assetImgGenerate.maximumSize = CGSize(width: 300, height: 300)
    
    let time = CMTime(seconds: 1.0, preferredTimescale: 600)
    
    do {
        let img = try assetImgGenerate.copyCGImage(at: time, actualTime: nil)
        return UIImage(cgImage: img)
    } catch {
        print("⚠️ Error generating thumbnail: \(error.localizedDescription)")
        return nil
    }
}
}

extension DashboardVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.projectCount()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? ProjectCell else {
            return UITableViewCell()
        }
        let project = viewModel.getProject(at: indexPath.row)
        cell.configure(with: project)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let project = viewModel.getProject(at: indexPath.row)
        
        guard let videoURL = URL(string: project.url) else {
            print("Invalid video URL")
            return
        }
        
      
        
        
        
        DispatchQueue.main.async {
         
            guard let detailVC = self.storyboard?.instantiateViewController(withIdentifier: "VideoPlayVC") as? VideoPlayVC else {
                print("Failed to instantiate AICreatorContinueVC")
                return
            }
            detailVC.videoURL = videoURL
          
            self.navigationController?.pushViewController(detailVC, animated: true)
        }
        
        
        
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 102
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] _, _, completionHandler in
            guard let self = self else { return }

            let project = viewModel.getProject(at: indexPath.row)

            viewModel.deleteVideos(videoId: String(project.id)) { success in
                DispatchQueue.main.async {
                    if success {
                        if indexPath.row < self.viewModel.projectCount() {  // Ensure valid index
                            tableView.performBatchUpdates({
                                tableView.deleteRows(at: [indexPath], with: .automatic)
                            }, completion: { _ in
                                self.checkEmptyState()
                            })
                        }
                        self.showAlert(title: "", message: "Deleted video successfully.")
                    } else {
                        self.showAlert(title: "Error", message: "Failed to delete the video. Please try again.")
                    }
                    completionHandler(success)
                }
            }
        }

        deleteAction.backgroundColor = .red
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
}

//struct Project {
//    let image: UIImage?
//    let title: String
//    let lastUpdated: String
//}
//
//class DashboardVC: UIViewController {
//
//    @IBOutlet weak var tblVw_Projects: UITableView!
//
//    private let emptyStateView = UIStackView()
//    
//    let authService = AuthService()
//   private var projects: [Project] = []
////    private var projects: [Project] = [
////        Project(image: UIImage(named: "profileImage"), title: "Hey there. Ever had one of those days?", lastUpdated: "Mar 18, 2025"),
////        Project(image: UIImage(named: "profileImage"), title: "New Project", lastUpdated: "Mar 19, 2025")
////    ]
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        self.navigationItem.hidesBackButton = true
//        setupUI()
//        setupTableView()
//        checkEmptyState()
//        
//        
//
//        authService.fetchFinalVideos { result in
//            switch result {
//            case .success(let videos):
//                print("Videos fetched successfully:")
//                videos.forEach { print($0) }
//            case .failure(let error):
//                print("Error fetching videos: \(error)")
//            }
//        }
//    }
//
//    private func setupUI() {
//        view.backgroundColor = UIColor(red: 16/255, green: 9/255, blue: 25/255, alpha: 1.0)
//
//        // Empty State Icon
//        let folderIcon = UIImageView(image: UIImage(named: "folderIcon"))
//        folderIcon.tintColor = UIColor.darkGray
//        folderIcon.translatesAutoresizingMaskIntoConstraints = false
//
//        // Empty State Label
//        let titleLabel = UILabel()
//        titleLabel.text = "No projects yet"
//        titleLabel.textColor = UIColor.white
//        titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
//
//        let subtitleLabel = UILabel()
//        subtitleLabel.text = "Hit the button below to add your first project"
//        subtitleLabel.textColor = UIColor.gray
//        subtitleLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
//
//        // Center Content Stack
//        emptyStateView.axis = .vertical
//        emptyStateView.spacing = 12
//        emptyStateView.alignment = .center
//        emptyStateView.translatesAutoresizingMaskIntoConstraints = false
//
//        emptyStateView.addArrangedSubview(folderIcon)
//        emptyStateView.addArrangedSubview(titleLabel)
//        emptyStateView.addArrangedSubview(subtitleLabel)
//
//        view.addSubview(emptyStateView)
//
//        NSLayoutConstraint.activate([
//            emptyStateView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            emptyStateView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
//        ])
//
//        // Add Custom Tab Bar
//        let tabBar = TabBarController()
//        tabBar.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(tabBar)
//
//        NSLayoutConstraint.activate([
//            tabBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            tabBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            tabBar.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -15),
//            tabBar.heightAnchor.constraint(equalToConstant: 80)
//        ])
//    }
//
//    private func setupTableView() {
//        tblVw_Projects.delegate = self
//        tblVw_Projects.dataSource = self
//        tblVw_Projects.register(ProjectCell.self, forCellReuseIdentifier: "ProjectCell")
//        tblVw_Projects.tableFooterView = UIView() // Removes extra separators
//    }
//
//    private func checkEmptyState() {
//        emptyStateView.isHidden = !projects.isEmpty
//        tblVw_Projects.isHidden = projects.isEmpty
//    }
//}
//
//class ProjectCell: UITableViewCell {
//  
//    
//  
//    @IBOutlet var dateLabel: UILabel!
//    @IBOutlet var titleLabel: UILabel!
//    @IBOutlet var projectImageView: UIImageView!
//    
//    
//    override func awakeFromNib() {
//        super.awakeFromNib()
// 
//        
//    }
//
////
////    func configure(with project: Project) {
////        projectImageView.image = project.image
////        titleLabel.text = project.title
////        dateLabel.text = "Last update on \(project.lastUpdated)"
////    }
//}
//
//extension DashboardVC: UITableViewDelegate, UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return projects.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? ProjectCell else {
//            return UITableViewCell()
//        }
//       // cell.configure(with: projects[indexPath.row])
//        return cell
//    }
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print("Selected project: \(projects[indexPath.row].title)")
//    }
//    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//       
//            return 102
//        
//    }
//}
