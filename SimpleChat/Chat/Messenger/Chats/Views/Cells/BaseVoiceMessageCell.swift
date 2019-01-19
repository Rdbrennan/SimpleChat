//
//  BaseVoiceMessageCell.swift
//  Subly
//
//  Created by Robert Brennan on 9/20/18.
//  Copyright © 2018 TechYes. All rights reserved.
//

import UIKit

class BaseVoiceMessageCell: BaseMessageCell {
    
    var playerView: PlayerCellView = {
        var playerView = PlayerCellView()
        playerView.alpha = 1
        playerView.backgroundColor = .clear
        playerView.play.setImage(UIImage(named: "pause"), for: .selected)
        playerView.play.setImage(UIImage(named: "playWhite"), for: .normal)
        playerView.play.isSelected = false
        playerView.timerLabel.text = "00:00:00"
        playerView.startingTime = 0
        playerView.seconds = 0
        
        return playerView
    }()
    
    override func prepareViewsForReuse() {
        playerView.timerLabel.text = "00:00:00"
        playerView.seconds = 0
        playerView.startingTime = 0
        playerView.play.isSelected = false
        bubbleView.image = blueBubbleImage
    }
}

