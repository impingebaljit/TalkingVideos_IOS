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
import SDWebImage



//class VideoPlayVC: UIViewController {
//
//    @IBOutlet weak var imgVw: UIImageView!
//    @IBOutlet weak var subtitleLabel: UILabel!
//
//    var videoURL: URL?
//    var imageURL: String?
//    private var player: AVPlayer?
//    private var playerLayer: AVPlayerLayer?
//    private var isPlaying = false  // Flag to track playback state
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        self.navigationItem.hidesBackButton = true
//        setupAudioSession()  // Configure audio session
//        setupPlayer()
//        setupTapGesture()  // Add tap gesture to control playback
//        
//        
//    }
//
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        startPlayback()
//    }
//
//    private func setupAudioSession() {
//        let audioSession = AVAudioSession.sharedInstance()
//        do {
//            try audioSession.setCategory(.playback, mode: .default, options: [.allowAirPlay])
//            try audioSession.setActive(true)
//        } catch {
//            print("Failed to set up audio session: \(error)")
//        }
//    }
//
//    private func setupPlayer() {
//        guard let url = videoURL else {
//            print("Invalid video URL")
//            return
//        }
//
//        let playerItem = AVPlayerItem(url: url)
//        playerItem.preferredForwardBufferDuration = 0  // Reduce buffering delay
//        playerItem.preferredPeakBitRate = 5000000  // Adjust for faster streaming
//
//        player = AVPlayer(playerItem: playerItem)
//        player?.automaticallyWaitsToMinimizeStalling = false  // Force instant play
//
//        // Ensure volume is not muted
//        player?.volume = 1.0
//
//        playerLayer = AVPlayerLayer(player: player)
//        playerLayer?.videoGravity = .resizeAspectFill
//    }
//
//    private func startPlayback() {
//        guard let player = player, let imgVw = imgVw, let playerLayer = playerLayer else {
//            print("Player or ImageView is nil")
//            return
//        }
//
//        DispatchQueue.main.async {
//            self.playerLayer?.frame = self.imgVw.bounds
//            self.imgVw.layer.addSublayer(playerLayer)
//
//            self.player?.play()  // Start playback immediately
//            self.isPlaying = true  // Update playback state
//        }
//    }
//
//    private func setupTapGesture() {
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
//        imgVw.addGestureRecognizer(tapGesture)
//        imgVw.isUserInteractionEnabled = true
//    }
//
//    @objc func handleTap() {
//        guard let player = player else { return }
//
//        if isPlaying {
//            player.pause()
//            isPlaying = false
//        } else {
//            player.play()
//            isPlaying = true
//        }
//    }
//
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        playerLayer?.frame = imgVw.bounds  // Ensure resizing works
//    }
//
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        player?.pause()
//        player = nil
//    }
//
//    @IBAction func acn_backBtn(_ sender: Any) {
//        self.navigationController?.popViewController(animated: false)
//    }
//}
//


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
import SDWebImage

//class VideoPlayVC: UIViewController {
//
//    @IBOutlet weak var imgVw: UIImageView!
//    @IBOutlet weak var subtitleLabel: UILabel!
//
//    var videoURL: URL?
//    var imageURL: String?
//    private var player: AVPlayer?
//    private var playerLayer: AVPlayerLayer?
//    private var isPlaying = false  // Flag to track playback state
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        self.navigationItem.hidesBackButton = true
//        setupAudioSession()  // Configure audio session
//        setupImageView()  // Load image using SDWebImage
//        setupPlayer()  // Setup player but don't start playback yet
//        setupTapGesture()  // Add tap gesture to control playback
//        
//       
//    }
//
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        startPlayback()  // Start playback when view appears
//    }
//
//    private func setupAudioSession() {
//        let audioSession = AVAudioSession.sharedInstance()
//        do {
//            try audioSession.setCategory(.playback, mode: .default, options: [.allowAirPlay])
//            try audioSession.setActive(true)
//        } catch {
//            print("Failed to set up audio session: \(error)")
//        }
//    }
//
//    private func setupImageView() {
//        guard let imageURL = imageURL else {
//            print("Invalid image URL")
//            return
//        }
//
//        imgVw.sd_setImage(with: URL(string: imageURL), placeholderImage: nil, options: [.continueInBackground], completed: nil)
//    }
//
//    private func setupPlayer() {
//        guard let url = videoURL else {
//            print("Invalid video URL")
//            return
//        }
//
//        let playerItem = AVPlayerItem(url: url)
//        playerItem.preferredForwardBufferDuration = 0  // Reduce buffering delay
//        playerItem.preferredPeakBitRate = 5000000  // Adjust for faster streaming
//
//        player = AVPlayer(playerItem: playerItem)
//        player?.automaticallyWaitsToMinimizeStalling = false  // Force instant play
//
//        // Ensure volume is not muted
//        player?.volume = 1.0
//
//        playerLayer = AVPlayerLayer(player: player)
//        playerLayer?.videoGravity = .resizeAspectFill
//    }
//
//    private func startPlayback() {
//        guard let player = player, let imgVw = imgVw, let playerLayer = playerLayer else {
//            print("Player or ImageView is nil")
//            return
//        }
//
//        DispatchQueue.main.async {
//            self.playerLayer?.frame = self.imgVw.bounds
//            self.imgVw.layer.addSublayer(playerLayer)
//
//            self.player?.play()  // Start playback immediately
//            self.isPlaying = true  // Update playback state
//        }
//    }
//
//    private func setupTapGesture() {
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
//        imgVw.addGestureRecognizer(tapGesture)
//        imgVw.isUserInteractionEnabled = true
//    }
//
//    @objc func handleTap() {
//        guard let player = player else { return }
//
//        if isPlaying {
//            player.pause()
//            isPlaying = false
//        } else {
//            player.play()
//            isPlaying = true
//        }
//    }
//
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        playerLayer?.frame = imgVw.bounds  // Ensure resizing works
//    }
//
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        player?.pause()
//        player = nil
//    }
//
//    @IBAction func acn_backBtn(_ sender: Any) {
//        self.navigationController?.popViewController(animated: false)
//    }
//}


