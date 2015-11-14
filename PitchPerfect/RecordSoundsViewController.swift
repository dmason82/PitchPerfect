//
//  RecordSoundsViewController
//  PitchPerfect
//
//  Created by Doug Mason on 11/1/15.
//  Copyright © 2015 Doug Mason. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController,AVAudioRecorderDelegate {
    var audioRecorder:AVAudioRecorder!
    var recordedAudio:RecordedAudio!
    
    override func viewWillAppear(animated: Bool) {
        stopButton.hidden = true
    }
    
    @IBOutlet weak var stopButton: UIButton!
    
    @IBOutlet weak var recordingLabel: UILabel!
    @IBAction func recordAudio(sender: AnyObject) {
        //TODO: Show text for recording in progress
        print("Recording Audio...")
        recordingLabel.text = "Recording..."
        stopButton.hidden = false
        //TODO: Actually record audio
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        let recordingName = "my_audio.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        print(filePath)
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        
        try! audioRecorder = AVAudioRecorder(URL: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    @IBAction func stopRecording(sender: UIButton) {
        audioRecorder.stop()
        stopButton.hidden = true
        let session = AVAudioSession.sharedInstance()
        try! session.setActive(false)
        recordingLabel.text = "Tap the Microphone to record"

    }
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        recordedAudio = RecordedAudio(filePathUrl: recorder.url, title: recorder.url.lastPathComponent)
        self.performSegueWithIdentifier("playAudioSegue", sender: recordedAudio)

    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "playAudioSegue"){
            //TODO: pass audio file from source to destination segue.
            let playbackVC = segue.destinationViewController as! PlaybackViewController
            let data = sender as! RecordedAudio
            playbackVC.receivedAudio = data
        }
    }


}

