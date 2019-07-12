//
//  SubtypeTVController.swift
//  jedeye
//
//  Created by Rick Campbell on 5/12/19.
//  Copyright © 2019 Datacom. All rights reserved.
//

import UIKit

class SubtypeTVController: UITableViewController, AsynchDataDelegate {
    
    var subtypes : [String:[String:String]] = [:]
    var displayStrings : [String] = [] // for sorting

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "Power"
        self.displayStrings = Session.getSortedStrings(dict: self.subtypes, field: "displayname")
        tableView.reloadData()
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.displayStrings.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LiftSubtype", for: indexPath)

        // Configure the cell...
        cell.textLabel?.text = self.displayStrings[indexPath.row]
        cell.accessoryType = .none
        if let t = Session.surveyData?.surveySelections["Power"] {
            if (t as! String) == cell.textLabel?.text {
                cell.accessoryType = .checkmark
            }
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print("&&Subtype: \(Session.getSelection()["Type"]!)")
        if (((Session.getSelection()["Type"] as? String)?.contains("Articulating"))!) {
            performSegue(withIdentifier: "WallSegue", sender: self)
        } else {
            performSegue(withIdentifier: "OpeningSegue", sender: self)
        }
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var nextOrdPos : String?
        
        switch segue.identifier {
        case "WallSegue":
            let indexPath = tableView.indexPathForSelectedRow
            let selectedText = (tableView.cellForRow(at: indexPath!)?.textLabel?.text)!
            Session.addToEquipmentSelectionDict(id:"Power", value: selectedText)
            Session.setKVPair(key: "Power", value: selectedText)
            nextOrdPos = "25"
            let destVC = segue.destination as! ArticulatingWallHeightViewController
            destVC.promptText = Session.getFieldDataFrom(Session.questions!, ordinalPosition: nextOrdPos!, colName: "description")
        case "OpeningSegue":
            let indexPath = tableView.indexPathForSelectedRow
            let selectedText = (tableView.cellForRow(at: indexPath!)?.textLabel?.text)!
            Session.addToEquipmentSelectionDict(id:"Power", value: selectedText)
            Session.setKVPair(key: "Power", value: selectedText)
            nextOrdPos = "30"
            let destVC = segue.destination as! MeasureOpeningViewController
            destVC.promptText = Session.getFieldDataFrom(Session.questions!, ordinalPosition: nextOrdPos!, colName: "description")
        default:
            print("&&Non-Existant Segue ID")
        }
    }
}
