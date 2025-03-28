//
//  StatusCheckViewModel.swift
//  TalkingVideos
//
//  Created by Nisha Gupta on 25/03/25.
//

import UIKit

class StatusCheckViewModel {

    private let authService: AuthService
    
    var onCompletion: (() -> Void)?

    init(authService: AuthService) {
        self.authService = authService
    }

    func checkStatus(operationID: String, progressHandler: @escaping (String) -> Void, completion: @escaping (Bool, StatusCheckModel?) -> Void) {
            authService.pollCaptionStatus(operationId: operationID, progressHandler: { status in
                print("Progress: \(status)")
                progressHandler(status)
            }, completion: { [weak self] success, statusModel in
                guard let self = self else { return }

                if success, let statusModel = statusModel {
                    print("StatusCheckModel received: \(statusModel)")
                    completion(true, statusModel)
                } else {
                    print("Status check failed")
                    completion(false, nil)
                }
            })
        }
    
    var updateProgress: ((String) -> Void)?
       var updateState: ((String) -> Void)?
     

       func upload(operationId: String) {
           updateState?("Uploading...")


           authService.uploadData(operationId: operationId, progressHandler: { [weak self] progress in
                      self?.updateProgress?(progress)
                  }) { [weak self] result in
                      switch result {
                      case .success(let statusModel):
                          self?.handleStatusUpdate(statusModel, operationID: operationId)
                      case .failure(let error):
                          self?.updateState?("Error: \(error.localizedDescription)")
                      }
                  }
              }
    
    
    private func pollUploadStatus(operationID: String) {
            guard !operationID.isEmpty else { return }

            DispatchQueue.global().asyncAfter(deadline: .now() + 3) { [weak self] in
                self?.authService.uploadData(operationId: operationID, progressHandler: { [weak self] progress in
                    self?.updateProgress?(progress)
                }) { [weak self] result in
                    switch result {
                    case .success(let statusModel):
                        self?.handleStatusUpdate(statusModel, operationID: operationID)
                    case .failure(let error):
                        self?.updateState?("Error: \(error.localizedDescription)")
                    }
                }
            }
        }

//    private func handleStatusUpdate(_ statusModel: StatusCheckModel, operationID: String) {
//        let stateMessage = "\(statusModel.progress ?? 100)% complete"
//        updateState?(stateMessage)
//
//        if statusModel.progress! < 100 && statusModel.state != "COMPLETED" {
//            pollUploadStatus(operationID: operationID)
//        }
//    }
    
//    private func handleStatusUpdate(_ statusModel: StatusCheckModel, operationID: String) {
//        let progress = statusModel.progress ?? 100
//        let stateMessage = "\(progress)% complete"
//        updateState?(stateMessage)
//
//        if progress < 100 && statusModel.state != "COMPLETED" {
//            pollUploadStatus(operationID: operationID)
//        }
//    }
    
//    private func handleStatusUpdate(_ statusModel: StatusCheckModel, operationID: String) {
//        let progress = statusModel.progress ?? 100
//        let stateMessage = "\(progress)% complete"
//        updateState?(stateMessage)
//
//        if progress < 100 && statusModel.state != "COMPLETED" {
//            pollUploadStatus(operationID: operationID)
//        } else if progress == 100 && statusModel.state == "COMPLETED" {
//            // Navigate to DashboardVC when completed
//            DispatchQueue.main.async {
//                self.onCompletion?()
//            }
//        }
//    }
    
    
    private func handleStatusUpdate(_ statusModel: StatusCheckModel, operationID: String) {
        let progress = statusModel.progress ?? 100
        let stateMessage = "\(progress)% complete"
        updateState?(stateMessage)

        if progress < 100, statusModel.state != "COMPLETE" {
            DispatchQueue.global().asyncAfter(deadline: .now() + 5) {
                self.pollUploadStatus(operationID: operationID)
            }
        } else if progress == 100, statusModel.state == "COMPLETE" {
            DispatchQueue.main.async {
              //  print("Processing completed. Video URL: \(statusModel.url ?? "No URL")")
                self.onCompletion?() // Pass the video URL if needed
            }
        }
    }
    
}
