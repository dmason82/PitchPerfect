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
    var receivedAudio:RecordedAudio!
    var audioEngine:AVAudioEngine!
    var audioFile: AVAudioFile!
    override func viewDidLoad() {
        audioEngine = AVAudioEngine()
        audioFile = try! AVAudioFile(forReading: receivedAudio.filePathUrl)
    }
    @IBAction func playAudioWithSpeed(sender: UIButton ){
        stopPlayback()
        let audioPlayer = AVAudioPlayerNode()
        let audioRate = AVAudioUnitTimePitch()
        audioEngine.attachNode(audioPlayer)
        switch(sender.accessibilityIdentifier!){
        case "slow":
            audioRate.rate = 0.25
            break
        case "fast":
            audioRate.rate = 2.0
            break
        default:
            return
        }
        
        audioEngine.attachNode(audioRate)
        audioEngine.connect(audioPlayer, to: audioRate, format: nil)
        audioEngine.connect(audioRate, to: audioEngine.outputNode, format: nil)
        
        audioPlayer.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        
        try! audioEngine.start()
        audioPlayer.play()
        
    }
    
    @IBAction func stop(sender: UIButton) {
        audioEngine.stop()
        audioEngine.reset()
    }

    @IBAction func playAudioWithPitch(sender: UIButton){
        stopPlayback()
        let audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        audioPlayerNode.volume = 100
        let changePitchEffect = AVAudioUnitTimePitch()
        if(sender.accessibilityIdentifier == "chipmunk"){
            changePitchEffect.pitch = 1000
        }
        else if(sender.accessibilityIdentifier == "vader"){
            changePitchEffect.pitch = -1000
        }
        audioEngine.attachNode(changePitchEffect)
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        try! audioEngine.start()
        audioPlayerNode.play()
    }
    @IBAction func playAudioWithEcho(sender: AnyObject) {
        stopPlayback()
        let echoNode = AVAudioUnitDelay()
        let audioPlayer = AVAudioPlayerNode()
        echoNode.delayTime = NSTimeInterval(0.2)
        audioEngine.attachNode(audioPlayer)
        audioEngine.attachNode(echoNode)
        audioEngine.connect(audioPlayer, to: echoNode, format: nil)
        audioEngine.connect(echoNode, to: audioEngine.outputNode, format: nil)
        audioPlayer.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        try! audioEngine.start()
        audioPlayer.play()
    }
    
    @IBAction func playAudioWithReverb(sender: AnyObject) {
        stopPlayback()
        let audioPlayerNode = AVAudioPlayerNode()
        let reverb = AVAudioUnitReverb()
        reverb.loadFactoryPreset(AVAudioUnitReverbPreset.Cathedral)
        reverb.wetDryMix = 60
        audioEngine.attachNode(audioPlayerNode)
        audioEngine.attachNode(reverb)
        audioEngine.connect(audioPlayerNode, to: reverb, format: nil)
        audioEngine.connect(reverb, to: audioEngine.outputNode, format: nil)
        audioPlayerNode.volume = 100
        try! audioEngine.start()
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioPlayerNode.play()
    }
    
    func stopPlayback(){
        audioEngine.stop()
        audioEngine.reset()
    }
    
    
}