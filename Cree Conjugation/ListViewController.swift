//
//  List.swift
//  Cree Conjugation
//
//  Created by Wolfgang on 2018-02-28.
//  Copyright © 2018 nistosap. All rights reserved.
//

import UIKit


class ListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    //MARK:properties
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableVerbs: UITableView!
    
    var verbs = [CreeVerb]() //saved verbs
    var defaultList = [CreeVerb]() // pick list
    var filtered = [CreeVerb]() // filtered search list
    var tmpFilter = [CreeVerb]()
    var searchActive:Bool = false

    //verbs counts
    var vaiCount = 0
    var vtaCount = 0
    var vtiCount = 0
    var theText:String = ""
    
    let titleColor = UIColor(red:98/255, green: 162/255, blue:83/255, alpha:1)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background")!)
        navigationController?.navigationBar.barTintColor = titleColor
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        
        tableVerbs.delegate = self
        tableVerbs.dataSource = self
        searchBar.delegate = self
        searchActive = false
       // self.searchBar.barTintColor = titleColor
        
        //UIBarButtonItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.white], for: .normal)
        
        if let savedVerbs = loadVerbs() {
            verbs += savedVerbs
        } else {
            loadTextDefaults()
        }
        loadDefaults()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: search methods
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    
        searchActive = false
       
        searchBar.resignFirstResponder()
        searchBar.text = ""
        loadDefaults()
        tableVerbs.reloadData()
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
        searchActive = true
       
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false
       
        searchBar.resignFirstResponder()
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false
       
        searchBar.resignFirstResponder()
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            loadDefaults()
        } else {
            filtered = []
            tmpFilter = []
        
            tmpFilter = verbs.filter{($0.cree.range(of: searchText, options: [.caseInsensitive, .diacriticInsensitive]) != nil) || ($0.english.range(of: searchText, options: [.caseInsensitive, .diacriticInsensitive]) != nil)}
            tmpFilter.sort(by: {$0.cree < $1.cree})
       
            filtered.append(contentsOf: tmpFilter)
            if tmpFilter.count == 0 {
                filtered = []
                tmpFilter = []
                searchActive = false
            } else {
                searchActive = true
            }
        }
       
        tableVerbs.reloadData()
    }
    //MARK: table methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if filtered.count > 0  {
            return filtered.count
        }
        return defaultList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "verbList", for: indexPath) as? verbTableViewCell else {
            fatalError("unable to dequeue cell")
        }
        var dirObject:String = ""
        
        if filtered.count > 0 {
                let dList = filtered[indexPath.row]
                cell.lblCree1.text = dList.cree
                switch dList.type {
                case "VTA":
                    if checkforSO(checkEnglish:dList.english) {
                        dirObject = ""
                    } else {
                        dirObject = " s.o."
                    }
                    cell.lblEnglish1.text = dList.english + dirObject
                case "VTI":
                    cell.lblEnglish1.text = dList.english + " s.t."
                default: //VAI
                    cell.lblEnglish1.text = dList.english
                }
                
                cell.lblType1.text = dList.type
            } else {
                let dList = defaultList[indexPath.row]
                cell.lblCree1.text = dList.cree
                switch dList.type {
                case "VTA":
                    if checkforSO(checkEnglish:dList.english) {
                        dirObject = ""
                    } else {
                        dirObject = " s.o."
                    }
                    cell.lblEnglish1.text = dList.english + dirObject
                case "VTI":
                    cell.lblEnglish1.text = dList.english + " s.t."
                default: //VAI
                    cell.lblEnglish1.text = dList.english
                }
                cell.lblType1.text = dList.type
            }
        
        return cell
    }
  
    private func checkforSO(checkEnglish:String) -> Bool {
        let lowercaseEnglish = checkEnglish.lowercased()
        if lowercaseEnglish.range(of: "s.o.") != nil {
            return true
        }
        return false
    }
  
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var selectedVerb:CreeVerb?
        var indexOf = Int()
        super.prepare(for: segue, sender: sender)
        switch(segue.identifier ?? ""){
        case "aboutPage"://go to about page WebpageViewcontroller
            break
        case "addVerb" :
            //go to add item page - viewController.sift
            break
        case "conjVerb":
            //pass verb that is clicked on Display ViewController
            guard let DisplayViewController = segue.destination as? DisplayViewController else {
                fatalError("There is a problem completing your call")
            }
            guard let selectedVerbCell = sender as? verbTableViewCell else {
                fatalError("unexpected sender")
            }
            guard let indexPath = tableVerbs.indexPath(for: selectedVerbCell) else {
                fatalError("selected cell not in table")
            }
            if filtered.count > 0 {
                 selectedVerb = filtered[indexPath.row]
                 indexOf = verbs.index(where: {$0.cree == filtered[indexPath.row].cree} )!
            } else {
                 selectedVerb = defaultList[indexPath.row]
                 indexOf = verbs.index(where: {$0.cree == defaultList[indexPath.row].cree} )!
            }
            DisplayViewController.verb = selectedVerb
            // pass original row number of selected verb
            
            DisplayViewController.row = indexOf
            DisplayViewController.filterRow = indexPath.row
        default:
            fatalError("unexpected segue")
        }
        
    }
    
    //MARK: actions
    
    @IBAction func unwindtoVerbList(sender: UIStoryboardSegue){
    
        if let sourceViewController = sender.source as? ViewController, let verb = sourceViewController.verb {
            //edit verb
            if sourceViewController.editRow! >= 0 {
                let selectedIndexPath = IndexPath(row: sourceViewController.editRow!, section: 0)
               
                let delBool = sourceViewController.deleteBool
                
                if delBool == true { //delete verb
                    verbs.remove(at: selectedIndexPath.row)
                    if filtered.count > 0 {
                        filtered.remove(at: sourceViewController.filterRow!)
                    } else {
                        defaultList.remove(at: sourceViewController.filterRow!)
                    }
                } else { //edit verb
                    verbs[selectedIndexPath.row] = verb
                    if filtered.count > 0 {
                        filtered[sourceViewController.filterRow!] = verb
                    } else {
                        defaultList[sourceViewController.filterRow!] = verb
                    }
                }
                
                searchActive = true // you can only edit/del via filtered list
                tableVerbs.reloadData()
            } else {
                
                //add verb
                verbs.append(verb)
                if filtered.count > 0 { //if on filtered view then show filtered view plus new verb
                    searchActive = true
                    let filteredIndex = IndexPath(row: filtered.count, section: 0)
                    filtered.append(verb)
                    tableVerbs.insertRows(at: [filteredIndex], with: .automatic)
                    tableVerbs.reloadData()
                } else {
                    searchActive = false
                    let filteredIndex = IndexPath(row: filtered.count, section: 0)
                    defaultList.append(verb)
                    tableVerbs.insertRows(at: [filteredIndex], with: .automatic)
                    loadDefaults()
                    tableVerbs.reloadData()
                }
            }
            
            saveVerb()

        }
    }

    //MARK: private
    private func loadDefaults(){
        defaultList = []
        filtered = []
        tmpFilter = []
        searchActive = false
        defaultList = verbs
        defaultList.sort(by: {$0.cree < $1.cree})
    }
    
    private func saveVerb(){
        
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(verbs, toFile: CreeVerb.ArchiveURL.path)
        
        if isSuccessfulSave {
            print("verb saved")
        } else {
            print("verb not saved")
        }

    }
    
    private func loadVerbs() -> [CreeVerb]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: CreeVerb.ArchiveURL.path) as? [CreeVerb]
    }
    
    //MARK: open text file and load defaults
    func cleanRows(file:String) -> String {
        //use a uniform \n for end of line
        var cleanFile = file
        cleanFile = cleanFile.replacingOccurrences(of: "\r", with: "\n")
        cleanFile = cleanFile.replacingOccurrences(of: "\n\n", with: "\n")
        return cleanFile
    }
    func getStringFieldsForRow(row:String, delimiter:String) -> [String]{
        return row.components(separatedBy: delimiter)
    }
    // read from txt file
    func readDataFromFile(file:String) -> String! {
        guard let filePath = Bundle.main.path(forResource: file, ofType: "txt") else {
            return nil
        }
        do{
            let contents = try String(contentsOfFile: filePath)
            return contents //return full contents of text file
        } catch {
            print ("file read error")
            return nil
        }
    }
    func loadTextDefaults(){
        //read txt file of verbs
        let strVerbs:String = readDataFromFile(file: "verbs2")
        let rows = cleanRows(file: strVerbs).components(separatedBy: "\n")
        var loadCree:String = ""
        var loadEnglish:String = ""
        var loadType:String = ""
        var loadImperative:String = ""
        if rows.count > 0 {
            for row in rows {
                let fields = getStringFieldsForRow(row: row, delimiter: "\t")//delimiter is tab
                //let fields = getStringFieldsForRow(row: row, delimiter: ",")//delimiter is comma
                for (index, field) in fields.enumerated(){
                    if index == 0 { //3rd person cree verb
                        loadCree = field
                        
                    } else if index == 1 { //imperative
                        loadImperative = field
                    } else if index == 2{//english
                        loadEnglish = field
                        
                    } else if index == 3 {//type
                        loadType = field
                        guard let verb1 = CreeVerb(cree: loadCree.lowercased(), english:loadEnglish.lowercased(), type:loadType, imperative:loadImperative) else {
                            fatalError("coud not verb")
                    }
                    

                    verbs.append(verb1)
                      
                        loadCree = ""
                        loadEnglish = ""
                        loadType = ""
                        loadImperative = ""
                        
                    }
                    
                }
            }
        } else {
            print ("no data")
        }
    }

}



