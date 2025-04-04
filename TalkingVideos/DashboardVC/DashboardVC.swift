import UIKit
import AVFoundation
import AVKit
import SDWebImage

class DashboardVC: UIViewController {

    @IBOutlet weak var tblVw_Projects: UITableView!
    
    var operationIdSend = String()
    var comesFromSubmitVideo = Bool()

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
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.fetchProjects()
       
    //   comesFromSubmitVideo = true
        if(comesFromSubmitVideo == true) {
            viewModel.upload(operationId: operationIdSend, from: true)
        }
        tblVw_Projects.reloadData()
    }
    
    private func setupBindings() {
        viewModel.onProjectsUpdated = { [weak self] in
            DispatchQueue.main.async {
                self?.tblVw_Projects.reloadData()
            }
        }
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

extension DashboardVC: UITableViewDelegate, UITableViewDataSource {

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = viewModel.projectCount()

        // Get the state safely, defaulting to empty string if nil
        let state = viewModel.getStatus()?.state.uppercased() ?? ""

        // Only add 1 if comesFromSubmitVideo is true AND state is QUEUED or PROCESSING
        if comesFromSubmitVideo && (state == API.VideoStatus.queued || state == API.VideoStatus.processing) {
            count += 1
        }

        print("Debug: Number of rows in tableView - \(count)")
        return count
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell  {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? ProjectCell else {
            return UITableViewCell()
        }
        cell.selectionStyle = .none

        // Get status state safely
        let state = viewModel.getStatus()?.state.uppercased() ?? ""

        // First row: StatusCheckModel data if `comesFromSubmitVideo` is true AND state is QUEUED or PROCESSING
        if comesFromSubmitVideo && indexPath.row == 0 && (state == API.VideoStatus.queued || state == API.VideoStatus.processing) {
            if let status = viewModel.getStatus() {
                cell.configure(with: status)
                return cell
            }
        }

        // Remaining rows: Project data from DashboardModel
        let adjustedIndex = (comesFromSubmitVideo && (state == API.VideoStatus.queued || state == API.VideoStatus.processing)) ? indexPath.row - 1 : indexPath.row

        if let project = viewModel.getProject(at: adjustedIndex) {
            cell.configure(with: project)
        }

        return cell
    }

//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let project = viewModel.getProject(at: indexPath.row)
//        guard let videoURL = URL(string: project?.url ?? "fdf") else {
//            print("Invalid video URL")
//            return
//        }
//
//        DispatchQueue.main.async {
//            guard let detailVC = self.storyboard?.instantiateViewController(withIdentifier: "VideoPlayVC") as? VideoPlayVC else {
//                print("Failed to instantiate VideoPlayVC")
//                return
//            }
//            detailVC.videoURL = videoURL
//            self.navigationController?.pushViewController(detailVC, animated: true)
//        }
//    }

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

    
}

