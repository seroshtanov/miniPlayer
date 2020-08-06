//
//  MPAudioPlayer.swift
//  AudioTrack
//
//  Created by Виталий Сероштанов on 04.05.2020.
//  Copyright © 2020 sv.singletone.inc. All rights reserved.
//

import UIKit
import AVFoundation


class MPAudioPlayer: NSObject {
    fileprivate var audioPlayer: AVQueuePlayer?    
    func play(song: AVPlayerItem, from: CGFloat) {
        let targetTime:CMTime = CMTime.init(seconds: Double(from), preferredTimescale: 1000)
        song.seek(to: targetTime, completionHandler: nil)
        if self.audioPlayer == nil {
            self.audioPlayer = AVQueuePlayer.init(playerItem: song)
        } else {
            self.audioPlayer?.removeAllItems()
            self.audioPlayer?.insert(song, after: nil)
            self.audioPlayer?.seek(to: .zero)
        }
        
        self.audioPlayer?.seek(to: targetTime, completionHandler: { [weak self](success) in
            if self?.audioPlayer?.rate == 0
            {
                self?.audioPlayer?.play()
            }
        })

    }
    
    func stop()  {
        self.audioPlayer?.currentItem?.seek(to: .zero, completionHandler: { [weak self](success) in
            self?.audioPlayer?.removeAllItems()
        })
        
    }
    
    var currentTime : Double? {
        self.audioPlayer?.currentTime().seconds
    }
}



