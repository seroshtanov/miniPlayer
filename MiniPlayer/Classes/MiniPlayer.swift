//
//  AudioTrack.swift
//  AudioTrack
//
//  Created by Виталий Сероштанов on 04.05.2020.
//  Copyright © 2020 sv.singletone.inc. All rights reserved.
//

import UIKit
import AVFoundation


public protocol MiniPlayerDelegate : AnyObject {
    func didPlay(player: MiniPlayer)
    func didStop(player: MiniPlayer)
    func didPause(player: MiniPlayer)
}


@IBDesignable public class MiniPlayer: UIView {

    @IBInspectable public var timerColor : UIColor?
    @IBInspectable public var activeTimerColor : UIColor?
    @IBInspectable public var activeTrackColor: UIColor = UIColor.yellow
    @IBInspectable public var durationTimeInSec : CGFloat = 0 {
        didSet {
            self.updateTime()
        }
    }
    @IBInspectable public var timeLabelVisible : Bool = true
    public weak var delegate : MiniPlayerDelegate?
    
    public var soundTrack :  AVPlayerItem? {
        didSet {
            self.isUserInteractionEnabled = (self.soundTrack != nil)
            self.durationTimeInSec = CGFloat(self.soundTrack?.asset.duration.seconds ?? 0)
        }
    }
    
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.isUserInteractionEnabled = false
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.isUserInteractionEnabled = false
    }
    
    fileprivate enum PlayerState {
        case stopped
        case played
    }
    fileprivate var playerState = PlayerState.stopped {
        didSet{
            self.updateButtonImage()
        }
    }
    fileprivate var playPauseButton : UIButton!
    fileprivate var trackView: UIView!
    fileprivate var timeLabel: UILabel!
    
    fileprivate let player = MPAudioPlayer()
    fileprivate var timer : CADisplayLink?
    fileprivate var isTracking: Bool = false
    fileprivate var playedTime : CGFloat = 0
    
    override public func draw(_ rect: CGRect) {
        super.draw(rect)
        if self.activeTimerColor == nil {self.activeTimerColor = self.tintColor}
        if self.timerColor == nil {self.timerColor = self.tintColor}
        self.clipsToBounds = true
        self.layer.cornerRadius = rect.size.height / 2
        let buttonFrame = CGRect.init(x: 0, y: 0, width: rect.size.height, height: rect.size.height)
        self.trackViewSetup(buttonFrame)
        self.playPauseButtonSetup(buttonFrame)
        let timeLabelFrame = CGRect.init(x: rect.height + 4, y: 0, width: rect.width - ( (rect.height + 4) * 2) , height: rect.height)
        self.timeLabelSetup(frame: timeLabelFrame)
        self.addGestures()
        self.trackView.isUserInteractionEnabled = false
    }

    public func play() {
        guard self.soundTrack != nil else {
            print("No tracks to play")
            return
        }
        self.playerState = .played
        print("Play with: \(playedTime)")
        self.player.play(song: self.soundTrack!, from: playedTime)
        if self.timer != nil {timer?.invalidate()}
        self.timer = CADisplayLink.init(target: self, selector: #selector(updateTimeLine))
        self.timer?.add(to: .current, forMode: .common)
        self.delegate?.didPlay(player: self)
    }
    
    public func pause() {
        self.playerState = .stopped
        self.playedTime = CGFloat(self.player.currentTime ?? 0)
        self.timer?.isPaused = true
        self.player.stop()
        self.delegate?.didPause(player: self)
    }
    
    public func stop() {
        self.playerState = .stopped
        self.player.stop()
        self.playedTime = 0
        self.timer?.invalidate()
        self.updateTime()
        self.trackView?.frame = CGRect.init(x: 0, y: 0, width: self.frame.height, height: self.frame.height)
        self.timeLabel?.textColor = self.timerColor
        self.delegate?.didStop(player: self)
    }
}

