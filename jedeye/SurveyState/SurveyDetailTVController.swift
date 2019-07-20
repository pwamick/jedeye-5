//
//  SurveyDetailTVController.swift
//  jedeye
//
//  Created by Rick Campbell on 7/16/19.
//  Copyright © 2019 Datacom. All rights reserved.
//

import UIKit

class SurveyDetailTVController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.navigationItem.rightBarButtonItem = nil
        self.tabBarController?.title = "View"
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
        
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var retVal: String = ""
        switch section {
        case 0:
            retVal = "Information"
        case 1:
            retVal = "Site / Project Address"
        case 2:
            retVal = "Contractor Address"
        case 3:
            retVal = "User Selections"
        default:
            print("&&Unknown section")
            
        }
        return retVal
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SurveyInfoCell", for: indexPath) as! SurveyInfoCell
            cell.lbSiteName?.text = Session.surveyData?.s_lname
            cell.lbContractorName?.text = Session.surveyData?.c_lname
            cell.tvDescription?.text = Session.surveyData?.desc
            cell.lbSurveyID?.text = Session.surveyID
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SurveyAddressCell", for: indexPath) as! SurveyAddressCell
            cell.lbAddr1?.text = Session.surveyData?.s_addr1
            cell.lbAddr2?.text = Session.surveyData?.s_addr2
            cell.lbCity?.text = Session.surveyData?.s_city
            cell.lbState?.text = Session.surveyData?.s_state
            cell.lbPostalCode?.text = Session.surveyData?.s_postalcode
            cell.lbPhone?.text = Session.surveyData?.s_phone
            cell.lbPhone2?.text = Session.surveyData?.s_phone2
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SurveyAddressCell", for: indexPath) as! SurveyAddressCell
            cell.lbAddr1?.text = Session.surveyData?.c_addr1
            cell.lbAddr2?.text = Session.surveyData?.c_addr2
            cell.lbCity?.text = Session.surveyData?.c_city
            cell.lbState?.text = Session.surveyData?.c_state
            cell.lbPostalCode?.text = Session.surveyData?.c_postalcode
            cell.lbPhone?.text = Session.surveyData?.c_phone
            cell.lbPhone2?.text = Session.surveyData?.c_phone2
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SurveyUserSelectionCell", for: indexPath) as! SurveyUserSelectionCell
            
            cell.lbEquipmentType?.text = Session.surveyData?.surveySelections["Type"] as? String
            cell.lbEquipmentPowerType?.text = Session.surveyData?.surveySelections["Power"] as? String
            cell.lbWallHeight?.text = Session.surveyData?.surveySelections["WallHeight"] as? String
            cell.lbOpeningWidth?.text = Session.surveyData?.surveySelections["OpeningWidth"] as? String
            cell.lbOpeningHeight?.text = Session.surveyData?.surveySelections["OpeningHeight"] as? String
            cell.lbEquipmentWeight?.text = Session.surveyData?.surveySelections["TerWeight"] as? String
            cell.lbLiftGreaterThan500?.text = Session.surveyData?.surveySelections["gt500"] as? String
            cell.lbMeasuredDistance?.text = Session.surveyData?.surveySelections["MeasDistance"] as? String
            cell.lbMeasuredAngle?.text = Session.surveyData?.surveySelections["MeasAngle"] as? String
            cell.lbAccessoryAntiCrush?.text = Session.surveyData?.surveySelections["Anti-Crush Bar"] as? String
            cell.lbAccessoryDripDiaper?.text = Session.surveyData?.surveySelections["Drip Diaper"] as? String
            cell.lbAccessoryGlazingKit?.text = Session.surveyData?.surveySelections["Glazing Kit"] as? String
            cell.lbAccessorySkyPower?.text = Session.surveyData?.surveySelections["Sky Power"] as? String
            cell.lbAccessorySkyWelder?.text = Session.surveyData?.surveySelections["Sky Welder"] as? String
            cell.lbAccessoryTireSocks?.text = Session.surveyData?.surveySelections["Tire Socks"] as? String
            cell.lbAccessoryExtendedForks?.text = Session.surveyData?.surveySelections["Extended Forks"] as? String
            
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "none", for: indexPath)
            print("&&Unknown section when dequeueing cell")
            return cell
        }
        
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
