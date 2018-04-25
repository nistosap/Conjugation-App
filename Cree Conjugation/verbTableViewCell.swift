//
//  verbTableViewCell.swift
//  Cree Conjugation
//
//  Created by Wolfgang on 2018-02-22.
//  Copyright © 2018 nistosap. All rights reserved.
//

import UIKit

class verbTableViewCell: UITableViewCell {
//MARK: properties
    
    @IBOutlet weak var lblType1: UILabel!
    @IBOutlet weak var lblEnglish1: UILabel!
    @IBOutlet weak var lblCree1: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
