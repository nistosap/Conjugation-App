//
//  DisplayViewController.swift
//  Cree Conjugation
//
//  Created by Wolfgang on 2018-03-05.
//  Copyright © 2018 nistosap. All rights reserved.
//

import UIKit

class DisplayViewController: UIViewController,UIPickerViewDelegate, UIPickerViewDataSource {
//MARK: properties
    

    @IBOutlet weak var pickPreverb: UIPickerView!
    @IBOutlet weak var txtConj: UITextView!
    @IBOutlet weak var pluralButton: UIButton!
    
    @IBOutlet weak var bImperative: UIButton!
    @IBOutlet weak var bIndicative: UIButton!
    @IBOutlet weak var bConjunct: UIButton!
    @IBOutlet weak var bInverse: UIButton!
    @IBOutlet weak var bYou: UIButton!
    
    var boolPlural = Bool() //is the verb plural only VTA verbs are plural
    var boolInv = Bool() //if you is inverse, true or else direct false
    var strMode:String = "" //Imp, Ind, Con, Inv, You me,
    var boolVTIsuffix = Bool() //what suffixes for vti verb do we use t=vti f = vai
    var iVerb = Int() //what verb is being conjugated VTA1,VTA2,VTA3,VTA4
    var invSuff = String() //suffix for VTA verbs
    var vType = String() //get number of verb type for VTA and VTI
    var vaiVerb = String() //strip off ending and se it to conjugate
    var boolN = Bool()
    var rootVerb = String()
    //preverbs
    var preVerbs = ["Add a preverb", "ati", "kakwê", "kihci","kîmôci","maci","mâmawi","matwê","mâci","mâwaci","mâyi","mistahi","misi","mitoni","miyo","nihtâ","nisihkâci","nitawi","nôhtê","papâmi","papâsi","pê","pêci","pêyâhtaki","pêyako","pisci","pôni","sâpo","sôhki","yôski"]
    var preVerb_e = ["start to","try to", "greatly","secretly","evilly","together with a group","loudly","begin to","extremely","badly","greatly","greatly","very/much/well","good", "competently","slowly","go and","want to","travel around","hurriedly","come and","come and","carefully","alone","accidentally","stopped","thoroughly","using great effort","softly"]
//passed verb
    var verb:CreeVerb?//pass the verb to conjugate
    var row:Int? //what row from verbList to show/edit
    var filterRow:Int? //what row from filtered list

    /* imp - imperative or commands
     ind - indicative - present tense statement
     con - conjunct as I
     fut - future conditional if/when I
     inv - Inverse VTA verbs
     dir - direct mode VTA verbs
     pl - plural
     */
    let verbSelf = ["myself","yourself","her/himself","her/himself","ourselves","ourselves","yourselves","themselves"]
    let verbAm = ["am","are","is","is","are","are","are","are"]
    let impPeople = ["2", "2P", "21"]
    let impPronouns = ["You", "You (pl)", "Let's (inc)"]
    let people = ["1", "2", "3", "3'/3'P", "1P", "21", "2P", "3P"]
    let pronouns = ["I", "you", "she/he", "her/his/their__", "we (exc)", "we (inc)", "you (pl)", "they"]
    
    let impVAI = ["", "k","tân","hkan", "hkêk", "hkahk"]
    
    let indVAI = ["n","n","w","yiwa","nân","naw","nâwâw","wak"]
    let conVAI = ["yân", "yan", "t", "yit", "yâhk", "yahk", "yêk", "cik"]
    let futVAI = ["yâni", "yani", "ci", "yici", "yâhki", "yahko", "yêko", "twâwi"]
    
    let impVTI = ["", "mok","tân","mohkan", "mohkêk", "mohkahk"]
    let indVTI = ["n","n","m","miyiwa","nân","naw","nâwâw","mwak"]
    let conVTI = ["mân", "man", "hk", "miyit", "mâhk", "mahk", "mêk", "hkik"]
    let futVTI = ["mâni", "mani", "hki", "miyici", "mâhki", "mahko", "mêko", "hkwâwi"]
    
    let impVTA = ["", "ihk", "âtân", "âhkan", "âhkêk", "âhkahk"]
    let indVTA = ["âw","âw","êw","êyiwa","ânân","ânaw","âwâw","êwak"]
    let conVTA = ["ak", "at", "ât", "âyit", "âyâhk", "âyahk", "âyêk", "âcik"]
    let futVTA = ["aki", "aci", "âci", "âyici", "âyâhki", "âyahko", "âyêko", "âtwâwi"]
    
    let impVTApl = ["ik", "ihkok", "âtânik", "âhkanik", "âhkêkok", "âhkahkok"]
    let indVTApl = ["âwak","âwak","êw","êyiwa","ânânak","ânawak","âwâwak","êwak"]
    let conVTApl = ["akik", "acik", "ât", "âyit", "âyâhkik", "âyahkok", "âyêkok", "âcik"]
    let futVTApl = ["akwâwi", "atwâwi", "âci", "âyici", "âyâhkwâwi", "âyahkwâwi", "âyêkwâwi", "âtwâwi"]
    
    let iImpVTA = ["in", "inân", "ik", "ihkan", "ihkâhk", "ihkêk"]
    let iIndVTA = ["in", "inân", "inâwâw"]
    let iConVTA = ["iyan", "iyâhk", "iyêk"]
    let iFutVTA = ["iyani", "iyâhki", "iyêko"]
    //you
    let iPeople = ["2","2/2P", "2P"]
    let iPronoun = ["I", "we", "I", "you", "you/you(pl)", "you(pl)"]
    let iPronouns = ["you", "you/You(pl)", "you(pl)", "me", "us", "me"]
    
    let indDirYou = ["tin", "tinân", "tinâwâw"]
    let conDirYou = ["tân", "tâhk", "takohk"]
    let conDirYou2 = ["tân", "tâhk", "takohk"]
    let futDirYou = ["tâni", "tâhk", "tako"]
    
    let impInvYou = ["n","nân","k","hkan","hkâhk","hkêk"]
    let indInvYou = ["n","nân","nâwâw"]
    let conInvYou = ["yan","yâhk","yêk"]
    let futInvYou = ["yani","yâhki","yêko"]
    
    //inverse
    let i3VTAa = ["she/he/it", "she/he/it", "hers/his/its","her/his/its__","she/he/it","she/he/it","she/he/it","they"] //actor of inv
    let i3VTAo = ["me", "you", "by her/him", "by her/him", "us(exc)", "us(inc)", "you(pl)", "by her/him"]//object of inv
    let indInvVTA = ["k", "k", "k", "koyiwa", "konân", "konaw", "kowâw", "kowak"]
    let conInvVTA = ["t", "sk", "kot", "koyit", "koyâhk", "koyahk", "koyêk", "kocik"]
    let futInvVTA = ["ci", "ski", "koci","koyici","koyâhki","koyahko","koyêko","kotwâwi"]
    
    let indInvVTApl = ["kwak", "kwak", "k", "koyiwa", "konânak", "konawak", "kowâwak", "kowak"]
    let conInvVTApl = ["cik", "skik", "kot", "koyit", "koyâhkik", "koyahkok", "koyêkok", "kocik"]
    let futInvVTApl = ["twâwi", "skwâwi", "koci","koyici","koyâhkwâwi","koyahkwâwi","koyêkwâwi","kotwâwi"]
    

    //strings for conjugation
    var imperative = [String]()//immediate, delayed
    var impEnglish = [String]()
    var sampleEnglish = [String]()
    var indicative = [String]()//present/past,fut def, fut indef
    var conjunct = [String]()//present, past, future ind, infinitive, relative
    var inverse = [String]()//present, past,
    var youme = [String]()//present
    var sections = [String] () //sections titles
    var theText = NSMutableAttributedString()
    
    var attrPrefix = [String]()//bold ni(t),ki(t),preverb
    var attrSuffix = [String]()//bold
    var attrVerb = [String]()//plain
    var attrEnglish = [String]()//plain
    var attrImpPrefix = [String]()//preverb
    var attrImpSuffix = [String]()//bold
    var attrImpVerb = [String]()//plain
    var attrImpEnglish = [String]()//plain
    
   
    let attrBold = [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 19)]
    let attrUnder = [NSAttributedStringKey.underlineStyle: NSUnderlineStyle.styleSingle.rawValue]
    let attrCree = [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 18)]
    let attrPlain = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 18)]
    let attrEng = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 16)]
    let attrSyll = [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 16)]
    
    let titleColor = UIColor(red:98/255, green: 152/255, blue:83/255, alpha:1)
    let pickedColor = UIColor(red:30/255, green: 58/255, blue:162/255, alpha:1)
    let noPlural = UIColor(red:223/255, green: 246/255, blue:218/255, alpha:1)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background")!)
        navigationController?.navigationBar.barTintColor = titleColor
       

        pickPreverb.delegate = self
        pickPreverb.dataSource = self
        
        vType = getverbType(theVerb: (verb?.cree)!, theType: (verb?.type)!)
        navigationItem.title = "\((verb?.cree)!): \((verb?.type)!)\(vType)"
        if verb?.type == "VTA" {
            pluralButton.isHidden = false
            bInverse.isHidden = false
            bYou.isHidden = false
            boolPlural = false
           
            bInverse.setTitleColor(UIColor.white, for: .normal)
            bInverse.backgroundColor = titleColor

            pluralButton.layer.cornerRadius = 8
            pluralButton.backgroundColor = titleColor
            pluralButton.setTitleColor(UIColor.white, for: .normal)

            bYou.backgroundColor = titleColor
            bYou.setTitleColor(UIColor.white, for: .normal)
        } else {
            pluralButton.isHidden = true
            bInverse.isHidden = true
            bYou.isHidden = true
        }
        bIndicative.backgroundColor = pickedColor
        bIndicative.setTitleColor(UIColor.white, for: .normal)
        bConjunct.backgroundColor = titleColor
        bConjunct.setTitleColor(UIColor.white, for: .normal)
        bImperative.backgroundColor = titleColor
        bImperative.setTitleColor(UIColor.white, for: .normal)
        
        
        //default Indicative mode
        strMode = "Ind"
        sections = ["Statement-Present", "Statement-Past", "Statement-Future Indefinite", "Statement-Future Definite", "Statement-Can/Could/Should"]

        conjugation(theVerb: verb!, thePrev: 0)
        fillText(section: sections, strMode: strMode)
        self.txtConj.scrollRangeToVisible(NSMakeRange(0,0))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK: picker type
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return preVerbs.count
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
 
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        var samplePreverbs:String = ""
        if row == 0 {
            samplePreverbs = preVerbs[row]
        }else {
            samplePreverbs = "\(preVerbs[row]) \'\(preVerb_e[row-1])\'"
        }
        let myTitle = NSAttributedString(string: samplePreverbs, attributes: [NSAttributedStringKey.foregroundColor:UIColor.white])
        return myTitle
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        conjugation(theVerb: verb!, thePrev: row)
        fillText(section: sections, strMode: strMode)
    }

       private func getverbType(theVerb: String, theType: String) -> String{
        if theVerb.count <= 2 {
            rootVerb = theVerb
            return ""
        }
        let tempVerb:String = theVerb.lowercased()
        var count = Int()
        switch theType {// get root verb
        case "VAI":
            let eIndex = tempVerb[tempVerb.index(before: tempVerb.endIndex)]
            if eIndex == "n" {
                rootVerb = theVerb
                boolN = true
            } else {
                rootVerb = String(tempVerb[..<tempVerb.index(before:tempVerb.endIndex)])
               // rootVerb = tempVerb.substring(to: tempVerb.index(before:tempVerb.endIndex))
                boolN = false
            }
            
        case "VTA":
            count = Int(tempVerb.count)-3
            let startI = tempVerb.startIndex
            let endI = tempVerb.index(tempVerb.startIndex, offsetBy: count)
            let range = startI...endI
            //remove êw for root
            rootVerb = String(tempVerb[range])
        case "VTI":
            rootVerb = String(tempVerb[..<tempVerb.index(before:tempVerb.endIndex)])
         //   rootVerb = tempVerb.substring(to: tempVerb.index(before:tempVerb.endIndex))
        default:
            break
        }
        
        let eIndex = rootVerb[rootVerb.index(before: rootVerb.endIndex)]
       
        switch theType { //get verb type for VTA and VTI
            
        case "VTI": //VTI verbs
            //t1 = a, vt2 = â, vti3 = all others
            if eIndex == "a" {
                return "1"
            } else if eIndex == "â"{
                return "2"
            } else {
                return "3"
            }
            
        case "VTA":
            switch eIndex {
            case "t": //VTA4
                return "4"
            case "w": //vta2,3
                count = Int(rootVerb.count)-2
                let tIndex = rootVerb[rootVerb.index(theVerb.startIndex, offsetBy: count)]
                switch tIndex {
                case "a", "A": //VTA2
                    return "2"
                case "â","ā","Â","Ā","ê","e","ē","E","Ê","Ē","i","î","ī","I","Î","Ī","o","ō","O","Ô","ô", "Ō"://VTA1
                    return "1"
                default: //VTA3 Cw
                    return "3"
                }
            default: //vta1
                return "1"
            }
            
        default: //VAI - no type all VAI
            return ""
        }
    }
    //prepare verb, change endings for certain verbs
    private func prepareVerb(theVerb: String, theType:String) -> String {
        if theVerb.count <= 2{
            return theVerb
        }
        var eVerb:String = ""
        let tempVerb:String = theVerb.lowercased()
        let eIndex = tempVerb[tempVerb.index(before: tempVerb.endIndex)]
        switch theType {
        case "VAI": //VAI verb
            //for VAI verb, remove last e, add a, for 1,2,1p,21,2p
            if (eIndex == "ê") || (eIndex == "e") {
                eVerb = tempVerb[..<tempVerb.index(before:tempVerb.endIndex)] + "â"
                //eVerb = tempVerb.substring(to: tempVerb.index(before:tempVerb.endIndex)) + "â"
            } else {
                eVerb = tempVerb
            }
        case "VTI": //VTI verbs
            //for VTI verbs remove last 'a' and change to ê for 1,2,1p,21,2p
            if eIndex == "a" {
                eVerb = tempVerb[..<tempVerb.index(before:tempVerb.endIndex)] + "ê"
               // eVerb = tempVerb.substring(to: ) + "ê"
                boolVTIsuffix = true
            } else {
                eVerb = tempVerb
                boolVTIsuffix = false
            }
        default: //VTA
            switch eIndex {
            case "a","â","ā","ê","e","ē","i","î","ī","o","ô","ō"://remove last vowel if exists
                eVerb = String(tempVerb[..<tempVerb.index(before:tempVerb.endIndex)])
                //eVerb = tempVerb.substring(to: tempVerb.index(before:tempVerb.endIndex))
            default:
                eVerb = tempVerb
            }
        }
        
        return eVerb
    }
    

    
    private func addT2(theVerb: String, thePrefix: String, thePrev:Int) -> String{        
        var tempConvert:[Character] = []
        
        
        if thePrev > 0 {//preverb added
            for char in preVerbs[thePrev] {
                tempConvert.append(char)// fil tempConvert with all characters
            }
            
        } else {
            for char in theVerb {
                tempConvert.append(char)// fil tempConvert with all characters
            }
        }
        switch tempConvert[0] {
        case "a","â","ā","A","Â","Ā","ê","e","ē","E","Ê","Ē","i","î","ī","I","Î","Ī","o","ō","O","Ô","ô", "Ō":
            return thePrefix + "t"
        default:
            return thePrefix
        }

    }
    
    private func getVTAVerbType(theVerb:String) -> String{
        if theVerb.count <= 2 {
            iVerb = 0
            invSuff = "i"
            return theVerb
        }
        var impVTAverb:String = ""
        var count:Int = 0
        let tempVerb:String = theVerb.lowercased()
        
        let eIndex = tempVerb[tempVerb.index(before: tempVerb.endIndex)]
        switch eIndex {
        case "t": //VTA4
            //change ending to t to s in 1,1P cases
            count = Int(tempVerb.count)-2
            let startI = tempVerb.startIndex
            let endI = tempVerb.index(tempVerb.startIndex, offsetBy: count)
            let range = startI...endI
            impVTAverb = tempVerb[range] + "s"
            iVerb = 4
            invSuff = "i"
        case "w": //vta2,3
            count = Int(tempVerb.count)-2
            let tIndex = tempVerb[tempVerb.index(theVerb.startIndex, offsetBy: count)]
            switch tIndex {
            case "a", "A": //VTA2
                count = Int(tempVerb.count)-3
                let startI = tempVerb.startIndex
                let endI = tempVerb.index(tempVerb.startIndex, offsetBy: count)
                let range = startI...endI
                //remove aw for 2, 2P
                impVTAverb = String(tempVerb[range])
                iVerb = 2
                invSuff = "â"
                
            case "â","ā","Â","Ā","ê","e","ē","E","Ê","Ē","i","î","ī","I","Î","Ī","o","ō","O","Ô","ô", "Ō"://VTA1
                impVTAverb = tempVerb
                iVerb = 0
                invSuff = "i"
                
            default: //VTA3 Cw
                count = Int(tempVerb.count)-2
                let startI = tempVerb.startIndex
                let endI = tempVerb.index(tempVerb.startIndex, offsetBy: count)
                let range = startI...endI
                //remove w for 1,1P, and 2,2p
                impVTAverb = String(tempVerb[range])
                iVerb = 3
                invSuff = "o"
            }
        default: //vta1
            
            
            impVTAverb = tempVerb
            iVerb = 0
            invSuff = "i"
        }
        //remove last vowel
        switch eIndex {
        case "â","ā","Â","Ā","ê","e","ē","E","Ê","Ē","i","î","ī","I","Î","Ī","o","ō","O","Ô","ô", "Ō":
            impVTAverb = String(impVTAverb[..<impVTAverb.index(before:impVTAverb.endIndex)])
           // impVTAverb = impVTAverb.substring(to: impVTAverb.index(before:impVTAverb.endIndex))
        default:
            break
        }
        return impVTAverb
    }
    
    private func checkforSO(checkEnglish:String) -> Bool {
        
        let lowercaseEnglish = checkEnglish.lowercased()
        if lowercaseEnglish.range(of: "s.o.") != nil {
            return true
        }
        return false
    }
    
    private func checkForSelf(checkEnglish:String, index:Int, tense:Int) -> String {
        
        var checked = String()
        var lowercaseEnglish = String()
        
        var pastEng = ["was","were","was","was","were","were","were","were"]
        var invAm = ["is","is","is","is","is","is","is","are"]
        var invAmpl = ["are","are","is","is","are","are","are","are"]
        var youAm = ["am","are","am"]
        lowercaseEnglish = checkEnglish.lowercased()
        
        //check for self and conjugate it
        if lowercaseEnglish.range(of: "self") != nil {
            checked = lowercaseEnglish.replacingOccurrences(of: "self", with: verbSelf[index])
        } else {
            checked = checkEnglish
        }
        if lowercaseEnglish.range(of: "s.o.") != nil {
            if boolPlural{
                checked = checked.replacingOccurrences(of: "s.o.", with: "them")
            } else {
                checked = checked.replacingOccurrences(of: "s.o.", with: "her/him")
            }
        }
        
        if !(checkEnglish.count < 2 ) {
        //check for 'am' and conjugate it
            if checkEnglish.count <= 2 {
                checked = checked + " "
            }
            let secIndex = checkEnglish.index(checkEnglish.startIndex, offsetBy: 2)
            lowercaseEnglish = String(checkEnglish.lowercased()[..<secIndex])
           // lowercaseEnglish = checkEnglish.lowercased().substring(to: secIndex)
        
            if (lowercaseEnglish == "am"){
                switch tense {
                case 1: //past
                    checked = "\(pastEng[index])\(checked[secIndex...checked.index(before:checked.endIndex)])"
                case 2: //fut
                    checked = "be\(checked[secIndex...checked.index(before:checked.endIndex)])"
                default: //present
                    if strMode == "Inv" {
                        if boolPlural {
                            checked = "\(invAmpl[index])\(checked[secIndex...checked.index(before:checked.endIndex)])"
                        } else {
                            checked = "\(invAm[index])\(checked[secIndex...checked.index(before:checked.endIndex)])"
                        }
                    
                    } else if strMode == "You" {
                    //i am, we are, i am, you are, you are, you are
                        if boolInv {
                            checked = "are\(checked[secIndex...checked.index(before:checked.endIndex)])"
                        } else {
                            checked = "\(youAm[index])\(checked[secIndex...checked.index(before:checked.endIndex)])"
                        }
                    } else {
                        checked = "\(verbAm[index])\(checked[secIndex...checked.index(before:checked.endIndex)])"
                    }
                }
            
            } else {
                switch tense {
                case 1: //past
                    checked = "did \(checked)"
                default:
                    break
                }
            
            }
        }
        return checked
    }
