import UIKit
import AVFoundation
import AVKit
import SDWebImage

class DashboardVC: UIViewController {

    @IBOutlet weak var tblVw_Projects: UITableView!
    
    var operationIdSend = String()
    //var comesFromSubmitVideo = Bool()
    var comesFromSubmitVideo: Bool = false
    private let emptyStateView = UIStackView()

    private let viewModel = DashboardViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.hidesBackButton = true
        self.navigationController?.isNavigationBarHidden = true

        setupUI()
        setupBindings()
        setupTableView()
        setupViewModel()
        
       
       
       
        
        tblVw_Projects.contentInsetAdjustmentBehavior = .automatic
        tblVw_Projects.tableFooterView = UIView(frame: .zero)

    }
    
//    override func viewWillAppear(_ animated: Bool) {
//       
//       print("View WillAppear called")
//     comesFromSubmitVideo = true
//       // if(comesFromSubmitVideo == true) {
//      //  viewModel.upload(operationId: operationIdSend, from: true)
//       // }
//
//        
////        let getOperationIdSend = UserDefaults.standard.string(forKey: "operationIdSend") ?? "abc"
////        viewModel.upload(operationId: getOperationIdSend, from: true)
//        
//        self.viewModel.processIncompleteVideos()
//        DispatchQueue.main.async {
//            CustomLoader.shared.showLoader(in: self)
//          
//            self.viewModel.fetchProjects()
//            self.tblVw_Projects.reloadData()
//        }
////        self.viewModel.processIncompleteVideos()
////        viewModel.fetchProjects { [weak self] in
////            guard let self = self else { return }
////            
////            // UI updates once projects are fetched
////            DispatchQueue.main.async {
////                self.tblVw_Projects.reloadData()
////                //CustomLoader.shared.hideLoader()
////            }
////        }
//        //DispatchQueue.global(qos: .background).async {
//        
//         //   }
//       
//    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        print("View WillAppear called")

        //comesFromSubmitVideo = true
       // tblVw_Projects.reloadData()
     
        
        emptyStateView.isHidden = true
        CustomLoader.shared.showLoader(in: self)
        
        
        // Process any incomplete video uploads
       viewModel.processIncompleteVideos()
        
        
        // Fetch offline data first
                loadOfflineVideos()

        // Start fetching data and reload once complete
        viewModel.fetchProjects { [weak self] in
            guard let self = self else { return }

            DispatchQueue.main.async {
           self.tblVw_Projects.reloadData()
                self.checkEmptyState()
               CustomLoader.shared.hideLoader()
            }
        }

        
    }
    
    
    func loadOfflineVideos() {
           if let savedVideosData = UserDefaults.standard.data(forKey: "offlineVideos") {
               do {
                   // Decode the saved videos from JSON data
                   let savedVideos = try JSONDecoder().decode([DashboardModel].self, from: savedVideosData)
                   if !savedVideos.isEmpty {
                       // If offline videos exist, use them as initial data
                       viewModel.projects = savedVideos
                       viewModel.cachedProjects = savedVideos
                       self.tblVw_Projects.reloadData()  // Reload with cached data
                   }
               } catch {
                   print("Error decoding offline videos: \(error)")
               }
           } else {
               print("No offline data found.")
           }
       }
    private func setupBindings() {
        viewModel.onProjectsUpdated = { [weak self] in
            DispatchQueue.main.async {
                self?.tblVw_Projects.reloadData()

                // ✅ Reset the flag once upload is complete and view updated
                let state = self?.viewModel.getStatus()?.state.uppercased() ?? ""
                if state == API.VideoStatus.complete {
                    self?.comesFromSubmitVideo = false
                }
            }
        }
    }

    func didTapCancelInCell(_ cell: ProjectCell) {
        
        guard let indexPath = self.tblVw_Projects.indexPath(for: cell) else { return }
        
        // Retrieve the project corresponding to this row
        let project = viewModel.projects[indexPath.row]
        
        // Show confirmation alert
        showCancelAlert(on: self, projectId: project.id)
        
    }
        


    func showCancelAlert(on viewController: UIViewController, projectId: Int) {
        // Create the alert controller
        let alertController = UIAlertController(
            title: "Cancel AI Creator Video?",
            message: "Are you sure you want to cancel generating an AI Creator video? This action can't be undone.",
            preferredStyle: .alert
        )
        
        // Add "Don't cancel" action
        let dontCancelAction = UIAlertAction(title: "Don't cancel", style: .default, handler: { _ in
            print("User chose not to cancel.")
        })
        
        // Add "Yes, cancel" action
        let yesCancelAction = UIAlertAction(title: "Yes, cancel", style: .destructive, handler: { _ in
            print("User chose to cancel.")
            let videoId = String(projectId)
            self.viewModel.deleteVideos(videoId: videoId) { [weak self] success in
                guard let self = self else { return }
                
                if success {
                    DispatchQueue.main.async {
                        if let index = self.viewModel.projects.firstIndex(where: { $0.id == Int(videoId) }) {
                            let indexPath = IndexPath(row: index, section: 0)
                            self.tblVw_Projects.deleteRows(at: [indexPath], with: .automatic)
                        } else {
                            self.tblVw_Projects.reloadData() // fallback
                        }
                    }
                }
            }

        })
        
        // Add actions to the alert controller
        alertController.addAction(dontCancelAction)
        alertController.addAction(yesCancelAction)
        
        // Present the alert
        viewController.present(alertController, animated: true, completion: nil)
    }


    
    private func setupUI() {
        // Set up empty state UI
        let folderIcon = UIImageView(image: UIImage(named: "folderIcon"))
        folderIcon.tintColor = UIColor.darkGray
        folderIcon.translatesAutoresizingMaskIntoConstraints = false

        let titleLabel = UILabel()
        titleLabel.text = "No projects yet"
        titleLabel.textColor = UIColor.white
        //titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        titleLabel.font = UIFont(name: "SFProDisplay-Medium", size: 24)
        let subtitleLabel = UILabel()
        subtitleLabel.text = "Hit the button below to add your first project"
        subtitleLabel.textColor = UIColor.gray
        //subtitleLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        titleLabel.font = UIFont(name: "SFProDisplay-Regular", size: 18)
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

        // Add custom tab bar
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

extension DashboardVC: UITableViewDelegate, UITableViewDataSource,ProjectCellDelegate {

    func getSortedProjects() -> [DashboardModel] {
        return viewModel.projects.sorted(by: { $0.createdAt > $1.createdAt })
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let count = self.getSortedProjects().count
            let state = viewModel.getStatus()?.state.uppercased() ?? ""
            let isUploading = (state == API.VideoStatus.queued || state == API.VideoStatus.processing)
          //  return isUploading ? count + 1 : count
        return count
        
//        let finalProjectsCount = viewModel.projectCount()
//
//        // Add 1 only if the current state is QUEUED or PROCESSING
//        let state = viewModel.getStatus()?.state.uppercased() ?? ""
//        let shouldAddUploadingRow = (state == API.VideoStatus.queued || state == API.VideoStatus.processing)
//
//      //  let total = finalProjectsCount + (shouldAddUploadingRow ? 1 : 0)
//        print("Debug: Number of rows in tableView - \(finalProjectsCount)")
//
//        return finalProjectsCount
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell  {
       
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? ProjectCell else {
                return UITableViewCell()
            }
            cell.selectionStyle = .none
        
        cell.delegate = self

            let state = viewModel.getStatus()?.state.uppercased() ?? ""
            let isShowingUploadingRow = (state == API.VideoStatus.queued || state == API.VideoStatus.processing)

            // First row is the uploading status row
            if isShowingUploadingRow && indexPath.row == 0 {
                if let status = viewModel.getStatus() {
                   // cell.configure(with: status)
                 
                    let firstProject = self.getSortedProjects()[safe: indexPath.row]
                    cell.configure(with: status, and: firstProject!)
                    
                    return cell
                }
            }

       
        
        if let project = self.getSortedProjects()[safe: indexPath.row] {
            cell.configure(with: project)
        }
//
//            if let project = viewModel.getProject(at: indexPath.row) {
//                cell.configure(with: project)
//            }

            return cell
        

    }

//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        guard let project = self.getSortedProjects()[safe: indexPath.row] else {
//            print("Project not found at index \(indexPath.row)")
//            return
//        }
//
//        guard let projectUrlString = project.url else {
//            print("URL not found in selected project")
//            return
//        }
//
//        print("✅ Selected video URL: \(projectUrlString)")
//        
//        DispatchQueue.main.async {
//            guard let detailVC = self.storyboard?.instantiateViewController(withIdentifier: "VideoPlayVC") as? VideoPlayVC else {
//                print("Failed to instantiate VideoPlayVC")
//                return
//            }
//            detailVC.videoURL = projectUrlString
//            detailVC.imageURL = project.creatorImage
//            self.navigationController?.pushViewController(detailVC, animated: true)
//        }
//    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let project = self.getSortedProjects()[safe: indexPath.row] else {
            print("Project not found at index \(indexPath.row)")
            return
        }

        let videoUrlString = project.url
        let imageUrl = project.creatorImage

        if let videoUrlString = videoUrlString {
            print("Selected video URL: \(videoUrlString)")
        } else {
            print("No video URL found. Proceeding to VideoPlayVC anyway.")
        }

        DispatchQueue.main.async {
            guard let detailVC = self.storyboard?.instantiateViewController(withIdentifier: "VideoPlayVC") as? VideoPlayVC else {
                print("Failed to instantiate VideoPlayVC")
                return
            }

            detailVC.videoURL = videoUrlString
            detailVC.imageURL = imageUrl

            self.navigationController?.pushViewController(detailVC, animated: true)
        }
    }

    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 102
    }

   
