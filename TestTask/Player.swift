
//
//  Player.swift
//  TestTask
//
//  Created by ParaBellum on 9/9/17.
//  Copyright © 2017 ParaBellum. All rights reserved.
//

import Foundation
import AVFoundation

class Player:NSObject {
    
    static let shared = Player()
    override private init() {
        super.init()
        setupAudioSession()
        
    }
    
    private var audioSession = AVAudioSession.sharedInstance()
    private var player:AVAudioPlayer!
    
    weak var cell:RecordTableViewCell!
    
    private func setupAudioSession(){
    try! audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord, with: .defaultToSpeaker)
    }
    
    
    func playFrom(selectedCell:RecordTableViewCell){
        cell = selectedCell
        do {
            player = try AVAudioPlayer(contentsOf:selectedCell.recordURL )
            player.delegate  = self
            guard let player = player else { return }
            if !cell.isRed{
                player.volume = 1
                player.prepareToPlay()
                selectedCell.toggleColor()
                player.play()
            }else{
                cell.toggleColor()
                player.stop()
            }
        } catch let error {
            print(error.localizedDescription)
        }
        
        
    }
}
extension Player: AVAudioPlayerDelegate{
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        cell.toggleColor()
    }
    
    
    
}