//MARK: Action
    
    @IBAction func plButton(_ sender: UIButton) {
        if boolPlural {
            boolPlural = false
            pluralButton.backgroundColor = titleColor
           
            conjugation(theVerb: verb!, thePrev: pickPreverb.selectedRow(inComponent: 0))
            fillText(section: sections, strMode: strMode)
            
        } else {
            boolPlural = true
            pluralButton.backgroundColor = pickedColor
            
            conjugation(theVerb: verb!, thePrev: pickPreverb.selectedRow(inComponent: 0))
            fillText(section: sections, strMode: strMode)
         
        }
    }
    
    @IBAction func indButt(_ sender: UIButton) {
        bYou.backgroundColor = titleColor
      
        bIndicative.backgroundColor = pickedColor

        bInverse.backgroundColor = titleColor
      
        bConjunct.backgroundColor = titleColor
        
        bImperative.backgroundColor = titleColor
        
        pluralButton.isEnabled = true
        pluralButton.setTitle("Plural", for: .normal)
        strMode = "Ind"
        sections = ["Statement-Present", "Statement-Past", "Statement-Future Indefinite", "Statement-Future Definite", "Statement-Can/Could/Should"]
        if boolPlural{
            pluralButton.backgroundColor = pickedColor
        } else {
            pluralButton.backgroundColor = titleColor
        }
        conjugation(theVerb: verb!, thePrev: pickPreverb.selectedRow(inComponent: 0))
        fillText(section: sections, strMode: strMode)
        self.txtConj.scrollRangeToVisible(NSMakeRange(0,0))
    }
    @IBAction func impButt(_ sender: UIButton) {
        bYou.backgroundColor = titleColor
        
        bIndicative.backgroundColor = titleColor
        
        bInverse.backgroundColor = titleColor
        
        bConjunct.backgroundColor = titleColor
       
        bImperative.backgroundColor = pickedColor
        if boolPlural{
            pluralButton.backgroundColor = pickedColor
        } else {
            pluralButton.backgroundColor = titleColor
        }
        pluralButton.isEnabled = true
        pluralButton.setTitle("Plural", for: .normal)
        strMode = "Imp"
        sections = ["Imperatives/Commands"]
        
     
        conjugation(theVerb: verb!, thePrev: pickPreverb.selectedRow(inComponent: 0))
        fillText(section: sections, strMode: strMode)
        self.txtConj.scrollRangeToVisible(NSMakeRange(0,0))
    }
    
    @IBAction func conButt(_ sender: UIButton) {
        bYou.backgroundColor = titleColor
       
        bIndicative.backgroundColor = titleColor
       
        bInverse.backgroundColor = titleColor
        
        bConjunct.backgroundColor = pickedColor
        
        bImperative.backgroundColor = titleColor
        if boolPlural{
            pluralButton.backgroundColor = pickedColor
        } else {
            pluralButton.backgroundColor = titleColor
        }
        pluralButton.isEnabled = true
        pluralButton.setTitle("Plural", for: .normal)
        strMode = "Con"
        sections = ["Conjunct Clause-Present", "Conjunct Clause-Past", "Conjunct Clause-Future Indefinite", "Relative Clause-Present", "Relative Clause-Past", "Relative Clause -Future Indefinite", "Infinitive Clause", "Future Conditional Clause"]
       
        conjugation(theVerb: verb!, thePrev: pickPreverb.selectedRow(inComponent: 0))
        fillText(section: sections, strMode: strMode)
        self.txtConj.scrollRangeToVisible(NSMakeRange(0,0))
    }
    
    @IBAction func invButt(_ sender: UIButton) {
        bYou.backgroundColor = titleColor
        
        bIndicative.backgroundColor = titleColor
        
        bInverse.backgroundColor = pickedColor
        
        bConjunct.backgroundColor = titleColor
        
        bImperative.backgroundColor = titleColor
        if boolPlural{
           pluralButton.backgroundColor = pickedColor
        } else {
            pluralButton.backgroundColor = titleColor
        }
        pluralButton.isEnabled = true
        pluralButton.setTitle("Plural", for: .normal)
        strMode = "Inv"
        sections = ["Statement Present: 3->another", "Conjunct Clause: 3->another", "Future Conditional Clause: 3->another"]
        
        conjugation(theVerb: verb!, thePrev: pickPreverb.selectedRow(inComponent: 0))
        fillText(section: sections, strMode: strMode)
        self.txtConj.scrollRangeToVisible(NSMakeRange(0,0))
    }
    @IBAction func youButt(_ sender: UIButton) {
        bYou.backgroundColor = pickedColor
       
        bIndicative.backgroundColor = titleColor
        bInverse.backgroundColor = titleColor
        bConjunct.backgroundColor = titleColor
        bImperative.backgroundColor = titleColor
        pluralButton.backgroundColor = titleColor
        
        pluralButton.isEnabled = false
        pluralButton.setTitle("No plural", for: .normal)
        strMode = "You"
        sections = ["Statement Present-Direct", "Conjunct clause-Direct", "Future Conditional Clause-Direct","Statement Present-Inverse", "Conjunct clause-Inverse", "Future Conditional Clause-Inverse","Command-Inverse"]
     
        conjugation(theVerb: verb!, thePrev: pickPreverb.selectedRow(inComponent: 0))
        fillText(section: sections, strMode: strMode)
        self.txtConj.scrollRangeToVisible(NSMakeRange(0,0))
    }
    //MARK: navigation
    override func prepare(for segue: UIStoryboardSegue, sender : Any?){
        super.prepare(for: segue, sender: sender)
        switch (segue.identifier ?? "") {
        case "editVerb":
            guard let ViewController = segue.destination as? ViewController else {
                fatalError("could not find edit item")
            }
            ViewController.verb = CreeVerb(cree: (verb?.cree)!, english: (verb?.english)!, type: (verb?.type)!, imperative: (verb?.imperative)!)
            ViewController.editRow = row!
            ViewController.filterRow = filterRow!
        default:
            break
        }
    }

    @IBAction func backButton(_ sender: UIBarButtonItem) {
        let isPresenting = presentingViewController is UINavigationController
        if isPresenting {
            dismiss(animated: true, completion: nil)
        } else  if let owningNavController = navigationController {
            owningNavController.popViewController(animated: true)
        } else {
            fatalError("no nav controller")
        }
    }
