//
//  DashboardViewModel.swift
//  TalkingVideos
//
//  Created by Nisha Gupta on 26/03/25.
//

import UIKit


//class DashboardViewModel {
//    
//    private var projects: [DashboardModel] = []
//    private var retryCount = 3  // Assuming retry count for upload
//    
//    var onProjectsUpdated: (() -> Void)?
//    var updateProgress: ((Int) -> Void)?
//    var updateState: ((String) -> Void)?
//    
//    private var progressCheckWorkItem: DispatchWorkItem?
//    
//    private let authService = AuthService()
//    
//    // Fetch the projects
//    func fetchProjects() {
//        authService.fetchFinalVideos { [weak self] result in
//            switch result {
//            case .success(let videos):
//                self?.projects = videos
//                self?.onProjectsUpdated?()
//            case .failure(let error):
//                print("Error fetching videos: \(error)")
//            }
//        }
//    }
//    
//    // Delete video
//    func deleteVideos(videoId: String, completion: @escaping (Bool) -> Void) {
//        guard let videoIdInt = Int(videoId) else {
//            print("Invalid videoId: \(videoId)")
//            completion(false)
//            return
//        }
//        
//        authService.deleteVideos(videoId: videoId) { [weak self] result in
//            DispatchQueue.main.async {
//                switch result {
//                case .success:
//                    if let index = self?.projects.firstIndex(where: { $0.id == videoIdInt }) {
//                        self?.projects.remove(at: index)
//                        self?.onProjectsUpdated?()
//                        completion(true)
//                    } else {
//                        completion(false)  // Index not found
//                    }
//                case .failure(let error):
//                    print("Error deleting video: \(error)")
//                    completion(false)
//                }
//            }
//        }
//    }
//    
//    // Get a project at a specific index
//    func getProject(at index: Int) -> DashboardModel {
//        return projects[index]
//    }
//    
//    // Get total count of projects
//    func projectCount() -> Int {
//        return projects.count
//    }
//    
//    // Remove project at a given index
    
//    
//    // Upload data with progress tracking
//    func upload(operationId: String) {
//        // Start the initial upload
//        authService.uploadData(operationId: operationId, progressHandler: { [weak self] progress in
//            DispatchQueue.main.async {
//                self?.updateProgress?(progress)
//                self?.updateState?("\(progress)% complete")
//            }
//        }) { [weak self] result in
//            DispatchQueue.main.async {
//                switch result {
//                case .success(let statusModel):
//                    self?.handleStatusUpdate(statusModel)
//                    // Start checking the progress periodically (every 3 seconds)
//                    self?.checkUploadProgressPeriodically(operationId: operationId)
//                case .failure(let error):
//                    print("Error: \(error.localizedDescription)")
//                    self?.handleError(error)
//                }
//            }
//        }
//    }
//    func handleStatusUpdate(_ statusModel: StatusCheckModel) {
//        // Implement status handling logic (e.g., update UI based on the upload status)
//        print("Upload status: \(statusModel.state), Progress: \(statusModel.progress)%")
//    }
//    
//    // Handle errors
//    func handleError(_ error: Error) {
//        // Implement error handling (e.g., showing an alert to the user)
//        print("Error: \(error.localizedDescription)")
//    }
//    // Periodically check the upload progress every 3 seconds
//    
//    
//    private func checkUploadProgressPeriodically(operationId: String) {
//        progressCheckWorkItem?.cancel()
//        
//        let workItem = DispatchWorkItem { [weak self] in
//            self?.authService.uploadData(
//                operationId: operationId,
//                progressHandler: { progress in
//                    DispatchQueue.main.async {
//                        self?.updateProgress?(progress)
//                        self?.updateState?("\(progress)% complete")
//                    }
//                },
//                completion: { result in
//                    DispatchQueue.main.async {
//                       
//                            switch result {
//                            case .success(let statusModel):
//                                self?.handleStatusUpdate(statusModel)
//                                
//                                // Check if progress is nil but state is "COMPLETE", or progress is below 100
//                                if let progress = statusModel.progress {
//                                    if progress < 100 {
//                                        self?.checkUploadProgressPeriodically(operationId: operationId)
//                                    }
//                                } else if statusModel.state != "COMPLETE" {
//                                    // If progress is nil but state is NOT "COMPLETE", keep checking
//                                    self?.checkUploadProgressPeriodically(operationId: operationId)
//                                }
//                                
//                            case .failure(let error):
//                                self?.handleError(error)
//                            }
//                        
//                    }
//                }
//            )
//        }
//        
//        progressCheckWorkItem = workItem
//        DispatchQueue.main.asyncAfter(deadline: .now() + 5, execute: workItem)
//    }
//
//    
//}
import UIKit

