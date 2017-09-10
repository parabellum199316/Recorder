//
//  RecordViewController.swift
//  TestTask
//
//  Created by ParaBellum on 9/9/17.
//  Copyright © 2017 ParaBellum. All rights reserved.
//

import UIKit
import AVFoundation

class RecordViewController: UIViewController{
    private enum State:String{
        case recording
        case stoped
        case needPermission
    }
    
    @IBOutlet weak var recordingStateLabel: UILabel!
    
    private var state = State.stoped{
        didSet{
            updateUI()
        }
    }
    
    private  var recorder: Recorder!
   
    @IBOutlet weak var toggleRecordButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        recorder = Recorder()
        AVAudioSession.sharedInstance().requestRecordPermission(){[unowned self] allowed in
            if allowed{
                self.state = .stoped
            }else{
                self.state = .needPermission
            }
        }

    }
    
    @IBAction func toggleRecording(_ sender: Any) {
        switch  state{
        case .stoped:
            state = .recording
            recorder.record()
            
        case .recording:
            state = .stoped
            recorder.stopRecording()
            
        case .needPermission:
            updateUI()
            
        }
        
    }
    
    @IBAction func save(_ sender: Any) {
        state = .stoped
        recorder.saveRecord()
        navigationController?.popViewController(animated: true)
    }
    
    @IBOutlet weak var saveButton: UIButton!
    private func updateUI(){
        switch state {
        case .recording:
            toggleRecordButton.backgroundColor = .red
            recordingStateLabel.text = "Recording..."
        case .stoped:
            toggleRecordButton.backgroundColor = .blue
            recordingStateLabel.text = "Press button to start recording"
        case .needPermission:
            showAlert(title:"No access to MIC",message:"You can grant access from the settings app")
        }
        
    }
    
    private func showAlert(title:String, message:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default) { _ in
            self.navigationController?.popViewController(animated: true)
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}
