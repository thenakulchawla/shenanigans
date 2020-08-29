//
//  UserPostCell.swift
//  reeal
//
//  Created by Nakul Chawla on 3/23/20.
//  Copyright © 2020 Nakul Chawla. All rights reserved.

import Foundation
import UIKit
import AVKit

class UserPostCell: UICollectionViewCell {
    
    
//    @IBOutlet weak var playerView: PlayerView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying), name: .AVPlayerItemDidPlayToEndTime, object: nil)
        
    }
    
    
    @objc func playerDidFinishPlaying(note: NSNotification) {
        playerView.player?.seek(to: CMTime.zero)
        
    }
    
}
