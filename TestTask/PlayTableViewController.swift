//
//  PlayTableViewController.swift
//  TestTask
//
//  Created by ParaBellum on 9/9/17.
//  Copyright © 2017 ParaBellum. All rights reserved.
//

import UIKit
import RealmSwift

class PlayTableViewController: UITableViewController {
    fileprivate let cellID = "RecordCell"
    let realm = try! Realm()
    var player = Player.shared
    var sections:[DueDate] = []
    
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getLatestData()
        tableView.reloadData()
    }
    
    func getLatestData(){
        sections = realm.objects(DueDate.self).sorted(by: { return $0.date > $1.date})
    }
    
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].dateString
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return  sections.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let dueDay = sections[section]
        let recordsCount = dueDay.records.count
        return recordsCount
    }
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! RecordTableViewCell
        let section = indexPath.section
        let record = sections[section].records[indexPath.row]
        cell.configureWithRecord(record)
        return cell
    }
    
    
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        return true
    }
    override func viewWillDisappear(_ animated: Bool) {
        player.stopPlaying()
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            player.stopPlaying()
            let dueDate =  sections[indexPath.section]
            let record = dueDate.records[indexPath.row]
            //Remove record from section
            try! realm.write {
                dueDate.records.remove(objectAtIndex: indexPath.row)
            }
            let url = record.url
            //Delete file
            try? FileManager.default.removeItem(at: url)
            
            //Delete row
            tableView.deleteRows(at: [indexPath], with: .fade)
            //If it was last record in section - delete section
            if dueDate.records.count == 0 {
                sections.remove(at: indexPath.section)
                tableView.deleteSections(IndexSet(arrayLiteral:indexPath.section), with: .fade)
                try! realm.write {
                    realm.delete(dueDate)
                }
            }
        }
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! RecordTableViewCell
        player.delegate = cell
        let section = indexPath.section
        let record = sections[section].records[indexPath.row]
        player.play(from: record.url)
        tableView.deselectRow(at: indexPath, animated: true)
        
        
    }
    
    
}
