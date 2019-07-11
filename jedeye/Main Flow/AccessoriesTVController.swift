//
//  AccessoriesTVController.swift
//  jedeye
//
//  Created by Rick Campbell on 5/20/19.
//  Copyright © 2019 Datacom. All rights reserved.
//

import UIKit

class AccessoriesTVController: UITableViewController {
    
    //var survey : Survey?
    //var navController : NavController?
    
    var arrAccessories : [String]?

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "Accessories"
        self.arrAccessories = self.arrAccessories?.sorted()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
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
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //marshall all cells with switches on into an array:
        var selectedAccessories : [String:String] = [:]
        //loop through all the rows, looking for set switches
        for (c) in tableView.visibleCells {
            let accCell = c as? BooleanCell
            selectedAccessories[accCell!.accessory!.text!] = (accCell!.isNeeded!.isOn ? "true" : "false")
            
        }
        Session.addToEquipmentSelectionDict(id: "Accessories", value: selectedAccessories)
        Session.setKVPairs(selectedAccessories)
        
        var response : EntryType = [:]
        response["accessories"] = selectedAccessories
        
    }
    

}
