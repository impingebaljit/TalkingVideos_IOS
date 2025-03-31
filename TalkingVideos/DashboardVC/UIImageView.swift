//
//  Untitled.swift
//  TalkingVideos
//
//  Created by Nisha Gupta on 31/03/25.
//

import AVFoundation
import UIKit

extension UIImageView {
    func loadThumbnail(from videoURL: URL, placeholder: String = "projectPlaceholder") {
        DispatchQueue.main.async {
            self.image = UIImage(named: placeholder) // Show placeholder while loading
        }

        DispatchQueue.global().async {
            let asset = AVAsset(url: videoURL)
            let assetKeys = ["playable", "tracks", "duration"]

            asset.loadValuesAsynchronously(forKeys: assetKeys) {
                var error: NSError?

                for key in assetKeys {
                    let status = asset.statusOfValue(forKey: key, error: &error)
                    if status == .failed {
                        print("❌ Error: Failed to load \(key) - \(error?.localizedDescription ?? "Unknown error")")
                        return
                    }
                }

                // Ensure the asset is playable and has video tracks
                guard asset.isPlayable, asset.tracks(withMediaType: .video).count > 0 else {
                    print("❌ Error: No valid video track found or asset is not playable.")
                    return
                }

                let assetImgGenerate = AVAssetImageGenerator(asset: asset)
                assetImgGenerate.appliesPreferredTrackTransform = true
                assetImgGenerate.requestedTimeToleranceAfter = .zero
                assetImgGenerate.requestedTimeToleranceBefore = .zero

                // Get video duration and pick a safe timestamp
                let duration = CMTimeGetSeconds(asset.duration)
                let thumbnailTime = CMTime(seconds: min(1.0, duration / 2), preferredTimescale: 600)

                do {
                    let img = try assetImgGenerate.copyCGImage(at: thumbnailTime, actualTime: nil)
                    let thumbnail = UIImage(cgImage: img)
                    
                    DispatchQueue.main.async {
                        self.image = thumbnail // Set extracted thumbnail
                    }
                } catch {
                    print("❌ Error generating thumbnail: \(error.localizedDescription)")
                    DispatchQueue.main.async {
                        self.image = UIImage(named: placeholder) // Show placeholder on failure
                    }
                }
            }
        }
    }
}
