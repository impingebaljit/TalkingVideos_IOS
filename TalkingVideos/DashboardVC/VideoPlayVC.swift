//
//  VideoPlayVC.swift
//  TalkingVideos
//
//  Created by Nisha Gupta on 31/03/25.
//





import UIKit
import AVFoundation
import AVKit
import Speech



class VideoPlayVC: UIViewController {

    @IBOutlet weak var imgVw: UIImageView!
    @IBOutlet weak var subtitleLabel: UILabel!

    var videoURL: URL?
    private var player: AVPlayer?
    private var playerLayer: AVPlayerLayer?
    private var isPlaying = false  // Flag to track playback state

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        setupAudioSession()  // Configure audio session
        setupPlayer()
        setupTapGesture()  // Add tap gesture to control playback
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        startPlayback()
    }

    private func setupAudioSession() {
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.playback, mode: .default, options: [.allowAirPlay])
            try audioSession.setActive(true)
        } catch {
            print("Failed to set up audio session: \(error)")
        }
    }

    private func setupPlayer() {
        guard let url = videoURL else {
            print("Invalid video URL")
            return
        }

        let playerItem = AVPlayerItem(url: url)
        playerItem.preferredForwardBufferDuration = 0  // Reduce buffering delay
        playerItem.preferredPeakBitRate = 5000000  // Adjust for faster streaming

        player = AVPlayer(playerItem: playerItem)
        player?.automaticallyWaitsToMinimizeStalling = false  // Force instant play

        // Ensure volume is not muted
        player?.volume = 1.0

        playerLayer = AVPlayerLayer(player: player)
        playerLayer?.videoGravity = .resizeAspectFill
    }

    private func startPlayback() {
        guard let player = player, let imgVw = imgVw, let playerLayer = playerLayer else {
            print("Player or ImageView is nil")
            return
        }

        DispatchQueue.main.async {
            self.playerLayer?.frame = self.imgVw.bounds
            self.imgVw.layer.addSublayer(playerLayer)

            self.player?.play()  // Start playback immediately
            self.isPlaying = true  // Update playback state
        }
    }

    private func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        imgVw.addGestureRecognizer(tapGesture)
        imgVw.isUserInteractionEnabled = true
    }

    @objc func handleTap() {
        guard let player = player else { return }

        if isPlaying {
            player.pause()
            isPlaying = false
        } else {
            player.play()
            isPlaying = true
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        playerLayer?.frame = imgVw.bounds  // Ensure resizing works
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        player?.pause()
        player = nil
    }

    @IBAction func acn_backBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: false)
    }
}
