//
//  PlayerView.swift
//  reeal
//
//  Created by Nakul Chawla on 3/29/20.
//  Copyright © 2020 Nakul Chawla. All rights reserved.
//
//  Created by Chris Mash on 11/09/2019.
//  Copyright © 2019 Chris Mash. All rights reserved.
//

import SwiftUI
import AVFoundation

// This is the UIView that contains the AVPlayerLayer for rendering the video
class VideoPlayerUIView: UIView {
    private let player: AVPlayer
    private let playerLayer = AVPlayerLayer()
    private let videoPos: Binding<Double>
    private let videoDuration: Binding<Double>
    private let seeking: Binding<Bool>
    private var durationObservation: NSKeyValueObservation?
    private var timeObservation: Any?
    
    init(player: AVPlayer, videoPos: Binding<Double>, videoDuration: Binding<Double>, seeking: Binding<Bool>) {
        self.player = player
        self.videoDuration = videoDuration
        self.videoPos = videoPos
        self.seeking = seeking
        
        super.init(frame: .zero)
        
        backgroundColor = .gray
        playerLayer.player = player
        layer.addSublayer(playerLayer)
        
        
        // Observe the duration of the player's item so we can display it
        // and use it for updating the seek bar's position
        durationObservation = player.currentItem?.observe(\.duration, changeHandler: { [weak self] item, change in
            guard let self = self else { return }
            self.videoDuration.wrappedValue = item.duration.seconds
        })
        
        // Observe the player's time periodically so we can update the seek bar's
        // position as we progress through playback
        timeObservation = player.addPeriodicTimeObserver(forInterval: CMTime(seconds: 0.5, preferredTimescale: 600), queue: nil) { [weak self] time in
            guard let self = self else { return }
            // If we're not seeking currently (don't want to override the slider
            // position if the user is interacting)
            guard !self.seeking.wrappedValue else {
                return
            }
            
            // update videoPos with the new video time (as a percentage)
            self.videoPos.wrappedValue = time.seconds / self.videoDuration.wrappedValue
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        playerLayer.frame = bounds
//        playerLayer.frame = CGRect(x: 0, y: 0, width: UIScreen.screenWidth/2.5, height: (UIScreen.screenWidth/3.0)*1.5)

    }
    
    func cleanUp() {
        // Remove observers we setup in init
        durationObservation?.invalidate()
        durationObservation = nil
        
        if let observation = timeObservation {
            player.removeTimeObserver(observation)
            timeObservation = nil
        }
    }
    
}

// This is the SwiftUI view which wraps the UIKit-based PlayerUIView above
struct VideoPlayerView: UIViewRepresentable {
    @Binding private(set) var videoPos: Double
    @Binding private(set) var videoDuration: Double
    @Binding private(set) var seeking: Bool
    
    let player: AVPlayer
    
    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<VideoPlayerView>) {
        // This function gets called if the bindings change, which could be useful if
        // you need to respond to external changes, but we don't in this example
    }
    
    func makeUIView(context: UIViewRepresentableContext<VideoPlayerView>) -> UIView {
        let uiView = VideoPlayerUIView(player: player,
                                       videoPos: $videoPos,
                                       videoDuration: $videoDuration,
                                       seeking: $seeking)
        return uiView
    }
    
    static func dismantleUIView(_ uiView: UIView, coordinator: ()) {
        guard let playerUIView = uiView as? VideoPlayerUIView else {
            return
        }
        
        playerUIView.cleanUp()
    }
}

// This is the SwiftUI view which contains the player and its controls
struct VideoPlayerContainerView : View {
    // The progress through the video, as a percentage (from 0 to 1)
    @State private var videoPos: Double = 0
    // The duration of the video in seconds
    @State private var videoDuration: Double = 0
    // Whether we're currently interacting with the seek bar or doing a seek
    @State private var seeking = false
    
    @State private var playerPaused = true
    
    private let player: AVPlayer
    
    init(url: URL) {
        player = AVPlayer(url: url)
    }
    
    var body: some View {
        
        VideoPlayerView(videoPos: $videoPos,
                        videoDuration: $videoDuration,
                        seeking: $seeking,
                        player: player)
            
//            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height )
            .overlay(PlayPauseButton(player: player , pause: self.$playerPaused, playerPaused: $playerPaused), alignment: .center)
            .onDisappear { self.player.replaceCurrentItem(with: nil) }
        
        // When this View isn't being shown anymore stop the player
    }
}

// This is the SwiftUI view which contains the player and its controls
struct VideoPlayerContainerProfileView : View {
    // The progress through the video, as a percentage (from 0 to 1)
    @State private var videoPos: Double = 0
    // The duration of the video in seconds
    @State private var videoDuration: Double = 0
    // Whether we're currently interacting with the seek bar or doing a seek
    @State private var seeking = false
    
    @State private var playerPaused = true
    
    private let player: AVPlayer
    
    init(url: URL) {
        player = AVPlayer(url: url)
    }
    
    var body: some View {
        
        VideoPlayerView(videoPos: $videoPos,
                        videoDuration: $videoDuration,
                        seeking: $seeking,
                        player: player)
            .border(Color.yellow, width: 4)
//            .frame(width: (UIScreen.main.bounds.width/3.0), height: (UIScreen.main.bounds.width/3.0)*1.5 )
        
//            .overlay(PlayPauseButtonForProfile(player: player , pause: self.$playerPaused, playerPaused: $playerPaused), alignment: .center)
//            .onDisappear { self.player.replaceCurrentItem(with: nil) }
        
        // When this View isn't being shown anymore stop the player
    }
}

// This is the main SwiftUI view for this app, containing a single PlayerContainerView
struct VideoView: View {
    var body: some View {
        VideoPlayerContainerView(url: postUrl)
    }
}


