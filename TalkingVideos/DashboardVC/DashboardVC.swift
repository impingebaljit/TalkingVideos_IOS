//
//  DashboardVC.swift
//  TalkingVideos
//
//  Created by Nisha Gupta on 12/03/25.
//

import UIKit


class DashboardVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        setupUI()
    }

    private func setupUI() {
        view.backgroundColor = UIColor(red: 16/255, green: 9/255, blue: 25/255, alpha: 1.0)

        // Empty State Icon
        let folderIcon = UIImageView(image: UIImage(named: "folderIcon"))
        folderIcon.tintColor = UIColor.darkGray
        folderIcon.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(folderIcon)

        // Empty State Label
        let titleLabel = UILabel()
        titleLabel.text = "No projects yet"
        titleLabel.textColor = UIColor.white
        titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)

        let subtitleLabel = UILabel()
        subtitleLabel.text = "Hit the button below to add your first project"
        subtitleLabel.textColor = UIColor.gray
        subtitleLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(subtitleLabel)

        // Center Content Stack
        let stackView = UIStackView(arrangedSubviews: [folderIcon, titleLabel, subtitleLabel])
        stackView.axis = .vertical
        stackView.spacing = 12
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
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
}
