//
//  StatusCheckViewModel.swift
//  TalkingVideos
//
//  Created by Nisha Gupta on 25/03/25.
//

import UIKit
import Foundation

import Foundation

 class StatusCheckViewModel {
    
    private let authService: AuthService
    private var retryCount = 3  // Maximum retry attempts
    private var operationId: String?
    private var statusCheckTimer: Timer?

    var onCompletion: (() -> Void)?
    var updateState: ((String) -> Void)?
    var updateProgress: ((Int) -> Void)?

    init(authService: AuthService) {
        self.authService = authService
    }

    func upload(operationId: String) {
        guard !operationId.isEmpty else {
            updateState?("Invalid Operation ID")
            return
        }
        
        self.operationId = operationId
        updateState?("Uploading...")
        fetchStatus()
    }

    private func fetchStatus() {
        guard let operationId = operationId else {
            updateState?("Operation ID is missing")
            return
        }

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
//                case .failure(let error):
//                    print("Error: \(error.localizedDescription) | Retries left: \(self?.retryCount ?? 0)")
//                    self?.handleError(error)
//                }
//            }
//        }
//    }
//
//    private func handleStatusUpdate(_ statusModel: StatusCheckModel) {
//        let progress = statusModel.progress ?? 0
//        let state = statusModel.state.lowercased()
//
//        DispatchQueue.main.async {
//            self.updateProgress?(progress)
//            self.updateState?("\(progress)% complete")
//        }
//
//        if progress < 100, state != "complete" {
//            scheduleNextPoll(delay: 3)  // Poll every 3 seconds
//        } else {
//            DispatchQueue.main.async {
//                self.onCompletion?()
//            }
//        }
//    }
//
//    private func handleError(_ error: NetworkError) {
//        if retryCount > 0, shouldRetry(error: error) {
//            retryCount -= 1
//            scheduleNextPoll(delay: 3)  // Retry after 3 seconds
//        } else {
//            updateState?("Error: \(error.localizedDescription)")
//        }
//    }
//
//     private func shouldRetry(error: Error) -> Bool {
//         // Try to cast the error to a NetworkError and check for a specific error case
//         if let networkError = error as? NetworkError {
//             // Here, you can decide which errors should trigger a retry.
//             if case .requestFailed(let statusCode) = networkError {
//                 return true  // Retry on server error (status 500)
//             }
//         }
//         
//         return false
//     }
//
//
//    private func scheduleNextPoll(delay: TimeInterval) {
//        // Cancel any previous timer before scheduling a new one.
//        statusCheckTimer?.invalidate()
//
//        statusCheckTimer = Timer.scheduledTimer(withTimeInterval: delay, repeats: false) { [weak self] _ in
//            self?.fetchStatus()  // Re-poll the status
//        }
    }
}

