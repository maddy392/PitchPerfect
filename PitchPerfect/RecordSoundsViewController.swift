//
//  RecordSoundsViewController.swift
//  PitchPerfect
//
//  Created by MadhuBabu Adiki on 3/25/24.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    
    var audioRecorder: AVAudioRecorder!

    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopRecordingButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI(false)
//        stopRecordingButton.isEnabled = false
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func configureUI(_ recordingState: Bool) {
        switch recordingState {
        case true:
            self.recordingLabel.text = "Recording in Progress"
            self.recordingLabel.adjustsFontSizeToFitWidth = true
            self.stopRecordingButton.isEnabled = true
            self.recordButton.isEnabled = false
        case false:
            self.recordButton.isEnabled = true
            self.stopRecordingButton.isEnabled = false
            self.recordingLabel.adjustsFontSizeToFitWidth = false
    //        recordingLabel.width
            self.recordingLabel.text = "Tap to Record"
        }
    }

    @IBAction func recordAudio(_ sender: Any) {
        print("record button was pressed")
        configureUI(true)
//        recordingLabel.text = "Recording in Progress"
//        recordingLabel.adjustsFontSizeToFitWidth = true
//        stopRecordingButton.isEnabled = true
//        recordButton.isEnabled = false
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSession.Category.playAndRecord, mode: AVAudioSession.Mode.default, options: AVAudioSession.CategoryOptions.defaultToSpeaker)
        
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
        
    }
    @IBAction func stopRecording(_ sender: Any) {
        print("stop recording button was pressed")
        configureUI(false)
//        recordButton.isEnabled = true
//        stopRecordingButton.isEnabled = false
//        recordingLabel.adjustsFontSizeToFitWidth = false
//        recordingLabel.text = "Tap to Record"
        
        audioRecorder.stop()
        let audioSession = AVAudioSession()
        try! audioSession.setActive(false)
        
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            print("Finished Recording")
            performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        }
        else {
            print("Error Recording")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording" {
            let playSoundsVC = segue.destination as! PlaySoundsViewController
            let recordedAudioURL = sender as! URL
            playSoundsVC.recordedAudioURL = recordedAudioURL
        }
    }
 
}

