//
//  RecordViewController.swift
//  TestTask
//
//  Created by ParaBellum on 9/9/17.
//  Copyright © 2017 ParaBellum. All rights reserved.
//

import UIKit


class RecordViewController: UIViewController {
    
    private enum State:String{
        case recording
        case stoped
    }
    @IBOutlet weak var recordingStateLabel: UILabel!
    private var state = State.stoped{
        didSet{
            updateUI()
        }
    }
    private let recorder = Recorder()
    
    @IBOutlet weak var toggleRecordButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func toggleRecording(_ sender: Any) {
        switch  state{
        case .stoped:
            state = .recording
            recorder.record()
            
        case .recording:
            state = .stoped
            recorder.stopRecording()
            
            
        }
     
    }
    
    
    
    @IBAction func save(_ sender: Any) {
        state = .stoped
        recorder.saveRecord()
    }
    
    
    
    private func updateUI(){
        print("\(state.rawValue)")
        switch state {
        case .recording:
            toggleRecordButton.backgroundColor = .red
            recordingStateLabel.text = "Recording..."
        case .stoped:
            toggleRecordButton.backgroundColor = .blue
            recordingStateLabel.text = "Press button to start recording"
            
            
        }
        
        
        
    }
}
