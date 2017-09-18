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
    var isRed:Bool = false
    @IBOutlet weak var timeLabel: UILabel!
    func configureWithRecord(_ record:Record){
        self.timeLabel.text = record.name
        self.recordURL = record.url
    }
    
    func toggleColor(){
        isRed = !isRed
        self.contentView.backgroundColor = isRed ? .red : .white
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
    
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    

}
