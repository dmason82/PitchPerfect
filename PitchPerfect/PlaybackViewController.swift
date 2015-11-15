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
        let changePitchEffect = AVAudioUnitTimePitch()
        switch(sender.accessibilityIdentifier!){
            case "chipmunk":
                changePitchEffect.pitch = 1000
                break
            case "vader":
                changePitchEffect.pitch = -1000
                break
        default: //Just in case
            changePitchEffect.pitch=0
        }
        setupAndPlayAudio(changePitchEffect)
        
    }
    @IBAction func playAudioWithEcho(sender: AnyObject) {
        stopPlayback()
        let echoNode = AVAudioUnitDelay()
        echoNode.delayTime = NSTimeInterval(0.2)
        setupAndPlayAudio(echoNode)
    }
    
    @IBAction func playAudioWithReverb(sender: AnyObject) {
        stopPlayback()
        let reverb = AVAudioUnitReverb()
        reverb.loadFactoryPreset(AVAudioUnitReverbPreset.Cathedral)
        reverb.wetDryMix = 60
        setupAndPlayAudio(reverb)
    }
    
    func stopPlayback(){
        audioEngine.stop()
        audioEngine.reset()
    }
    
    /**This function is to act as our playback method for all of our calls that need a specific sound effect played. For
     * speed changes, this doesn't quite work without making the code a bit more cumbersome to work with, so I figured it was best
     to keep code affecting speed and audio effects separate. This does at least clean up each method so that they don't have a ton of boilerplate code to setup and playback the file
    */
    func setupAndPlayAudio(audioEffect:AVAudioNode=AVAudioPlayerNode()){
        let audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        audioEngine.attachNode(audioEffect)
        audioEngine.connect(audioPlayerNode, to: audioEffect, format: nil)
        audioEngine.connect(audioEffect, to: audioEngine.outputNode, format: nil)
        audioPlayerNode.volume = 100
        try! audioEngine.start()
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioPlayerNode.play()
    }
    
    
}