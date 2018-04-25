//
//  ViewController.swift
//  Cree Conjugation
//
//  Created by Wolfgang on 2018-02-21.
//  Copyright © 2018 nistosap. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
//MARK: properties

    @IBOutlet weak var creeText: UITextField!//3rd person
    @IBOutlet weak var englishText: UITextField!
    @IBOutlet weak var sampleText: UILabel!
    @IBOutlet weak var pickerType: UIPickerView!
    @IBOutlet weak var imperativeText: UITextField!
    @IBOutlet weak var textViewSample: UITextView!
    @IBOutlet weak var delButton: UIButton!
    @IBOutlet weak var saveButton: UIBarButtonItem!
   
    
    // cree verb types to choose
    var verbTypes = ["Pick Verb Type", "VAI","VTA","VTI"]
    var verb: CreeVerb?
    var editRow: Int?
    var filterRow:Int?
    var deleteBool = Bool()
    var boolN = Bool()
    var rootVerb = String()
    
    var attrPrefix = [String]()//bold ni(t),ki(t),preverb
    var attrSuffix = [String]()//bold
    var attrVerb = [String]()//plain
    var attrEnglish = [String]()//plain
    
    let verbSelf = ["myself","yourself","her/himself","her/himself","ourselves","ourselves","yourselves","themselves"]
    let verbAm = ["am","are","is","is","are","are","are","are"]
    //people used in conjugations and ther pronouns: 1st person = I, 2nd person - you, etc
    let people = ["1", "2", "3","3'/3'P", "1P", "21", "2P", "3P"]
    let pronouns = ["I", "You", "She/He", "Her/His/Their__", "We (exc)", "We (inc)", "You (pl)", "They"]
    let i3VTAo = ["me", "you", "by her/him","by her/him",  "us(exc)", "us(inc)", "you(pl)", "by her/him"]
    //indicative mode, for sample conjugation
    let indVAIy = ["n","n","w","yiwa","nân","naw","nâwâw","wak"]
    let indVTIy = ["n","n","m","miyiwa","nân","naw","nâwâw","mwak"]
    let indVTAy = ["âw","âw","êw","êyiwa","ânân","ânaw","âwâw","êwak"]

    //string for conjugation
    //var sampleConj:[conjVerbs] = []
    var boolVTIsuffix = Bool() // is VTI verb 1/t or 2/f
    var pickID = Int()//get row picked from picker
    let titleColor = UIColor(red:98/255, green: 152/255, blue:83/255, alpha:1)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background")!)
        navigationController?.navigationBar.barTintColor = titleColor
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]

        
        deleteBool = false
        creeText.delegate = self
        englishText.delegate = self
        pickerType.delegate = self
        pickerType.dataSource = self
       
        if let verb = verb {
            navigationItem.title = "Edit Verb"
            creeText.text = verb.cree
            englishText.text = verb.english
            imperativeText.text = verb.imperative
            switch verb.type {
            case "VAI":
                pickID = 1
            case "VTA":
                pickID = 2
            case "VTI":
                pickID = 3
            default:
                break
            }
            pickerType.selectRow(pickID, inComponent: 0, animated: true)
            delButton.isHidden = false
            delButton.setTitleColor(UIColor.white, for: .normal)
            delButton.backgroundColor = titleColor
            delButton.layer.cornerRadius = 8
            rootVerb = getRootVerb(theVerb:verb.cree, theType:pickID)
            enableConjugation()
        } else {
            delButton.isHidden = true
            editRow = -1
            
        }
        
        updateSaveButton()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//MARK: picker type
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return verbTypes.count
    }


    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        
        let myTitle = NSAttributedString(string: verbTypes[row], attributes: [NSForegroundColorAttributeName:UIColor.white])
        return myTitle
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pickID = row
        if pickID == 0 {
            let theText = NSMutableAttributedString()
            textViewSample.attributedText = theText
            imperativeText.text = ""
        }
        if !((creeText.text?.isEmpty)!) && (pickID > 0) {
            imperativeText.text = getImperative(theVerb:(creeText.text)!, theType: pickID)
        }
        
        enableConjugation()
        updateSaveButton()
    }
    
//MARK: text field
    func textFieldDidBeginEditing(_ textField: UITextField) {
        saveButton.isEnabled = false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        creeText.resignFirstResponder()
        englishText.resignFirstResponder()
        imperativeText.resignFirstResponder()
       
        if !(creeText.text?.isEmpty)! {
            let lowercaseEnglish = creeText.text?.lowercased()
            creeText.text = lowercaseEnglish?.replacingOccurrences(of: "e", with: "ê")
        }
        if !((creeText.text?.isEmpty)!) && (pickID > 0) {
            imperativeText.text = getImperative(theVerb:(creeText.text)!, theType: pickID)
        }
       
        enableConjugation()
        updateSaveButton()
        return true
    }
    
   func textFieldDidEndEditing(_ textField: UITextField) {
        if !((creeText.text?.isEmpty)!) && (pickID > 0) {
            imperativeText.text = getImperative(theVerb:(creeText.text)!, theType: pickID)
        }
    
        enableConjugation()
        updateSaveButton()
    }