class DashboardViewModel {
    
    private var projects: [DashboardModel] = []
    private var uploadingProjects: [DashboardModel] = [] // Store in-progress uploads
    private var retryCount = 3
    
    private var getStatusI: StatusCheckModel?
    
    var onProjectsUpdated: (() -> Void)?
    var updateProgress: ((Int) -> Void)?
    var updateState: ((String) -> Void)?
    
    private let authService = AuthService()
    
    func projectCount() -> Int {
        return projects.count
    }
    
//    func getProject(at index: Int) -> DashboardModel? {
//           guard index >= 0 && index < projects.count else {
//               return nil
//           }
//           return projects[index]
//       }
    
    func getProject(at index: Int) -> DashboardModel? {
        guard index >= 0, index < projects.count else {
            print("Attempted to access index \(index) but projects only has \(projects.count) items.")
            return nil
        }
        return projects[index]
    }
    
//    func fetchProjects() {
//        authService.fetchFinalVideos { [weak self] result in
//            switch result {
//            case .success(let videos):
//                self?.projects = videos.filter { $0.uploadInProgress == false } // Only complete videos
//                self?.projects.insert(contentsOf: self?.uploadingProjects ?? [], at: 0) // Keep uploading videos
//                self?.onProjectsUpdated?()
//            case .failure(let error):
//                print("Error fetching videos: \(error)")
//            }
//        }
//    }
    
//    
//    func fetchProjects() {
//        authService.fetchFinalVideos { [weak self] result in
//            switch result {
//            case .success(let videos):
//                self?.projects = videos.filter { $0.uploadInProgress == false } // Only complete videos
//                self?.projects.insert(contentsOf: self?.uploadingProjects ?? [], at: 0) // Keep uploading videos
//                self?.onProjectsUpdated?()  // Trigger the callback to update the UI
//            case .failure(let error):
//                print("Error fetching videos: \(error)")
//            }
//        }
//    }
    
    func fetchProjects() {
        // Initially fetch all projects (completed and uploading)
        authService.fetchFinalVideos { [weak self] result in
            switch result {
            case .success(let videos):
                // Assuming that videos fetched initially will not have the `uploadInProgress` param
                // So we will store them as complete, then we append uploading projects at the top
                self?.projects = videos
                self?.projects.insert(contentsOf: self?.uploadingProjects ?? [], at: 0) // Keep uploading videos at the top
                self?.onProjectsUpdated?()  // Trigger the callback to update the UI
            case .failure(let error):
                print("Error fetching videos: \(error)")
            }
        }
    }
    
    func upload(operationId: String, from submitVideoScreen: Bool) {
        let newProject = DashboardModel(
            id: -1,
            userID: 0,
            script: "Uploading...",
            creatorName: "Unknown",
            operationID: "operationID",
            state: "",
            url: "",
            status: nil,
            createdAt: Date().description,
            updatedAt: Date().description,
            creatorImage: "Img",
            creatorVideo: nil,
            uploadInProgress: true
        )
        
        if submitVideoScreen {
            uploadingProjects.append(newProject)
            projects.insert(newProject, at: 0)
            onProjectsUpdated?()
        }
        
        authService.uploadData(operationId: operationId, progressHandler: { [weak self] progress in
            DispatchQueue.main.async {
                self?.updateProgress?(progress)
                self?.updateState?("\(progress)% complete")
            }
        }) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let statusModel):
                    self?.handleUploadCompletion(statusModel, operationId: operationId)
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                    self?.handleError(error)
                }
            }
        }
    }
    
    private func handleUploadCompletion(_ statusModel: StatusCheckModel, operationId: String) {
        if statusModel.state == "COMPLETE" {
            self.uploadingProjects.removeAll { $0.id == -1 }
            self.fetchProjects()
        } else {
            checkUploadProgressPeriodically(operationId: operationId)
        }
    }
    
    private func checkUploadProgressPeriodically(operationId: String) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) { [weak self] in
            self?.authService.uploadData(operationId: operationId, progressHandler: { progress in
                DispatchQueue.main.async {
                    self?.updateProgress?(progress)
                    self?.updateState?("\(progress)% complete")
                }
            }, completion: { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let statusModel):
                        self?.handleUploadCompletion(statusModel, operationId: operationId)
                    case .failure(let error):
                        self?.handleError(error)
                    }
                }
            })
        }
    }
    
    private func handleError(_ error: Error) {
        print("Error: \(error.localizedDescription)")
    }
    
  
//    func getStatus() -> StatusCheckModel? {
//        return  ""
//    }
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
    
    
    
    func removeProject(at index: Int) {
        guard index >= 0, index < projects.count else { return }
        projects.remove(at: index)
    }
}
