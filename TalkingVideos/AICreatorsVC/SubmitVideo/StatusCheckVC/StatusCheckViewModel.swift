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
    var updateProgress: ((String) -> Void)?
    var updateState: ((String) -> Void)?
    
    init(authService: AuthService) {
        self.authService = authService
    }

//    func upload(operationId: String) {
//        guard !operationId.isEmpty else {
//            updateState?("Invalid Operation ID")
//            return
//        }
//        
//        updateState?("Uploading...")
//        authService.uploadData(operationId: operationId, progressHandler: { [weak self] progress in
//            self?.updateProgress?(progress)
//        }) { [weak self] result in
//            switch result {
//            case .success(let statusModel):
//                self?.handleStatusUpdate(statusModel, operationID: operationId)
//            case .failure(let error):
//                self?.updateState?("Error: \(error.localizedDescription)")
//            }
//        }
//    }

//    private func pollUploadStatus(operationID: String) {
//        DispatchQueue.global().asyncAfter(deadline: .now() + 3) { [weak self] in
//            self?.authService.uploadData(operationId: operationID, progressHandler: { [weak self] progress in
//                self?.updateProgress?(progress)
//            }) { [weak self] result in
//                switch result {
//                case .success(let statusModel):
//                    self?.handleStatusUpdate(statusModel, operationID: operationID)
//                case .failure(let error):
//                    self?.updateState?("Error: \(error.localizedDescription)")
//                }
//            }
//        }
//    }

//    private func handleStatusUpdate(_ statusModel: StatusCheckModel, operationID: String) {
//        let progress = statusModel.progress ?? 100
//        updateState?("\(progress)% complete")
//        
//        if progress < 100, statusModel.state != "COMPLETE" {
//            pollUploadStatus(operationID: operationID)
//        } else {
//            DispatchQueue.main.async {
//                self.onCompletion?()
//            }
//        }
//    }
}
