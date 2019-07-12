//
//  MainTVController.swift
//  jedeye
//
//  Created by Rick Campbell on 2/24/19.
//  Copyright © 2019 Datacom. All rights reserved.
//

import UIKit

class MainTVController: UITableViewController, AsynchDataDelegate {
    
    var questions : [String:[String:String]] = [:]
    var displayStrings : [String] = [] // for sorting
    var subtypes : [String:[String:String]] = [:]
    var dataFlag = false
    var headerText : String = ""
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Session.delegate = self
        Session.getSurvey()
    }
    
    func sessionReturnedWith(data: EntryType) {
        //print("&&Session Returned: \(data)")
        Session.questions = data
        self.questions = (Session.getQuestionsHaving(sourceType: "categories"))
        self.displayStrings = Session.getSortedStrings(dict: self.questions, field: "displayname")
        self.headerText = Session.getFieldDataFrom(Session.questions!, ordinalPosition: "0", colName: "description")
        
        //print("&&\(self.questions)")
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func surveyIDReturnedWith(data: [String : String]) {
        Session.surveyID = data["surveyid"]
        //print("&&SURVEYID: " + Session.surveyID!)
    }
    
    func singlePairSetWithResponse(data: String) {
        //print("&&Single pair set. Message from php: \(data)")
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        return self.displayStrings.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.headerText
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        //config the cell:
        cell.textLabel?.text = self.displayStrings[indexPath.row]
        cell.accessoryType = .none
        if let t = Session.surveyData?.surveySelections["Type"] {
            if (t as! String) == cell.textLabel?.text {
                cell.accessoryType = .checkmark
            }
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        if cell?.textLabel!.text == "Telehandler" {
            performSegue(withIdentifier: "TeleSegue", sender: self)
        } else {
            performSegue(withIdentifier: "NonTeleSegue", sender: self)
        }
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segue.identifier {
        case "NonTeleSegue" :
            let indexPath = self.tableView.indexPathForSelectedRow
            let selectedText = (tableView.cellForRow(at: indexPath!)?.textLabel?.text)!
            Session.addToEquipmentSelectionDict(id: "Type", value: selectedText)
            Session.setKVPair(key: "Type", value:  selectedText)
            let nextOrdPos = "20"
            let destVC = segue.destination as! SubtypeTVController
            destVC.subtypes = (Session.getQuestionsHaving(ordPos: nextOrdPos, sourceType: "questions"))
        case "TeleSegue" :
            let indexPath = self.tableView.indexPathForSelectedRow
            let selectedText = (tableView.cellForRow(at: indexPath!)?.textLabel?.text)!
            Session.addToEquipmentSelectionDict(id: "Type", value: selectedText)
            Session.setKVPair(key: "Type", value:  selectedText)
            let nextOrdPos = "30"
            let destVC = segue.destination as! MeasureOpeningViewController
            destVC.promptText = Session.getFieldDataFrom(Session.questions!, ordinalPosition: nextOrdPos, colName: "description")
        default :
            print("Non-Existant Segue Identifier")
        }
    }
}
