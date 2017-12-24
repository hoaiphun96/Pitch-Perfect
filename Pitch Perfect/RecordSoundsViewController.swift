//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by cc-user on 8/24/17.
//  Copyright © 2017 Udacity. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopRecordingButton: UIButton!
    var audioRecorder: AVAudioRecorder!
   
    //MARK: viewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()
        recordButton.imageView?.contentMode = .scaleAspectFit
        stopRecordingButton.imageView?.contentMode = .scaleAspectFit
        stopRecordingButton.isEnabled = false
    }
    

    //MARK: record audio
    @IBAction func recordAudio(_ sender: AnyObject) {
        configureUI(true)
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord, with:AVAudioSessionCategoryOptions.defaultToSpeaker)
        
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }

    //MARK: stop recording
    @IBAction func stopRecording(_ sender: AnyObject) {
        configureUI(false)
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        }
        else {
            let alert = UIAlertController(title: "Try again", message: "Recording was not successful", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    //MARK: prepare the segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording" {
            let playSoundVC = segue.destination as! PlaySoundsViewController
            let recordedAudioURL = sender as! URL
            playSoundVC.recordedAudioURL = recordedAudioURL
        }
    }
    
    //MARK: Configure UI
    func configureUI(_ isPlaying: Bool) {
        recordingLabel.text = isPlaying ? "Recording in Progress" : "Tap to record"
        stopRecordingButton.isEnabled = isPlaying
        recordingLabel.isEnabled = !isPlaying
    }
}

