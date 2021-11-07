//
//  TableViewCellController.swift
//  FirstExample
//
//  Created by Furkan Saffet Olkay on 26.10.2021.
//

import UIKit

class TableViewCellController: UITableViewCell {

    
    @IBOutlet weak var customLabel: UILabel!
    @IBOutlet weak var customImage: UIImageView!
    
   
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.separatorInset.left = .greatestFiniteMagnitude

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
