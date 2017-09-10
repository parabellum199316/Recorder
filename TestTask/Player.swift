
//
//  Player.swift
//  TestTask
//
//  Created by ParaBellum on 9/9/17.
//  Copyright © 2017 ParaBellum. All rights reserved.
//

import Foundation
import AVFoundation
protocol PlayerDelegate{
    func didFinishPlaying(flag:Bool)
    func setRedColor(flag:Bool)
    
}
class Player:NSObject {
    static let shared = Player()
    override private init() {
        super.init()
        setupAudioSession()
    }
    private var audioSession = AVAudioSession.sharedInstance()
    private var player:AVAudioPlayer!
    private func setupAudioSession(){
        try! audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord, with: .defaultToSpeaker)
    }
    var isInMiddleOfPlaying = false
    
    var delegate:PlayerDelegate!{
        didSet{
            if let oldValue = oldValue{
                oldValue.setRedColor(flag: false)
                
            }
        }
    }
    
    func play(from url:URL){
        do {
            if !isInMiddleOfPlaying{
                player = try AVAudioPlayer(contentsOf:url)
                player.delegate  = self
                guard let player = player else { return }
                if !player.isPlaying{
                    player.volume = 1
                    player.prepareToPlay()
                    player.play()
                    isInMiddleOfPlaying = true
                    self.delegate.setRedColor(flag:true)
                }
            }else{
                stopPlaying()
            }
        } catch  {
            fatalError("Failed to create player")
        }
    }
    
    private func stopPlaying(){
        guard let player = player else {return}
        player.stop()
        isInMiddleOfPlaying = false
        self.delegate.setRedColor(flag:false)
    }
}

extension Player: AVAudioPlayerDelegate{
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if flag{
            self.delegate.setRedColor(flag:false)
        }
        self.isInMiddleOfPlaying = false
    }
    
    
}
