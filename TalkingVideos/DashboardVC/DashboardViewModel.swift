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

    func deleteVideos(videoId: String, completion: @escaping (Bool) -> Void) {
        guard let videoIdInt = Int(videoId) else {
            print("Invalid videoId: \(videoId)")
            completion(false)
            return
        }

        authService.deleteVideos(videoId: videoId) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    if let index = self?.projects.firstIndex(where: { $0.id == videoIdInt }) {
                        self?.projects.remove(at: index)  // Remove from the data source
                        self?.onProjectsUpdated?()
                        completion(true)
                    } else {
                        completion(false) // Index not found
                    }
                case .failure(let error):
                    print("Error deleting video: \(error)")
                    completion(false)
                }
            }
        }
    }
    
    
func getProject(at index: Int) -> DashboardModel {
    return projects[index]
}

func projectCount() -> Int {
    return projects.count
}
    func removeProject(at index: Int) {
            projects.remove(at: index)
            onProjectsUpdated?()
        }
}
