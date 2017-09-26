//
//  RecordTableViewCell.swift
//  TestTask
//
//  Created by ParaBellum on 9/9/17.
//  Copyright © 2017 ParaBellum. All rights reserved.
//

import UIKit

class RecordTableViewCell: UITableViewCell {
    var recordURL: URL!
    var isRed:Bool = false{
        didSet{
            toggleViewColor()
        }
    }
    //MARK: - Life cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    //MARK: - Outlets
    @IBOutlet weak var timeLabel: UILabel!
    //MARK: - Funcs
    func configureWithRecord(_ record:Record){
        self.timeLabel.text = record.durationString
        self.recordURL = record.url
    }
    
    func toggleViewColor(){
        self.contentView.backgroundColor = isRed ? .red : .white
    }
    
    
    

}
extension RecordTableViewCell:PlayerDelegate{
    func didFinishPlaying(flag: Bool) {
        self.isRed = flag
    }
    func setRedColor(flag:Bool){
        self.isRed = flag
    }
}