//        func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
//            
//            let deleteAction = UIContextualAction(style: .destructive, title: "Delete") {
//                [weak self, weak tableView] action, view, completionHandler in
//                
//                guard let self = self, let tableView = tableView else {
//                    completionHandler(false)
//                    return
//                }
//                
//                guard let project = self.viewModel.getProject(at: indexPath.row) else {
//                    completionHandler(false)
//                    return
//                }
//                
//                let videoId = String(project.id) // Ensure videoId is a String
//                
//                self.viewModel.deleteVideos(videoId: videoId) { success in
//                    DispatchQueue.main.async {
//                        if success {
//                            // ✅ STEP 1: Update Data Source BEFORE Table View Updates
//                            self.viewModel.removeProject(at: indexPath.row)
//
//                            // ✅ STEP 2: Perform Table View Updates
//                            tableView.performBatchUpdates({
//                                tableView.deleteRows(at: [indexPath], with: .automatic)
//                            }, completion: { _ in
//                                self.checkEmptyState()
//                            })
//                            
//                            self.showAlert(title: "", message: "Deleted video successfully.")
//                        } else {
//                            self.showAlert(title: "Error", message: "Failed to delete the video. Please try again.")
//                        }
//                        completionHandler(success)
//                    }
//                }
//            }
//            
//            return UISwipeActionsConfiguration(actions: [deleteAction])
//        }

//    func deleteVideoCode(){
//        // Ensure videoId is a String
//        
//        self.viewModel.deleteVideos(videoId: videoId) { success in
//            DispatchQueue.main.async {
//                if success {
//                    // ✅ STEP 1: Update Data Source BEFORE Table View Updates
//                    self.viewModel.removeProject(at: 0)
//                    self.tblVw_Projects.reloadData()
//                    
//                    // ✅ STEP 2: Perform Table View Updates
//                    
//                    
//                    // self.showAlert(title: "", message: "Deleted video successfully.")
//                } else {
//                    self.showAlert(title: "Error", message: "Failed to delete the video. Please try again.")
//                }
//                
//            }
//        }
//    }
}

extension Collection {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
