//
//  RecordTableViewCell.swift
//  TestTask
//
//  Created by ParaBellum on 9/9/17.
//  Copyright © 2017 ParaBellum. All rights reserved.
//

import UIKit

class RecordTableViewCell: UITableViewCell {

    
    @IBOutlet weak var timeLabel: UILabel!
    func configureWithRecord(_ record:Record){
        self.timeLabel.text = record.name
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
