//
//  DashboardViewModel.swift
//  TalkingVideos
//
//  Created by Nisha Gupta on 26/03/25.
//

import UIKit

class DashboardViewModel{
    
 private var projects: [DashboardModel] = []

var onProjectsUpdated: (() -> Void)?

let authService = AuthService()

func fetchProjects() {
    authService.fetchFinalVideos { [weak self] result in
        switch result {
        case .success(let videos):
            self?.projects = videos
            self?.onProjectsUpdated?()
        case .failure(let error):
            print("Error fetching videos: \(error)")
        }
    }
}

func getProject(at index: Int) -> DashboardModel {
    return projects[index]
}

func projectCount() -> Int {
    return projects.count
}
}
