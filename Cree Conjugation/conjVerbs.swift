//
//  conjVerbs.swift
//  Cree Conjugation
//
//  Created by Wolfgang on 2018-02-23.
//  Copyright © 2018 nistosap. All rights reserved.
//

import UIKit

class conjVerbs {
    //MARK: Properties
    var conjCree: String
    var conjEnglish: String
    var conjPerson: String
    //var qualifier: String
    
    //MARK:Initialization
    init?(conjCree:String, conjEnglish:String,conjPerson:String){
        guard !conjCree.isEmpty else {
            return nil
        }
        guard !conjEnglish.isEmpty else {
            return nil
        }
        guard !conjPerson.isEmpty else {
            return nil
        }
        self.conjCree = conjCree
        self.conjEnglish = conjEnglish
        self.conjPerson = conjPerson
    }
    
}
