//
//  EquipmentSelectionTVController.swift
//  jedeye
//
//  Created by Rick Campbell on 7/24/19.
//  Copyright © 2019 Datacom. All rights reserved.
//

import UIKit

class EquipmentSelectionTVController: UITableViewController, AsynchDataDelegate, ConfirmDelegate {
    
    var equipment : EntryType = [:]
    var confirmCell : EquipmentCell?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Equipment"
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Survey", style: .plain, target: self, action: #selector(goSurvey(sender:)))
        Session.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.rightBarButtonItem?.title = Session.surveyID
        Session.getRecommendations(surveyid: Session.surveyID!, surveytype: "", enditemqty: "0", note: "Version+1.0")
    }
    
    func recommendationsReturned(data: EntryType) {
        self.equipment = data
        print("&&EquipData: \(self.equipment)")
        DispatchQueue.main.async {
            if self.equipment.count == 0 {
                let alertController = UIAlertController(title: "No Equipment", message:"No equipment meets reach requirements. If possible, move equipment placement closer to target and try again.", preferredStyle: .alert)
                
                alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction) in
                    // nothing to see here yet.
                }))
                
                self.present(alertController, animated: true, completion: nil)
            }
            self.tableView.reloadData()
        }
    }
    
    func orderConfirmed(sender: EquipmentCell) {
        self.confirmCell = sender
        performSegue(withIdentifier: "EquipmentToConfirmSegue", sender: self)
    }
     
    @objc func goSurvey(sender:UIBarButtonItem) {
        performSegue(withIdentifier: "EquipmentToSurveySegue", sender: sender)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.equipment.count
    }
    
    func sortBySize() -> [String] {
        var equipmentSize : [String:String] = [:]
        var retVal : [String] = []
        for (k, v) in self.equipment {
            equipmentSize[k] = v["sortorder"]
        }
        retVal = Array(equipmentSize.keys).sorted(by: {
            return equipmentSize[$0]! < equipmentSize[$1]!
        })
        
        return retVal
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "equipmentCell", for: indexPath) as! EquipmentCell
        
        cell.delegate = self

        // Configure the cell...
        let equipmentKeys = sortBySize()
        print(equipmentKeys)
        let thisKey = equipmentKeys[indexPath.row]
        
        cell.lbManufacturer?.text = equipment[thisKey]!["manufacturer"]
        cell.lbModel?.text = equipment[thisKey]!["modelno"]
        cell.lbNotes?.text = equipment[thisKey]!["notes"]
        
        //color the notes field if some other data is something:
        /*
        if something {
            cell.lbNotes?.textColor = UIColor.blue
        }
        */
        
        cell.pdfPath = "https://www.ibeamma.com/jedeye/pdf/" + equipment[thisKey]!["linkpdf"]!
        
        return cell
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

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "EquipmentToPDFSegue":
            let destVC = segue.destination as! PDFViewController
            let btn = sender as! UIButton
            let cell = btn.superview?.superview as! EquipmentCell
            let pdfURL = cell.pdfPath 
            
            destVC.datasheetURL = pdfURL
        case "EquipmentToConfirmSegue":
            let destVC = segue.destination as! ConfirmOrderViewController
            destVC.manufacturer = self.confirmCell?.lbManufacturer?.text
            destVC.model = self.confirmCell?.lbModel?.text
            destVC.quantity = self.confirmCell?.lbQuantity?.text
            
        default:
            print("&&Unknown segue ID in Equipment VC")
            
        }
    }
    

}
