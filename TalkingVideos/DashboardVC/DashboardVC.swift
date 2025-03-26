//
//  DashboardVC.swift
//  TalkingVideos
//
//  Created by Nisha Gupta on 12/03/25.
//

import UIKit

class DashboardVC: UIViewController {

    @IBOutlet weak var tblVw_Projects: UITableView!

    private let emptyStateView = UIStackView()

    private let viewModel = DashboardViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.hidesBackButton = true

        setupUI()
        setupTableView()
        setupViewModel()

      //  viewModel.fetchProjects()
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

    func configure(with project: DashboardModel) {
            titleLabel?.text = project.script
            dateLabel?.text = "Last update on \(project.createdAt)"

            if let imageURL = URL(string: project.url) {
                DispatchQueue.global().async {
                    if let imageData = try? Data(contentsOf: imageURL) {
                        let image = UIImage(data: imageData)
                        DispatchQueue.main.async {
                            self.projectImageView?.image = image
                        }
                    }
                }
            } else {
                projectImageView?.image = UIImage(named: "projectPlaceholder")
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
        print("Selected project: \(project.operationID)")
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 102
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
