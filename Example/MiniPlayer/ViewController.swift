//
//  ViewController.swift
//  MiniPlayer
//
//  Created by 3422983@gmail.com on 07/15/2020.
//  Copyright (c) 2020 3422983@gmail.com. All rights reserved.
//

import UIKit
import MiniPlayer

import AVKit

class ViewController: UIViewController {
    
    @IBOutlet weak var miniPlayer: MiniPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.miniPlayer.delegate = self
        
        self.miniPlayer.tintColor = UIColor.white
        self.miniPlayer.backgroundColor = UIColor.init(red: 204/255.0, green: 221/255.0, blue: 255/255.0, alpha: 1)
        
        /*
        "timeLabelVisible" - set "false" if you want to hide timer. True by default
        */
        
        self.miniPlayer.timeLabelVisible = true
        
        /*
         "timerColor" - it's time color when player is stopped. TintColor by default
        */

        self.miniPlayer.timerColor = UIColor.white
        
        /*
         "activeTimerColor" - it's time color when player is stopped. TintColor by default
        */
        
        self.miniPlayer.activeTimerColor = UIColor.white
        
        /*
         "activeTrackColor" - it's progress bar color. UIColor.yellow by default
        */
        
        self.miniPlayer.activeTrackColor = UIColor.init(red: 204/255.0, green: 170/255.0, blue: 255/255.0, alpha: 1)

        /*
        "durationTimeInSec" - it's start time (in seconds) when track will be started. 0 by default.
         It'll reset when property "soundTrack" changes
        */
        
        self.miniPlayer.durationTimeInSec = 0
        
        /*
        Use code bottom to set playing track
        */
        
        let urlPath = Bundle.main.path(forResource: "file", ofType: "mp3")
        let url = URL.init(fileURLWithPath: urlPath!)

        let song = AVPlayerItem(asset: AVAsset(url: url), automaticallyLoadedAssetKeys: ["playable"])
        self.miniPlayer.soundTrack = song
        
    }


}


extension ViewController: MiniPlayerDelegate {
    func didPlay(player: MiniPlayer) {
        print("Playing...")
    }
    
    func didStop(player: MiniPlayer) {
        print("Stopped")
    }
    
    func didPause(player: MiniPlayer) {
        print("Pause")
    }
}
