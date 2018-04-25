//
//  CreeVerbs.swift
//  Cree Verbs
//
//  Created by Wolfgang on 2018-02-13.
//  Copyright © 2018 nistosâp. All rights reserved.
//

import UIKit

class CreeVerb: NSObject, NSCoding {
    //MARK: Properties
    var cree: String
    var english: String
    var type: String
    var imperative: String
    //var qualifier: String
    
    //MARK:Initialization
    init?(cree:String, english:String,type:String, imperative:String){
        guard !cree.isEmpty else {
            return nil
        }
        guard !english.isEmpty else {
            return nil
        }
        guard !type.isEmpty else {
            return nil
        }
        guard !imperative.isEmpty else {
            return nil
        }
        self.cree = cree
        self.english = english
        self.type = type
        self.imperative = imperative
    }
    //MARK: Archiving Paths
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("verbs")
    
    //MARK: types
    struct PropertyKeys{
        static let cree = "cree"
        static let english = "english"
        static let type = "type"
        static let imperative = "imperative"
    }
    
    //MARK: nscoding
    func encode(with aCoder: NSCoder) {
        aCoder.encode(cree, forKey: PropertyKeys.cree)
        aCoder.encode(english, forKey: PropertyKeys.english)
        aCoder.encode(type, forKey: PropertyKeys.type)
        aCoder.encode(imperative, forKey:PropertyKeys.imperative)
        
    }
    required convenience init?(coder aDecoder: NSCoder){
        guard let cree = aDecoder.decodeObject(forKey: PropertyKeys.cree) as? String else {
            fatalError("could not decode cree verb")
            return nil
        }
        guard let english = aDecoder.decodeObject(forKey: PropertyKeys.english) as? String else {
            fatalError("could not decode english")
            return nil
        }
        guard let type = aDecoder.decodeObject(forKey: PropertyKeys.type) as? String else {
            fatalError("could not decode type")
            return nil
        }
        guard let imperative = aDecoder.decodeObject(forKey: PropertyKeys.imperative) as? String else {
            fatalError("could not decode imperative")
            return nil
        }
        self.init(cree:cree, english:english, type:type, imperative:imperative)
    }
    
}