import UIKit
import AVFoundation
import SDWebImage




 import UIKit
import AVFoundation
import SDWebImage

class VideoPlayVC: UIViewController {

    @IBOutlet weak var imgVw: UIImageView!
    @IBOutlet weak var subtitleLabel: UILabel!

    var videoURL: String?
    var imageURL: String?

    private var player: AVPlayer?
    private var playerLayer: AVPlayerLayer?
    private var isPlaying = false
    private var playWhenReady = false
    private static var playerItemContext = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true

        setupAudioSession()
        setupImageView()
        setupTapGesture()
        preparePlayerAsync()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if let player = player, player.currentItem?.status == .readyToPlay {
            player.play()
            isPlaying = true
        } else {
            playWhenReady = true
        }
    }

    private func setupAudioSession() {
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.playback, mode: .default)
            try audioSession.setActive(true)
        } catch {
            print("❌ Audio session setup failed: \(error.localizedDescription)")
        }
    }

    private func setupImageView() {
        guard let imageURL = imageURL, let url = URL(string: imageURL) else {
            print("⚠️ Invalid image URL")
            return
        }

        imgVw.sd_setImage(with: url, placeholderImage: nil, options: [.continueInBackground])
    }

    private func preparePlayerAsync() {
        guard let urlString = videoURL, let url = URL(string: urlString) else {
            print("❌ Invalid video URL string: \(videoURL ?? "nil")")
            return
        }

        print("🎥 Loading video from: \(url.absoluteString)")

        let asset = AVURLAsset(url: url)
        let keys = ["playable"]

        asset.loadValuesAsynchronously(forKeys: keys) { [weak self] in
            guard let self = self else { return }

            var error: NSError?
            let status = asset.statusOfValue(forKey: "playable", error: &error)

            switch status {
            case .loaded:
                DispatchQueue.main.async {
                    let item = AVPlayerItem(asset: asset)
                    item.addObserver(self,
                                     forKeyPath: "status",
                                     options: [.new, .initial],
                                     context: &Self.playerItemContext)

                    let player = AVPlayer(playerItem: item)
                    player.automaticallyWaitsToMinimizeStalling = false
                    self.player = player

                    self.setupPlayerLayer()

                    if self.playWhenReady {
                        player.play()
                        self.isPlaying = true
                    }
                }
            default:
                print("❌ Video asset is not playable: \(error?.localizedDescription ?? "Unknown error")")
            }
        }
    }

    private func setupPlayerLayer() {
        guard let player = player else { return }

        let layer = AVPlayerLayer(player: player)
        layer.frame = imgVw.bounds
        layer.videoGravity = .resizeAspectFill

        playerLayer?.removeFromSuperlayer()
        imgVw.layer.insertSublayer(layer, at: 0)
        playerLayer = layer
    }

    private func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(togglePlayback))
        imgVw.isUserInteractionEnabled = true
        imgVw.addGestureRecognizer(tapGesture)
    }

    @objc private func togglePlayback() {
        guard let player = player else { return }

        if isPlaying {
            player.pause()
        } else {
            player.play()
        }
        isPlaying.toggle()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        playerLayer?.frame = imgVw.bounds
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        player?.pause()

        if let currentItem = player?.currentItem {
            currentItem.removeObserver(self, forKeyPath: "status", context: &Self.playerItemContext)
        }

        player = nil
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?,
                               change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
        guard context == &Self.playerItemContext, keyPath == "status",
              let item = object as? AVPlayerItem else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
            return
        }

        switch item.status {
        case .readyToPlay:
            print("✅ Video ready to play")
            if playWhenReady {
                player?.play()
                isPlaying = true
            }
        case .failed:
            print("❌ Failed to load video: \(item.error?.localizedDescription ?? "Unknown error")")
        default:
            break
        }
    }

    @IBAction func acn_backBtn(_ sender: Any) {
        navigationController?.popViewController(animated: false)
    }
}