//Mark:conjugation
    private func conjugation(theVerb:CreeVerb, thePrev:Int) {
        
        attrPrefix = []

        attrSuffix = []
        attrVerb = []
        attrEnglish = []
        attrImpPrefix = []
        attrImpSuffix = []
        attrImpVerb = []
        attrImpEnglish = []
 
        
        var tVerb:String = ""
        var tVerb2:String = ""
        var indVTIsuffix:[String] = []
        var impVTIsuffix:[String] = []
        var inplVTAsuffix:[String] = []
        var implVTAsuffix:[String] = []
        var futVTIsuffix:[String] = []
        var conVTAsuffix:[String] = []
        var futVTAsuffix:[String] = []
        var strPreVerb:String = ""
        var strPreVerb_e:String = ""
        var vaiVerb = String()
        if thePrev > 0 {
            strPreVerb = "\(preVerbs[thePrev])-"
            strPreVerb_e = preVerb_e[thePrev-1]
        }
        
        
        switch theVerb.type{
        case "VAI": //VAI
            if boolN {
                vaiVerb = theVerb.imperative
            } else {
                vaiVerb = rootVerb
            }
            
            
            
            switch strMode {
            case "Con"://conjunct mode
                for (index, _) in people.enumerated() {
                    //present tense conjunct
                    if thePrev > 0 {
                        attrPrefix.append("ê-\(strPreVerb)")
                        attrEnglish.append("As \(pronouns[index]) \(strPreVerb_e) \(checkForSelf(checkEnglish:theVerb.english, index:index, tense:2))")
                    } else {
                        attrPrefix.append("ê-")
                        attrEnglish.append("As \(pronouns[index]) \(checkForSelf(checkEnglish:theVerb.english, index:index, tense:0))")
                    }
                    attrVerb.append(vaiVerb)
                    attrSuffix.append(conVAI[index])
                    
                    
                    //past tense conjunct
                    if thePrev > 0 {
                       attrPrefix.append("ê-kî-\(strPreVerb)")
                        attrEnglish.append("As \(pronouns[index]) did \(strPreVerb_e) \(checkForSelf(checkEnglish:theVerb.english, index:index, tense:2))")
                    } else {
                        attrPrefix.append("ê-kî-")
                        attrEnglish.append("As \(pronouns[index]) \(checkForSelf(checkEnglish:theVerb.english, index:index, tense:1))")                    }
                
                    attrVerb.append(vaiVerb)
                    attrSuffix.append(conVAI[index])
                
                    
                    //future indefinite
                    if thePrev > 0 {
                        attrPrefix.append("ê-wî-\(strPreVerb)")
                        attrEnglish.append("As \(pronouns[index]) intend to \(strPreVerb_e) \(checkForSelf(checkEnglish:theVerb.english, index:index, tense:2))")
                    }else {
                        attrPrefix.append("ê-wî-")
                        attrEnglish.append("As \(pronouns[index]) intend to \(checkForSelf(checkEnglish:theVerb.english, index:index, tense:2))")                    }
                    
                    attrVerb.append(vaiVerb)
                    attrSuffix.append(conVAI[index])
                    
                    
                    //relative clause
                    if thePrev > 0{
                        attrPrefix.append("kâ-\(strPreVerb)")
                         attrEnglish.append("\(pronouns[index]) who \(strPreVerb_e) \(checkForSelf(checkEnglish:theVerb.english, index:index, tense:2))")
                    } else {
                        attrPrefix.append("kâ-")
                        attrEnglish.append("\(pronouns[index]) who \(checkForSelf(checkEnglish:theVerb.english, index:index, tense:0))")
                    }
                    
                    attrVerb.append(vaiVerb)
                    attrSuffix.append(conVAI[index])
                    
                    //relative clause past
                    if thePrev > 0 {
                        attrPrefix.append("kâ-kî-\(strPreVerb)")
                        attrEnglish.append("\(pronouns[index]) who did \(strPreVerb_e) \(checkForSelf(checkEnglish:theVerb.english, index:index, tense:2))")
                    } else {
                        attrPrefix.append("kâ-kî-")
                        attrEnglish.append("\(pronouns[index]) who \(checkForSelf(checkEnglish:theVerb.english, index:index, tense:1))")
                    }
                    
                    attrVerb.append(vaiVerb)
                    attrSuffix.append(conVAI[index])
                    
                    //relative clause future indefinite
                    if thePrev > 0 {
                        attrPrefix.append("kâ-wî-\(strPreVerb)")
                        attrEnglish.append("\(pronouns[index]) who intends to \(strPreVerb_e) \(checkForSelf(checkEnglish:theVerb.english, index:index, tense:2))")
                    } else {
                        attrPrefix.append("kâ-wî-")
                        attrEnglish.append("\(pronouns[index]) who intends to \(checkForSelf(checkEnglish:theVerb.english, index:index, tense:2))")
                    }
                    
                    attrVerb.append(vaiVerb)
                    attrSuffix.append(conVAI[index])
                    
                    
                    
                    //infinitive
                    if thePrev > 0{
                        attrPrefix.append("ta-\(strPreVerb)")
                        attrEnglish.append("to \(strPreVerb_e) \(checkForSelf(checkEnglish:theVerb.english, index:index, tense:2))")
                    } else {
                        attrPrefix.append("ta-")
                        attrEnglish.append("to \(checkForSelf(checkEnglish:theVerb.english, index:index, tense:2))")
                    }
                    
                    attrVerb.append(vaiVerb)
                    attrSuffix.append(conVAI[index])
                    
                    
                    //future conditional
                    if thePrev > 0 {
                        attrPrefix.append("\(strPreVerb)")
                        attrEnglish.append("If/when \(pronouns[index]) \(strPreVerb_e) \(checkForSelf(checkEnglish:theVerb.english, index:index, tense:2))")
                    } else {
                        attrPrefix.append("")
                        attrEnglish.append("If/when \(pronouns[index]) \(checkForSelf(checkEnglish:theVerb.english, index:index, tense:0))")
                    }
                    attrVerb.append(vaiVerb)
                    attrSuffix.append(futVAI[index])
                    

                }
                
            case "Imp":
                let tempIndex = theVerb.imperative
                let aIndex = tempIndex[tempIndex.index(before: tempIndex.endIndex)]
                
                
                for (index, suffix) in impVAI.enumerated(){
                    switch index {
                    case 0:
                        attrImpVerb.append(theVerb.imperative)
                    case 3,4,5:
                        if aIndex == "i" {
                            let counti = Int(tempIndex.count)-2
                            let startI = tempIndex.startIndex
                            let endI = tempIndex.index(tempIndex.startIndex, offsetBy: counti)
                            let range = startI...endI
                            let longI = tempIndex[range] + "î"
                            attrImpVerb.append(String(longI))
                        } else if aIndex == "o" {
                            let counti = Int(tempIndex.count)-2
                            let startI = tempIndex.startIndex
                            let endI = tempIndex.index(tempIndex.startIndex, offsetBy: counti)
                            let range = startI...endI
                            let longI = tempIndex[range] + "ô"
                            attrImpVerb.append(String(longI))
                        } else {
                            attrImpVerb.append(vaiVerb)
                        }
                    default:
                        
                        attrImpVerb.append(vaiVerb)
                    }
                    if thePrev > 0 {
                        attrImpPrefix.append("\(strPreVerb)")
                        attrImpEnglish.append("\(strPreVerb_e) \(checkForSelf(checkEnglish:theVerb.english, index:index, tense:2))")
                    } else {
                        attrImpPrefix.append("")
                        attrImpEnglish.append("\(checkForSelf(checkEnglish:theVerb.english, index:index, tense:2))")
                    }
                    
                    
                    attrImpSuffix.append(suffix)
                    
                }
            default: //ind
                tVerb = prepareVerb(theVerb: vaiVerb, theType: theVerb.type)
                for (index, _) in people.enumerated() {
                    switch index {
                    case 0,4://1, 1p
                        //present tense
                        
                        tVerb2 = addT2(theVerb: tVerb, thePrefix: "ni", thePrev: thePrev)
                        if thePrev > 0 {
                            
                            attrPrefix.append("\(tVerb2)\(strPreVerb)")
                            attrEnglish.append("\(pronouns[index]) \(strPreVerb_e) \(checkForSelf(checkEnglish:theVerb.english, index:index, tense:2))")
                        } else {

                            attrPrefix.append("\(tVerb2)")
                            attrEnglish.append("\(pronouns[index]) \(checkForSelf(checkEnglish:theVerb.english, index:index, tense:0))")
                        }
                        
                        attrVerb.append(tVerb)
                        attrSuffix.append(indVAI[index])
                        
                        
                        //past tense
                        if thePrev > 0 {
                            attrPrefix.append("nikî-\(strPreVerb)")
                            attrEnglish.append("\(pronouns[index]) did \(strPreVerb_e) \(checkForSelf(checkEnglish:theVerb.english, index:index, tense:2))")
                        } else {
                            attrPrefix.append("nikî-")
                            attrEnglish.append("\(pronouns[index]) \(checkForSelf(checkEnglish:theVerb.english, index:index, tense:1))")
                        }
                        
                        attrVerb.append(tVerb)
                        attrSuffix.append(indVAI[index])
                        
                        //future indefinite
                        if thePrev > 0 {
                            attrPrefix.append("niwî-\(strPreVerb)")
                            attrEnglish.append("\(pronouns[index]) intend to \(strPreVerb_e) \(checkForSelf(checkEnglish:theVerb.english, index:index, tense:2))")
                        } else {
                            attrPrefix.append("niwî-")
                            attrEnglish.append("\(pronouns[index]) intend to \(checkForSelf(checkEnglish:theVerb.english, index:index, tense:2))")
                        }
                        
                        attrVerb.append(tVerb)
                        attrSuffix.append(indVAI[index])
                       
                        //future definite
                        
                        if thePrev > 0 {
                            attrPrefix.append("nika-\(strPreVerb)")
                            attrEnglish.append("\(pronouns[index]) will \(strPreVerb_e) \(checkForSelf(checkEnglish:theVerb.english, index:index, tense:2))")
                        } else {
                            attrPrefix.append("nika-")
                            attrEnglish.append("\(pronouns[index]) will \(checkForSelf(checkEnglish:theVerb.english, index:index, tense:2))")
                        }
                        
                        attrVerb.append(tVerb)
                        attrSuffix.append(indVAI[index])
                        
                        //can/culd/should
                        if thePrev > 0 {
                            attrPrefix.append("nika-kî-\(strPreVerb)")
                            attrEnglish.append("\(pronouns[index]) should \(strPreVerb_e) \(checkForSelf(checkEnglish:theVerb.english, index:index, tense:2))")
                        } else {
                            attrPrefix.append("nika-kî-")
                            attrEnglish.append("\(pronouns[index]) should \(checkForSelf(checkEnglish:theVerb.english, index:index, tense:2))")
                        }
                        
                        attrVerb.append(tVerb)
                        attrSuffix.append(indVAI[index])
                        
                        
                    case 1, 5, 6://2,21,2p
                        //present tense
                        tVerb2 = addT2(theVerb: tVerb, thePrefix: "ki", thePrev: thePrev)
                        if thePrev > 0 {
                            attrPrefix.append("\(tVerb2)\(strPreVerb)")
                            attrEnglish.append("\(pronouns[index]) \(strPreVerb_e) \(checkForSelf(checkEnglish:theVerb.english, index:index, tense:2))")
                        } else {
                            attrPrefix.append("\(tVerb2)")
                            attrEnglish.append("\(pronouns[index]) \(checkForSelf(checkEnglish:theVerb.english, index:index, tense:0))")
                        }
                        
                        attrVerb.append(tVerb)
                        attrSuffix.append(indVAI[index])
                        
                        
                        //past tense
                        if thePrev > 0 {
                            attrPrefix.append("kikî-\(strPreVerb)")
                            attrEnglish.append("\(pronouns[index]) did \(strPreVerb_e) \(checkForSelf(checkEnglish:theVerb.english, index:index, tense:2))")
                        } else {
                            attrPrefix.append("kikî-")
                            attrEnglish.append("\(pronouns[index]) \(checkForSelf(checkEnglish:theVerb.english, index:index, tense:1))")
                        }
                        
                        attrVerb.append(tVerb)
                        attrSuffix.append(indVAI[index])
                        
                        //future indefinite
                        if thePrev > 0 {
                            attrPrefix.append("kiwî-\(strPreVerb)")
                            attrEnglish.append("\(pronouns[index]) intend to \(strPreVerb_e) \(checkForSelf(checkEnglish:theVerb.english, index:index, tense:2))")
                        } else {
                            attrPrefix.append("kiwî-")
                            attrEnglish.append("\(pronouns[index]) intend to \(checkForSelf(checkEnglish:theVerb.english, index:index, tense:2))")
                        }
                        
                        attrVerb.append(tVerb)
                        attrSuffix.append(indVAI[index])
                        
                        //future definite
                        
                        if thePrev > 0 {
                            attrPrefix.append("kika-\(strPreVerb)")
                            attrEnglish.append("\(pronouns[index]) will \(strPreVerb_e) \(checkForSelf(checkEnglish:theVerb.english, index:index, tense:2))")
                        } else {
                            attrPrefix.append("kika-")
                            attrEnglish.append("\(pronouns[index]) will \(checkForSelf(checkEnglish:theVerb.english, index:index, tense:2))")
                        }
                        
                        attrVerb.append(tVerb)
                        attrSuffix.append( indVAI[index])
                        
                        //can/culd/should
                        if thePrev > 0 {
                            attrPrefix.append("kika-kî-\(strPreVerb)")
                            attrEnglish.append("\(pronouns[index]) should \(strPreVerb_e) \(checkForSelf(checkEnglish:theVerb.english, index:index, tense:2))")
                        } else {
                            attrPrefix.append("kika-kî-")
                            attrEnglish.append("\(pronouns[index]) should \(checkForSelf(checkEnglish:theVerb.english, index:index, tense:2))")
                        }
                        
                        attrVerb.append(tVerb)
                        attrSuffix.append(indVAI[index])
                        
                    
                    default: // 3,3'(p),3P
                        if thePrev > 0 {
                            attrPrefix.append("\(strPreVerb)")
                            attrEnglish.append("\(pronouns[index]) \(strPreVerb_e) \(checkForSelf(checkEnglish:theVerb.english, index:index, tense:2))")
                        } else {
                            attrPrefix.append("")
                            attrEnglish.append("\(pronouns[index]) \(checkForSelf(checkEnglish:theVerb.english, index:index, tense:0))")
                        }
                        if boolN && (index == 7){ //3P
                            attrVerb.append(rootVerb)
                        } else {
                            attrVerb.append(vaiVerb)
                        }
                        attrSuffix.append(indVAI[index])
                        
                        
                        //past tense
                        if thePrev > 0 {
                            attrPrefix.append("kî-\(strPreVerb)")
                            attrEnglish.append("\(pronouns[index]) did \(strPreVerb_e) \(checkForSelf(checkEnglish:theVerb.english, index:index, tense:2))")
                        } else {
                            attrPrefix.append("kî-")
                            attrEnglish.append("\(pronouns[index]) \(checkForSelf(checkEnglish:theVerb.english, index:index, tense:1))")
                        }
                        
                        if boolN && (index == 7){ //3P
                            attrVerb.append(rootVerb)
                        } else {
                            attrVerb.append(vaiVerb)
                        }
                        attrSuffix.append(indVAI[index])
                        
                        //future indefinite
                        if thePrev > 0 {
                            attrPrefix.append("wî-\(strPreVerb)")
                            attrEnglish.append("\(pronouns[index]) intend to \(strPreVerb_e) \(checkForSelf(checkEnglish:theVerb.english, index:index, tense:2))")
                        } else {
                            attrPrefix.append("wî-")
                            attrEnglish.append("\(pronouns[index]) intend to \(checkForSelf(checkEnglish:theVerb.english, index:index, tense:2))")
                        }
                        
                        if boolN && (index == 7){ //3P
                            attrVerb.append(rootVerb)
                        } else {
                            attrVerb.append(vaiVerb)
                        }
                        attrSuffix.append(indVAI[index])
                        
                        //future definite
                        
                        if thePrev > 0 {
                            attrPrefix.append("ta-\(strPreVerb)")
                            attrEnglish.append("\(pronouns[index]) will \(strPreVerb_e) \(checkForSelf(checkEnglish:theVerb.english, index:index, tense:2))")
                        } else {
                            attrPrefix.append("ta-")
                            attrEnglish.append("\(pronouns[index]) will \(checkForSelf(checkEnglish:theVerb.english, index:index, tense:2))")
                        }
                        
                        if boolN && (index == 7){ //3P
                            attrVerb.append(rootVerb)
                        } else {
                            attrVerb.append(vaiVerb)
                        }
                        attrSuffix.append(indVAI[index])
                        
                        //can/culd/should
                        if thePrev > 0 {
                            attrPrefix.append("ta-kî-\(strPreVerb)")
                            attrEnglish.append("\(pronouns[index]) should \(strPreVerb_e) \(checkForSelf(checkEnglish:theVerb.english, index:index, tense:2))")
                        } else {
                            attrPrefix.append("ta-kî-")
                            attrEnglish.append("\(pronouns[index]) should \(checkForSelf(checkEnglish:theVerb.english, index:index, tense:2))")
                        }
                        
                        if boolN && (index == 7){ //3P
                            attrVerb.append(rootVerb)
                        } else {
                            attrVerb.append(vaiVerb)
                        }
                        attrSuffix.append(indVAI[index])
                    }
                }
                
            }
        case "VTA": //VTA
            
            var dObject = String()
            if boolPlural {
                inplVTAsuffix = indVTApl
                implVTAsuffix = impVTApl
                conVTAsuffix = conVTApl
                futVTAsuffix = futVTApl
                
                
            } else {
                inplVTAsuffix = indVTA
                implVTAsuffix = impVTA
                conVTAsuffix = conVTA
                futVTAsuffix = futVTA
               
            }
            
            switch strMode {
            case "Con"://conjunct mode
                tVerb = prepareVerb(theVerb: rootVerb, theType: theVerb.type)
                for (index, person) in people.enumerated() {
                    if boolPlural {//set direct object
                        switch index {
                        case 2,3,7:
                            if checkforSO(checkEnglish:theVerb.english) {
                                dObject = ""
                            } else {
                                dObject = "s.o./them"
                            }
                        default:
                            if checkforSO(checkEnglish:theVerb.english) {
                                dObject = ""
                            } else {
                                dObject = "them"
                            }
                            
                        }
                        
                    } else {
                        switch index {
                        case 2,3,7:
                            if checkforSO(checkEnglish:theVerb.english) {
                                dObject = ""
                            } else {
                                dObject = "s.o./them"
                            }
                            
                        default:
                            if checkforSO(checkEnglish:theVerb.english) {
                                dObject = ""
                            } else {
                                dObject = "s.o."
                            }
                            
                        }
                    }
                    
                    //present tense
                    if thePrev > 0 {
                        attrPrefix.append("ê-\(strPreVerb)")
                        attrEnglish.append("As \(pronouns[index]) \(strPreVerb_e) \(checkForSelf(checkEnglish:theVerb.english, index:index, tense:2)) \(dObject)")
                    } else {
                        attrPrefix.append("ê-")
                        attrEnglish.append("As \(pronouns[index]) \(checkForSelf(checkEnglish:theVerb.english, index:index, tense:0)) \(dObject)")
                    }
                    attrVerb.append(tVerb)
                    attrSuffix.append(conVTAsuffix[index])

                    //past
                    if thePrev > 0 {
                        attrPrefix.append("ê-kî-\(strPreVerb)")
                        attrEnglish.append("As \(pronouns[index]) did \(strPreVerb_e) \(checkForSelf(checkEnglish:theVerb.english, index:index, tense:2)) \(dObject)")
                    } else {
                        attrPrefix.append("ê-kî-")
                        attrEnglish.append("As \(pronouns[index]) \(checkForSelf(checkEnglish:theVerb.english, index:index, tense:1)) \(dObject)")
                    }
                    attrVerb.append(tVerb)
                    attrSuffix.append(conVTAsuffix[index])
                    
                    //future indefinite
                    if thePrev > 0 {
                        attrPrefix.append("ê-wî-\(strPreVerb)")
                        attrEnglish.append("As \(pronouns[index]) intend to \(strPreVerb_e) \(checkForSelf(checkEnglish:theVerb.english, index:index, tense:2)) \(dObject)")
                    } else {
                        attrPrefix.append("ê-wî-")
                        attrEnglish.append("As \(pronouns[index]) intend to \(checkForSelf(checkEnglish:theVerb.english, index:index, tense:2)) \(dObject)")
                    }
                    attrVerb.append(tVerb)
                    attrSuffix.append(conVTAsuffix[index])
                    
                    //relative clause
                    if thePrev > 0 {
                        attrPrefix.append("kâ-\(strPreVerb)")
                        attrEnglish.append("\(pronouns[index]) who \(strPreVerb_e) \(checkForSelf(checkEnglish:theVerb.english, index:index, tense:2)) \(dObject)")
                    } else {
                        attrPrefix.append("kâ-")
                        attrEnglish.append("\(pronouns[index]) who \(checkForSelf(checkEnglish:theVerb.english, index:index, tense:0)) \(dObject)")
                    }
                    attrVerb.append(tVerb)
                    attrSuffix.append(conVTAsuffix[index])
                    
                    
                    //relative clause past
                    if thePrev > 0 {
                        attrPrefix.append("kâ-kî-\(strPreVerb)")
                        attrEnglish.append("\(pronouns[index]) who did \(strPreVerb_e) \(checkForSelf(checkEnglish:theVerb.english, index:index, tense:2)) \(dObject)")
                    } else {
                        attrPrefix.append("kâ-kî-")
                        attrEnglish.append("\(pronouns[index]) who did \(checkForSelf(checkEnglish:theVerb.english, index:index, tense:2)) \(dObject)")
                    }
                    attrVerb.append(tVerb)
                    attrSuffix.append(conVTAsuffix[index])
                    
                    //relative clause future indefinite
                    if thePrev > 0 {
                        attrPrefix.append("kâ-wî-\(strPreVerb)")
                        attrEnglish.append("\(pronouns[index]) who intends to \(strPreVerb_e) \(checkForSelf(checkEnglish:theVerb.english, index:index, tense:2)) \(dObject)")
                    } else {
                        attrPrefix.append("kâ-wî-")
                        attrEnglish.append("\(pronouns[index]) who intends to  \(checkForSelf(checkEnglish:theVerb.english, index:index, tense:2)) \(dObject)")
                    }
                    attrVerb.append(tVerb)
                    attrSuffix.append(conVTAsuffix[index])
                    
                    
                    //infinitive
                    if thePrev > 0 {
                        attrPrefix.append("ta-\(strPreVerb)")
                        attrEnglish.append("to \(strPreVerb_e) \(checkForSelf(checkEnglish:theVerb.english, index:index, tense:2)) \(dObject)")
                    } else {
                        attrPrefix.append("ta-")
                        attrEnglish.append("to \(checkForSelf(checkEnglish:theVerb.english, index:index, tense:2)) \(dObject)")
                    }
                    attrVerb.append(tVerb)
                    attrSuffix.append(conVTAsuffix[index])
                    
                    
                    //future conditional
                    if (iVerb == 3) && (person == "21") && !(boolPlural){
                        attrSuffix.append("âyahki")
                    } else {
                        attrSuffix.append(futVTAsuffix[index])
                    }
                    
                    if thePrev > 0{
                        attrPrefix.append("\(strPreVerb)")
                        attrEnglish.append("If/when \(pronouns[index]) \(strPreVerb_e) \(checkForSelf(checkEnglish:theVerb.english, index:index, tense:2)) \(dObject)")
                    } else {
                        attrPrefix.append("")
                        attrEnglish.append("If/when \(pronouns[index]) \(checkForSelf(checkEnglish:theVerb.english, index:index, tense:0)) \(dObject)")
                    }
                    
                    attrVerb.append(tVerb)
                   
                    
                }
            case "Imp":
                for (person, suffix) in implVTAsuffix.enumerated(){
                    if boolPlural {//set direct object
                        switch person {
                        case 2,3,7:
                            if checkforSO(checkEnglish:theVerb.english) {
                                dObject = ""
                            } else {
                                dObject = "s.o./them"
                            }
                            
                        default:
                            if checkforSO(checkEnglish:theVerb.english) {
                                dObject = ""
                            } else {
                                dObject = "them"
                            }
                            
                        }
                        
                    } else {
                        switch person {
                        case 2,3,7:
                            if checkforSO(checkEnglish:theVerb.english) {
                                dObject = ""
                            } else {
                                dObject = "s.o./them"
                            }
                            
                        default:
                            if checkforSO(checkEnglish:theVerb.english) {
                                dObject = ""
                            } else {
                                dObject = "s.o."
                            }
                           
                        }
                    }
                    
                    tVerb = getVTAVerbType(theVerb: rootVerb)
                    switch person {
                    case 0:
                        switch iVerb{
                        case 0:
                            let tempVerb:String = theVerb.imperative
                            let eIndex = tempVerb[tempVerb.index(before: tempVerb.endIndex)]
                            switch eIndex {
                            case "a","â","ā","A","Â","Ā","ê","e","ē","E","Ê","Ē","i","î","ī","I","Î","Ī","o","ō","O","Ô","ô", "Ō":
                                if boolPlural {
                                   attrImpVerb.append(tVerb)
                                } else {
                                    attrImpVerb.append(theVerb.imperative)
                                }
                            default:
                                attrImpVerb.append(rootVerb)

                            }
                            attrImpSuffix.append(suffix)
                        case 3: //VTA3 -ends in Cw
                            if boolPlural {
                                
                                attrImpVerb.append(tVerb)
                                attrImpSuffix.append("ok")
                                
                            } else {
                                attrImpVerb.append(tVerb)
                                attrImpSuffix.append("")
                                
                            }
                        case 4: //VTA4 ends in t
                            
                            attrImpVerb.append(tVerb)
                            attrImpSuffix.append(suffix)
                           
                        default:
                            
                            attrImpVerb.append(rootVerb)
                            attrImpSuffix.append(suffix)
                            
                        }
                        if thePrev > 0 {
                            attrImpPrefix.append( "\(strPreVerb)")
                            attrImpEnglish.append("\(strPreVerb_e) \(checkForSelf(checkEnglish:theVerb.english, index:person, tense:2)) \(dObject)")
                        } else {
                            attrImpPrefix.append("")
                            attrImpEnglish.append("\(checkForSelf(checkEnglish:theVerb.english, index:person, tense:2)) \(dObject)")
                        }
                        
                        
                    case 1:
                        switch iVerb {
                        case 2:
                            if boolPlural {
                                attrImpSuffix.append("âhkok")
                                attrImpVerb.append(tVerb)
                                
                            } else {
                                attrImpSuffix.append("âhk")
                                attrImpVerb.append(tVerb)
                               
                            }
                        case 3:
                            if boolPlural {
                                attrImpSuffix.append("ohkok")
                                attrImpVerb.append(tVerb)
                               
                            } else {
                                attrImpSuffix.append("ohk")
                                attrImpVerb.append(tVerb)
                                
                            }
                        default:
                            attrImpSuffix.append(suffix)
                            attrImpVerb.append(rootVerb)
                           
                        }
                    
                    if thePrev > 0 {
                        attrImpPrefix.append("\(strPreVerb)")
                        attrImpEnglish.append("\(strPreVerb_e) \(checkForSelf(checkEnglish:theVerb.english, index:person, tense:2)) \(dObject)")
                    } else {
                        attrImpPrefix.append("")
                        attrImpEnglish.append("\(checkForSelf(checkEnglish:theVerb.english, index:person, tense:2)) \(dObject)")
                    }
                    
                
                    default:
                        if thePrev > 0 {
                            attrImpPrefix.append("\(strPreVerb)")
                            attrImpEnglish.append("\(strPreVerb_e) \(checkForSelf(checkEnglish:theVerb.english, index:person, tense:2)) \(dObject)")
                        } else {
                            attrImpPrefix.append("")
                            attrImpEnglish.append("\(checkForSelf(checkEnglish:theVerb.english, index:person, tense:2)) \(dObject)")
                        }
                        attrImpVerb.append(rootVerb)
                        attrImpSuffix.append(suffix)
                    }
                    
                }
                
            case "Ind":
                tVerb = prepareVerb(theVerb: rootVerb, theType: theVerb.type)
                for (index, _) in people.enumerated() {
                    if boolPlural {//set direct object
                        switch index {
                        case 2,3,7:
                            if checkforSO(checkEnglish:theVerb.english) {
                                dObject = ""
                            } else {
                                dObject = "s.o./them"
                            }
                           
                        default:
                            if checkforSO(checkEnglish:theVerb.english) {
                                dObject = ""
                            } else {
                                dObject = "them"
                            }
                            
                        }
                        
                    } else {
                        switch index {
                        case 2,3,7:
                            if checkforSO(checkEnglish:theVerb.english) {
                                dObject = ""
                            } else {
                                dObject = "s.o./them"
                            }
                            
                        default:
                            if checkforSO(checkEnglish:theVerb.english) {
                                dObject = ""
                            } else {
                                dObject = "s.o."
                            }
                            
                        }
                    }
                    switch index {
                    case 0,4://1, 1p
                        //present tense
                        
                        tVerb2 = addT2(theVerb: rootVerb, thePrefix: "ni", thePrev: thePrev)
                        if thePrev > 0 {
                            attrPrefix.append("\(tVerb2)\(strPreVerb)")
                            attrEnglish.append("\(pronouns[index]) \(strPreVerb_e) \(checkForSelf(checkEnglish:theVerb.english, index:index, tense:2)) \(dObject)")
                        } else {
                            attrPrefix.append("\(tVerb2)")
                            attrEnglish.append("\(pronouns[index]) \(checkForSelf(checkEnglish:theVerb.english, index:index, tense:0)) \(dObject)")
                        }
                        
                        attrVerb.append(tVerb)
                        attrSuffix.append(inplVTAsuffix[index])
                        
                        //past tense
                        if thePrev > 0 {
                            attrPrefix.append("nikî-\(strPreVerb)")
                            attrEnglish.append("\(pronouns[index]) did \(strPreVerb_e) \(checkForSelf(checkEnglish:theVerb.english, index:index, tense:2)) \(dObject)")
                        } else {
                            attrPrefix.append("nikî-")
                            attrEnglish.append("\(pronouns[index]) \(checkForSelf(checkEnglish:theVerb.english, index:index, tense:1)) \(dObject)")
                        }
                        
                        attrVerb.append(tVerb)
                        attrSuffix.append(inplVTAsuffix[index])
                     
                       
                        //future indefinite
                        if thePrev > 0 {
                            attrPrefix.append("niwî-\(strPreVerb)")
                            attrEnglish.append("\(pronouns[index]) intend to \(strPreVerb_e) \(checkForSelf(checkEnglish:theVerb.english, index:index, tense:2)) \(dObject)")
                        } else {
                            attrPrefix.append("niwî-")
                            attrEnglish.append("\(pronouns[index]) intend to \(checkForSelf(checkEnglish:theVerb.english, index:index, tense:2)) \(dObject)")
                        }
                        
                        attrVerb.append(tVerb)
                        attrSuffix.append(inplVTAsuffix[index])
                        
            
                        
                        //future definite
                        if thePrev > 0 {
                            attrPrefix.append("nika-\(strPreVerb)")
                            attrEnglish.append("\(pronouns[index]) will \(strPreVerb_e) \(checkForSelf(checkEnglish:theVerb.english, index:index, tense:2)) \(dObject)")
                        } else {
                            attrPrefix.append("nika-")
                            attrEnglish.append("\(pronouns[index]) will \(checkForSelf(checkEnglish:theVerb.english, index:index, tense:2)) \(dObject)")
                        }
                        
                        attrVerb.append(tVerb)
                        attrSuffix.append(inplVTAsuffix[index])
                        
                       
                        //can/culd/should
                        if thePrev > 0 {
                            attrPrefix.append("nika-kî-\(strPreVerb)")
                            attrEnglish.append("\(pronouns[index]) should \(strPreVerb_e) \(checkForSelf(checkEnglish:theVerb.english, index:index, tense:2)) \(dObject)")
                        } else {
                            attrPrefix.append("nika-kî-")
                            attrEnglish.append("\(pronouns[index]) should \(checkForSelf(checkEnglish:theVerb.english, index:index, tense:2)) \(dObject)")
                        }
                        
                        attrVerb.append(tVerb)
                        attrSuffix.append(inplVTAsuffix[index])
                       
                        
                        
                    case 1, 5, 6://2,21,2p
                        //present tense
                        tVerb2 = addT2(theVerb: rootVerb, thePrefix: "ki", thePrev: thePrev)
                        if thePrev > 0 {
                            attrPrefix.append("\(tVerb2)\(strPreVerb)")
                            attrEnglish.append("\(pronouns[index]) \(strPreVerb_e) \(checkForSelf(checkEnglish:theVerb.english, index:index, tense:2)) \(dObject)")
                        } else {
                            attrPrefix.append("\(tVerb2)")
                            attrEnglish.append("\(pronouns[index]) \(checkForSelf(checkEnglish:theVerb.english, index:index, tense:0)) \(dObject)")
                        }
                        
                        attrVerb.append(tVerb)
                        attrSuffix.append(inplVTAsuffix[index])
                        
                        //past tense
                        if thePrev > 0 {
                            attrPrefix.append("kikî-\(strPreVerb)")
                            attrEnglish.append("\(pronouns[index]) did \(strPreVerb_e) \(checkForSelf(checkEnglish:theVerb.english, index:index, tense:2)) \(dObject)")
                        } else {
                            attrPrefix.append("kikî-")
                            attrEnglish.append("\(pronouns[index]) \(checkForSelf(checkEnglish:theVerb.english, index:index, tense:1)) \(dObject)")
                        }
                        
                        attrVerb.append(tVerb)
                        attrSuffix.append(inplVTAsuffix[index])
                        
                        
                        //future indefinite
                        if thePrev > 0 {
                            attrPrefix.append("kiwî-\(strPreVerb)")
                            attrEnglish.append("\(pronouns[index]) intend to \(strPreVerb_e) \(checkForSelf(checkEnglish:theVerb.english, index:index, tense:2)) \(dObject)")
                        } else {
                            attrPrefix.append("kiwî-")
                            attrEnglish.append("\(pronouns[index]) intend to \(checkForSelf(checkEnglish:theVerb.english, index:index, tense:2)) \(dObject)")
                        }
                        
                        attrVerb.append(tVerb)
                        attrSuffix.append(inplVTAsuffix[index])
                        
                        //future definite
                        if thePrev > 0 {
                            attrPrefix.append("kika-\(strPreVerb)")
                            attrEnglish.append("\(pronouns[index]) will \(strPreVerb_e) \(checkForSelf(checkEnglish:theVerb.english, index:index, tense:2)) \(dObject)")
                        } else {
                            attrPrefix.append("kika-")
                            attrEnglish.append("\(pronouns[index]) will \(checkForSelf(checkEnglish:theVerb.english, index:index, tense:2)) \(dObject)")
                        }
                        
                        attrVerb.append(tVerb)
                        attrSuffix.append(inplVTAsuffix[index])
                        
                        
                        //can/culd/should
                        if thePrev > 0 {
                            attrPrefix.append("kika-kî-\(strPreVerb)")
                            attrEnglish.append("\(pronouns[index]) should \(strPreVerb_e) \(checkForSelf(checkEnglish:theVerb.english, index:index, tense:2)) \(dObject)")
                        } else {
                            attrPrefix.append("kika-kî-")
                            attrEnglish.append("\(pronouns[index]) should \(checkForSelf(checkEnglish:theVerb.english, index:index, tense:2)) \(dObject)")
                        }
                        
                        attrVerb.append(tVerb)
                        attrSuffix.append(inplVTAsuffix[index])
                     
                    default://3,3'(p),3p
                        //present tense
                        if thePrev > 0 {
                            attrPrefix.append("\(strPreVerb)")
                            attrEnglish.append("\(pronouns[index]) \(strPreVerb_e) \(checkForSelf(checkEnglish:theVerb.english, index:index, tense:2)) \(dObject)")
                        } else {
                            attrPrefix.append("")
                            attrEnglish.append("\(pronouns[index]) \(checkForSelf(checkEnglish:theVerb.english, index:index, tense:0)) \(dObject)")
                        }
                        
                        attrVerb.append(tVerb)
                        attrSuffix.append(inplVTAsuffix[index])
                        
                        
                        
                        //past tense
                        if thePrev > 0 {
                            attrPrefix.append("kî-\(strPreVerb)")
                            attrEnglish.append("\(pronouns[index]) did \(strPreVerb_e) \(checkForSelf(checkEnglish:theVerb.english, index:index, tense:2)) \(dObject)")
                        } else {
                            attrPrefix.append("kî-")
                            attrEnglish.append("\(pronouns[index]) \(checkForSelf(checkEnglish:theVerb.english, index:index, tense:1)) \(dObject)")
                        }
                        
                        attrVerb.append(tVerb)
                        attrSuffix.append(inplVTAsuffix[index])
                        
                        
                        
                        //future indefinite
                        if thePrev > 0 {
                            attrPrefix.append("wî-\(strPreVerb)")
                            attrEnglish.append("\(pronouns[index]) intend to  \(strPreVerb_e) \(checkForSelf(checkEnglish:theVerb.english, index:index, tense:2)) \(dObject)")
                        } else {
                            attrPrefix.append( "wî-")
                            attrEnglish.append("\(pronouns[index]) intend to \(checkForSelf(checkEnglish:theVerb.english, index:index, tense:2)) \(dObject)")
                        }
                        
                        attrVerb.append(tVerb)
                        attrSuffix.append(inplVTAsuffix[index])
                    
                        
                        
                        //future definite
                        if thePrev > 0 {
                            attrPrefix.append("ta-\(strPreVerb)")
                            attrEnglish.append("\(pronouns[index]) will \(strPreVerb_e) \(checkForSelf(checkEnglish:theVerb.english, index:index, tense:2)) \(dObject)")
                        } else {
                            attrPrefix.append("ta-")
                            attrEnglish.append("\(pronouns[index]) will \(checkForSelf(checkEnglish:theVerb.english, index:index, tense:2)) \(dObject)")
                        }
                        
                        attrVerb.append(tVerb)
                        attrSuffix.append(inplVTAsuffix[index])
                        
                        
                        
                        
                        //can/culd/should
                        if thePrev > 0 {
                            attrPrefix.append("ta-kî-\(strPreVerb)")
                            attrEnglish.append("\(pronouns[index]) should \(strPreVerb_e) \(checkForSelf(checkEnglish:theVerb.english, index:index, tense:2)) \(dObject)")
                        } else {
                            attrPrefix.append("ta-kî-")
                            attrEnglish.append("\(pronouns[index]) should \(checkForSelf(checkEnglish:theVerb.english, index:index, tense:2)) \(dObject)")
                        }
                        
                        attrVerb.append(tVerb)
                        attrSuffix.append(inplVTAsuffix[index])
             
                    }
                }
                
            case "Inv":
                var invVerbsuffix:[String] = []
                var invConsuff:[String] = []
                var invFutsuff:[String] = []
                var actor:[String] = []
                if boolPlural{
                    invVerbsuffix = indInvVTApl
                    invConsuff = conInvVTApl
                    invFutsuff = futInvVTApl
                    actor = ["they","they","hers/his/its","her/his/its__","they","they","they","they"]
                } else {
                    invVerbsuffix = indInvVTA
                    invConsuff = conInvVTA
                    invFutsuff = futInvVTA
                    actor = i3VTAa
                }
                //indicative
                tVerb = getVTAVerbType(theVerb: rootVerb) // prep verb
                
                for (index, _) in people.enumerated() {
                    switch index {
                    case 0://first person 1
                        switch iVerb {
                        case 2://VTA2
                            //present tense
                            
                            tVerb2 = addT2(theVerb: tVerb, thePrefix: "ni", thePrev: thePrev)
                            if thePrev > 0 {
                                attrPrefix.append("\(tVerb2)\(strPreVerb)")
                                attrEnglish.append("\(actor[index]) \(strPreVerb_e) \(checkForSelf(checkEnglish:theVerb.english, index:index, tense:2)) \(i3VTAo[index])")
                            } else {
                                attrPrefix.append("\(tVerb2)")
                                attrEnglish.append("\(actor[index]) \(checkForSelf(checkEnglish:theVerb.english, index:index, tense:0)) \(i3VTAo[index])")
                            }
                            attrVerb.append(tVerb)
                            attrSuffix.append("\(invSuff)\(invVerbsuffix[index])")
                           
                           
                            //conj
                            if thePrev > 0 {
                                attrPrefix.append("ê-\(strPreVerb)")
                                attrEnglish.append("As \(actor[index]) \(strPreVerb_e) \(checkForSelf(checkEnglish:theVerb.english, index:index, tense:2)) \(i3VTAo[index])")
                            } else {
                                attrPrefix.append("ê-")
                                attrEnglish.append("As \(actor[index]) \(checkForSelf(checkEnglish:theVerb.english, index:index, tense:0)) \(i3VTAo[index])")
                            }
                            attrVerb.append(rootVerb)
                            attrSuffix.append("i\(invConsuff[index])")
                            
                            
                            //fut cond
                            if thePrev > 0 {
                                attrPrefix.append( "\(strPreVerb)")
                                attrEnglish.append( "If/when \(actor[index]) \(strPreVerb_e) \(checkForSelf(checkEnglish:theVerb.english, index:index, tense:2)) \(i3VTAo[index])")
                            } else {
                                attrPrefix.append("")
                                attrEnglish.append("If/when \(actor[index]) \(checkForSelf(checkEnglish:theVerb.english, index:index, tense:0)) \(i3VTAo[index])")
                            }
                            attrVerb.append(rootVerb)
                            attrSuffix.append("i\(invFutsuff[index])")
                          
                           
                        case 4://VTA-4
                            //present
                            tVerb2 = addT2(theVerb: rootVerb, thePrefix: "ni", thePrev: thePrev)
                            if thePrev > 0 {
                                attrPrefix.append("\(tVerb2)\(strPreVerb)")
                                attrEnglish.append("\(actor[index]) \(strPreVerb_e) \(checkForSelf(checkEnglish:theVerb.english, index:index, tense:2)) \(i3VTAo[index])")
                            } else {
                                attrPrefix.append("\(tVerb2)")
                                attrEnglish.append("\(actor[index]) \(checkForSelf(checkEnglish:theVerb.english, index:index, tense:0)) \(i3VTAo[index])")
                            }
                            attrVerb.append(rootVerb)
                            attrSuffix.append("\(invSuff)\(invVerbsuffix[index])")
                          
                            
                            //conj
                            if thePrev > 0 {
                                attrPrefix.append("ê-\(strPreVerb)")
                                attrEnglish.append("As \(actor[index]) \(strPreVerb_e) \(checkForSelf(checkEnglish:theVerb.english, index:index, tense:2)) \(i3VTAo[index])")
                            } else {
                                attrPrefix.append("ê-")
                                attrEnglish.append("As \(actor[index]) \(checkForSelf(checkEnglish:theVerb.english, index:index, tense:0)) \(i3VTAo[index])")
                            }
                            attrVerb.append(tVerb)
                            attrSuffix.append("\(invSuff)\(invConsuff[index])")
                            
                 
                            //future conditional
                            if thePrev > 0 {
                                attrPrefix.append("\(strPreVerb)")
                                attrEnglish.append("If/when \(actor[index]) \(strPreVerb_e) \(checkForSelf(checkEnglish:theVerb.english, index:index, tense:2)) \(i3VTAo[index])")
                            } else {
                                attrPrefix.append("")
                                attrEnglish.append("If/when \(actor[index]) \(checkForSelf(checkEnglish:theVerb.english, index:index, tense:0)) \(i3VTAo[index])")
                            }
                            attrVerb.append(tVerb)
                            attrSuffix.append("\(invSuff)\(invFutsuff[index])")
                     
                        default: //vta1,3
                            //present
                            tVerb2 = addT2(theVerb: rootVerb, thePrefix: "ni", thePrev: thePrev)
                            if thePrev > 0 {
                                attrPrefix.append("\(tVerb2)\(strPreVerb)")
                                attrEnglish.append("\(actor[index]) \(strPreVerb_e) \(checkForSelf(checkEnglish:theVerb.english, index:index, tense:2)) \(i3VTAo[index])")
                            } else {
                                attrPrefix.append("\(tVerb2)")
                                attrEnglish.append("\(actor[index]) \(checkForSelf(checkEnglish:theVerb.english, index:index, tense:0)) \(i3VTAo[index])")
                            }
                            attrVerb.append(tVerb)
                            attrSuffix.append("\(invSuff)\(invVerbsuffix[index])")
                         
                            
                            
                            //conjunct
                            if thePrev > 0 {
                                attrPrefix.append("ê-\(strPreVerb)")
                                attrEnglish.append("As \(actor[index]) \(strPreVerb_e) \(checkForSelf(checkEnglish:theVerb.english, index:index, tense:2)) \(i3VTAo[index])")
                            } else {
                                attrPrefix.append( "ê-")
                                attrEnglish.append("As \(actor[index]) \(checkForSelf(checkEnglish:theVerb.english, index:index, tense:0)) \(i3VTAo[index])")
                            }
                            attrVerb.append(tVerb)
                            attrSuffix.append("\(invSuff)\(invConsuff[index])")
                
                           
                            
                            //fut cond
                            if thePrev > 0 {
                                attrPrefix.append("\(strPreVerb)")
                                attrEnglish.append("If/when \(actor[index]) \(strPreVerb_e) \(checkForSelf(checkEnglish:theVerb.english, index:index, tense:2)) \(i3VTAo[index])")
                            } else {
                                attrPrefix.append("")
                                attrEnglish.append("If/when \(actor[index]) \(checkForSelf(checkEnglish:theVerb.english, index:index, tense:0)) \(i3VTAo[index])")
                            }
                            attrVerb.append(tVerb)
                            attrSuffix.append("\(invSuff)\(invFutsuff[index])")
                            
                            
                        }
                        
                        
                    case 4://1P
                        var useVerb = ""
                        if iVerb == 4 {
                            useVerb = rootVerb
                        } else {
                            useVerb = getVTAVerbType(theVerb: rootVerb)
                        }
                        //present
                        tVerb2 = addT2(theVerb: useVerb, thePrefix: "ni", thePrev: thePrev)
                        if thePrev > 0 {
                            attrPrefix.append("\(tVerb2)\(strPreVerb)")
                            attrEnglish.append("\(actor[index]) \(strPreVerb_e) \(checkForSelf(checkEnglish:theVerb.english, index:index, tense:2)) \(i3VTAo[index])")
                        } else {
                            attrPrefix.append("\(tVerb2)")
                            attrEnglish.append("\(actor[index]) \(checkForSelf(checkEnglish:theVerb.english, index:index, tense:0)) \(i3VTAo[index])")
                        }
                        attrVerb.append(useVerb)
                        attrSuffix.append( "\(invSuff)\(invVerbsuffix[index])")

                        
                        //conjunct
                        if thePrev > 0 {
                            attrPrefix.append("ê-\(strPreVerb)")
                            attrEnglish.append("As \(actor[index]) \(strPreVerb_e) \(checkForSelf(checkEnglish:theVerb.english, index:index, tense:2)) \(i3VTAo[index])")
                        } else {
                            attrPrefix.append("ê-")
                            attrEnglish.append("As \(actor[index]) \(checkForSelf(checkEnglish:theVerb.english, index:index, tense:0)) \(i3VTAo[index])")
                        }
                        attrVerb.append(useVerb)
                        attrSuffix.append("\(invSuff)\(invConsuff[index])")
                    
                        //fut cond
                        if thePrev > 0 {
                            attrPrefix.append("\(strPreVerb)")
                            attrEnglish.append("If/when \(actor[index]) \(strPreVerb_e) \(checkForSelf(checkEnglish:theVerb.english, index:index, tense:2)) \(i3VTAo[index])")
                        } else {
                            attrPrefix.append("")
                            attrEnglish.append("If/when \(actor[index]) \(checkForSelf(checkEnglish:theVerb.english, index:index, tense:0)) \(i3VTAo[index])")
                        }
                        attrVerb.append(useVerb)
                        attrSuffix.append("\(invSuff)\(invFutsuff[index])")

                       
                        
                    case 1, 5,6://2,21,2P
                        var useVerb = ""
                        if iVerb == 4 {
                            useVerb = rootVerb
                        } else {
                            useVerb = getVTAVerbType(theVerb: rootVerb)
                        }
                        //present
                        tVerb2 = addT2(theVerb: useVerb, thePrefix: "ki", thePrev: thePrev)
                        if thePrev > 0 {
                            attrPrefix.append("\(tVerb2)\(strPreVerb)")
                            attrEnglish.append("\(actor[index]) \(strPreVerb_e) \(checkForSelf(checkEnglish:theVerb.english, index:index, tense:2)) \(i3VTAo[index])")
                        } else {
                            attrPrefix.append( "\(tVerb2)")
                            attrEnglish.append("\(actor[index]) \(checkForSelf(checkEnglish:theVerb.english, index:index, tense:0)) \(i3VTAo[index])")
                        }
                        attrVerb.append(useVerb)
                        attrSuffix.append("\(invSuff)\(invVerbsuffix[index])")
                        
                        //conjunct
                        if thePrev > 0 {
                            attrPrefix.append("ê-\(strPreVerb)")
                            attrEnglish.append("As \(actor[index]) \(strPreVerb_e) \(checkForSelf(checkEnglish:theVerb.english, index:index, tense:2)) \(i3VTAo[index])")
                        } else {
                            attrPrefix.append("ê-")
                            attrEnglish.append("As \(actor[index]) \(checkForSelf(checkEnglish:theVerb.english, index:index, tense:0)) \(i3VTAo[index])")
                        }
                        attrVerb.append(useVerb)
                        attrSuffix.append("\(invSuff)\(invConsuff[index])")
                       
                        
                        //fut cond
                        if thePrev > 0 {
                            attrPrefix.append("\(strPreVerb)")
                            attrEnglish.append("If/when \(actor[index]) \(strPreVerb_e) \(checkForSelf(checkEnglish:theVerb.english, index:index, tense:2)) \(i3VTAo[index])")
                        } else {
                            attrPrefix.append("")
                            attrEnglish.append("If/when \(actor[index]) \(checkForSelf(checkEnglish:theVerb.english, index:index, tense:0)) \(i3VTAo[index])")
                        }
                        attrVerb.append(useVerb)
                        attrSuffix.append("\(invSuff)\(invFutsuff[index])")

                        
                        
                    default: //3, 3'(P), 3P
                        var useVerb = ""
                        if iVerb == 4 {
                            useVerb = rootVerb
                        } else {
                            useVerb = getVTAVerbType(theVerb: rootVerb)
                        }
                        //present
                        if thePrev > 0 {
                            attrPrefix.append("\(strPreVerb)")
                            attrEnglish.append("\(actor[index]) \(strPreVerb_e) \(checkForSelf(checkEnglish:theVerb.english, index:index, tense:2)) \(i3VTAo[index])")
                        } else {
                            attrPrefix.append("")
                            attrEnglish.append("\(actor[index]) \(checkForSelf(checkEnglish:theVerb.english, index:index, tense:0)) \(i3VTAo[index])")
                        }
                        attrVerb.append(useVerb)
                        
                        
                        if (iVerb == 2) && (index == 7)  {
                            attrSuffix.append("\(invSuff)kwak")
                           
                        } else if ((iVerb == 4) || (iVerb == 3)) && (index == 7) && (boolPlural){
                            attrSuffix.append("\(invSuff)kwak")
                           
                        } else {
                            attrSuffix.append("\(invSuff)\(invVerbsuffix[index])")
                            
                        }
                        
                        
                        //conjunct
                        if thePrev > 0 {
                            attrPrefix.append("ê-\(strPreVerb)")
                            attrEnglish.append("As \(actor[index]) \(strPreVerb_e) \(checkForSelf(checkEnglish:theVerb.english, index:index, tense:2)) \(i3VTAo[index])")
                        } else {
                            attrPrefix.append("ê-")
                            attrEnglish.append("As \(actor[index]) \(checkForSelf(checkEnglish:theVerb.english, index:index, tense:0)) \(i3VTAo[index])")
                        }
                        attrVerb.append(useVerb)
                        attrSuffix.append("\(invSuff)\(invConsuff[index])")
                        

                        
                        
                        //fut cond
                        if thePrev > 0 {
                            attrPrefix.append("\(strPreVerb)")
                            attrEnglish.append("If/when \(actor[index]) \(strPreVerb_e) \(checkForSelf(checkEnglish:theVerb.english, index:index, tense:2)) \(i3VTAo[index])")
                        } else {
                            attrPrefix.append("")
                            attrEnglish.append("If/when \(actor[index]) \(checkForSelf(checkEnglish:theVerb.english, index:index, tense:0)) \(i3VTAo[index])")
                        }
                        attrVerb.append(useVerb)
                        attrSuffix.append("\(invSuff)\(invFutsuff[index])")

                       
                        
                    }
                }
            case "You":
                // cSections = ["Statement Present-Direct", "Conjunct clause-Direct", "Future Conditional Clause-Direct","Statement Present-Inverse", "Conjunct clause-Inverse", "Future Conditional Clause-Inverse", "Command-Inverse"]
                var useVerb = ""
                useVerb = getVTAVerbType(theVerb: rootVerb)
                for (person, _) in iPeople.enumerated() {
                    //indicative Direct
                    if (iVerb == 4) {
                        useVerb = rootVerb
                        invSuff = "i"
                    } else {
                        useVerb = getVTAVerbType(theVerb: rootVerb)
                    }
                    //"present
                    boolInv = false
                    tVerb2 = addT2(theVerb: useVerb, thePrefix: "ki", thePrev: thePrev)
                    if thePrev > 0 {
                        attrPrefix.append("\(tVerb2)\(strPreVerb)")
                        attrEnglish.append("\(iPronoun[person]) \(strPreVerb_e) \(checkForSelf(checkEnglish:theVerb.english, index:person, tense:2)) \(iPronoun[person+3])")
                    } else  {
                        attrPrefix.append("\(tVerb2)")
                        attrEnglish.append("\(iPronoun[person]) \(checkForSelf(checkEnglish:theVerb.english, index:person, tense:0)) \(iPronoun[person+3])")
                    }
                    
                    attrVerb.append(useVerb)
                    attrSuffix.append("\(invSuff)\(indDirYou[person])")
                    
                    
                    
                    //conjunt clause dir
                    if thePrev > 0 {
                        attrPrefix.append("ê-\(strPreVerb)")
                        attrEnglish.append("As \(iPronoun[person]) \(strPreVerb_e) \(checkForSelf(checkEnglish:theVerb.english, index:person, tense:2)) \(iPronoun[person+3])")
                    } else {
                        attrPrefix.append("ê-")
                       attrEnglish.append("As \(iPronoun[person]) \(checkForSelf(checkEnglish:theVerb.english, index:person, tense:0)) \(iPronoun[person+3])")
                    }
                    
                    if (iVerb == 2) || (iVerb == 3) {
                        attrSuffix.append( "\(invSuff)\(conDirYou2[person])")
                        
                    }else{
                        attrSuffix.append("\(invSuff)\(conDirYou[person])")
                        
                    }
                    attrVerb.append(useVerb)
                    
                  
                    
                    //fut - direct
                    if person == 1 {
                        if iVerb == 2{
                            attrSuffix.append("\(invSuff)\(futDirYou[person])o")
                            

                        } else {
                            attrSuffix.append("\(invSuff)\(futDirYou[person])i")

                        }
                        
                    } else {
                        attrSuffix.append("\(invSuff)\(futDirYou[person])")
                        
                    }
                    if thePrev > 0 {
                        attrPrefix.append("\(strPreVerb)")
                        attrEnglish.append("If/when \(iPronoun[person]) \(strPreVerb_e) \(checkForSelf(checkEnglish:theVerb.english, index:person, tense:2)) \(iPronoun[person+3])")
                    } else {
                        attrPrefix.append("")
                        attrEnglish.append("If/when \(iPronoun[person]) \(checkForSelf(checkEnglish:theVerb.english, index:person, tense:0)) \(iPronoun[person+3])")
                    }
                    attrVerb.append(useVerb)
                  
                    if iVerb == 2 {
                        useVerb = rootVerb
                        invSuff = "i"
                    } else {
                        useVerb = getVTAVerbType(theVerb: rootVerb)
                    }
                    //indicative inverse
                   boolInv = true
                    tVerb2 = addT2(theVerb: useVerb, thePrefix: "ki", thePrev: thePrev)
                    if thePrev > 0 {
                        attrPrefix.append("\(tVerb2)\(strPreVerb)")
                        attrEnglish.append("\(iPronouns[person]) \(strPreVerb_e) \(checkForSelf(checkEnglish:theVerb.english, index:person, tense:2)) \(iPronouns[person+3])")
                    } else  {
                        attrPrefix.append("\(tVerb2)")
                        attrEnglish.append("\(iPronouns[person]) \(checkForSelf(checkEnglish:theVerb.english, index:person, tense:0)) \(iPronouns[person+3])")
                    }
                    
                    attrVerb.append(useVerb)
                    attrSuffix.append( "\(invSuff)\(indInvYou[person])")

                    //conjunct Inverse
                    if thePrev > 0 {
                        attrPrefix.append("ê-\(strPreVerb)")
                        attrEnglish.append( "As \(iPronouns[person]) \(strPreVerb_e) \(checkForSelf(checkEnglish:theVerb.english, index:person, tense:2)) \(iPronouns[person+3])")
                    } else {
                        attrPrefix.append("ê-")
                        attrEnglish.append("As \(iPronouns[person]) \(checkForSelf(checkEnglish:theVerb.english, index:person, tense:0)) \(iPronouns[person+3])")
                    }
                    attrVerb.append(useVerb)
                    attrSuffix.append( "\(invSuff)\(conInvYou[person])")
    
                    
                    
                    
                    //fut cond inverse
                    if thePrev > 0 {
                        attrPrefix.append("\(strPreVerb)")
                        attrEnglish.append("If/when \(iPronouns[person]) \(strPreVerb_e) \(checkForSelf(checkEnglish:theVerb.english, index:person, tense:2)) \(iPronouns[person+3])")
                    } else {
                        attrPrefix.append("")
                        attrEnglish.append("If/when \(iPronouns[person]) \(checkForSelf(checkEnglish:theVerb.english, index:person, tense:0)) \(iPronouns[person+3])")
                    }
                    attrVerb.append(useVerb)
                    attrSuffix.append("\(invSuff)\(futInvYou[person])")
                    
                    
                }
                
                if (iVerb == 3) || (iVerb == 4) || (iVerb == 0){
                    useVerb = getVTAVerbType(theVerb: rootVerb)
                } else {
                    useVerb = rootVerb
                    invSuff = "i"
                }
                //imperative
                for (person, suffix) in impInvYou.enumerated(){
                    
                    switch person {
                    case 0,3:
                        if thePrev > 0 {
                            attrImpPrefix.append("\(strPreVerb)")
                            attrImpEnglish.append("\(strPreVerb_e) \(checkForSelf(checkEnglish:theVerb.english, index:person, tense:2)) \(iPronouns[3])")
                        } else {
                            attrImpPrefix.append("")
                            attrImpEnglish.append("\(checkForSelf(checkEnglish:theVerb.english, index:person, tense:2)) \(iPronouns[3])")
                        }
                        attrImpSuffix.append("\(invSuff)\(suffix)")
                         attrImpVerb.append(useVerb)

                    case 1,4:
                        if thePrev > 0 {
                            attrImpPrefix.append("\(strPreVerb)")
                            attrImpEnglish.append("\(strPreVerb_e) \(checkForSelf(checkEnglish:theVerb.english, index:person, tense:2)) \(iPronouns[4])")
                        } else {
                            attrImpPrefix.append("")
                            attrImpEnglish.append("\(checkForSelf(checkEnglish:theVerb.english, index:person, tense:2)) \(iPronouns[4])")
                        }

                        attrImpSuffix.append("\(invSuff)\(suffix)")
                         attrImpVerb.append(useVerb)
                        
                    case 2,5:
                        
                        if thePrev > 0 {
                            attrImpPrefix.append("\(strPreVerb)")
                            attrImpEnglish.append("\(strPreVerb_e) \(checkForSelf(checkEnglish:theVerb.english, index:person, tense:2)) \(iPronouns[3])")
                        } else {
                            attrImpPrefix.append("")
                            attrImpEnglish.append("\(checkForSelf(checkEnglish:theVerb.english, index:person, tense:2)) \(iPronouns[3])")
                        }
                        attrImpSuffix.append("\(invSuff)\(suffix)")
                        attrImpVerb.append(useVerb)
                    default:
                        break
                    }
                    
                }
                
                
            default:
                break
            }
        case "VTI": //VTI
            switch strMode {
            case "Con"://conjunct mode
                tVerb = prepareVerb(theVerb: rootVerb, theType: theVerb.type)
                if boolVTIsuffix {
                    indVTIsuffix = conVTI
                    futVTIsuffix = futVTI
                    
                } else {
                    indVTIsuffix = conVAI
                    futVTIsuffix = futVAI
                }
                
                for (index, _) in people.enumerated() {
                    //present tense
                    if thePrev > 0{
                         attrPrefix.append("ê-\(strPreVerb)")
                        attrEnglish.append("As \(pronouns[index]) \(strPreVerb_e) \(checkForSelf(checkEnglish:theVerb.english, index:index, tense:2)) something(s)")
                    }else {
                        attrPrefix.append("ê-")
                        attrEnglish.append("As \(pronouns[index]) \(checkForSelf(checkEnglish:theVerb.english, index:index, tense:0)) something(s)")
                    }
                   
                    attrVerb.append("\(rootVerb)")
                    attrSuffix.append("\(indVTIsuffix[index])")

                    
                    
                    //past
                    if thePrev > 0{
                        attrPrefix.append("ê-kî-\(strPreVerb)")
                        attrEnglish.append("As \(pronouns[index]) did \(strPreVerb_e) \(checkForSelf(checkEnglish:theVerb.english, index:index, tense:2)) something(s)")
                    }else {
                        attrPrefix.append("ê-kî-")
                        attrEnglish.append("As \(pronouns[index]) \(checkForSelf(checkEnglish:theVerb.english, index:index, tense:1)) something(s)")
                    }
                    
                    attrVerb.append("\(rootVerb)")
                    attrSuffix.append("\(indVTIsuffix[index])")
                    
                
                    
                    //future indefinite
                    if thePrev > 0{
                        attrPrefix.append("ê-wî-\(strPreVerb)")
                        attrEnglish.append("As \(pronouns[index]) intend to \(strPreVerb_e) \(checkForSelf(checkEnglish:theVerb.english, index:index, tense:2)) something(s)")
                    }else {
                        attrPrefix.append("ê-wî-")
                        attrEnglish.append("As \(pronouns[index]) intend to \(checkForSelf(checkEnglish:theVerb.english, index:index, tense:2)) something(s)")
                    }
                    
                    attrVerb.append("\(rootVerb)")
                    attrSuffix.append("\(indVTIsuffix[index])")
                    
                    
                    
                    //relative clause
                    if thePrev > 0{
                        attrPrefix.append("kâ-\(strPreVerb)")
                        attrEnglish.append("\(pronouns[index]) who \(strPreVerb_e) \(checkForSelf(checkEnglish:theVerb.english, index:index, tense:2)) something(s)")
                    }else {
                        attrPrefix.append("kâ-")
                        attrEnglish.append("\(pronouns[index]) who \(checkForSelf(checkEnglish:theVerb.english, index:index, tense:0)) something(s)")
                    }
                    
                    attrVerb.append("\(rootVerb)")
                    attrSuffix.append("\(indVTIsuffix[index])")
                    
    
                    
                    //relative clause past
                    if thePrev > 0{
                        attrPrefix.append("kâ-kî-\(strPreVerb)")
                        attrEnglish.append("\(pronouns[index]) who did \(strPreVerb_e) \(checkForSelf(checkEnglish:theVerb.english, index:index, tense:2)) something(s)")
                    }else {
                        attrPrefix.append("kâ-kî-")
                        attrEnglish.append("\(pronouns[index]) who \(checkForSelf(checkEnglish:theVerb.english, index:index, tense:1)) something(s)")
                    }
                    
                    attrVerb.append("\(rootVerb)")
                    attrSuffix.append("\(indVTIsuffix[index])")
                  
                    
                    //relative clause future indefinite
                    if thePrev > 0{
                        attrPrefix.append("kâ-wî-\(strPreVerb)")
                        attrEnglish.append("\(pronouns[index]) who intends \(strPreVerb_e) \(checkForSelf(checkEnglish:theVerb.english, index:index, tense:2)) something(s)")
                    }else {
                        attrPrefix.append("kâ-wî-")
                        attrEnglish.append("\(pronouns[index]) who intends \(checkForSelf(checkEnglish:theVerb.english, index:index, tense:2)) something(s)")
                    }
                    
                    attrVerb.append("\(rootVerb)")
                    attrSuffix.append("\(indVTIsuffix[index])")
                    
                
                    
                    //infinitive
                    if thePrev > 0{
                        attrPrefix.append("ta-\(strPreVerb)")
                        attrEnglish.append("to \(strPreVerb_e) \(checkForSelf(checkEnglish:theVerb.english, index:index, tense:2)) something(s)")
                    }else {
                        attrPrefix.append("ta-")
                        attrEnglish.append("to \(checkForSelf(checkEnglish:theVerb.english, index:index, tense:2)) something(s)")
                    }
                    
                    attrVerb.append("\(rootVerb)")
                    attrSuffix.append("\(indVTIsuffix[index])")
           
                    
                    //future conditional
                    if thePrev > 0{
                        attrPrefix.append("\(strPreVerb)")
                        attrEnglish.append("If/when \(pronouns[index]) \(strPreVerb_e) \(checkForSelf(checkEnglish:theVerb.english, index:index, tense:2)) something(s)")
                    }else {
                        attrPrefix.append("")
                        attrEnglish.append("If/when \(pronouns[index]) \(checkForSelf(checkEnglish:theVerb.english, index:index, tense:0)) something(s)")
                    }
                    
                    attrVerb.append("\(rootVerb)")
                    attrSuffix.append("\(futVTIsuffix[index])")
                    
                    
                }
            case "Imp":
                tVerb = prepareVerb(theVerb: rootVerb, theType: theVerb.type)
                if boolVTIsuffix {
                    impVTIsuffix = impVTI
                } else {
                    impVTIsuffix = impVAI
                }
                for (person, suffix) in impVTIsuffix.enumerated(){
                    
                    switch person {
                    case 0:
                        if thePrev > 0 {
                            attrImpPrefix.append("\(strPreVerb)")
                            attrImpEnglish.append("\(strPreVerb_e) \(checkForSelf(checkEnglish:theVerb.english, index:person, tense:2)) something(s)")
                        } else {
                            attrImpPrefix.append("")
                            attrImpEnglish.append("\(checkForSelf(checkEnglish:theVerb.english, index:person, tense:2)) something(s)")
                        }
                        
                        
                        attrImpSuffix.append("\(suffix)")
                        attrImpVerb.append("\(theVerb.imperative)")
                    case 1,3,4:
                        if thePrev > 0 {
                            attrImpPrefix.append("\(strPreVerb)")
                            attrImpEnglish.append("\(strPreVerb_e) \(checkForSelf(checkEnglish:theVerb.english, index:person, tense:2)) something(s)")
                        } else {
                            attrImpPrefix.append("")
                            attrImpEnglish.append("\(checkForSelf(checkEnglish:theVerb.english, index:person, tense:2)) something(s)")
                        }
                        
                        
                        attrImpSuffix.append("\(suffix)")
                        attrImpVerb.append("\(rootVerb)")
                  
                    case 2,5:
                        attrImpSuffix.append("\(suffix)")
                        if person == 2 {
                            attrImpVerb.append(tVerb)
                            
                        } else {
                            attrImpVerb.append("\(rootVerb)")
                            
                        }
                        
                        if thePrev > 0 {
                            attrImpPrefix.append("\(strPreVerb)")
                            attrImpEnglish.append("\(strPreVerb_e) \(checkForSelf(checkEnglish:theVerb.english, index:person, tense:2)) something(s)")
                        } else {
                            attrImpPrefix.append("")
                            attrImpEnglish.append("\(checkForSelf(checkEnglish:theVerb.english, index:person, tense:2)) something(s)")
                        }
                       
                    default:
                        break
                    }
                    
                }
                
            default: //ind
                
                tVerb = prepareVerb(theVerb: rootVerb, theType: theVerb.type)
                if boolVTIsuffix {
                    indVTIsuffix = indVTI
                } else {
                    indVTIsuffix = indVAI
                }
                for (index, _) in people.enumerated() {
                    switch index {
                    case 0,4://1, 1p
                        //present
                        tVerb2 = addT2(theVerb: rootVerb, thePrefix: "ni", thePrev: thePrev)
                        if thePrev > 0 {
                            attrPrefix.append("\(tVerb2)\(strPreVerb)")
                            attrEnglish.append("\(pronouns[index]) \(strPreVerb_e) \(checkForSelf(checkEnglish:theVerb.english, index:index, tense:2)) something(s)")
                        } else {
                            attrPrefix.append("\(tVerb2)")
                            attrEnglish.append("\(pronouns[index]) \(checkForSelf(checkEnglish:theVerb.english, index:index, tense:0)) something(s)")
                        }
                        attrVerb.append(tVerb)
                        attrSuffix.append("\(indVTIsuffix[index])")
    
                        
                        //past tense
                        if thePrev > 0 {
                            attrPrefix.append("nikî-\(strPreVerb)")
                            attrEnglish.append("\(pronouns[index]) did \(strPreVerb_e) \(checkForSelf(checkEnglish:theVerb.english, index:index, tense:2)) something(s)")
                        } else {
                            attrPrefix.append("nikî-")
                            attrEnglish.append("\(pronouns[index]) \(checkForSelf(checkEnglish:theVerb.english, index:index, tense:1)) something(s)")
                        }
                        attrVerb.append(tVerb)
                        attrSuffix.append("\(indVTIsuffix[index])")
                     
                        //future indefinite
                        if thePrev > 0 {
                            attrPrefix.append("niwî-\(strPreVerb)")
                            attrEnglish.append("\(pronouns[index]) intend to \(strPreVerb_e) \(checkForSelf(checkEnglish:theVerb.english, index:index, tense:2)) something(s)")
                        } else {
                            attrPrefix.append("niwî-")
                            attrEnglish.append("\(pronouns[index]) intend to \(checkForSelf(checkEnglish:theVerb.english, index:index, tense:2)) something(s)")
                        }
                        attrVerb.append(tVerb)
                        attrSuffix.append("\(indVTIsuffix[index])")
                        
                        //future definite
                        if thePrev > 0 {
                            attrPrefix.append("nika-\(strPreVerb)")
                            attrEnglish.append("\(pronouns[index]) will \(strPreVerb_e) \(checkForSelf(checkEnglish:theVerb.english, index:index, tense:2)) something(s)")
                        } else {
                            attrPrefix.append("nika-")
                            attrEnglish.append("\(pronouns[index]) will \(checkForSelf(checkEnglish:theVerb.english, index:index, tense:2)) something(s)")
                        }
                        attrVerb.append(tVerb)
                        attrSuffix.append("\(indVTIsuffix[index])")
                        
                    
                        //can/culd/should
                        if thePrev > 0 {
                            attrPrefix.append("nika-kî-\(strPreVerb)")
                            attrEnglish.append("\(pronouns[index]) should \(strPreVerb_e) \(checkForSelf(checkEnglish:theVerb.english, index:index, tense:2)) something(s)")
                        } else {
                            attrPrefix.append("nika-kî-")
                            attrEnglish.append("\(pronouns[index]) should \(checkForSelf(checkEnglish:theVerb.english, index:index, tense:2)) something(s)")
                        }
                        attrVerb.append(tVerb)
                        attrSuffix.append("\(indVTIsuffix[index])")
            
                        
                        
                        
                    case 1, 5, 6://2,21,2p
                        //present
                        tVerb2 = addT2(theVerb: rootVerb, thePrefix: "ki", thePrev: thePrev)
                        if thePrev > 0 {
                            attrPrefix.append("\(tVerb2)\(strPreVerb)")
                            attrEnglish.append("\(pronouns[index]) \(strPreVerb_e) \(checkForSelf(checkEnglish:theVerb.english, index:index, tense:2)) something(s)")
                        } else {
                            attrPrefix.append("\(tVerb2)")
                            attrEnglish.append("\(pronouns[index]) \(checkForSelf(checkEnglish:theVerb.english, index:index, tense:0)) something(s)")
                        }
                        attrVerb.append(tVerb)
                        attrSuffix.append("\(indVTIsuffix[index])")
                        
                       
                        //past tense
                        if thePrev > 0 {
                            attrPrefix.append("kikî-\(strPreVerb)")
                            attrEnglish.append("\(pronouns[index]) did \(strPreVerb_e) \(checkForSelf(checkEnglish:theVerb.english, index:index, tense:2)) something(s)")
                        } else {
                            attrPrefix.append("kikî-")
                            attrEnglish.append("\(pronouns[index]) \(checkForSelf(checkEnglish:theVerb.english, index:index, tense:1)) something(s)")
                        }
                        attrVerb.append(tVerb)
                        attrSuffix.append("\(indVTIsuffix[index])")
                        
                        
                        //future indefinite
                        if thePrev > 0 {
                            attrPrefix.append("kiwî-\(strPreVerb)")
                            attrEnglish.append("\(pronouns[index]) intend to \(strPreVerb_e) \(checkForSelf(checkEnglish:theVerb.english, index:index, tense:2)) something(s)")
                        } else {
                            attrPrefix.append("kiwî-")
                            attrEnglish.append("\(pronouns[index]) intend to \(checkForSelf(checkEnglish:theVerb.english, index:index, tense:2)) something(s)")
                        }
                        attrVerb.append(tVerb)
                        attrSuffix.append("\(indVTIsuffix[index])")
                        
                     
                        //future definite
                        if thePrev > 0 {
                            attrPrefix.append("kika-\(strPreVerb)")
                            attrEnglish.append("\(pronouns[index]) will \(strPreVerb_e) \(checkForSelf(checkEnglish:theVerb.english, index:index, tense:2)) something(s)")
                        } else {
                            attrPrefix.append("kika-")
                            attrEnglish.append("\(pronouns[index]) will \(checkForSelf(checkEnglish:theVerb.english, index:index, tense:2)) something(s)")
                        }
                        attrVerb.append(tVerb)
                        attrSuffix.append("\(indVTIsuffix[index])")
                        
                        
                        //can/culd/should
                        if thePrev > 0 {
                            attrPrefix.append("kika-kî-\(strPreVerb)")
                            attrEnglish.append("\(pronouns[index]) should \(strPreVerb_e) \(checkForSelf(checkEnglish:theVerb.english, index:index, tense:2)) something(s)")
                        } else {
                            attrPrefix.append("kika-kî-")
                            attrEnglish.append("\(pronouns[index]) should \(checkForSelf(checkEnglish:theVerb.english, index:index, tense:2)) something(s)")
                        }
                        attrVerb.append(tVerb)
                        attrSuffix.append("\(indVTIsuffix[index])")

                        
                        
                    default://3,3'(p),3p
                        //present
                        if thePrev > 0 {
                            attrPrefix.append("\(strPreVerb)")
                            attrEnglish.append("\(pronouns[index]) \(strPreVerb_e) \(checkForSelf(checkEnglish:theVerb.english, index:index, tense:2)) something(s)")
                        } else {
                            attrPrefix.append("")
                            attrEnglish.append("\(pronouns[index]) \(checkForSelf(checkEnglish:theVerb.english, index:index, tense:0)) something(s)")
                        }
                        attrVerb.append(rootVerb)
                        attrSuffix.append("\(indVTIsuffix[index])")
                        
                        //past tense
                        if thePrev > 0 {
                            attrPrefix.append("kî-\(strPreVerb)")
                            attrEnglish.append("\(pronouns[index]) did \(strPreVerb_e) \(checkForSelf(checkEnglish:theVerb.english, index:index, tense:2)) something(s)")
                        } else {
                            attrPrefix.append("kî-")
                            attrEnglish.append("\(pronouns[index]) \(checkForSelf(checkEnglish:theVerb.english, index:index, tense:1)) something(s)")
                        }
                        attrVerb.append(rootVerb)
                        attrSuffix.append("\(indVTIsuffix[index])")
                        
                       
                        //future indefinite
                        if thePrev > 0 {
                            attrPrefix.append("wî-\(strPreVerb)")
                            attrEnglish.append("\(pronouns[index]) intend to \(strPreVerb_e) \(checkForSelf(checkEnglish:theVerb.english, index:index, tense:2)) something(s)")
                        } else {
                            attrPrefix.append("wî-")
                            attrEnglish.append("\(pronouns[index]) intend to \(checkForSelf(checkEnglish:theVerb.english, index:index, tense:2)) something(s)")
                        }
                        attrVerb.append(rootVerb)
                        attrSuffix.append("\(indVTIsuffix[index])")
                        

                        //future definite
                        if thePrev > 0 {
                            attrPrefix.append("ta-\(strPreVerb)")
                            attrEnglish.append("\(pronouns[index]) will \(strPreVerb_e) \(checkForSelf(checkEnglish:theVerb.english, index:index, tense:2)) it/them")
                        } else {
                            attrPrefix.append("ta-")
                            attrEnglish.append("\(pronouns[index]) will \(checkForSelf(checkEnglish:theVerb.english, index:index, tense:2)) it/them")
                        }
                        attrVerb.append(rootVerb)
                        attrSuffix.append("\(indVTIsuffix[index])")
                        
                        //can/culd/should
                        if thePrev > 0 {
                            attrPrefix.append("ta-kî-\(strPreVerb)")
                            attrEnglish.append("\(pronouns[index]) should \(strPreVerb_e) \(checkForSelf(checkEnglish:theVerb.english, index:index, tense:2)) something(s)")
                        } else {
                            attrPrefix.append("ta-kî-")
                            attrEnglish.append("\(pronouns[index]) should \(checkForSelf(checkEnglish:theVerb.english, index:index, tense:2)) something(s)")
                        }
                        attrVerb.append(rootVerb)
                        attrSuffix.append("\(indVTIsuffix[index])")
                        
                    }
                    
                }
            }
        default:
            //0 no verb picked
            break
        }
        
    }
    private func fillText(section: [String], strMode: String){
        var impActor = ["You","You all","Let's (inc) "]
        var atEnglish = NSMutableAttributedString()
        theText.deleteCharacters(in: NSMakeRange(0, theText.length))
        
        var inc:Int = 0
       // var theTitle = NSMutableAttributedString()
        let sCount = section.count
        for i in 1...sCount {
            
           var theTitle = NSMutableAttributedString(string: "\n\(section[i-1])\n")
            
            theTitle.addAttributes(attrBold, range: NSMakeRange(0, theTitle.length))
            theTitle.addAttributes(attrUnder, range: NSMakeRange(0, theTitle.length))
          
            theText.append(theTitle)
            
            inc = i-1
            switch  strMode {
            case "You":
                
                if section[i-1] != "Command-Inverse" {//show all other you sets
                    for (_,person) in iPeople.enumerated(){
                        let atPerson = NSMutableAttributedString(string: "\(person): ")
                        atPerson.addAttributes(attrPlain, range: NSMakeRange(0, atPerson.length))
                        let atPrefix = NSMutableAttributedString(string: "\(attrPrefix[inc])")
                        atPrefix.addAttributes(attrCree, range: NSMakeRange(0, atPrefix.length))
                        let atVerb = NSMutableAttributedString(string: attrVerb[inc])
                        atVerb.addAttributes(attrPlain, range: NSMakeRange(0, atVerb.length))
                        let atSuffix = NSMutableAttributedString(string: attrSuffix[inc])
                        atSuffix.addAttributes(attrCree, range: NSMakeRange(0, atSuffix.length))
                        
                        let prePrefix = NSMutableAttributedString(string: " - ")
                        prePrefix.addAttributes(attrPlain, range: NSMakeRange(0, prePrefix.length))
                    
                        
                        let verbtoConvert = "\(attrPrefix[inc])\(attrVerb[inc])\(attrSuffix[inc])"
                        let syllabics = NSMutableAttributedString(string: "\(convertSyllabics(Cree:verbtoConvert))")
                        
                        syllabics.addAttributes(attrSyll, range: NSMakeRange(0, syllabics.length))
                        atEnglish = NSMutableAttributedString(string: "\n\(attrEnglish[inc])\n")
                        atEnglish.addAttributes(attrEng, range: NSMakeRange(0, atEnglish.length))
                        theText.append(atPerson)
                        theText.append(atPrefix)
                        theText.append(atVerb)
                        theText.append(atSuffix)
                        theText.append(prePrefix)
                        theText.append(syllabics)
                        theText.append(atEnglish)
                        
                        inc += section.count - 1
                    }
                } else { //command inverse
                    inc = 0
                    for (index,_) in iPronoun.enumerated(){
                        switch index {
                        case 0:
                            let atPerson = NSMutableAttributedString(string: "\(impPeople[0]): ")
                            atPerson.addAttributes(attrPlain, range: NSMakeRange(0, atPerson.length))
                            let atPrefix = NSMutableAttributedString(string: "\(attrImpPrefix[inc])")
                            atPrefix.addAttributes(attrCree, range: NSMakeRange(0, atPrefix.length))
                            let atVerb = NSMutableAttributedString(string: attrImpVerb[inc])
                            atVerb.addAttributes(attrPlain, range: NSMakeRange(0, atVerb.length))
                            let atSuffix = NSMutableAttributedString(string: attrImpSuffix[inc])
                            atSuffix.addAttributes(attrCree, range: NSMakeRange(0, atSuffix.length))
                            
                            let prePrefix = NSMutableAttributedString(string: " - ")
                            prePrefix.addAttributes(attrPlain, range: NSMakeRange(0, prePrefix.length))
                            
                            let verbtoConvert = "\(attrImpPrefix[inc])\(attrImpVerb[inc])\(attrImpSuffix[inc])"
                            let syllabics = NSMutableAttributedString(string: "\(convertSyllabics(Cree:verbtoConvert))")
                            
                            syllabics.addAttributes(attrSyll, range: NSMakeRange(0, syllabics.length))
                            
                            atEnglish = NSMutableAttributedString(string: "\n\(attrImpEnglish[inc])\n")
                            atEnglish.addAttributes(attrEng, range: NSMakeRange(0, atEnglish.length))
                            theText.append(atPerson)
                            theText.append(atPrefix)
                            theText.append(atVerb)
                            theText.append(atSuffix)
                            theText.append(prePrefix)
                            theText.append(syllabics)
                            theText.append(atEnglish)
                            
                            
                        case 3:
                           // theTitle = NSAttributedString(string: "Delayed\n", attributes: attr as? [NSAttributedStringKey : Any])
                             theTitle = NSMutableAttributedString(string: "Delayed\n")
                            
                             theTitle.addAttributes(attrBold, range: NSMakeRange(0, theTitle.length))
                             theTitle.addAttributes(attrUnder, range: NSMakeRange(0, theTitle.length))
                            let atPerson = NSMutableAttributedString(string: "\(impPeople[0]): ")
                            atPerson.addAttributes(attrPlain, range: NSMakeRange(0, atPerson.length))
                            let atPrefix = NSMutableAttributedString(string: "\(attrImpPrefix[inc])")
                            atPrefix.addAttributes(attrCree, range: NSMakeRange(0, atPrefix.length))
                            let atVerb = NSMutableAttributedString(string: attrImpVerb[inc])
                            atVerb.addAttributes(attrPlain, range: NSMakeRange(0, atVerb.length))
                            let atSuffix = NSMutableAttributedString(string: attrImpSuffix[inc])
                            atSuffix.addAttributes(attrCree, range: NSMakeRange(0, atSuffix.length))
                            
                            let prePrefix = NSMutableAttributedString(string: " - ")
                            prePrefix.addAttributes(attrPlain, range: NSMakeRange(0, prePrefix.length))
                            
                            let verbtoConvert = "\(attrImpPrefix[inc])\(attrImpVerb[inc])\(attrImpSuffix[inc])"
                            let syllabics = NSMutableAttributedString(string: "\(convertSyllabics(Cree:verbtoConvert))")
                            syllabics.addAttributes(attrSyll, range: NSMakeRange(0, syllabics.length))
                            
                            atEnglish = NSMutableAttributedString(string: "\n\(attrImpEnglish[inc]) later\n")
                            atEnglish.addAttributes(attrEng, range: NSMakeRange(0, atEnglish.length))
                            theText.append(theTitle)
                            theText.append(atPerson)
                            theText.append(atPrefix)
                            theText.append(atVerb)
                            theText.append(atSuffix)
                            theText.append(prePrefix)
                            theText.append(syllabics)
                            theText.append(atEnglish)
                            
                        case 1,4:
                            let atPerson = NSMutableAttributedString(string: "\(impPeople[1]): ")
                            atPerson.addAttributes(attrPlain, range: NSMakeRange(0, atPerson.length))
                            let atPrefix = NSMutableAttributedString(string: "\(attrImpPrefix[inc])")
                            atPrefix.addAttributes(attrCree, range: NSMakeRange(0, atPrefix.length))
                            let atVerb = NSMutableAttributedString(string: attrImpVerb[inc])
                            atVerb.addAttributes(attrPlain, range: NSMakeRange(0, atVerb.length))
                            let atSuffix = NSMutableAttributedString(string: attrImpSuffix[inc])
                            atSuffix.addAttributes(attrCree, range: NSMakeRange(0, atSuffix.length))
                            
                            let prePrefix = NSMutableAttributedString(string: " - ")
                            prePrefix.addAttributes(attrPlain, range: NSMakeRange(0, prePrefix.length))
                            let verbtoConvert = "\(attrImpPrefix[inc])\(attrImpVerb[inc])\(attrImpSuffix[inc])"
                            let syllabics = NSMutableAttributedString(string: "\(convertSyllabics(Cree:verbtoConvert))")
                            syllabics.addAttributes(attrSyll, range: NSMakeRange(0, syllabics.length))
                            
                            if index == 4 {
                                atEnglish = NSMutableAttributedString(string: "\n\(attrImpEnglish[inc]) later\n")
                            } else {
                               atEnglish = NSMutableAttributedString(string: "\n\(attrImpEnglish[inc])\n")
                            }
                            atEnglish.addAttributes(attrEng, range: NSMakeRange(0, atEnglish.length))
                            theText.append(atPerson)
                            theText.append(atPrefix)
                            theText.append(atVerb)
                            theText.append(atSuffix)
                            theText.append(prePrefix)
                            theText.append(syllabics)
                            theText.append(atEnglish)
                        case 2,5:
                            let atPerson = NSMutableAttributedString(string: "\(impPeople[2]): ")
                            atPerson.addAttributes(attrPlain, range: NSMakeRange(0, atPerson.length))
                            let atPrefix = NSMutableAttributedString(string: "\(attrImpPrefix[inc])")
                            atPrefix.addAttributes(attrCree, range: NSMakeRange(0, atPrefix.length))
                            let atVerb = NSMutableAttributedString(string: attrImpVerb[inc])
                            atVerb.addAttributes(attrPlain, range: NSMakeRange(0, atVerb.length))
                            let atSuffix = NSMutableAttributedString(string: attrImpSuffix[inc])
                            atSuffix.addAttributes(attrCree, range: NSMakeRange(0, atSuffix.length))
                            let prePrefix = NSMutableAttributedString(string: " - ")
                            prePrefix.addAttributes(attrPlain, range: NSMakeRange(0, prePrefix.length))
                            let verbtoConvert = "\(attrImpPrefix[inc])\(attrImpVerb[inc])\(attrImpSuffix[inc])"
                            let syllabics = NSMutableAttributedString(string: "\(convertSyllabics(Cree:verbtoConvert))")
                            syllabics.addAttributes(attrSyll, range: NSMakeRange(0, syllabics.length))
                            
                            if index == 5 {
                                atEnglish = NSMutableAttributedString(string: "\n\(attrImpEnglish[inc]) later\n")
                            } else {
                                atEnglish = NSMutableAttributedString(string: "\n\(attrImpEnglish[inc])\n")
                            }
                            atEnglish.addAttributes(attrEng, range: NSMakeRange(0, atEnglish.length))
                            theText.append(atPerson)
                            theText.append(atPrefix)
                            theText.append(atVerb)
                            theText.append(atSuffix)
                            theText.append(prePrefix)
                            theText.append(syllabics)
                            theText.append(atEnglish)
                        default:
                            break
                        }

                        inc += 1
                    }
                }
            case "Imp":
                for (index,_) in iPronoun.enumerated(){
                    switch index {
                    case 0:
                        let atPerson = NSMutableAttributedString(string: "\(impPeople[0]): ")
                        atPerson.addAttributes(attrPlain, range: NSMakeRange(0, atPerson.length))
                        let atPrefix = NSMutableAttributedString(string: "\(attrImpPrefix[inc])")
                        atPrefix.addAttributes(attrCree, range: NSMakeRange(0, atPrefix.length))
                        let atVerb = NSMutableAttributedString(string: attrImpVerb[inc])
                        atVerb.addAttributes(attrPlain, range: NSMakeRange(0, atVerb.length))
                        let atSuffix = NSMutableAttributedString(string: attrImpSuffix[inc])
                        atSuffix.addAttributes(attrCree, range: NSMakeRange(0, atSuffix.length))
                        
                        let prePrefix = NSMutableAttributedString(string: " - ")
                        prePrefix.addAttributes(attrPlain, range: NSMakeRange(0, prePrefix.length))
                        let verbtoConvert = "\(attrImpPrefix[inc])\(attrImpVerb[inc])\(attrImpSuffix[inc])"
                        let syllabics = NSMutableAttributedString(string: "\(convertSyllabics(Cree:verbtoConvert))")
                        syllabics.addAttributes(attrSyll, range: NSMakeRange(0, syllabics.length))
                        
                        atEnglish = NSMutableAttributedString(string: "\n\(impActor[0]) \(attrImpEnglish[inc])\n")
                        atEnglish.addAttributes(attrEng, range: NSMakeRange(0, atEnglish.length))
                        theText.append(atPerson)
                        theText.append(atPrefix)
                        theText.append(atVerb)
                        theText.append(atSuffix)
                        theText.append(prePrefix)
                        theText.append(syllabics)
                        theText.append(atEnglish)
                        
                        
                    case 3:
                        theTitle = NSMutableAttributedString(string: "Delayed\n")
                        
                        theTitle.addAttributes(attrBold, range: NSMakeRange(0, theTitle.length))
                        theTitle.addAttributes(attrUnder, range: NSMakeRange(0, theTitle.length))

                        
                        let atPerson = NSMutableAttributedString(string: "\(impPeople[0]): ")
                        atPerson.addAttributes(attrPlain, range: NSMakeRange(0, atPerson.length))
                        let atPrefix = NSMutableAttributedString(string: "\(attrImpPrefix[inc])")
                        atPrefix.addAttributes(attrCree, range: NSMakeRange(0, atPrefix.length))
                        let atVerb = NSMutableAttributedString(string: attrImpVerb[inc])
                        atVerb.addAttributes(attrPlain, range: NSMakeRange(0, atVerb.length))
                        let atSuffix = NSMutableAttributedString(string: attrImpSuffix[inc])
                        atSuffix.addAttributes(attrCree, range: NSMakeRange(0, atSuffix.length))
                        let prePrefix = NSMutableAttributedString(string: " - ")
                        prePrefix.addAttributes(attrPlain, range: NSMakeRange(0, prePrefix.length))
                        let verbtoConvert = "\(attrImpPrefix[inc])\(attrImpVerb[inc])\(attrImpSuffix[inc])"
                        let syllabics = NSMutableAttributedString(string: "\(convertSyllabics(Cree:verbtoConvert))")
                        syllabics.addAttributes(attrSyll, range: NSMakeRange(0, syllabics.length))
                        
                        
                        atEnglish = NSMutableAttributedString(string: "\n\(impActor[0]) \(attrImpEnglish[inc]) later\n")
                        atEnglish.addAttributes(attrEng, range: NSMakeRange(0, atEnglish.length))
                        theText.append(theTitle)
                        theText.append(atPerson)
                        theText.append(atPrefix)
                        theText.append(atVerb)
                        theText.append(atSuffix)
                        theText.append(prePrefix)
                        theText.append(syllabics)
                        theText.append(atEnglish)
                        
                    case 1,4:
                        let atPerson = NSMutableAttributedString(string: "\(impPeople[1]): ")
                        atPerson.addAttributes(attrPlain, range: NSMakeRange(0, atPerson.length))
                        let atPrefix = NSMutableAttributedString(string: "\(attrImpPrefix[inc])")
                        atPrefix.addAttributes(attrCree, range: NSMakeRange(0, atPrefix.length))
                        let atVerb = NSMutableAttributedString(string: attrImpVerb[inc])
                        atVerb.addAttributes(attrPlain, range: NSMakeRange(0, atVerb.length))
                        let atSuffix = NSMutableAttributedString(string: attrImpSuffix[inc])
                        atSuffix.addAttributes(attrCree, range: NSMakeRange(0, atSuffix.length))
                        
                        let prePrefix = NSMutableAttributedString(string: " - ")
                        prePrefix.addAttributes(attrPlain, range: NSMakeRange(0, prePrefix.length))
                        let verbtoConvert = "\(attrImpPrefix[inc])\(attrImpVerb[inc])\(attrImpSuffix[inc])"
                        let syllabics = NSMutableAttributedString(string: "\(convertSyllabics(Cree:verbtoConvert))")
                        syllabics.addAttributes(attrSyll, range: NSMakeRange(0, syllabics.length))
                        
                        if index == 4 {
                             atEnglish = NSMutableAttributedString(string: "\n\(impActor[1]) \(attrImpEnglish[inc]) later\n")
                        } else {
                             atEnglish = NSMutableAttributedString(string: "\n\(impActor[1]) \(attrImpEnglish[inc])\n")
                        }
                        atEnglish.addAttributes(attrEng, range: NSMakeRange(0, atEnglish.length))
                        theText.append(atPerson)
                        theText.append(atPrefix)
                        theText.append(atVerb)
                        theText.append(atSuffix)
                        theText.append(prePrefix)
                        theText.append(syllabics)
                        theText.append(atEnglish)
                    case 2,5:
                        let atPerson = NSMutableAttributedString(string: "\(impPeople[2]): ")
                        atPerson.addAttributes(attrPlain, range: NSMakeRange(0, atPerson.length))
                        let atPrefix = NSMutableAttributedString(string: "\(attrImpPrefix[inc])")
                        atPrefix.addAttributes(attrCree, range: NSMakeRange(0, atPrefix.length))
                        let atVerb = NSMutableAttributedString(string: attrImpVerb[inc])
                        atVerb.addAttributes(attrPlain, range: NSMakeRange(0, atVerb.length))
                        let atSuffix = NSMutableAttributedString(string: attrImpSuffix[inc])
                        atSuffix.addAttributes(attrCree, range: NSMakeRange(0, atSuffix.length))
                        let prePrefix = NSMutableAttributedString(string: " - ")
                        prePrefix.addAttributes(attrPlain, range: NSMakeRange(0, prePrefix.length))
                        let verbtoConvert = "\(attrImpPrefix[inc])\(attrImpVerb[inc])\(attrImpSuffix[inc])"
                        let syllabics = NSMutableAttributedString(string: "\(convertSyllabics(Cree:verbtoConvert))")
                        syllabics.addAttributes(attrSyll, range: NSMakeRange(0, syllabics.length))
                        
                        
                        if index == 5 {
                             atEnglish = NSMutableAttributedString(string: "\n\(impActor[2]) \(attrImpEnglish[inc]) later\n")
                        }else {
                            atEnglish = NSMutableAttributedString(string: "\n\(impActor[2]) \(attrImpEnglish[inc])\n")
                        }
                        atEnglish.addAttributes(attrEng, range: NSMakeRange(0, atEnglish.length))
                        theText.append(atPerson)
                        theText.append(atPrefix)
                        theText.append(atVerb)
                        theText.append(atSuffix)
                        theText.append(prePrefix)
                        theText.append(syllabics)
                        theText.append(atEnglish)
                    default:
                        break
                    }
                    
                    inc += 1
                }
            default:
                for (_,person) in people.enumerated(){
                    let atPerson = NSMutableAttributedString(string: "\(person): ")
                    atPerson.addAttributes(attrPlain, range: NSMakeRange(0, atPerson.length))
                    theText.append(atPerson)
                   
                    let atPrefix = NSMutableAttributedString(string: "\(attrPrefix[inc])")
                    atPrefix.addAttributes(attrCree, range: NSMakeRange(0, atPrefix.length))
                    theText.append(atPrefix)
                    
                    
                    
                    if boolN && (person == "3") && (strMode == "Ind") {
                        let atVerb = NSMutableAttributedString(string: rootVerb)
                        atVerb.addAttributes(attrPlain, range: NSMakeRange(0, atVerb.length))
                        
                        let prePrefix = NSMutableAttributedString(string: " - ")
                        prePrefix.addAttributes(attrPlain, range: NSMakeRange(0, prePrefix.length))
                        
                        let verbtoConvertn = "\(attrPrefix[inc])\(rootVerb)"
                        let syllabicsn = NSMutableAttributedString(string: "\(convertSyllabics(Cree:verbtoConvertn))")
                        syllabicsn.addAttributes(attrSyll, range: NSMakeRange(0, syllabicsn.length))
                        
                        theText.append(atVerb)
                        theText.append(prePrefix)
                        theText.append(syllabicsn)
                        let prePrefix1 = NSMutableAttributedString(string: "\n or: ")
                        prePrefix1.addAttributes(attrPlain, range: NSMakeRange(0, prePrefix1.length))
                        
                        let atSuffix = NSMutableAttributedString(string: "i\(attrSuffix[inc])")
                        atSuffix.addAttributes(attrCree, range: NSMakeRange(0, atSuffix.length))
                        
                       //edit later
                        let verbtoConvert = "\(attrPrefix[inc])\(rootVerb)i\(attrSuffix[inc])"
                        let syllabics = NSMutableAttributedString(string: "\(convertSyllabics(Cree:verbtoConvert))")
                        syllabics.addAttributes(attrSyll, range: NSMakeRange(0, syllabics.length))

                        theText.append(prePrefix1)
                        theText.append(atPrefix)
                        theText.append(atVerb)
                        theText.append(atSuffix)
                        theText.append(prePrefix)
                        theText.append(syllabics)
                    } else {
                        let atVerb = NSMutableAttributedString(string: attrVerb[inc])
                        atVerb.addAttributes(attrPlain, range: NSMakeRange(0, atVerb.length))
                        theText.append(atVerb)
                        
                        let atSuffix = NSMutableAttributedString(string: attrSuffix[inc])
                        atSuffix.addAttributes(attrCree, range: NSMakeRange(0, atSuffix.length))
                        
                        let prePrefix = NSMutableAttributedString(string: " - ")
                        prePrefix.addAttributes(attrPlain, range: NSMakeRange(0, prePrefix.length))
                        //edit later
                        let verbtoConvert = "\(attrPrefix[inc])\(attrVerb[inc])\(attrSuffix[inc])"
                        let syllabics = NSMutableAttributedString(string: "\(convertSyllabics(Cree:verbtoConvert))")
                        syllabics.addAttributes(attrSyll, range: NSMakeRange(0, syllabics.length))
                        
                        theText.append(atSuffix)
                        theText.append(prePrefix)
                        theText.append(syllabics)
                    }
                    
                    if boolN && (person == "3") && (strMode == "Con") && (i < sCount){
                        let prePrefix1 = NSMutableAttributedString(string: "\n or: ")
                        prePrefix1.addAttributes(attrPlain, range: NSMakeRange(0, prePrefix1.length))
                      
                        let eVerb = String(rootVerb[..<rootVerb.index(before:rootVerb.endIndex)])
                        //let eVerb = rootVerb.substring(to: rootVerb.index(before:rootVerb.endIndex))
                        let atPrefix = NSMutableAttributedString(string: "\(attrPrefix[inc])")
                        atPrefix.addAttributes(attrCree, range: NSMakeRange(0, atPrefix.length))
                        let atVerb = NSMutableAttributedString(string: "\(eVerb)")
                        atVerb.addAttributes(attrPlain, range: NSMakeRange(0, atVerb.length))
                        let atSuffix = NSMutableAttributedString(string: "hk")
                        atSuffix.addAttributes(attrCree, range: NSMakeRange(0, atSuffix.length))
                       
                        let prePrefix = NSMutableAttributedString(string: " - ")
                        prePrefix.addAttributes(attrPlain, range: NSMakeRange(0, prePrefix.length))
                        //edit later
                        let verbtoConvert = "\(attrPrefix[inc])\(eVerb)hk"
                        let syllabics = NSMutableAttributedString(string: "\(convertSyllabics(Cree:verbtoConvert))")
                        syllabics.addAttributes(attrSyll, range: NSMakeRange(0, syllabics.length))
                        
                        theText.append(prePrefix1)
                        theText.append(atPrefix)
                        theText.append(atVerb)
                        theText.append(atSuffix)
                        theText.append(prePrefix)
                        theText.append(syllabics)
                    }
                    
                    if boolN && (person == "3P") && (strMode == "Con") && (i < sCount){
                        let prePrefix1 = NSMutableAttributedString(string: "\n or: ")
                        prePrefix1.addAttributes(attrPlain, range: NSMakeRange(0, prePrefix1.length))
                        
                        let eVerb = String(rootVerb[..<rootVerb.index(before:rootVerb.endIndex)])
                       // let eVerb = rootVerb.substring(to: rootVerb.index(before:rootVerb.endIndex))
                        let atPrefix = NSMutableAttributedString(string: "\(attrPrefix[inc])")
                        atPrefix.addAttributes(attrCree, range: NSMakeRange(0, atPrefix.length))
                        let atVerb = NSMutableAttributedString(string: "\(eVerb)")
                        atVerb.addAttributes(attrPlain, range: NSMakeRange(0, atVerb.length))
                        let atSuffix = NSMutableAttributedString(string: "hkik")
                        atSuffix.addAttributes(attrCree, range: NSMakeRange(0, atSuffix.length))
                        
                        let prePrefix = NSMutableAttributedString(string: " - ")
                        prePrefix.addAttributes(attrPlain, range: NSMakeRange(0, prePrefix.length))
                        //edit later
                        let verbtoConvert = "\(attrPrefix[inc])\(eVerb)hkik"
                        let syllabics = NSMutableAttributedString(string: "\(convertSyllabics(Cree:verbtoConvert))")
                        syllabics.addAttributes(attrSyll, range: NSMakeRange(0, syllabics.length))
                        theText.append(prePrefix1)
                        theText.append(atPrefix)
                        theText.append(atVerb)
                        theText.append(atSuffix)
                        theText.append(prePrefix)
                        theText.append(syllabics)
                    }
                    if ((verb?.type == "VTI") || (verb?.type == "VAI")) && (strMode == "Ind"){ //VAI, VTI
                        if person == "21" {
                            let prePrefix1 = NSMutableAttributedString(string: "\n or: ")
                            prePrefix1.addAttributes(attrPlain, range: NSMakeRange(0, prePrefix1.length))
                            let atPrefix = NSMutableAttributedString(string: "\(attrPrefix[inc])")
                            atPrefix.addAttributes(attrCree, range: NSMakeRange(0, atPrefix.length))
                            
                            let atVerb = NSMutableAttributedString(string: attrVerb[inc])
                            atVerb.addAttributes(attrPlain, range: NSMakeRange(0, atVerb.length))
                            
                            
                            let atSuffix = NSMutableAttributedString(string: "nâ\(attrSuffix[inc])")
                            atSuffix.addAttributes(attrCree, range: NSMakeRange(0, atSuffix.length))
                            let prePrefix = NSMutableAttributedString(string: " - ")
                            prePrefix.addAttributes(attrPlain, range: NSMakeRange(0, prePrefix.length))
                            let verbtoConvert = "\(attrPrefix[inc])\(attrVerb[inc])nâ\(attrSuffix[inc])"
                            let syllabics = NSMutableAttributedString(string: "\(convertSyllabics(Cree:verbtoConvert))")
                            syllabics.addAttributes(attrSyll, range: NSMakeRange(0, syllabics.length))
                            
                            theText.append(prePrefix1)
                            theText.append(atPrefix)
                            theText.append(atVerb)
                            theText.append(atSuffix)
                            theText.append(prePrefix)
                            theText.append(syllabics)
                        }
                    }
                    
                    if (verb?.type == "VTA") && (strMode == "Inv") && (i==1){
                        if person == "3" {
                            let prePrefix1 = NSMutableAttributedString(string: "\n or: ")
                            prePrefix1.addAttributes(attrPlain, range: NSMakeRange(0, prePrefix1.length))
                            
                            let atPrefix = NSMutableAttributedString(string: "\(attrPrefix[inc])")
                            atPrefix.addAttributes(attrCree, range: NSMakeRange(0, atPrefix.length))
                            
                            let atVerb = NSMutableAttributedString(string: attrVerb[inc])
                            atVerb.addAttributes(attrPlain, range: NSMakeRange(0, atVerb.length))
                            
                            
                            let atSuffix = NSMutableAttributedString(string: "\(attrSuffix[inc])ow")
                            atSuffix.addAttributes(attrCree, range: NSMakeRange(0, atSuffix.length))
                            let prePrefix = NSMutableAttributedString(string: " - ")
                            prePrefix.addAttributes(attrPlain, range: NSMakeRange(0, prePrefix.length))
                            let verbtoConvert = "\(attrPrefix[inc])\(attrVerb[inc])\(attrSuffix[inc])ow"
                            let syllabics = NSMutableAttributedString(string: "\(convertSyllabics(Cree:verbtoConvert))")
                            syllabics.addAttributes(attrSyll, range: NSMakeRange(0, syllabics.length))
                            
                            theText.append(prePrefix1)
                            theText.append(atPrefix)
                            theText.append(atVerb)
                            theText.append(atSuffix)
                            theText.append(prePrefix)
                            theText.append(syllabics)
                        }
                        if !(iVerb == 2){
                            if person == "3P" {
                                let prePrefix1 = NSMutableAttributedString(string: "\n or: ")
                                prePrefix1.addAttributes(attrPlain, range: NSMakeRange(0, prePrefix1.length))
                            
                                let atPrefix = NSMutableAttributedString(string: "\(attrPrefix[inc])")
                                atPrefix.addAttributes(attrCree, range: NSMakeRange(0, atPrefix.length))
                            
                                let atVerb = NSMutableAttributedString(string: attrVerb[inc])
                                atVerb.addAttributes(attrPlain, range: NSMakeRange(0, atVerb.length))
                            
                            
                                let atSuffix = NSMutableAttributedString(string: "\(invSuff)kwak")
                                atSuffix.addAttributes(attrCree, range: NSMakeRange(0, atSuffix.length))
                                let prePrefix = NSMutableAttributedString(string: " - ")
                                prePrefix.addAttributes(attrPlain, range: NSMakeRange(0, prePrefix.length))
                                let verbtoConvert = "\(attrPrefix[inc])\(attrVerb[inc])\(invSuff)kwak"
                                let syllabics = NSMutableAttributedString(string: "\(convertSyllabics(Cree:verbtoConvert))")
                                syllabics.addAttributes(attrSyll, range: NSMakeRange(0, syllabics.length))
                            
                                theText.append(prePrefix1)
                                theText.append(atPrefix)
                                theText.append(atVerb)
                                theText.append(atSuffix)
                                theText.append(prePrefix)
                                theText.append(syllabics)
                            }
                        }

                    }
                    
                    let atEnglish = NSMutableAttributedString(string: "\n\(attrEnglish[inc])\n")
                    atEnglish.addAttributes(attrEng, range: NSMakeRange(0, atEnglish.length))
                    theText.append(atEnglish)
                    
                    inc += section.count
                }
                
            }
            
            
        }
        
        txtConj.attributedText = theText
        
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
        var strLength = convertedText.count - 1
       
        let syllabics1 = ["ᐊ","ᐋ","ᐃ", "ᐄ","ᐅ", "ᐆ", "ᐁ","ᒐ", "ᒑ", "ᒋ", "ᒌ", "ᒍ", "ᒎ", "ᒉ",
                          "ᑲ", "ᑳ", "ᑭ", "ᑮ", "ᑯ", "ᑰ", "ᑫ", "ᒪ", "ᒫ", "ᒥ", "ᒦ", "ᒧ", "ᒨ", "ᒣ",
                          "ᓇ", "ᓈ", "ᓂ", "ᓃ", "ᓄ", "ᓅ", "ᓀ", "ᐸ", "ᐹ", "ᐱ", "ᐲ", "ᐳ", "ᐴ", "ᐯ",
                          "ᓴ", "ᓵ", "ᓯ", "ᓰ", "ᓱ", "ᓲ", "ᓭ", "ᑕ", "ᑖ", "ᑎ", "ᑏ", "ᑐ", "ᑑ", "ᑌ",
                          "ᔭ", "ᔮ", "ᔨ", "ᔩ", "ᔪ", "ᔫ", "ᔦ", "ᖬ", "ᖭ", "ᖨ", "ᖩ", "ᖪ", "ᖫ", "ᖧ"]
        let syllabics2 = ["ᐧ","ᐤ", "ᑊ", "ᐟ", "ᐠ", "ᐨ", "ᒼ", "ᐣ", "ᐢ", "ᐩ", "ᕽ", "ᐦ", "≠"]

        
        for char in convertedText {
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
}

