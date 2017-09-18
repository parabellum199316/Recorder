//
//  RecordViewController.swift
//  TestTask
//
//  Created by ParaBellum on 9/9/17.
//  Copyright © 2017 ParaBellum. All rights reserved.
//

import UIKit


class RecordViewController: UIViewController , RecorderDelegate{
    
    
    func chekPermission(_ permission: Bool) {
        if !permission{
            state = .needPermission
        }
    }
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
    private let recorder = Recorder()
    
    @IBOutlet weak var toggleRecordButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if !recorder.havePermission{
            state = .needPermission
        }else{
            state = .stoped
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
        print("\(state.rawValue)")
        switch state {
        case .recording:
            toggleRecordButton.backgroundColor = .red
            recordingStateLabel.text = "Recording..."
        case .stoped:
            toggleRecordButton.isEnabled = true
            saveButton.isEnabled = true
            toggleRecordButton.backgroundColor = .blue
            recordingStateLabel.text = "Press button to start recording"
        case .needPermission:
            showAlert(title:"I need permission",message:"You can give me access to your mic in settings")
            toggleRecordButton.isEnabled = false
            saveButton.isEnabled = false
            
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