// MARK : Button
extension MiniPlayer {
    fileprivate func playPauseButtonSetup(_ rect: CGRect) {
        if self.playPauseButton == nil {
            self.playPauseButton = UIButton.init(type: .system)
            self.playPauseButton.addTarget(self, action: #selector(playPauseButtonPressed), for: .touchUpInside)
            self.addSubview(self.playPauseButton)
        }
        self.playPauseButton.frame = rect
        self.playPauseButton.layer.cornerRadius = rect.size.height / 2
        self.playPauseButton.backgroundColor = self.activeTrackColor
        self.updateButtonImage()
    }
    
    fileprivate var playButtonImage : UIImage {
        let bundle = Bundle.init(for: MiniPlayer.self)
        if #available(iOS 13.0, *) {
            return UIImage.init(named: "play", in: bundle, with: nil)!
        } else {
            return UIImage.init(named: "play", in: bundle, compatibleWith: nil)!//Image.init(named: "play", in: Bun, with: nil)//UIImage.init(named: "play")
        }
    }
    fileprivate var pauseButtonImage : UIImage {
        let bundle = Bundle.init(for: MiniPlayer.self)
        if #available(iOS 13.0, *) {
            return UIImage.init(named: "pause", in: bundle, with: nil)!
        } else {
            return UIImage.init(named: "pause", in: bundle, compatibleWith: nil)!//Image.init(named: "play", in: Bun, with: nil)//UIImage.init(named: "play")
        }
    }
    
    fileprivate func updateButtonImage() {
        switch playerState {
        case .stopped:
            self.playPauseButton?.setImage(playButtonImage, for: .normal)
        case .played:
            self.playPauseButton?.setImage(pauseButtonImage, for: .normal)
        }
        self.playPauseButton?.setTitle(nil, for: .normal)
    }
    
    
    @objc fileprivate func playPauseButtonPressed(){
        if self.playerState == .played {
            self.pause()
        } else {
            self.play()
        }
    }
}

// MARK: Label
extension MiniPlayer {
    func timeLabelSetup(frame: CGRect) {
        if self.timeLabel == nil {
            self.timeLabel = UILabel.init(frame: frame)
            self.addSubview(self.timeLabel)
        }
        else {
            self.timeLabel.frame = frame
        }
        self.timeLabel.font = UIFont.systemFont(ofSize: 13)
        self.timeLabel.isHidden = !self.timeLabelVisible
        self.timeLabel.textColor = self.timerColor
        self.updateTime()
    }
    
    fileprivate func updateTime(){
        func updateWithSec(_ insec: Int) {
            guard insec > 0 else {
                self.timeLabel?.text = "0:00"
                return
            }
            let min = insec / 60
            let sec = insec - (min * 60)
            let text = String(min) + ":" + (sec < 10 ? "0\(sec)" : String(sec))
            self.timeLabel?.text = text
        }
        let insec : Int
        switch self.playerState {
        case .stopped:
            insec = self.playedTime == 0 ?  Int(self.durationTimeInSec) : Int(playedTime)
        case .played:
            if let played = self.player.currentTime, !played.isNaN {
                insec = Int(played)
            } else {
                insec = Int(self.durationTimeInSec)
            }
        }
        updateWithSec(insec)
    }
}


// MARK: TrackView
extension MiniPlayer {
    
    fileprivate func trackViewSetup(_ rect: CGRect) {
        if self.trackView == nil {
            self.trackView = UIView.init(frame: rect)
            self.addSubview(trackView)
        } else {
            self.trackView.frame = rect
        }
        self.trackView.backgroundColor = self.activeTrackColor
        self.trackView.layer.cornerRadius = rect.size.height / 2
    }
    
    fileprivate var velocity : CGFloat {
        if let buttonWidth = self.playPauseButton?.frame.size.width {
            let time = self.durationTimeInSec
            return (self.frame.width - buttonWidth) / CGFloat(time)
        } else {
            return 0
        }
    }
    
    @objc fileprivate func updateTimeLine() {
        guard  !self.isTracking, let playerTime = self.player.currentTime else {return}
        
        if playerTime.isNaN {
            self.stop()
            return
        }
        
        let trackTime : CGFloat = CGFloat(playerTime)
        let activeTrackWidth = self.playPauseButton.frame.width + (velocity * trackTime)
        self.trackView.frame = CGRect.init(x: 0, y: 0, width: activeTrackWidth, height: self.frame.height)
        self.timeLabel?.textColor = (activeTrackWidth == self.playPauseButton.frame.width) ? self.timerColor : self.activeTimerColor
        self.updateTime()
    }
    
}

// MARK: Gestures
extension MiniPlayer {
    fileprivate func addGestures() {
        let pan = UIPanGestureRecognizer.init(target: self, action: #selector(gesture(sender:)))
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(gesture(sender:)))
        self.addGestureRecognizer(pan)
        self.addGestureRecognizer(tap)
    }
    
    @objc fileprivate func gesture(sender: UIGestureRecognizer) {
        let x = sender.location(in: self).x
        let newSise : CGFloat = min(self.frame.size.width, max(0, x))
        switch sender.state {
        case .ended:
            self.playedTime = (newSise - self.frame.height) / velocity
            if self.playerState == .played {self.play()}
            if self.playerState == .stopped {
                self.trackView.frame = CGRect.init(x: 0, y: 0, width: newSise, height: self.frame.size.height)
                self.updateTime()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.isTracking = false
            }
        case .began, .changed:
            self.trackView.frame = CGRect.init(x: 0, y: 0, width: newSise, height: self.frame.size.height)
            self.isTracking = true
        default:
            self.isTracking = false
        }
    }
    
}
