//
//  DashboardViewModel.swift
//  TalkingVideos
//
//  Created by Nisha Gupta on 26/03/25.
//

import UIKit



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
    

    
    func getProject(at index: Int) -> DashboardModel? {
        guard index >= 0, index < projects.count else {
            print("Attempted to access index \(index) but projects only has \(projects.count) items.")
            return nil
        }
        return projects[index]
    }
    
   

//    func fetchProjects() {
//        // Initially fetch all projects (completed and uploading)
//        authService.fetchFinalVideos { [weak self] result in
//            switch result {
//            case .success(let videos):
//                // Assuming that videos fetched initially will not have the `uploadInProgress` param
//                // So we will store them as complete, then we append uploading projects at the top
//                self?.projects = videos
//                self?.projects.insert(contentsOf: self?.uploadingProjects ?? [], at: 0) // Keep uploading videos at the top
//                self?.onProjectsUpdated?()  // Trigger the callback to update the UI
//            case .failure(let error):
//                print("Error fetching videos: \(error)")
//            }
//        }
//    }
    
    
//    func fetchProjects() {
//        authService.fetchFinalVideos { [weak self] result in
//            switch result {
//            case .success(let videos):
//                self?.projects = videos
//                if let uploading = self?.uploadingProjects {
//                    self?.projects.insert(contentsOf: uploading, at: 0)
//                }
//                self?.onProjectsUpdated?()
//            case .failure(let error):
//                print("Error fetching videos: \(error)")
//            }
//        }
//    }
    
    
    func fetchProjects() {
        authService.fetchFinalVideos { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let videos):
                self.projects.removeAll()
                self.projects = videos

                // Insert uploading projects at the top if they're not marked complete
                let notCompletedUploads = self.uploadingProjects.filter {
                    $0.uploadInProgress! && (self.getStatusI?.state.uppercased() != API.VideoStatus.complete)
                }

                //self.projects.insert(contentsOf: notCompletedUploads, at: 0)

                print("Uploading projects inserted: \(notCompletedUploads.count)")

                self.onProjectsUpdated?()

            case .failure(let error):
                print("Error fetching videos: \(error)")
            }
        }
    }
    
    
    func upload(operationId: String, from submitVideoScreen: Bool) {
        let newProject = DashboardModel(
            id: -1,
            userID: 0,
            script: "Video...",
            creatorName: "Unknown",
            operationID: operationId,
            state: "",
            url: "",
            status: nil,
            createdAt: Date().description,
            updatedAt: Date().description,
            creatorImage: "Img",
            creatorVideo: nil,
            uploadInProgress: true
        )
        
        // Add to uploading projects list immediately
         //uploadingProjects.append(newProject)
         
         self.onProjectsUpdated?() // Reflect this immediately in UI

        
        authService.uploadData(operationId: operationId, progressHandler: { [weak self] progress in
//            DispatchQueue.main.async {
//                self?.updateProgress?(progress)
//                self?.updateState?("\(progress)% complete")
//            }
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
    
//    private func handleUploadCompletion(_ statusModel: StatusCheckModel, operationId: String) {
//        print("Debug: Received StatusCheckModel - State: \(statusModel.state), Progress: \(statusModel.progress ?? -1), URL: \(statusModel.url?.absoluteString ?? "nil")")
//
//           self.getStatusI = statusModel  // ✅ Assign the status model here
//           
//        
//        if statusModel.state ==  API.VideoStatus.queued || statusModel.state == API.VideoStatus.processing {
//            self.uploadingProjects.removeAll {$0.operationID == operationId} //{ $0.id == -1 }
//          self.fetchProjects()
//     //   } else {
//            checkUploadProgressPeriodically(operationId: operationId)
//        }
//        
//       
//    }
    private func handleUploadCompletion(_ statusModel: StatusCheckModel, operationId: String) {
        print("Debug: Received StatusCheckModel - State: \(statusModel.state), Progress: \(statusModel.progress ?? -1), URL: \(statusModel.url?.absoluteString ?? "nil")")

        self.getStatusI = statusModel  // ✅ Keep latest status
        
        let state = statusModel.state.uppercased()
        
        if state == API.VideoStatus.complete {
            // Only when it's complete, remove from uploadingProjects and fetch final list
            self.uploadingProjects.removeAll { $0.operationID == operationId }
            self.fetchProjects()
            self.onProjectsUpdated?()
        } else if state == API.VideoStatus.queued || state == API.VideoStatus.processing {
            // Keep polling until complete, don't remove yet
            checkUploadProgressPeriodically(operationId: operationId)
            self.onProjectsUpdated?()
        }
    }
    private func checkUploadProgressPeriodically(operationId: String) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) { [weak self] in
            self?.authService.uploadData(operationId: operationId, progressHandler: { progress in
//                DispatchQueue.main.async {
//                    self?.updateProgress?(progress)
//                    self?.updateState?("\(progress)% complete")
//                }
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
    
    func getStatus() -> StatusCheckModel? {
        guard let status = getStatusI else {
            print("Debug: getStatusI is nil")
            return nil
        }
        
        
        print("Debug: Retrieved status - State: \(status.state), Progress: \(status.progress ?? -1), URL: \(status.url?.absoluteString ?? "nil")")
        
        return StatusCheckModel(state: status.state, progress: status.progress, url: status.url)
    }

}
