//
//  FeedVideoCollectionViewCell.swift
//  BVURam
//
//  Created by Vardhan Chopada on 12/23/22.
//

import UIKit
import AVFoundation

class FeedVideoCollectionViewCell: UICollectionViewCell {
    
    
    
    static let identifier = "FeedVideoCollectionViewCell"
    
    var player: AVPlayer?
    var model: VideoModel?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
//        contentView.backgroundColor = .black
        contentView.clipsToBounds = true
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(with model: VideoModel) {
    
        self.model = model
        configureVideo()
        
    }
    
    private func configureVideo() {
        
        guard let model = model else {
            return
        }
        
        guard let path = Bundle.main.path(forResource: model.videoFileName, ofType: model.videoFileFormat) else {
            print("Not Working")
            return
        }
        
        player = AVPlayer(url: URL(fileURLWithPath: path))
        
        let playerView = AVPlayerLayer()
        playerView.player = player
        playerView.frame = contentView.bounds
        playerView.videoGravity = .resizeAspectFill
        contentView.layer.addSublayer(playerView)
        player?.play()
        player?.volume = 0
    }
    
}


