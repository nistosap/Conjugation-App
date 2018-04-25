//
//  conjTableViewCell.swift
//  Cree Conjugation
//
//  Created by Wolfgang on 2018-02-23.
//  Copyright © 2018 nistosap. All rights reserved.
//

import UIKit

class conjTableViewCell: UITableViewCell {
    //MARK: properties
    @IBOutlet weak var conjPerson: UILabel!
    @IBOutlet weak var conjCree: UILabel!
    @IBOutlet weak var conjEnglish: UILabel!

    @IBOutlet weak var samplePerson: UILabel!
    @IBOutlet weak var sampleCree: UILabel!
    @IBOutlet weak var sampleEnglish: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
