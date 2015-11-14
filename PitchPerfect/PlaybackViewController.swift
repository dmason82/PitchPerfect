//
//  PlaybackViewController.swift
//  PitchPerfect
//
//  Created by Doug Mason on 11/1/15.
//  Copyright © 2015 Doug Mason. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

class PlaybackViewController : UIViewController{
    var audioPlayer:AVAudioPlayer!
    var echoPlayer: AVAudioPlayer!
    var receivedAudio:RecordedAudio!
    var audioEngine:AVAudioEngine!
    var audioFile: AVAudioFile!
    override func viewDidLoad() {
        audioEngine = AVAudioEngine()
        audioPlayer = try? AVAudioPlayer(contentsOfURL:receivedAudio.filePathUrl! )
        echoPlayer = try? AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl! )
        audioFile = try! AVAudioFile(forReading: receivedAudio.filePathUrl)
        audioPlayer.enableRate = true
    }
    @IBAction func playSlow(sender: UIButton) {
        audioPlayer.rate = 0.25
        audioPlayer.currentTime = 0.0
        audioPlayer.play()

    }
    @IBAction func playFast(sender: UIButton) {
        audioPlayer.rate = 2.0
        audioPlayer.currentTime = 0.0
        audioPlayer.play()
    }
    
    @IBAction func playChipmunk(sender: UIButton) {
        playAudioWithPitch(float:1000)
    }
    
    @IBAction func stop(sender: UIButton) {
        audioPlayer.stop()
        echoPlayer.stop()
        audioEngine.stop()
    }
    
    @IBAction func playVader(sender: UIButton) {
        playAudioWithPitch(float: -1000)
    }
    func playAudioWithPitch(float pitch: Float){
        audioPlayer.stop()
        audioEngine.stop()
        echoPlayer.stop()
        audioEngine.reset()
        let audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        audioPlayerNode.volume = 100
        let changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        try! audioEngine.start()
        
        audioPlayerNode.play()
    }
    @IBAction func playAudioWithEcho(sender: AnyObject) {
        audioPlayer.stop()
        audioEngine.stop()
        audioPlayer.currentTime = 0
        audioEngine.reset()
        let echoDelay: NSTimeInterval = 0.2
        
        let echoTime = echoPlayer.currentTime + echoDelay
        echoPlayer.stop()
        echoPlayer.volume = 0.8
        echoPlayer.currentTime = 0
        echoPlayer.playAtTime(echoTime)
        
    }
    
    @IBAction func playAudioWithReverb(sender: AnyObject) {
        audioPlayer.stop()
        audioEngine.stop()
        echoPlayer.stop()
        audioEngine.reset()
        let audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        audioPlayerNode.volume = 100
        
    }
    
    
}