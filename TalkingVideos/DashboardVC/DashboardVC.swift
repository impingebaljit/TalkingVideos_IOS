//
//  DashboardVC.swift
//  TalkingVideos
//
//  Created by Nisha Gupta on 12/03/25.
//

import UIKit

//class DashboardVC: UIViewController {
//
//    private let tableView = UITableView()
//
//    // Sample Data Model
//    private var projects: [Project] = [
//        Project(title: "Ever wonder why your name ", date: "Mar 17, 2025", size: "299 MB", isAICreated: true, imageName: "ai_project"),
//        Project(title: "you you", date: "Mar 10, 2025", size: "32 MB", isAICreated: false, imageName: "project_thumb")
//    ]
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        self.navigationItem.hidesBackButton = true
//
//        view.backgroundColor = UIColor(red: 16/255, green: 9/255, blue: 25/255, alpha: 1.0)
//
//        setupTableView()
//        setupTabBar()
//    }
//
//    private func setupTableView() {
//        tableView.delegate = self
//        tableView.dataSource = self
//        tableView.separatorStyle = .none
//        tableView.backgroundColor = .clear
//        tableView.register(ProjectCell.self, forCellReuseIdentifier: "ProjectCell")
//
//        view.addSubview(tableView)
//        tableView.translatesAutoresizingMaskIntoConstraints = false
//
//        NSLayoutConstraint.activate([
//            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
//            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -90)
//        ])
//    }
//
//    private func setupTabBar() {
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
//}
//
//extension DashboardVC: UITableViewDelegate, UITableViewDataSource {
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 2
//    }
//
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return section == 0 ? "TODAY" : "MARCH 10"
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return section == 0 ? 1 : 1
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ProjectCell", for: indexPath) as? ProjectCell else {
//            return UITableViewCell()
//        }
//
//        let project = projects[indexPath.section]
//        cell.configure(with: project)
//
//        return cell
//    }
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print("Selected project: \(projects[indexPath.section].title)")
//    }
//}
//
//// MARK: - Project Model
//struct Project {
//    let title: String
//    let date: String
//    let size: String
//    let isAICreated: Bool
//    let imageName: String
//}
//
//// MARK: - ProjectCell
//class ProjectCell: UITableViewCell {
//
//    private let thumbnailImageView = UIImageView()
//    private let titleLabel = UILabel()
//    private let dateLabel = UILabel()
//    private let sizeLabel = UILabel()
//    private let aiBadge = UILabel()
//
//    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        setupUI()
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    private func setupUI() {
//        backgroundColor = .clear
//
//        thumbnailImageView.layer.cornerRadius = 8
//        thumbnailImageView.clipsToBounds = true
//        thumbnailImageView.translatesAutoresizingMaskIntoConstraints = false
//
//        titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
//        titleLabel.textColor = .white
//
//        dateLabel.font = UIFont.systemFont(ofSize: 12)
//        dateLabel.textColor = .lightGray
//
//        sizeLabel.font = UIFont.systemFont(ofSize: 12)
//        sizeLabel.textColor = .lightGray
//
//        aiBadge.font = UIFont.systemFont(ofSize: 10)
//        aiBadge.textColor = .white
//        aiBadge.backgroundColor = UIColor.darkGray
//        aiBadge.layer.cornerRadius = 5
//        aiBadge.layer.masksToBounds = true
//        aiBadge.text = "AI CREATOR"
//        aiBadge.textAlignment = .center
//        aiBadge.translatesAutoresizingMaskIntoConstraints = false
//
//        let textStack = UIStackView(arrangedSubviews: [titleLabel, dateLabel, sizeLabel])
//        textStack.axis = .vertical
//        textStack.spacing = 4
//
//        let containerStack = UIStackView(arrangedSubviews: [thumbnailImageView, textStack])
//        containerStack.axis = .horizontal
//        containerStack.spacing = 12
//        containerStack.translatesAutoresizingMaskIntoConstraints = false
//
//        contentView.addSubview(containerStack)
//        contentView.addSubview(aiBadge)
//
//        NSLayoutConstraint.activate([
//            thumbnailImageView.widthAnchor.constraint(equalToConstant: 60),
//            thumbnailImageView.heightAnchor.constraint(equalToConstant: 60),
//
//            containerStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
//            containerStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
//            containerStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
//            containerStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
//
//            aiBadge.topAnchor.constraint(equalTo: thumbnailImageView.topAnchor, constant: 4),
//            aiBadge.leadingAnchor.constraint(equalTo: thumbnailImageView.leadingAnchor, constant: 4),
//            aiBadge.heightAnchor.constraint(equalToConstant: 16)
//        ])
//    }
//
//    func configure(with project: Project) {
//        thumbnailImageView.image = UIImage(named: project.imageName)
//        titleLabel.text = project.title
//        dateLabel.text = "Last update \(project.date)"
//        sizeLabel.text = "Video size \(project.size)"
//        aiBadge.isHidden = !project.isAICreated
//    }
//}


struct Project {
    let image: UIImage?
    let title: String
    let lastUpdated: String
}

class DashboardVC: UIViewController {

    @IBOutlet weak var tblVw_Projects: UITableView!

    private let emptyStateView = UIStackView()
   private var projects: [Project] = []
//    private var projects: [Project] = [
//        Project(image: UIImage(named: "profileImage"), title: "Hey there. Ever had one of those days?", lastUpdated: "Mar 18, 2025"),
//        Project(image: UIImage(named: "profileImage"), title: "New Project", lastUpdated: "Mar 19, 2025")
//    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        setupUI()
        setupTableView()
        checkEmptyState()
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
        tblVw_Projects.tableFooterView = UIView() // Removes extra separators
    }

    private func checkEmptyState() {
        emptyStateView.isHidden = !projects.isEmpty
        tblVw_Projects.isHidden = projects.isEmpty
    }
}

class ProjectCell: UITableViewCell {
  
    
  
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var projectImageView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
 
        
    }

//
//    func configure(with project: Project) {
//        projectImageView.image = project.image
//        titleLabel.text = project.title
//        dateLabel.text = "Last update on \(project.lastUpdated)"
//    }
}

extension DashboardVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return projects.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? ProjectCell else {
            return UITableViewCell()
        }
       // cell.configure(with: projects[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Selected project: \(projects[indexPath.row].title)")
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       
            return 102
        
    }
}
