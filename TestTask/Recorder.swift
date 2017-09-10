//
//  Recorder.swift
//  TestTask
//
//  Created by ParaBellum on 9/9/17.
//  Copyright © 2017 ParaBellum. All rights reserved.
//

import Foundation
import AVFoundation
import RealmSwift

var dateFormatter:DateFormatter{
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .medium
    dateFormatter.timeStyle = .none
    return dateFormatter
}
class Recorder:NSObject{
    
    private var lastRecordedFileURL:URL!
    var recordingSession = AVAudioSession.sharedInstance()
    var audioRecorder: AVAudioRecorder!
    var numberOfRecords = 0
    private  let settings = [AVFormatIDKey: Int(kAudioFormatMPEG4AAC), AVSampleRateKey:12000, AVNumberOfChannelsKey: 1, AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue]
    
    
    
    
    override init() {
        super.init()
        if let number:Int = UserDefaults.standard.object(forKey: "numberOfRecords") as? Int{
            numberOfRecords = number
        }
    }
    func record(){
        //Check if we have an active recorder
        if audioRecorder == nil{
            numberOfRecords += 1
            let fileName = getDirectoryToSave().appendingPathComponent("\(numberOfRecords)record.m4a")
            lastRecordedFileURL = fileName
            
            //Start recording
            do{
                audioRecorder = try AVAudioRecorder(url: fileName, settings: self.settings)
                audioRecorder.delegate = self
                audioRecorder.record()
                print("RECORDING....")
            }catch{
                print("RecordingFailed")
            }
        }
    }
    
    
    
    
    
    func stopRecording(){
        // have we an active recording session?
        //Stopping audio recording
        if audioRecorder != nil{
            audioRecorder.stop()
            audioRecorder = nil
            UserDefaults.standard.set(numberOfRecords, forKey: "numberOfRecords")
        }
        
    }
    func saveRecord(){
        guard let recordedFileURL = lastRecordedFileURL else{return}
        stopRecording()
        let realm = try! Realm()
        let date = Date()
        let record = Record(name: "\(numberOfRecords)record", urlString:recordedFileURL.absoluteString,dateAdded: date)
        let dateString = dateFormatter.string(from: record.dateAdded)
        var dueDate = realm.object(ofType: DueDate.self, forPrimaryKey: dateString)
        if dueDate == nil{
            dueDate = DueDate()
            dueDate!.date = date
            dueDate!.dateString = dateString
            try! realm.write {
                realm.add(dueDate!, update: true)
                dueDate!.records.append(record)
            }
            
        }else{
            try! realm.write {
                dueDate!.records.append(record)
            }
        }
        
        lastRecordedFileURL = nil
        
    }
    
    
    private func getDirectoryToSave() -> URL{
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = path[0]
        return documentDirectory
    }
}
extension Recorder: AVAudioRecorderDelegate{
    
}