//MARK: Conjugation
    private func prepareVerb(theVerb: String, theType:String) -> String {
        var eVerb = String()
        if theVerb.characters.count <= 1 {
            return theVerb
        }
        
        let eIndex = theVerb[theVerb.index(before: theVerb.endIndex)]
        
        switch theType {
        case "VAI": //VAI verb ending 3rd person is w
            //for VAI verb, remove last e, add a, for 1,2,1p,21,2p
            switch eIndex {
            case "ê","e","ē":
                eVerb = theVerb.substring(to: theVerb.index(before:theVerb.endIndex)) + "â"
            default:
                eVerb = theVerb
            }
            
            
        case "VTI": //VTI verbs ending is either w or m
            //for VTI verbs remove last 'a' and change to ê for 1,2,1p,21,2p
            if eIndex == "a" {
                eVerb = theVerb.substring(to: theVerb.index(before:theVerb.endIndex)) + "ê"
                boolVTIsuffix = true
            } else {
                eVerb = theVerb
                boolVTIsuffix = false
            }
        case "VTA": //VTA ending is êw

                eVerb = theVerb
        default:
            eVerb = theVerb
        }
        
        return eVerb
    }
    //add t to verbs starting with vowels
    private func addT(theVerb: String, thePrefix: String) -> String {
        var tVerb:String = ""
        var tempConvert:[Character] = []
            for char in theVerb.characters {
                tempConvert.append(char)// fil tempConvert with all characters
            }
            switch tempConvert[0] {
            case "a","â","ā","ê","e","ē","i","î","ī","o","ô","ō":
                tVerb = thePrefix + "t"
            default:
                tVerb = thePrefix
            }
        return tVerb
    }
    
    private func conjugation(theVerb: String, theEnglish:String, theType:String){
        attrEnglish = []
        attrSuffix = []
        attrVerb = []
        attrPrefix = []
        var temp:String = ""
        var indVTIsuffix:[String] = []
        var tVerb2 = String()
        var dirObject = String()
        
        if checkforSO(checkEnglish: theEnglish) {
            dirObject = ""
        } else {
            dirObject = " s.o."
        }
        temp = prepareVerb(theVerb: theVerb, theType: theType)
       
        switch theType{
        case "VAI": //VAI
            
            for (index, _) in people.enumerated() {
                
                switch index {
               
                case 0,4://1, 1p
                    tVerb2 = addT(theVerb: temp, thePrefix: "ni")
                    attrPrefix.append(tVerb2)
                    attrVerb.append(temp)
                    attrSuffix.append(indVAIy[index])
                    attrEnglish.append(pronouns[index] + " " + checkForSelf(checkEnglish:theEnglish, index:index))
  
                case 1, 5, 6://2,21,2p
                    tVerb2 = addT(theVerb: temp, thePrefix: "ki")
                    attrPrefix.append(tVerb2)
                    attrVerb.append(temp)
                    attrSuffix.append(indVAIy[index])
                    attrEnglish.append(pronouns[index] + " " + checkForSelf(checkEnglish:theEnglish, index:index))
 
                case 2: //3
                    
                    attrPrefix.append("")
                    attrVerb.append(rootVerb)
                    attrSuffix.append(indVAIy[index])
                    attrEnglish.append(pronouns[index] + " " + checkForSelf(checkEnglish:theEnglish, index:index))

                case 7: //3p
                    attrPrefix.append("")
                   
                    attrSuffix.append(indVAIy[index])
                    attrEnglish.append(pronouns[index] + " " + checkForSelf(checkEnglish:theEnglish, index:index))
                     if boolN {
                        attrVerb.append(creeText.text!)
                        
                    } else {
                      
                        attrVerb.append(rootVerb)
                    }

                default://3'(p)
                    attrPrefix.append("")
                    attrVerb.append(rootVerb)
                    attrSuffix.append(indVAIy[index])
                    attrEnglish.append(pronouns[index] + " " + checkForSelf(checkEnglish:theEnglish, index:index))

                    
                }
               
            }
            
        case "VTA": //VTA
            for (index, _) in people.enumerated() {
                switch index {
                case 0,4://1, 1p
                    tVerb2 = addT(theVerb: temp, thePrefix: "ni")
                    attrPrefix.append(tVerb2)
                    attrVerb.append(temp)
                    attrSuffix.append(indVTAy[index])
                    attrEnglish.append(pronouns[index] + " " + checkForSelf(checkEnglish:theEnglish, index:index) + dirObject)

                    
                case 1, 5, 6://2,21,2p
                    tVerb2 = addT(theVerb: temp, thePrefix: "ki")
                    attrPrefix.append(tVerb2)
                    attrVerb.append(temp)
                    attrSuffix.append(indVTAy[index])
                    attrEnglish.append(pronouns[index] + " " + checkForSelf(checkEnglish:theEnglish, index:index) + dirObject)

                    
                default://3,3'(p),3p
                    attrPrefix.append("")
                    attrVerb.append(temp)
                    attrSuffix.append(indVTAy[index])
                    attrEnglish.append(pronouns[index] + " " + checkForSelf(checkEnglish:theEnglish, index:index) + dirObject)

                    
                }
                            }
            
        case "VTI": //VTI
            if boolVTIsuffix {
                indVTIsuffix = indVTIy
                
            } else {
                indVTIsuffix = indVAIy
            }
            for (index, _) in people.enumerated() {
                switch index {
                case 0,4://1, 1p
                    tVerb2 = addT(theVerb: temp, thePrefix: "ni")
                    attrPrefix.append(tVerb2)
                    attrVerb.append(temp)
                    attrSuffix.append(indVTIsuffix[index])
                    attrEnglish.append(pronouns[index] + " " + checkForSelf(checkEnglish:theEnglish, index:index) + " something(s)")

                    
                case 1, 5, 6://2,21,2p
                    tVerb2 = addT(theVerb: temp, thePrefix: "ki")
                    attrPrefix.append(tVerb2)
                    attrVerb.append(temp)
                    attrSuffix.append(indVTIsuffix[index])
                    attrEnglish.append(pronouns[index] + " " + checkForSelf(checkEnglish:theEnglish, index:index) + " something(s)")
 
                default://3,3'(p),3p
                    
                    attrPrefix.append("")
                    attrVerb.append(theVerb)
                    attrSuffix.append(indVTIsuffix[index])
                    attrEnglish.append(pronouns[index] + " " + checkForSelf(checkEnglish:theEnglish, index:index) + " something(s)")
           
                }
               
            }
            
        default:
            //0 no verb picked
            break
        }
    }
    
    private func enableConjugation(){
       // sampleConj = []
        let ctext = creeText.text ?? ""
        let etext = englishText.text ?? ""
        if !(ctext.isEmpty) && !(etext.isEmpty) && (pickID > 0) {
            conjugation(theVerb: rootVerb, theEnglish: etext.lowercased(), theType: verbTypes[pickID])
            fillText()
        }
        
    }
    
  
    //MARK: private
    private func updateSaveButton(){
        let text1 = creeText.text ?? ""
        let text2 = englishText.text ?? ""
        if !(text1.isEmpty) && !(text2.isEmpty) && (pickID > 0) {
            saveButton.isEnabled = true
            imperativeText.isEnabled = true
        } else {
            saveButton.isEnabled = false
            imperativeText.isEnabled = false
        }
        
    }
    private func checkforSO(checkEnglish:String) -> Bool {
        let lowercaseEnglish = checkEnglish.lowercased()
        if lowercaseEnglish.range(of: "s.o.") != nil {
            return true
        }
        return false
    }
    private func checkForSelf(checkEnglish:String, index:Int) -> String {
        var checked = String()
        var lowercaseEnglish = String()
         lowercaseEnglish = checkEnglish.lowercased()
        //check for self and conjugate it
        if lowercaseEnglish.range(of: "self") != nil {
            checked = lowercaseEnglish.replacingOccurrences(of: "self", with: verbSelf[index])
        } else {
            checked = checkEnglish
        }
        
        if lowercaseEnglish.range(of: "s.o.") != nil {
            checked = checked.replacingOccurrences(of: "s.o.", with: "her/him")
            
        } 
        
        //check for am and conjugate it
        if !(checkEnglish.characters.count < 2) {
            let secIndex = checkEnglish.index(checkEnglish.startIndex, offsetBy: 2)
            lowercaseEnglish = checkEnglish.lowercased().substring(to: secIndex)
            if (lowercaseEnglish == "am"){
                if checkEnglish.characters.count <= 2 {
                    checked = "\(verbAm[index])"
                } else {
                    checked = "\(verbAm[index])\(checked[secIndex...checked.index(before:checked.endIndex)])"
                }
            }
        }

        return checked
    }
    //fill the sample text with indicative conjugation
    private func fillText(){
        let theText = NSMutableAttributedString()
        theText.deleteCharacters(in: NSMakeRange(0, theText.length))
        
        let attrCree = [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 18)]
        let attrPlain = [NSFontAttributeName: UIFont.systemFont(ofSize: 18)]
        let attrEng = [NSFontAttributeName: UIFont.systemFont(ofSize: 16)]
        for (index, person) in people.enumerated(){
            let atPerson = NSMutableAttributedString(string: "\(person): ")
            atPerson.addAttributes(attrPlain, range: NSMakeRange(0, atPerson.length))
            theText.append(atPerson)
            
            let atPrefix = NSMutableAttributedString(string: "\(attrPrefix[index])")
            atPrefix.addAttributes(attrCree, range: NSMakeRange(0, atPrefix.length))
            theText.append(atPrefix)
            
            let atVerb = NSMutableAttributedString(string: "\(attrVerb[index])")
            atVerb.addAttributes(attrPlain, range: NSMakeRange(0, atVerb.length))
            theText.append(atVerb)
           // let atSuffix = NSMutableAttributedString()
            if boolN {
                if index == 2 {
                    let prePrefix = NSMutableAttributedString(string: " - ")
                    prePrefix.addAttributes(attrPlain, range: NSMakeRange(0, prePrefix.length))
                    theText.append(prePrefix)
                    let verbtoConvert = "\(attrPrefix[index])\(attrVerb[index])"
                    let syllabics = NSMutableAttributedString(string: "\(convertSyllabics(Cree:verbtoConvert))")
                    let attrSyll = [NSFontAttributeName: UIFont(name: "Saulteaux-Syllabic", size: 18)!]
                    syllabics.addAttributes(attrSyll, range: NSMakeRange(0, syllabics.length))
                    theText.append(syllabics)
                } else if index == 7 {
                    let atSuffix = NSMutableAttributedString(string: "\(attrSuffix[index])")
                    atSuffix.addAttributes(attrCree, range: NSMakeRange(0, atSuffix.length))
                    theText.append(atSuffix)
                    let prePrefix = NSMutableAttributedString(string: " - ")
                    prePrefix.addAttributes(attrPlain, range: NSMakeRange(0, prePrefix.length))
                    theText.append(prePrefix)
                    
                    let verbtoConvert = "\(attrPrefix[index])\(attrVerb[index])\(attrSuffix[index])"
                    let syllabics = NSMutableAttributedString(string: "\(convertSyllabics(Cree:verbtoConvert))")
                    let attrSyll = [NSFontAttributeName: UIFont(name: "Saulteaux-Syllabic", size: 18)!]
                    syllabics.addAttributes(attrSyll, range: NSMakeRange(0, syllabics.length))
                    theText.append(syllabics)
                } else {
                    let atSuffix = NSMutableAttributedString(string: "i\(attrSuffix[index])")
                    atSuffix.addAttributes(attrCree, range: NSMakeRange(0, atSuffix.length))
                    theText.append(atSuffix)
                    let prePrefix = NSMutableAttributedString(string: " - ")
                    prePrefix.addAttributes(attrPlain, range: NSMakeRange(0, prePrefix.length))
                    theText.append(prePrefix)
                    
                    let verbtoConvert = "\(attrPrefix[index])\(attrVerb[index])i\(attrSuffix[index])"
                    let syllabics = NSMutableAttributedString(string: "\(convertSyllabics(Cree:verbtoConvert))")
                    let attrSyll = [NSFontAttributeName: UIFont(name: "Saulteaux-Syllabic", size: 18)!]
                    syllabics.addAttributes(attrSyll, range: NSMakeRange(0, syllabics.length))
                    theText.append(syllabics)
                }

            } else {
                let atSuffix = NSMutableAttributedString(string: "\(attrSuffix[index])")
                atSuffix.addAttributes(attrCree, range: NSMakeRange(0, atSuffix.length))
                theText.append(atSuffix)
                let prePrefix = NSMutableAttributedString(string: " - ")
                prePrefix.addAttributes(attrPlain, range: NSMakeRange(0, prePrefix.length))
                theText.append(prePrefix)
                
                let verbtoConvert = "\(attrPrefix[index])\(attrVerb[index])\(attrSuffix[index])"
                let syllabics = NSMutableAttributedString(string: "\(convertSyllabics(Cree:verbtoConvert))")
                let attrSyll = [NSFontAttributeName: UIFont(name: "Saulteaux-Syllabic", size: 18)!]
                syllabics.addAttributes(attrSyll, range: NSMakeRange(0, syllabics.length))
                theText.append(syllabics)
            }
            
            
            if (pickID == 1) || (pickID == 3) { //VAI, VTI
                if index == 5 { //nânaw nâ is optional
                    let prePrefix = NSMutableAttributedString(string: "\n")
                    prePrefix.addAttributes(attrPlain, range: NSMakeRange(0, prePrefix.length))
                    theText.append(prePrefix)
                    
                    let atPrefix = NSMutableAttributedString(string: "\(attrPrefix[index])")
                    atPrefix.addAttributes(attrCree, range: NSMakeRange(0, atPrefix.length))
                    theText.append(atPrefix)
                    
                    let atVerb = NSMutableAttributedString(string: "\(attrVerb[index])")
                    atVerb.addAttributes(attrPlain, range: NSMakeRange(0, atVerb.length))
                    theText.append(atVerb)

                    let atSuffix = NSMutableAttributedString(string: "nâ\(attrSuffix[index])")
                    atSuffix.addAttributes(attrCree, range: NSMakeRange(0, atSuffix.length))
                    theText.append(atSuffix)
                    
                    let prePrefix2 = NSMutableAttributedString(string: " - ")
                    prePrefix2.addAttributes(attrPlain, range: NSMakeRange(0, prePrefix2.length))
                    theText.append(prePrefix2)
                    
                    let verbtoConvert = "\(attrPrefix[index])\(attrVerb[index])nâ\(attrSuffix[index])"
                    let syllabics = NSMutableAttributedString(string: "\(convertSyllabics(Cree:verbtoConvert))")
                    let attrSyll = [NSFontAttributeName: UIFont(name: "Saulteaux-Syllabic", size: 18)!]
                    syllabics.addAttributes(attrSyll, range: NSMakeRange(0, syllabics.length))
                    theText.append(syllabics)
                }
                
            }
            
            
            if boolN {
                if index == 2 {
                    let prePrefix = NSMutableAttributedString(string: "\n")
                    prePrefix.addAttributes(attrPlain, range: NSMakeRange(0, prePrefix.length))
                    theText.append(prePrefix)
                    
                    let atPrefix = NSMutableAttributedString(string: "\(attrPrefix[index])")
                    atPrefix.addAttributes(attrCree, range: NSMakeRange(0, atPrefix.length))
                    theText.append(atPrefix)
                    
                    let atVerb = NSMutableAttributedString(string: "\(attrVerb[index])")
                    atVerb.addAttributes(attrPlain, range: NSMakeRange(0, atVerb.length))
                    theText.append(atVerb)
                    
                    let atSuffix = NSMutableAttributedString(string: "i\(attrSuffix[index])")
                    atSuffix.addAttributes(attrCree, range: NSMakeRange(0, atSuffix.length))
                    theText.append(atSuffix)
                   
                    let prePrefix1 = NSMutableAttributedString(string: " - ")
                    prePrefix1.addAttributes(attrPlain, range: NSMakeRange(0, prePrefix1.length))
                    theText.append(prePrefix1)
                    
                    let verbtoConvert = "\(attrPrefix[index])\(attrVerb[index])i\(attrSuffix[index])"
                    let syllabics = NSMutableAttributedString(string: "\(convertSyllabics(Cree:verbtoConvert))")
                    let attrSyll = [NSFontAttributeName: UIFont(name: "Saulteaux-Syllabic", size: 18)!]
                    syllabics.addAttributes(attrSyll, range: NSMakeRange(0, syllabics.length))
                    theText.append(syllabics)
                    
                }
                

                
            }
            
            let atEnglish = NSMutableAttributedString(string: "\n\(attrEnglish[index])\n")
            atEnglish.addAttributes(attrEng, range: NSMakeRange(0, atEnglish.length))
            theText.append(atEnglish)

            
        }
        textViewSample.attributedText = theText
        self.textViewSample.scrollRangeToVisible(NSMakeRange(0,0))
        
    }
    
    //get the imperative//root verb
    private func getImperative(theVerb:String, theType:Int) -> String {
        // if too short, return the short word
        if theVerb.characters.count <= 1 {
            rootVerb = theVerb
            return theVerb
        }
        var imperativeVerb = String()
        let tempVerb:String = theVerb.lowercased()
        var count = Int()
        switch theType {// get root verb
        case 1: //VAI
            let eIndex = tempVerb[tempVerb.index(before: tempVerb.endIndex)]
            switch eIndex {
            case "n":
                boolN = true
                rootVerb = theVerb
                imperativeVerb = theVerb + "i"
            default:
                boolN = false
                rootVerb = tempVerb.substring(to: tempVerb.index(before:tempVerb.endIndex))
                imperativeVerb = tempVerb.substring(to: tempVerb.index(before:tempVerb.endIndex))
            }
            
        case 2: //VTA
            count = Int(tempVerb.characters.count)-3
            let startI = tempVerb.startIndex
            let endI = tempVerb.index(tempVerb.startIndex, offsetBy: count)
            let range = startI...endI
            //remove êw for root
            rootVerb = tempVerb[range]
            let eIndex = rootVerb[rootVerb.index(before: rootVerb.endIndex)]
            //if ends in t, imperative ends in s
            if eIndex == "t" {
                //change ending to t to s in 1,1P cases
                count = Int(rootVerb.characters.count)-2
                let startI = rootVerb.startIndex
                let endI = rootVerb.index(rootVerb.startIndex, offsetBy: count)
                let range = startI...endI
                imperativeVerb = rootVerb[range] + "s"
            } else {
                imperativeVerb = rootVerb
            }
        case 3: //VTI
            rootVerb = tempVerb.substring(to: tempVerb.index(before:tempVerb.endIndex))
            imperativeVerb = tempVerb.substring(to: tempVerb.index(before:tempVerb.endIndex))
        default:
            break
        }
        return imperativeVerb
    }
    private func getRootVerb(theVerb:String, theType:Int) -> String {
        // if too short, return the short word
        if theVerb.characters.count <= 1 {
            return theVerb
        }
        
        var tempVerb:String = theVerb.lowercased()
        var count = Int()
        
        switch theType {// get root verb
        case 1: //VAI
            let eIndex = tempVerb[tempVerb.index(before: tempVerb.endIndex)]
            switch eIndex {
            case "n":
                boolN = true
                tempVerb = theVerb
                
            default:
                boolN = false
                tempVerb = tempVerb.substring(to: tempVerb.index(before:tempVerb.endIndex))
                
            }
            
        case 2: //VTA
            
            count = Int(tempVerb.characters.count)-3
            let startI = tempVerb.startIndex
            let endI = tempVerb.index(tempVerb.startIndex, offsetBy: count)
            let range = startI...endI
            //remove êw for root
            tempVerb = tempVerb[range]
            
        case 3: //VTI
            tempVerb = tempVerb.substring(to: tempVerb.index(before:tempVerb.endIndex))
            
        default:
            break
        }
        return tempVerb
    }
    
    //MARK: Syllabics
    private func convertSyllabics(Cree:String)->String{
        var convertedText = String() //syllabics to return
        var tempConvert:[Character] = [] // characters in the string
        var i = 0
        var nextI = Int()
        var sCount = Int()
        var boolW = Bool()
        var boolTH = Bool()
        convertedText = Cree.lowercased()
        var strLength = convertedText.characters.count - 1
        let syllabics1 = ["z","Z","q","Q","a","A","1","b","B","t","T","g","G","5",
                          "v","V","r","R","f","F","4","n","N","y","Y","h","H","6",
                          "m","M","u","U","j","J","7","x","X","w","W","s","S","2",
                          ",","<","i","I","k","K","8","c","C","e","E","d","D","3",
                          ".",">","o","O","l","L","9","/","?","p","P",";",":","0"]
        let syllabics2 = ["!","=","@","#","$","%","^","&","*","(","[","{",")"]
        
        for char in convertedText.characters {
            if !((char == "-") || (char == " ") || (char == "(") || (char == ")")){
                tempConvert.append(char)// fil tempConvert with all characters
            }  else {
                strLength = strLength - 1
            }
            
        }
        i = 0
        convertedText = ""
        for _ in 0...strLength {
            sCount = 0
            if i <= strLength{
                switch tempConvert[i] {
                    case "c":
                        if ((i+1) > strLength) { //last character
                            convertedText = convertedText + syllabics2[5]
                            i += 1
                            boolW = false
                        } else { //another character after
                            
                            if String(tempConvert[i+1]) == "w" { //have to get next vowel first and  then convert
                                boolW = true
                                nextI = i+2
                                if nextI > strLength { // if no third charcter then add character c
                                    nextI = i+1
                                    boolW = false
                                } else {
                                    sCount = 7
                                }
                            } else {
                                boolW = false
                                nextI = i+1
                                sCount = 7
                            }
                            
                            switch tempConvert[nextI] {
                            case "a":
                                convertedText = convertedText + syllabics1[sCount]
                                i += 2
                            case "â","ā":
                                sCount = sCount + 1
                                convertedText = convertedText + syllabics1[sCount]
                                i += 2
                            case "i":
                                sCount = sCount + 2
                                convertedText = convertedText + syllabics1[sCount]
                                i += 2
                            case "î","ī":
                                sCount = sCount + 3
                                convertedText = convertedText + syllabics1[sCount]
                                i += 2
                            case "o":
                                sCount = sCount + 4
                                convertedText = convertedText + syllabics1[sCount]
                                i += 2
                            case "ô","ō":
                                sCount = sCount + 5
                                convertedText = convertedText + syllabics1[sCount]
                                i += 2
                            case "ê","ē","e":
                                sCount = sCount + 6
                                convertedText = convertedText + syllabics1[sCount]
                                i += 2
                            default: //next letter is not a vowel
                               convertedText = convertedText + syllabics2[5]
                               i += 1
                               boolW = false
                            }
                        }
                        if boolW {
                            convertedText = convertedText + syllabics2[0]
                            boolW = false
                            i += 1
                        }
                    
                    case "h": //h or hk,
                        if ((i + 1) == strLength) {
                            if String(tempConvert[i+1]) == "k" {
                                convertedText = convertedText + syllabics2[10]
                                 i += 2
                            } else {
                                convertedText = convertedText + syllabics2[11]
                                 i += 1
                            }
                           
                        } else {
                            convertedText = convertedText + syllabics2[11]
                            i += 1
                        }
                    
                    case "k":
                        if ((i+1) > strLength) { //last character
                           
                            convertedText = convertedText + syllabics2[4]
                            i += 1
                            boolW = false
                        } else { //another character after
                            
                            if String(tempConvert[i+1]) == "w" { //have to get next vowel first and  then convert
                                boolW = true
                                nextI = i+2
                                
                                if nextI > strLength { // if no vowel then add character w
                                    nextI = i+1
                                    boolW = false
                                } else {
                                    sCount = 14
                                }
                            } else {
                                boolW = false
                                nextI = i+1
                                sCount = 14
                            }
                            switch tempConvert[nextI] {
                            case "a":
                                convertedText = convertedText + syllabics1[sCount]
                                i += 2
                            case "â","ā":
                                sCount = sCount + 1
                                convertedText = convertedText + syllabics1[sCount]
                                i += 2
                            case "i":
                                sCount = sCount + 2
                                convertedText = convertedText + syllabics1[sCount]
                                i += 2
                            case "î","ī":
                                sCount = sCount + 3
                                convertedText = convertedText + syllabics1[sCount]
                                i += 2
                            case "o":
                                sCount = sCount + 4
                                convertedText = convertedText + syllabics1[sCount]
                                i += 2
                            case "ô","ō":
                                sCount = sCount + 5
                                convertedText = convertedText + syllabics1[sCount]
                                i += 2
                            case "ê","ē","e":
                                sCount = sCount + 6
                                convertedText = convertedText + syllabics1[sCount]
                                i += 2
                            default: //next letter is not a vowel

                                convertedText = convertedText + syllabics2[4]
                                
                                i += 1
                                boolW = false
                            }
                        }
                        if boolW {
                            convertedText = convertedText + syllabics2[0]
                            boolW = false
                            i += 1
                    }
                    case "m":
                        if ((i+1) > strLength) { //last character
                            convertedText = convertedText + syllabics2[6]
                            i += 1
                            boolW = false
                        } else { //another character after
                            
                            if String(tempConvert[i+1]) == "w" { //have to get next vowel first and  then convert
                                boolW = true
                                nextI = i+2
                                
                                if nextI > strLength { // if no vowel then add character w
                                    nextI = i+1
                                    boolW = false
                                } else {
                                    sCount = 21
                                }
                            } else {
                                boolW = false
                                nextI = i+1
                                sCount = 21
                            }
                            switch tempConvert[nextI] {
                            case "a":
                                convertedText = convertedText + syllabics1[sCount]
                                i += 2
                            case "â","ā":
                                sCount = sCount + 1
                                convertedText = convertedText + syllabics1[sCount]
                                i += 2
                            case "i":
                                sCount = sCount + 2
                                convertedText = convertedText + syllabics1[sCount]
                                i += 2
                            case "î","ī":
                                sCount = sCount + 3
                                convertedText = convertedText + syllabics1[sCount]
                                i += 2
                            case "o":
                                sCount = sCount + 4
                                convertedText = convertedText + syllabics1[sCount]
                                i += 2
                            case "ô","ō":
                                sCount = sCount + 5
                                convertedText = convertedText + syllabics1[sCount]
                                i += 2
                            case "ê","ē","e":
                                sCount = sCount + 6
                                convertedText = convertedText + syllabics1[sCount]
                                i += 2
                            default: //next letter is not a vowel
                                convertedText = convertedText + syllabics2[6]
                                
                                i += 1
                                boolW = false
                            }
                        }
                        if boolW {
                            convertedText = convertedText + syllabics2[0]
                            boolW = false
                            i += 1
                    }
                    case "n":
                        if ((i+1) > strLength) { //last character
                            convertedText = convertedText + syllabics2[7]
                            i += 1
                            boolW = false
                        } else { //another character after
                            let charW = String(tempConvert[i+1])
                            if charW == "w" { //have to get next vowel first and  then convert
                                boolW = true
                                nextI = i+2
                                
                                if nextI > strLength { // if no vowel then add character w
                                    
                                    nextI = i+1
                                    
                                    boolW = false
                                } else {
                                    sCount = 28
                                }
                            } else {
                                boolW = false
                                nextI = i+1
                                sCount = 28
                            }
                            switch tempConvert[nextI] {
                            case "a":
                                convertedText = convertedText + syllabics1[sCount]
                                i += 2
                            case "â","ā":
                                sCount = sCount + 1
                                convertedText = convertedText + syllabics1[sCount]
                                i += 2
                            case "i":
                                sCount = sCount + 2
                                convertedText = convertedText + syllabics1[sCount]
                                i += 2
                            case "î","ī":
                                sCount = sCount + 3
                                convertedText = convertedText + syllabics1[sCount]
                                i += 2
                            case "o":
                                sCount = sCount + 4
                                convertedText = convertedText + syllabics1[sCount]
                                i += 2
                            case "ô","ō":
                                sCount = sCount + 5
                                convertedText = convertedText + syllabics1[sCount]
                                i += 2
                            case "ê","ē","e":
                                sCount = sCount + 6
                                convertedText = convertedText + syllabics1[sCount]
                                i += 2
                            default: //next letter is not a vowel
                
                                convertedText = convertedText + syllabics2[7]
                                
                                i += 1
                                boolW = false
                            }
                        }
                        if boolW {
                            convertedText = convertedText + syllabics2[0]
                            boolW = false
                            i += 1
                    }
                    case "p":
                        if ((i+1) > strLength) { //last character
                            
                            convertedText = convertedText + syllabics2[2]
                            i += 1
                            boolW = false
                        } else { //another character after
                            
                            if String(tempConvert[i+1]) == "w" { //have to get next vowel first and  then convert
                                boolW = true
                                nextI = i+2
                                
                                if nextI > strLength { // if no vowel then add character w
                                   
                                    nextI = i+1
                                    
                                    boolW = false
                                } else {
                                    sCount = 35
                                }
                            } else {
                                boolW = false
                                nextI = i+1
                                sCount = 35
                            }
                            switch tempConvert[nextI] {
                            case "a":
                                convertedText = convertedText + syllabics1[sCount]
                                i += 2
                            case "â","ā":
                                sCount = sCount + 1
                                convertedText = convertedText + syllabics1[sCount]
                                i += 2
                            case "i":
                                sCount = sCount + 2
                                convertedText = convertedText + syllabics1[sCount]
                                i += 2
                            case "î","ī":
                                sCount = sCount + 3
                                convertedText = convertedText + syllabics1[sCount]
                                i += 2
                            case "o":
                                sCount = sCount + 4
                                convertedText = convertedText + syllabics1[sCount]
                                i += 2
                            case "ô","ō":
                                sCount = sCount + 5
                                convertedText = convertedText + syllabics1[sCount]
                                i += 2
                            case "ê","ē","e":
                                sCount = sCount + 6
                                convertedText = convertedText + syllabics1[sCount]
                                i += 2
                            default: //next letter is not a vowel
                            
                                convertedText = convertedText + syllabics2[2]
                    
                                i += 1
                                boolW = false
                            }
                        }
                        if boolW {
                            convertedText = convertedText + syllabics2[0]
                            boolW = false
                            i += 1
                    }
                    case "s":
                        if ((i+1) > strLength) { //last character
                            convertedText = convertedText + syllabics2[8]
                            i += 1
                            boolW = false
                        } else { //another character after
                            
                            if String(tempConvert[i+1]) == "w" { //have to get next vowel first and  then convert
                                boolW = true
                                nextI = i+2
                                
                                if nextI > strLength { // if no vowel then add character w
                                    
                                    nextI = i+1
                                    
                                    boolW = false
                                } else {
                                    sCount = 42
                                }
                            } else {
                                boolW = false
                                nextI = i+1
                                sCount = 42
                            }
                            switch tempConvert[nextI] {
                            case "a":
                                convertedText = convertedText + syllabics1[sCount]
                                i += 2
                            case "â","ā":
                                sCount = sCount + 1
                                convertedText = convertedText + syllabics1[sCount]
                                i += 2
                            case "i":
                                sCount = sCount + 2
                                convertedText = convertedText + syllabics1[sCount]
                                i += 2
                            case "î","ī":
                                sCount = sCount + 3
                                convertedText = convertedText + syllabics1[sCount]
                                i += 2
                            case "o":
                                sCount = sCount + 4
                                convertedText = convertedText + syllabics1[sCount]
                                i += 2
                            case "ô","ō":
                                sCount = sCount + 5
                                convertedText = convertedText + syllabics1[sCount]
                                i += 2
                            case "ê","ē","e":
                                sCount = sCount + 6
                                convertedText = convertedText + syllabics1[sCount]
                                i += 2
                            
                            default: //next letter is not a vowel
                             
                                convertedText = convertedText + syllabics2[8]
                                
                                i += 1
                                boolW = false
                            }
                        }
                        if boolW {
                            convertedText = convertedText + syllabics2[0]
                            boolW = false
                            i += 1
                    }
                    case "t":
                        if ((i+1) > strLength) { //last character
                            
                            convertedText = convertedText + syllabics2[3]
                            i += 1
                            boolW = false
                        } else { //another character after
                            
                            if String(tempConvert[i+1]) == "w" { //have to get next vowel first and  then convert
                                boolW = true
                                nextI = i+2
                                
                                if nextI > strLength { // if no vowel then add character w
                                    
                                    nextI = i+1
                                    
                                    boolW = false
                                    sCount = 49
                                } else {
                                    sCount = 49
                                }
                            } else if String(tempConvert[i+1]) == "h" {
                               
                                nextI = i+2
                                if nextI > strLength { // if no vowel then add character h
                                    
                                    nextI = i+1
                                    
                                    boolW = false
                                    sCount = 49
                                } else {
                                    sCount = 63
                                    boolTH = true
                                }
                                
                            } else {
                                boolW = false
                                nextI = i+1
                                sCount = 49
                            }
                            switch tempConvert[nextI] {
                            case "a":
                                convertedText = convertedText + syllabics1[sCount]
                                i += 2
                            case "â","ā":
                                sCount = sCount + 1
                                convertedText = convertedText + syllabics1[sCount]
                                i += 2
                            case "i":
                                sCount = sCount + 2
                                convertedText = convertedText + syllabics1[sCount]
                                i += 2
                            case "î","ī":
                                sCount = sCount + 3
                                convertedText = convertedText + syllabics1[sCount]
                                i += 2
                            case "o":
                                sCount = sCount + 4
                                convertedText = convertedText + syllabics1[sCount]
                                i += 2
                            case "ô","ō":
                                sCount = sCount + 5
                                convertedText = convertedText + syllabics1[sCount]
                                i += 2
                            case "ê","ē","e":
                                sCount = sCount + 6
                                convertedText = convertedText + syllabics1[sCount]
                                i += 2
                            
                            
                            default: //next letter is not a vowel
                                convertedText = convertedText + syllabics2[3]
                                i += 1
                                boolW = false
                                boolTH = false
                            }
                        }
                        if boolW {
                            convertedText = convertedText + syllabics2[0]
                            boolW = false
                            i += 1
                        }
                        if boolTH {
                            i += 1
                        }
                    case "w":
                        if ((i+1) > strLength) { //last character
                            convertedText = convertedText + syllabics2[1]
                            i += 1
                        } else { //another character after
                            
                            switch tempConvert[i+1] {
                            case "a":
                                convertedText = convertedText + syllabics1[0] + syllabics2[0]
                                i += 2
                            case "â","ā":
                                
                                convertedText = convertedText + syllabics1[1] + syllabics2[0]
                                i += 2
                            case "i":
                               
                                convertedText = convertedText + syllabics1[2] + syllabics2[0]
                                i += 2
                            case "î","ī":
                                
                                convertedText = convertedText + syllabics1[3] + syllabics2[0]
                                i += 2
                            case "o":
                                
                                convertedText = convertedText + syllabics1[4] + syllabics2[0]
                                i += 2
                            case "ô","ō":
                                
                                convertedText = convertedText + syllabics1[5] + syllabics2[0]
                                i += 2
                            case "ê","ē","e":
                                
                                convertedText = convertedText + syllabics1[6] + syllabics2[0]
                                i += 2
                            default: //move to next consonant
                                convertedText = convertedText + syllabics2[1]
                                i += 1
                            }
                        }
                    
                    case "y":
                        if ((i+1) > strLength) { //last character
                            
                            convertedText = convertedText + syllabics2[9]
                            
                            i += 1
                            boolW = false
                        } else { //another character after
                            
                            if String(tempConvert[i+1]) == "w" { //have to get next vowel first and  then convert
                                boolW = true
                                nextI = i+2
                                
                                if nextI > strLength { // if no vowel then add character w
                                    
                                    nextI = i+1
                                    
                                    boolW = false
                                } else {
                                    sCount = 56
                                }
                            } else {
                                boolW = false
                                nextI = i+1
                                sCount = 56
                            }
                            switch tempConvert[nextI] {
                            case "a":
                                convertedText = convertedText + syllabics1[sCount]
                                i += 2
                            case "â","ā":
                                sCount = sCount + 1
                                convertedText = convertedText + syllabics1[sCount]
                                i += 2
                            case "i":
                                sCount = sCount + 2
                                convertedText = convertedText + syllabics1[sCount]
                                i += 2
                            case "î","ī":
                                sCount = sCount + 3
                                convertedText = convertedText + syllabics1[sCount]
                                i += 2
                            case "o":
                                sCount = sCount + 4
                                convertedText = convertedText + syllabics1[sCount]
                                i += 2
                            case "ô","ō":
                                sCount = sCount + 5
                                convertedText = convertedText + syllabics1[sCount]
                                i += 2
                            case "ê","ē","e":
                                sCount = sCount + 6
                                convertedText = convertedText + syllabics1[sCount]
                                i += 2
                            default: //next letter is not a vowel
                           
                                convertedText = convertedText + syllabics2[9]
                                
                                i += 1
                                boolW = false
                            }
                        }
                        if boolW {
                            convertedText = convertedText + syllabics2[0]
                            boolW = false
                            i += 1
                        }
                    case "a":
                        convertedText = convertedText + syllabics1[0]
                        i += 1
                    case "â","ā":
                        convertedText = convertedText + syllabics1[1]
                        i += 1
                    case "i":
                        convertedText = convertedText + syllabics1[2]
                        i += 1
                    case "î","ī":
                        convertedText = convertedText + syllabics1[3]
                        i += 1
                    case "o":
                        convertedText = convertedText + syllabics1[4]
                        i += 1
                    case "ô","ō":
                        convertedText = convertedText + syllabics1[5]
                        i += 1
                    case "ê","ē","e":
                        convertedText = convertedText + syllabics1[6]
                        i += 1
                    default:
                        break
                    
                }
            }
            
        }
        
        return convertedText
    }

    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        let dbutton = sender as? UIButton
        if dbutton === delButton  {
            deleteBool = true
        }
        
        let cree = creeText.text ?? ""
        let english = englishText.text ?? ""
        let type = verbTypes[pickID]
        let imperative = imperativeText.text ?? ""
        verb = CreeVerb(cree: cree, english: english, type: type, imperative: imperative)
        
    }
    
    //MARK: action
    
    @IBAction func cancelButton(_ sender: UIBarButtonItem) {
        let isPresenting = presentingViewController is UINavigationController
        if isPresenting {
            dismiss(animated: true, completion: nil)
        } else  if let owningNavController = navigationController {
            owningNavController.popViewController(animated: true)
        } else {
            fatalError("no nav controller")
        }
    }

}

