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

func convertDateFormatter(_ date: Date) -> String{
    let inputDateFormatter = DateFormatter()
    inputDateFormatter.dateFormat = "dd/MM/YYYY"
    let showDateString = inputDateFormatter.string(from: date)
    inputDateFormatter.dateFormat = "dd.MM.yyyy"
    let showDate = inputDateFormatter.date(from: showDateString)
    return inputDateFormatter.string(from: showDate!)
}
class Recorder:NSObject{
    private var savedFlag:Bool = false
    private var lastRecordedFileURL:URL!
    var recordingSession = AVAudioSession.sharedInstance()
    var audioRecorder: AVAudioRecorder!
    var numberOfRecords = 0
    private  let settings = [AVFormatIDKey: Int(kAudioFormatMPEG4AAC), AVSampleRateKey:12000, AVNumberOfChannelsKey: 1, AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue]
    
    
    
    
    override init(){
        super.init()
        if let number:Int = UserDefaults.standard.object(forKey: "numberOfRecords") as? Int{
            numberOfRecords = number
        }
    }
    
    deinit {
        if !savedFlag{
           Recorder.deleteRecord(at: lastRecordedFileURL)
        }
    }
    
    func record(){
        //Check if we have an active recorder
        if audioRecorder == nil{
            
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
    
    
    static func deleteRecord(at url:URL){
        try? FileManager.default.removeItem(at: url)
    }
    
    
    func stopRecording(){
        // have we an active recording session?
        //Stopping audio recording
        if audioRecorder != nil{
            audioRecorder.stop()
            audioRecorder = nil
            
        }
        
    }
    func saveRecord(){
        
        guard let recordedFileURL = lastRecordedFileURL else{return}
        savedFlag = true
        numberOfRecords += 1
        UserDefaults.standard.set(numberOfRecords, forKey: "numberOfRecords")
        stopRecording()
        let realm = try! Realm()
        let date = Date()
        let record = Record(name: "\(numberOfRecords)record", urlString:recordedFileURL.absoluteString,dateAdded: date)
        let dateString = convertDateFormatter(date)
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
