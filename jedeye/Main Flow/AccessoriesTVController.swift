//
//  AccessoriesTVController.swift
//  jedeye
//
//  Created by Rick Campbell on 5/20/19.
//  Copyright © 2019 Datacom. All rights reserved.
//

import UIKit

class AccessoriesTVController: UITableViewController {
    
    var arrAccessories : [String]?

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "Accessories"
        self.arrAccessories = self.arrAccessories?.sorted()
        self.navigationItem.rightBarButtonItem?.title = Session.surveyID
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrAccessories!.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //downcast the cell as a BooleanCell:
        let cell = tableView.dequeueReusableCell(withIdentifier: "booleanCell", for: indexPath) as? BooleanCell
        cell?.accessory?.text = arrAccessories![indexPath.row]
        
        if let acc = (Session.surveyData?.surveySelections as! [String:String]?) {
            
            for (k, v) in acc {
                if k == cell?.accessory?.text && v == "true" {
                    cell?.isNeeded?.isOn = true
                }
            }
        }
        return cell!
    }
    

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //marshall all cells with switches on into an array:
        var selectedAccessories : [String:String] = [:]
        //loop through all the rows, looking for set switches
        for (c) in tableView.visibleCells {
            let accCell = c as? BooleanCell
            Session.addToEquipmentSelectionDict(id: accCell!.accessory!.text!, value: (accCell!.isNeeded!.isOn ? "true" : "false"))
            selectedAccessories[accCell!.accessory!.text!] = (accCell!.isNeeded!.isOn ? "true" : "false")
        }
        Session.addToEquipmentSelectionDict(id: "Accessories", value: selectedAccessories)
        Session.setKVPairs(selectedAccessories)
        
        var response : EntryType = [:]
        response["accessories"] = selectedAccessories
    }
}
